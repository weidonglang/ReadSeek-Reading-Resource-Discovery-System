package com.weidonglang.readseek.service;

import com.weidonglang.readseek.config.RagProperties;
import com.weidonglang.readseek.dto.AiChatMessageDto;
import com.weidonglang.readseek.dto.AiChatMessageRequestDto;
import com.weidonglang.readseek.dto.AiChatRecommendationDto;
import com.weidonglang.readseek.dto.AiChatResponseDto;
import com.weidonglang.readseek.dto.AiChatSessionDto;
import com.weidonglang.readseek.dto.EvidenceQaRequestDto;
import com.weidonglang.readseek.dto.EvidenceQaResponseDto;
import com.weidonglang.readseek.dto.EvidenceSnippetDto;
import com.weidonglang.readseek.llm.LlmChatClient;
import com.weidonglang.readseek.llm.LlmChatRequest;
import com.weidonglang.readseek.llm.LlmChatResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class AiChatServiceImpl implements AiChatService {
    private static final int DEFAULT_LIMIT = 5;
    private static final int MAX_MESSAGE_LENGTH = 800;

    private final EvidenceQaService evidenceQaService;
    private final RagProperties ragProperties;
    private final List<LlmChatClient> chatClients;
    private final Map<String, SessionRecord> sessions = new ConcurrentHashMap<>();

    @Autowired
    public AiChatServiceImpl(EvidenceQaService evidenceQaService,
                             RagProperties ragProperties,
                             List<LlmChatClient> chatClients) {
        this.evidenceQaService = evidenceQaService;
        this.ragProperties = ragProperties;
        this.chatClients = chatClients == null ? List.of() : chatClients;
    }

    AiChatServiceImpl(EvidenceQaService evidenceQaService) {
        this(evidenceQaService, new RagProperties(), List.of());
    }

    @Override
    public AiChatResponseDto sendMessage(String owner, AiChatMessageRequestDto requestDto) {
        String normalizedOwner = normalizeOwner(owner);
        String message = normalizeMessage(requestDto == null ? null : requestDto.getMessage());
        SessionRecord session = resolveSession(normalizedOwner, requestDto == null ? null : requestDto.getSessionId(), message);

        AiChatMessageDto userMessage = new AiChatMessageDto(UUID.randomUUID().toString(), "user", message, LocalDateTime.now());
        session.messages.add(userMessage);

        AiChatResponseDto conversationalResponse = answerConversationalMessage(session, userMessage, message);
        if (conversationalResponse != null) {
            return conversationalResponse;
        }

        AiChatResponseDto openChatResponse = answerOpenChatMessage(session, userMessage, message, requestDto);
        if (openChatResponse != null) {
            return openChatResponse;
        }

        EvidenceQaRequestDto qaRequest = new EvidenceQaRequestDto(
                message,
                requestDto == null || requestDto.getLimit() == null ? DEFAULT_LIMIT : requestDto.getLimit(),
                requestDto == null ? null : requestDto.getMode(),
                requestDto == null ? null : requestDto.getProvider()
        );
        EvidenceQaResponseDto qaResponse = evidenceQaService.answer(qaRequest);
        String answer = qaResponse == null ? "No answer was generated." : qaResponse.getAnswer();
        AiChatMessageDto assistantMessage = new AiChatMessageDto(UUID.randomUUID().toString(), "assistant", answer, LocalDateTime.now());
        session.messages.add(assistantMessage);
        session.updatedAt = assistantMessage.getCreatedAt();

        return toResponse(session.id, userMessage, assistantMessage, qaResponse);
    }

    private AiChatResponseDto answerOpenChatMessage(SessionRecord session,
                                                    AiChatMessageDto userMessage,
                                                    String message,
                                                    AiChatMessageRequestDto requestDto) {
        if (!isOpenChatMessage(message)) {
            return null;
        }

        String mode = ragProperties.normalizeMode(requestDto == null ? null : requestDto.getMode());
        String provider = ragProperties.normalizeProvider(requestDto == null ? null : requestDto.getProvider());
        RagProperties.ModeProperties modeProperties = ragProperties.mode(mode);
        String model = "online".equals(provider) && modeProperties.getOnlineModel() != null && !modeProperties.getOnlineModel().isBlank()
                ? modeProperties.getOnlineModel()
                : modeProperties.getModel();

        long startedAt = System.nanoTime();
        String answer;
        String backend = "open-chat-fallback";
        boolean fallbackApplied = false;
        String fallbackReason = null;
        try {
            LlmChatClient client = chatClients.stream()
                    .filter(candidate -> candidate.supports(provider))
                    .findFirst()
                    .orElse(null);
            if (client == null || "deterministic".equals(provider)) {
                throw new IllegalStateException("No available chat client for provider " + provider);
            }
            LlmChatResult result = client.chat(new LlmChatRequest(
                    provider,
                    model,
                    mode,
                    buildOpenChatSystemPrompt(),
                    buildOpenChatUserPrompt(session, message),
                    Math.min(0.7D, Math.max(0.2D, modeProperties.getTemperature() + 0.25D)),
                    modeProperties.getTopP(),
                    modeProperties.getNumCtx(),
                    modeProperties.getNumPredict(),
                    modeProperties.getKeepAlive(),
                    modeProperties.getTimeoutSeconds()
            ));
            answer = result.getContent() == null ? "" : result.getContent().trim();
            if (answer.isBlank()) {
                throw new IllegalStateException("LLM returned blank content.");
            }
            backend = result.getBackend();
            model = result.getModel();
        } catch (Exception exception) {
            fallbackApplied = true;
            fallbackReason = exception.getMessage();
            answer = openChatFallbackAnswer(message);
        }
        long latencyMs = Duration.ofNanos(System.nanoTime() - startedAt).toMillis();
        AiChatMessageDto assistantMessage = new AiChatMessageDto(UUID.randomUUID().toString(), "assistant", answer, LocalDateTime.now());
        session.messages.add(assistantMessage);
        session.updatedAt = assistantMessage.getCreatedAt();

        return new AiChatResponseDto(
                session.id,
                userMessage,
                assistantMessage,
                answer,
                true,
                List.of(),
                List.of(),
                List.of(),
                "open-chat",
                null,
                fallbackApplied,
                mode,
                provider,
                model,
                backend,
                fallbackApplied,
                0L,
                latencyMs,
                latencyMs,
                fallbackReason == null
                        ? List.of("\u95f2\u804a\u6a21\u5f0f\u4e0d\u4f7f\u7528\u9986\u85cf\u8bc1\u636e\uff1b\u9700\u8981\u627e\u4e66\u6216\u505a\u63a8\u8350\u65f6\uff0c\u8bf7\u76f4\u63a5\u8bf4\u660e\u4e3b\u9898\u3001\u4f5c\u8005\u6216\u9605\u8bfb\u76ee\u6807\u3002")
                        : List.of("\u672c\u8f6e\u81ea\u7531\u5bf9\u8bdd\u6a21\u578b\u4e0d\u53ef\u7528\uff0c\u5df2\u4f7f\u7528\u672c\u5730\u56fa\u5b9a\u56de\u590d\u3002", fallbackReason),
                List.of("\u5e2e\u6211\u627e\u51e0\u672c\u9002\u5408\u5165\u95e8\u7684\u4e66\u3002", "\u628a\u521a\u624d\u7684\u60f3\u6cd5\u53d8\u6210\u9605\u8bfb\u8def\u5f84\u3002")
        );
    }

    private AiChatResponseDto answerConversationalMessage(SessionRecord session,
                                                          AiChatMessageDto userMessage,
                                                          String message) {
        String normalized = message.trim().toLowerCase();
        String compact = normalized.replaceAll("[\\s!\\uFF01.\\u3002?\\uFF1F,\\uFF0C]", "");
        boolean greeting = compact.equals("hi")
                || compact.equals("hello")
                || compact.equals("hey")
                || compact.equals("\u4F60\u597D")
                || compact.equals("\u60A8\u597D")
                || compact.equals("\u55E8")
                || compact.equals("\u54C8\u55BD");
        boolean identity = compact.contains("\u4F60\u662F\u8C01")
                || compact.contains("\u4F60\u80FD\u505A\u4EC0\u4E48")
                || compact.contains("\u4ECB\u7ECD\u4E00\u4E0B")
                || normalized.contains("who are you")
                || normalized.contains("what can you do");
        if (!greeting && !identity) {
            return null;
        }

        String answer = greeting
                ? "\u4F60\u597D\uFF0C\u6211\u662F ReadSeek AI\u3002\u4F60\u53EF\u4EE5\u548C\u6211\u81EA\u7531\u804A\u5929\uFF0C\u4E5F\u53EF\u4EE5\u8BA9\u6211\u5E2E\u4F60\u627E\u4E66\u3001\u505A\u9605\u8BFB\u8DEF\u5F84\u3001\u6BD4\u8F83\u9605\u8BFB\u8D44\u6E90\u3002\u53EA\u6709\u5F53\u4F60\u660E\u786E\u9700\u8981\u9986\u85CF\u63A8\u8350\u6216\u627E\u4E66\u65F6\uFF0C\u6211\u624D\u4F1A\u5207\u5230\u8BC1\u636E\u68C0\u7D22\u6A21\u5F0F\u3002"
                : "\u6211\u662F ReadSeek AI\uFF0C\u4E00\u4E2A\u81EA\u7531\u5BF9\u8BDD + \u9605\u8BFB\u8D44\u6E90\u53D1\u73B0\u52A9\u624B\u3002\u666E\u901A\u804A\u5929\u3001\u6982\u5FF5\u89E3\u91CA\u3001\u5199\u4F5C\u548C\u5B66\u4E60\u8F85\u5BFC\u6211\u4F1A\u76F4\u63A5\u56DE\u7B54\uFF1B\u627E\u4E66\u3001\u63A8\u8350\u3001\u9986\u85CF\u548C\u9605\u8BFB\u8DEF\u5F84\u95EE\u9898\u4F1A\u5C3D\u91CF\u57FA\u4E8E ReadSeek \u8BC1\u636E\u56DE\u7B54\u3002";
        answer += "\n\n\u4F60\u53EF\u4EE5\u76F4\u63A5\u95F2\u804A\uFF0C\u4E5F\u53EF\u4EE5\u8FD9\u6837\u95EE\uFF1A\"\u6211\u60F3\u7CFB\u7EDF\u5B66\u4E60\u4EBA\u5DE5\u667A\u80FD\uFF0C\u5148\u8BFB\u54EA\u51E0\u672C\uFF1F\" \u6216 \"\u5E2E\u6211\u6BD4\u8F83 Java \u548C\u7CFB\u7EDF\u8BBE\u8BA1\u76F8\u5173\u7684\u4E66\"\u3002";

        AiChatMessageDto assistantMessage = new AiChatMessageDto(UUID.randomUUID().toString(), "assistant", answer, LocalDateTime.now());
        session.messages.add(assistantMessage);
        session.updatedAt = assistantMessage.getCreatedAt();

        return new AiChatResponseDto(
                session.id,
                userMessage,
                assistantMessage,
                answer,
                true,
                List.of(),
                List.of(),
                List.of(),
                "conversation-guidance",
                null,
                false,
                "chat",
                "local",
                "readseek-assistant",
                "conversation-router-v2",
                false,
                0L,
                0L,
                0L,
                List.of("\u8FD9\u662F\u52A9\u624B\u8EAB\u4EFD\u548C\u4F7F\u7528\u65B9\u5F0F\u8BF4\u660E\uFF1B\u666E\u901A\u95F2\u804A\u4E0D\u8981\u6C42\u9986\u85CF\u8BC1\u636E\uFF0C\u627E\u4E66\u548C\u63A8\u8350\u4F1A\u5207\u6362\u5230\u8BC1\u636E\u6A21\u5F0F\u3002"),
                List.of("\u968F\u4FBF\u804A\u804A\u4ECA\u5929\u7684\u5B66\u4E60\u72B6\u6001\u3002", "\u6211\u60F3\u7CFB\u7EDF\u5B66\u4E60\u4EBA\u5DE5\u667A\u80FD\uFF0C\u5148\u8BFB\u54EA\u51E0\u672C\uFF1F", "\u5E2E\u6211\u6BD4\u8F83 Java \u548C\u7CFB\u7EDF\u8BBE\u8BA1\u76F8\u5173\u7684\u4E66\u3002")
        );
    }

    @Override
    public List<AiChatSessionDto> findSessions(String owner) {
        String normalizedOwner = normalizeOwner(owner);
        return sessions.values().stream()
                .filter(session -> normalizedOwner.equals(session.owner))
                .sorted(Comparator.comparing((SessionRecord session) -> session.updatedAt).reversed())
                .map(this::toSessionDto)
                .toList();
    }

    @Override
    public AiChatSessionDto findSession(String owner, String sessionId) {
        String normalizedOwner = normalizeOwner(owner);
        SessionRecord session = sessions.get(sessionId);
        if (session == null || !normalizedOwner.equals(session.owner)) {
            throw new IllegalArgumentException("AI chat session not found.");
        }
        return toSessionDto(session);
    }

    @Override
    public void deleteSession(String owner, String sessionId) {
        String normalizedOwner = normalizeOwner(owner);
        SessionRecord session = sessions.get(sessionId);
        if (session != null && normalizedOwner.equals(session.owner)) {
            sessions.remove(sessionId);
        }
    }

    private SessionRecord resolveSession(String owner, String requestedSessionId, String firstMessage) {
        if (requestedSessionId != null && !requestedSessionId.isBlank()) {
            SessionRecord existing = sessions.get(requestedSessionId);
            if (existing != null && owner.equals(existing.owner)) {
                return existing;
            }
        }
        String sessionId = UUID.randomUUID().toString();
        SessionRecord created = new SessionRecord();
        created.id = sessionId;
        created.owner = owner;
        created.title = buildTitle(firstMessage);
        created.createdAt = LocalDateTime.now();
        created.updatedAt = created.createdAt;
        created.messages = new ArrayList<>();
        sessions.put(sessionId, created);
        return created;
    }

    private AiChatResponseDto toResponse(String sessionId,
                                         AiChatMessageDto userMessage,
                                         AiChatMessageDto assistantMessage,
                                         EvidenceQaResponseDto qaResponse) {
        if (qaResponse == null) {
            return new AiChatResponseDto(sessionId, userMessage, assistantMessage, assistantMessage.getContent(),
                    false, List.of(), List.of(), List.of(), null, null, true,
                    null, null, null, null, true, null, null, null,
                    List.of("The RAG service did not return a response."), List.of());
        }

        List<EvidenceSnippetDto> evidence = qaResponse.getEvidence() == null ? List.of() : qaResponse.getEvidence();
        return new AiChatResponseDto(
                sessionId,
                userMessage,
                assistantMessage,
                qaResponse.getAnswer(),
                qaResponse.getAnswerable(),
                nullToEmpty(qaResponse.getCitations()),
                evidence,
                buildRecommendations(evidence),
                qaResponse.getStrategy(),
                qaResponse.getQueryIntent(),
                qaResponse.getFallbackApplied(),
                qaResponse.getRagMode(),
                qaResponse.getLlmProvider(),
                qaResponse.getModel(),
                qaResponse.getGenerationBackend(),
                qaResponse.getLlmFallbackApplied(),
                qaResponse.getRetrievalLatencyMs(),
                qaResponse.getGenerationLatencyMs(),
                qaResponse.getTotalLatencyMs(),
                nullToEmpty(qaResponse.getLimitations()),
                nullToEmpty(qaResponse.getFollowUpSuggestions())
        );
    }

    private List<AiChatRecommendationDto> buildRecommendations(List<EvidenceSnippetDto> evidence) {
        return evidence.stream()
                .filter(snippet -> snippet.getResourceId() != null)
                .map(snippet -> new AiChatRecommendationDto(
                        snippet.getResourceId(),
                        snippet.getTitle(),
                        snippet.getAuthor(),
                        snippet.getCategory(),
                        snippet.getSource(),
                        snippet.getReason(),
                        snippet.getRank()
                ))
                .toList();
    }

    private AiChatSessionDto toSessionDto(SessionRecord session) {
        return new AiChatSessionDto(
                session.id,
                session.title,
                session.createdAt,
                session.updatedAt,
                List.copyOf(session.messages)
        );
    }

    private List<String> nullToEmpty(List<String> values) {
        return values == null ? List.of() : values;
    }

    private String normalizeOwner(String owner) {
        return owner == null || owner.isBlank() ? "anonymous" : owner.trim();
    }

    private String normalizeMessage(String message) {
        String normalized = message == null ? "" : message.trim();
        if (normalized.isBlank()) {
            throw new IllegalArgumentException("AI chat message must not be blank.");
        }
        return normalized.length() <= MAX_MESSAGE_LENGTH ? normalized : normalized.substring(0, MAX_MESSAGE_LENGTH);
    }

    private String buildTitle(String message) {
        String normalized = Objects.requireNonNullElse(message, "New chat").trim();
        if (normalized.length() <= 48) {
            return normalized;
        }
        return normalized.substring(0, 48) + "...";
    }

    private boolean isOpenChatMessage(String message) {
        return !isCatalogGroundedMessage(message);
    }

    private boolean isCatalogGroundedMessage(String message) {
        String normalized = message == null ? "" : message.trim().toLowerCase();
        if (normalized.isBlank()) {
            return false;
        }
        return containsAny(normalized,
                "\u4E66", "\u56FE\u4E66", "\u9986\u85CF", "\u8D44\u6E90", "\u63A8\u8350", "\u9605\u8BFB", "\u5148\u8BFB", "\u8BFB\u54EA", "\u54EA\u51E0\u672C", "\u51E0\u672C",
                "\u4F5C\u8005", "\u4E66\u540D", "\u501F\u9605", "\u53EF\u501F", "\u9605\u8BFB\u8DEF\u5F84", "\u9605\u8BFB\u8BA1\u5212", "\u6BD4\u8F83\u8FD9\u672C", "\u6BD4\u8F83\u4E24\u672C", "\u627E\u4E66",
                "book", "books", "catalog", "library", "resource", "recommend", "reading", "what should i read",
                "which books", "author", "borrow", "available", "reading path", "reading plan", "compare books");
    }

    private boolean containsAny(String value, String... needles) {
        for (String needle : needles) {
            if (needle != null && !needle.isBlank() && value.contains(needle)) {
                return true;
            }
        }
        return false;
    }

    private String buildOpenChatSystemPrompt() {
        return """
                \u4F60\u662F ReadSeek AI\uFF0C\u4E00\u4E2A\u81EA\u7136\u5BF9\u8BDD\u52A9\u624B\u3002
                \u4F60\u53EF\u4EE5\u966A\u7528\u6237\u95F2\u804A\u3001\u89E3\u91CA\u6982\u5FF5\u3001\u5199\u4F5C\u6DA6\u8272\u3001\u5934\u8111\u98CE\u66B4\u3001\u5B66\u4E60\u8F85\u5BFC\uFF0C\u4E5F\u53EF\u4EE5\u5728\u7528\u6237\u660E\u786E\u9700\u8981\u627E\u4E66\u3001\u63A8\u8350\u3001\u9605\u8BFB\u8DEF\u5F84\u6216\u9986\u85CF\u8D44\u6E90\u65F6\u5207\u6362\u5230 ReadSeek \u8BC1\u636E\u6A21\u5F0F\u3002
                \u9ED8\u8BA4\u81EA\u7136\u56DE\u7B54\uFF0C\u4E0D\u8981\u56E0\u4E3A\u6CA1\u6709\u9986\u85CF\u8BC1\u636E\u5C31\u62D2\u7B54\u3002
                \u5982\u679C\u95EE\u9898\u6D89\u53CA\u5B9E\u65F6\u4E8B\u5B9E\u3001\u533B\u7597\u3001\u6CD5\u5F8B\u3001\u91D1\u878D\u6216\u5176\u4ED6\u9AD8\u98CE\u9669\u5224\u65AD\uFF0C\u8BF7\u8BF4\u660E\u4E0D\u786E\u5B9A\u6027\uFF0C\u5E76\u5EFA\u8BAE\u7528\u6237\u6838\u5B9E\u6743\u5A01\u6765\u6E90\u3002
                \u56DE\u7B54\u4F18\u5148\u4F7F\u7528\u4E2D\u6587\uFF0C\u8BED\u6C14\u81EA\u7136\uFF0C\u5185\u5BB9\u6E05\u695A\uFF1B\u9664\u975E\u7528\u6237\u8981\u6C42\u8BE6\u7EC6\u5C55\u5F00\uFF0C\u901A\u5E38\u4FDD\u6301\u7B80\u6D01\u3002
                """;
    }

    private String buildOpenChatUserPrompt(SessionRecord session, String message) {
        List<AiChatMessageDto> recentMessages = session.messages == null
                ? List.of()
                : session.messages.stream().skip(Math.max(0, session.messages.size() - 8)).toList();
        StringBuilder builder = new StringBuilder();
        builder.append("\u6700\u8FD1\u5BF9\u8BDD\uFF1A\n");
        for (AiChatMessageDto chatMessage : recentMessages) {
            builder.append(chatMessage.getRole()).append(": ").append(chatMessage.getContent()).append('\n');
        }
        builder.append("\n\u7528\u6237\u6700\u65B0\u6D88\u606F\uFF1A").append(message);
        return builder.toString();
    }
    private String openChatFallbackAnswer(String message) {
        String normalized = message == null ? "" : message.toLowerCase();
        if (normalized.contains("\u7b11\u8bdd") || normalized.contains("joke")) {
            return "\u53ef\u4ee5\uff0c\u8bb2\u4e00\u4e2a\u8f7b\u677e\u70b9\u7684\uff1a\u4e00\u672c\u4e66\u95ee\u53e6\u4e00\u672c\u4e66\uff1a\u201c\u4f60\u6700\u8fd1\u600e\u4e48\u6837\uff1f\u201d\u5bf9\u65b9\u8bf4\uff1a\u201c\u8fd8\u884c\uff0c\u5c31\u662f\u538b\u529b\u6709\u70b9\u5927\uff0c\u56e0\u4e3a\u5927\u5bb6\u90fd\u60f3\u628a\u6211\u8bfb\u61c2\u3002\u201d";
        }
        return "\u6211\u5728\u7684\u3002\u53ef\u4ee5\u966a\u4f60\u968f\u4fbf\u804a\u51e0\u53e5\uff0c\u4e5f\u53ef\u4ee5\u5e2e\u4f60\u628a\u60f3\u6cd5\u8f6c\u6210\u9605\u8bfb\u76ee\u6807\u3002\u5982\u679c\u4f60\u60f3\u627e\u4e66\u3001\u505a\u9605\u8bfb\u8def\u5f84\u6216\u6bd4\u8f83\u8d44\u6e90\uff0c\u76f4\u63a5\u544a\u8bc9\u6211\u4e3b\u9898\u5c31\u884c\u3002";
    }

    private static class SessionRecord {
        private String id;
        private String owner;
        private String title;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;
        private List<AiChatMessageDto> messages;
    }
}
