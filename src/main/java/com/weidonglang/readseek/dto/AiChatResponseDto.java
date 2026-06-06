package com.weidonglang.readseek.dto;

import com.weidonglang.readseek.enums.SearchQueryIntent;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AiChatResponseDto {
    private String sessionId;
    private AiChatMessageDto userMessage;
    private AiChatMessageDto assistantMessage;
    private String answer;
    private Boolean answerable;
    private List<String> citations;
    private List<EvidenceSnippetDto> evidence;
    private List<AiChatRecommendationDto> recommendations;
    private String strategy;
    private SearchQueryIntent queryIntent;
    private Boolean fallbackApplied;
    private String ragMode;
    private String llmProvider;
    private String model;
    private String generationBackend;
    private Boolean llmFallbackApplied;
    private Long retrievalLatencyMs;
    private Long generationLatencyMs;
    private Long totalLatencyMs;
    private List<String> limitations;
    private List<String> followUps;
}
