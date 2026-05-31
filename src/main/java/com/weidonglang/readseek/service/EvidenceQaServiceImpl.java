package com.weidonglang.readseek.service;

import com.weidonglang.readseek.config.RagProperties;
import com.weidonglang.readseek.dto.BookDto;
import com.weidonglang.readseek.dto.BookSearchHitDto;
import com.weidonglang.readseek.dto.BookSearchResponseDto;
import com.weidonglang.readseek.dto.EvidenceQaRequestDto;
import com.weidonglang.readseek.dto.EvidenceQaResponseDto;
import com.weidonglang.readseek.dto.EvidenceSnippetDto;
import com.weidonglang.readseek.llm.RagAnswerGenerator;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@Slf4j
@Service
public class EvidenceQaServiceImpl implements EvidenceQaService {
    private static final int MAX_QUESTION_LENGTH = 500;
    private static final int HARD_MAX_EVIDENCE_LIMIT = 20;

    private final BookSearchService bookSearchService;
    private final RagProperties ragProperties;
    private final RagAnswerGenerator ragAnswerGenerator;
    private final QaEventService qaEventService;

    public EvidenceQaServiceImpl(BookSearchService bookSearchService,
                                 RagProperties ragProperties,
                                 RagAnswerGenerator ragAnswerGenerator,
                                 QaEventService qaEventService) {
        this.bookSearchService = bookSearchService;
        this.ragProperties = ragProperties;
        this.ragAnswerGenerator = ragAnswerGenerator;
        this.qaEventService = qaEventService;
    }

    @Override
    public EvidenceQaResponseDto answer(EvidenceQaRequestDto requestDto) {
        long totalStartedAt = System.nanoTime();
        String question = normalizeQuestion(requestDto == null ? null : requestDto.getQuestion());
        String ragMode = ragProperties.normalizeMode(requestDto == null ? null : requestDto.getMode());
        String provider = ragProperties.normalizeProvider(requestDto == null ? null : requestDto.getProvider());
        int searchLimit = sanitizeSearchLimit(requestDto == null ? null : requestDto.getLimit(), ragMode);
        int evidenceLimit = sanitizeEvidenceLimit(ragMode, searchLimit);

        long retrievalStartedAt = System.nanoTime();
        BookSearchResponseDto searchResponse = bookSearchService.searchBooks(question, searchLimit);
        long retrievalLatencyMs = Duration.ofNanos(System.nanoTime() - retrievalStartedAt).toMillis();
        List<BookSearchHitDto> hits = searchResponse == null || searchResponse.getHits() == null
                ? List.of()
                : searchResponse.getHits();

        List<EvidenceSnippetDto> evidence = new ArrayList<>();
        for (int index = 0; index < Math.min(hits.size(), evidenceLimit); index++) {
            evidence.add(toEvidenceSnippet(hits.get(index), index + 1));
        }

        String answerMode = inferAnswerMode(question);
        boolean answerable = hasReliableEvidence(evidence);
        RagAnswerGenerator.GeneratedAnswer generatedAnswer = ragAnswerGenerator.generate(
                question,
                answerMode,
                ragMode,
                provider,
                evidence,
                answerable
        );
        List<String> citations = buildCitations(evidence);
        List<String> limitations = buildLimitations(searchResponse, evidence, answerable, generatedAnswer);
        List<String> followUps = buildFollowUpSuggestions(question, answerMode, evidence);
        long totalLatencyMs = Duration.ofNanos(System.nanoTime() - totalStartedAt).toMillis();

        EvidenceQaResponseDto response = new EvidenceQaResponseDto(
                question,
                generatedAnswer.getAnswer(),
                answerMode,
                searchResponse == null ? null : searchResponse.getStrategy(),
                searchResponse == null ? null : searchResponse.getQueryIntent(),
                searchResponse != null && searchResponse.isFallbackApplied(),
                evidence.size(),
                evidence,
                limitations,
                followUps
        );
        response.setAnswerable(answerable);
        response.setGenerationBackend(generatedAnswer.getBackend());
        response.setEvidencePolicy(ragProperties.getEvidencePolicy());
        response.setCitations(citations);
        response.setConfidence(calculateConfidence(searchResponse, evidence, answerable));
        response.setRagMode(generatedAnswer.getMode());
        response.setLlmProvider(generatedAnswer.getProvider());
        response.setModel(generatedAnswer.getModel());
        response.setLlmFallbackApplied(generatedAnswer.isFallbackApplied());
        response.setLlmFallbackReason(generatedAnswer.getFallbackReason());
        response.setRetrievalLatencyMs(retrievalLatencyMs);
        response.setGenerationLatencyMs(generatedAnswer.getLatencyMs());
        response.setTotalLatencyMs(totalLatencyMs);
        qaEventService.recordQuestion(response);
        return response;
    }

