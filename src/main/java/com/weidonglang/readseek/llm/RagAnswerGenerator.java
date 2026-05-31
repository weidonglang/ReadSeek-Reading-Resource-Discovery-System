package com.weidonglang.readseek.llm;

import com.weidonglang.readseek.config.RagProperties;
import com.weidonglang.readseek.dto.EvidenceSnippetDto;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Slf4j
@Service
public class RagAnswerGenerator {
    private static final String DETERMINISTIC_BACKEND = "local-evidence-generator-v1";
    private static final Pattern THINK_BLOCK = Pattern.compile("(?is)<think>.*?</think>");
    private static final Pattern CITATION_PATTERN = Pattern.compile("\\[\\d+]");

    private final RagProperties ragProperties;
    private final List<LlmChatClient> clients;

    public RagAnswerGenerator(RagProperties ragProperties, List<LlmChatClient> clients) {
        this.ragProperties = ragProperties;
        this.clients = clients == null ? List.of() : clients;
    }

    public GeneratedAnswer generate(String question,
                                    String answerMode,
                                    String requestedMode,
                                    String requestedProvider,
                                    List<EvidenceSnippetDto> evidence,
                                    boolean answerable) {
        String mode = ragProperties.normalizeMode(requestedMode);
        String provider = ragProperties.normalizeProvider(requestedProvider);
        RagProperties.ModeProperties modeProperties = ragProperties.mode(mode);
        String model = resolveModel(provider, modeProperties);

        if (!answerable) {
            return deterministic(question, answerMode, mode, provider, model, evidence, false, "insufficient evidence");
        }
        if (!ragProperties.isLlmEnabled() || "deterministic".equals(provider)) {
            return deterministic(question, answerMode, mode, provider, model, evidence, false, "LLM disabled or deterministic provider requested");
        }

        Optional<LlmChatClient> client = clients.stream()
                .filter(candidate -> candidate.supports(provider))
                .findFirst();
        if (client.isEmpty()) {
            return deterministic(question, answerMode, mode, provider, model, evidence, true, "no chat client for provider " + provider);
        }

        LlmChatRequest request = new LlmChatRequest(
                provider,
                model,
                mode,
                buildSystemPrompt(answerMode),
                buildUserPrompt(question, answerMode, evidence),
                modeProperties.getTemperature(),
                modeProperties.getTopP(),
                modeProperties.getNumCtx(),
                modeProperties.getNumPredict(),
                modeProperties.getKeepAlive(),
                modeProperties.getTimeoutSeconds()
        );

        long startedAt = System.nanoTime();
        try {
            LlmChatResult result = client.get().chat(request);
            String content = sanitizeContent(result.getContent());
            if (content.isBlank()) {
                throw new LlmProviderException("LLM returned blank content.");
            }
            content = ensureCitations(content, evidence);
            return new GeneratedAnswer(
                    content,
                    result.getBackend(),
                    result.getProvider(),
                    result.getModel(),
                    mode,
                    false,
                    null,
                    result.getLatencyMs() > 0 ? result.getLatencyMs() : Duration.ofNanos(System.nanoTime() - startedAt).toMillis()
            );
        } catch (Exception exception) {
            log.warn("RAG LLM generation failed, provider={}, model={}, reason={}", provider, model, exception.getMessage());
            if (!ragProperties.isFallbackToDeterministic()) {
                throw exception;
            }
            return deterministic(question, answerMode, mode, provider, model, evidence, true, exception.getMessage());
        }
    }

    public int searchTopK(String mode) {
        return Math.max(1, ragProperties.mode(mode).getTopK());
    }

    public int evidenceTopK(String mode) {
        RagProperties.ModeProperties modeProperties = ragProperties.mode(mode);
        int rerankTopK = Math.max(1, modeProperties.getRerankTopK());
        return Math.min(searchTopK(mode), rerankTopK);
    }

    private String resolveModel(String provider, RagProperties.ModeProperties modeProperties) {
        if ("online".equals(provider)) {
            if (modeProperties.getOnlineModel() != null && !modeProperties.getOnlineModel().isBlank()) {
                return modeProperties.getOnlineModel();
            }
            if (ragProperties.getOnline().getModel() != null && !ragProperties.getOnline().getModel().isBlank()) {
                return ragProperties.getOnline().getModel();
            }
        }
        return modeProperties.getModel();
    }

    private String buildSystemPrompt(String answerMode) {
        return """
                你是 ReadSeek 的证据约束式 RAG 问答助手。
                规则：
                1. 只能使用用户提供的证据片段回答，不允许编造馆藏中没有的信息。
                2. 每个关键结论必须带引用，例如 [1] 或 [2]。
                3. 证据不足时要明确说明不足，并给出可继续检索的方向。
                4. 回答要简洁、可执行，优先使用中文。
                5. 当前问答类型为：%s。
                """.formatted(answerMode);
    }