    private EvidenceSnippetDto toEvidenceSnippet(BookSearchHitDto hit, int rank) {
        BookDto book = hit == null ? null : hit.getBook();
        EvidenceSnippetDto snippet = new EvidenceSnippetDto(
                book == null ? null : book.getId(),
                book == null ? null : book.getName(),
                book == null || book.getAuthor() == null ? null : book.getAuthor().getName(),
                book == null || book.getCategory() == null ? null : book.getCategory().getName(),
                truncate(book == null ? null : book.getDescription(), 420),
                hit == null ? null : hit.getMatchType(),
                hit == null ? null : hit.getScore(),
                hit == null ? null : hit.getReason(),
                rank
        );
        snippet.setCitation("[" + rank + "]");
        snippet.setSource(hit == null || hit.getSource() == null ? fallbackSource(hit) : hit.getSource());
        snippet.setReranked(hit != null && Boolean.TRUE.equals(hit.getReranked()));
        return snippet;
    }

    private boolean hasReliableEvidence(List<EvidenceSnippetDto> evidence) {
        if (evidence == null || evidence.isEmpty()) {
            return false;
        }
        return evidence.stream().anyMatch(snippet -> snippet.getResourceId() != null
                && snippet.getTitle() != null
                && !snippet.getTitle().isBlank()
                && snippet.getMatchType() != null
                && !snippet.getMatchType().isBlank());
    }

    private List<String> buildCitations(List<EvidenceSnippetDto> evidence) {
        return evidence.stream()
                .map(snippet -> String.format("%s %s / %s / %s",
                        safeCitation(snippet),
                        safe(snippet.getTitle()),
                        safe(snippet.getAuthor()),
                        safe(snippet.getSource())))
                .toList();
    }

    private List<String> buildLimitations(BookSearchResponseDto searchResponse,
                                          List<EvidenceSnippetDto> evidence,
                                          boolean answerable,
                                          RagAnswerGenerator.GeneratedAnswer generatedAnswer) {
        List<String> limitations = new ArrayList<>();
        limitations.add("回答严格受当前检索证据约束，不使用馆藏外事实补充。");
        limitations.add("证据范围仅限当前系统已入库并已建立索引的阅读资源。");
        if (!answerable) {
            limitations.add("证据为空或不可用，因此已拒绝生成具体推荐或事实判断。");
        }
        if (searchResponse != null && searchResponse.isFallbackApplied()) {
            limitations.add("本次检索触发了回退策略，说明高相关证据不足。");
        }
        if (generatedAnswer.isFallbackApplied()) {
            limitations.add("本次 LLM 调用不可用，已降级为本地证据模板生成。");
        }
        if (evidence.size() < 3) {
            limitations.add("可用证据数量较少，回答会偏保守。");
        }
        return limitations;
    }

    private Double calculateConfidence(BookSearchResponseDto searchResponse,
                                       List<EvidenceSnippetDto> evidence,
                                       boolean answerable) {
        if (!answerable) {
            return 0.0D;
        }
        double confidence = Math.min(0.35D + evidence.size() * 0.1D, 0.75D);
        EvidenceSnippetDto top = evidence.get(0);
        String matchType = top.getMatchType() == null ? "" : top.getMatchType().toUpperCase(Locale.ROOT);
        if (matchType.contains("EXACT_DB")) {
            confidence += 0.15D;
        }
        if (matchType.contains("RERANK") || Boolean.TRUE.equals(top.getReranked())) {
            confidence += 0.08D;
        }
        if (searchResponse != null && searchResponse.isFallbackApplied()) {
            confidence -= 0.15D;
        }
        return Math.max(0.0D, Math.min(confidence, 0.95D));
    }

    private List<String> buildFollowUpSuggestions(String question,
                                                  String answerMode,
                                                  List<EvidenceSnippetDto> evidence) {
        List<String> suggestions = new ArrayList<>();
        if ("READING_PATH".equals(answerMode)) {
            suggestions.add("把这条路径改成入门、进阶、深入三个阶段。");
        } else if ("COMPARISON".equals(answerMode)) {
            suggestions.add("按评分、篇幅和可借状态重新比较。");
        } else {
            suggestions.add("只看可借资源，应该选哪一本？");
            suggestions.add("按入门难度重新排序这些证据。");
        }
        if (!evidence.isEmpty() && evidence.get(0).getAuthor() != null) {
            suggestions.add("继续找 " + evidence.get(0).getAuthor() + " 的相关作品。");
        } else {
            suggestions.add("换成更具体的作者、主题或分类重新提问。");
        }
        return suggestions;
    }

    private String inferAnswerMode(String question) {
        String normalized = question.toLowerCase(Locale.ROOT);
        if (normalized.contains("路径") || normalized.contains("顺序") || normalized.contains("先读")
                || normalized.contains("reading path") || normalized.contains("order")) {
            return "READING_PATH";
        }
        if (normalized.contains("总结") || normalized.contains("概括") || normalized.contains("summary")) {
            return "SUMMARY";
        }
        if (normalized.contains("推荐") || normalized.contains("适合") || normalized.contains("想看")
                || normalized.contains("recommend") || normalized.contains("suggest")) {
            return "RECOMMENDATION";
        }
        if (normalized.contains("比较") || normalized.contains("区别") || normalized.contains("哪个好")
                || normalized.contains("compare") || normalized.contains("difference")) {
            return "COMPARISON";
        }
        if (normalized.contains("作者") || normalized.contains("代表作") || normalized.contains("author")
                || normalized.contains("work")) {
            return "AUTHOR_OR_WORK";
        }
        return "FACTUAL_LOOKUP";
    }

    private String normalizeQuestion(String question) {
        String normalized = question == null ? "" : question.trim();
        if (normalized.isBlank()) {
            throw new IllegalArgumentException("Question must not be blank.");
        }
        return normalized.length() <= MAX_QUESTION_LENGTH ? normalized : normalized.substring(0, MAX_QUESTION_LENGTH);
    }

    private int sanitizeSearchLimit(Integer requestedLimit, String mode) {
        int modeTopK = ragAnswerGenerator.searchTopK(mode);
        if (requestedLimit == null || requestedLimit < 1) {
            return Math.min(modeTopK, HARD_MAX_EVIDENCE_LIMIT);
        }
        return Math.min(Math.min(requestedLimit, modeTopK), HARD_MAX_EVIDENCE_LIMIT);
    }

    private int sanitizeEvidenceLimit(String mode, int searchLimit) {
        return Math.min(searchLimit, Math.min(ragAnswerGenerator.evidenceTopK(mode), HARD_MAX_EVIDENCE_LIMIT));
    }

    private String truncate(String value, int maxLength) {
        if (value == null || value.isBlank()) {
            return null;
        }
        String normalized = value.trim();
        return normalized.length() <= maxLength ? normalized : normalized.substring(0, maxLength) + "...";
    }

    private String safe(String value) {
        return value == null || value.isBlank() ? "暂无信息" : value;
    }

    private String safeCitation(EvidenceSnippetDto snippet) {
        return snippet == null || snippet.getCitation() == null ? "" : snippet.getCitation();
    }

    private String fallbackSource(BookSearchHitDto hit) {
        String matchType = hit == null ? null : hit.getMatchType();
        if (matchType == null || matchType.isBlank()) {
            return "search";
        }
        return matchType.toLowerCase(Locale.ROOT).replace("+", ",");
    }
}