    private String buildUserPrompt(String question, String answerMode, List<EvidenceSnippetDto> evidence) {
        String evidenceText = evidence.stream()
                .map(this::formatEvidence)
                .collect(Collectors.joining("\n\n"));
        return """
                用户问题：
                %s

                问答类型：
                %s

                证据片段：
                %s

                请基于证据生成最终回答。若是推荐问题，请给出推荐顺序和理由；若是对比问题，请按维度比较；若是阅读路径问题，请给出阶段化路径；若是事实查询，请直接回答并引用来源。
                """.formatted(question, answerMode, evidenceText);
    }

    private String formatEvidence(EvidenceSnippetDto snippet) {
        return """
                %s
                标题：%s
                作者：%s
                分类：%s
                简介：%s
                命中来源：%s
                命中理由：%s
                """.formatted(
                safe(snippet.getCitation()),
                safe(snippet.getTitle()),
                safe(snippet.getAuthor()),
                safe(snippet.getCategory()),
                safe(snippet.getDescription()),
                safe(snippet.getSource()),
                safe(snippet.getReason())
        );
    }

    private GeneratedAnswer deterministic(String question,
                                          String answerMode,
                                          String mode,
                                          String provider,
                                          String model,
                                          List<EvidenceSnippetDto> evidence,
                                          boolean fallbackApplied,
                                          String fallbackReason) {
        String answer = buildDeterministicAnswer(question, answerMode, evidence);
        String backend = DETERMINISTIC_BACKEND;
        if (fallbackApplied) {
            backend += "(fallback)";
        }
        return new GeneratedAnswer(answer, backend, provider, model, mode, fallbackApplied, fallbackReason, 0L);
    }

    private String buildDeterministicAnswer(String question, String answerMode, List<EvidenceSnippetDto> evidence) {
        if (evidence == null || evidence.isEmpty()) {
            return "我不能可靠回答这个问题：当前没有检索到足够的馆藏证据。请换成更具体的作者、书名、主题、体裁或目标读者后再问。";
        }
        EvidenceSnippetDto top = evidence.get(0);
        String titles = evidence.stream()
                .limit(3)
                .map(snippet -> "《" + safe(snippet.getTitle()) + "》" + safe(snippet.getCitation()))
                .collect(Collectors.joining("、"));
        return switch (answerMode) {
            case "RECOMMENDATION" -> String.format("基于当前证据，优先建议从《%s》%s 开始；也可以继续比较 %s。这个回答只依据馆藏标题、作者、分类、简介和命中理由生成。",
                    safe(top.getTitle()), safe(top.getCitation()), titles);
            case "COMPARISON" -> String.format("可以先比较 %s。建议重点看分类、作者背景、简介主题、篇幅、评分和可借状态，再决定哪一本更符合你的阅读目标。", titles);
            case "READING_PATH" -> String.format("建议按三个阶段阅读：先从《%s》%s 建立主题印象，再阅读后续高相关资源，最后用其余证据做拓展对照。", safe(top.getTitle()), safe(top.getCitation()));
            case "SUMMARY" -> String.format("本次检索围绕“%s”找到 %d 条证据，核心资源包括 %s。", question, evidence.size(), titles);
            case "AUTHOR_OR_WORK" -> String.format("检索结果中最相关的是《%s》%s，作者为 %s，分类为 %s。其余证据可以作为同作者、同主题或相近方向的补充。",
                    safe(top.getTitle()), safe(top.getCitation()), safe(top.getAuthor()), safe(top.getCategory()));
            default -> String.format("系统从馆藏检索到 %d 条相关证据。最相关的是《%s》%s，可以结合后续证据判断它是否满足“%s”这个需求。",
                    evidence.size(), safe(top.getTitle()), safe(top.getCitation()), question);
        };
    }

    private String sanitizeContent(String content) {
        if (content == null) {
            return "";
        }
        String withoutThink = THINK_BLOCK.matcher(content).replaceAll("");
        return withoutThink.trim();
    }

    private String ensureCitations(String content, List<EvidenceSnippetDto> evidence) {
        if (CITATION_PATTERN.matcher(content).find() || evidence == null || evidence.isEmpty()) {
            return content;
        }
        String references = evidence.stream()
                .limit(3)
                .map(snippet -> safe(snippet.getCitation()) + " " + safe(snippet.getTitle()))
                .collect(Collectors.joining("；"));
        return content + "\n\n参考来源：" + references;
    }

    private String safe(String value) {
        return value == null || value.isBlank() ? "暂无信息" : value;
    }

    @Getter
    @AllArgsConstructor
    public static class GeneratedAnswer {
        private String answer;
        private String backend;
        private String provider;
        private String model;
        private String mode;
        private boolean fallbackApplied;
        private String fallbackReason;
        private long latencyMs;
    }
}
