package com.weidonglang.NewBookRecommendationSystem.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.weidonglang.NewBookRecommendationSystem.config.SearchProperties;
import com.weidonglang.NewBookRecommendationSystem.dto.EmbeddingRequestDto;
import com.weidonglang.NewBookRecommendationSystem.dto.EmbeddingResponseDto;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Slf4j
@Service
public class LocalAiEmbeddingProvider implements EmbeddingProvider {
    private final SearchProperties searchProperties;
    private final ObjectMapper objectMapper;
    private final HttpClient httpClient;

    public LocalAiEmbeddingProvider(SearchProperties searchProperties,
                                    ObjectMapper objectMapper) {
        this.searchProperties = searchProperties;
        this.objectMapper = objectMapper;
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofMillis(searchProperties.getEmbedding().getTimeoutMs()))
                .build();
    }

    @Override
    public Optional<List<Float>> embedQuery(String text) {
        return requestEmbedding(text, searchProperties.getEmbedding().getQueryInputType());
    }

    @Override
    public Optional<List<Float>> embedDocument(String text) {
        return requestEmbedding(text, searchProperties.getEmbedding().getDocumentInputType());
    }

    @Override
    public boolean isEnabled() {
        return searchProperties.getEmbedding().isEnabled()
                && "local-ai".equalsIgnoreCase(searchProperties.getEmbedding().getProvider());
    }

    @Override
    public String getProviderName() {
        return searchProperties.getEmbedding().getProvider();
    }

    private Optional<List<Float>> requestEmbedding(String text, String inputType) {
        String normalizedText = text == null ? "" : text.trim();
        if (!isEnabled() || normalizedText.isBlank()) {
            return Optional.empty();
        }

        try {
            EmbeddingRequestDto requestDto = EmbeddingRequestDto.builder()
                    .text(normalizedText)
                    .model(searchProperties.getEmbedding().getModel())
                    .inputType(inputType)
                    .build();

            String payload = objectMapper.writeValueAsString(requestDto);
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(resolveEmbedUri())
                    .timeout(Duration.ofMillis(searchProperties.getEmbedding().getTimeoutMs()))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(payload))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() < 200 || response.statusCode() >= 300) {
                log.warn("LocalAiEmbeddingProvider: embedding request failed with status={}", response.statusCode());
                return Optional.empty();
            }

            EmbeddingResponseDto responseDto = objectMapper.readValue(response.body(), EmbeddingResponseDto.class);
            List<Double> rawVector = responseDto.resolveVector();
            if (rawVector.isEmpty()) {
                return Optional.empty();
            }

            if (searchProperties.getEmbedding().getDimensions() > 0
                    && rawVector.size() != searchProperties.getEmbedding().getDimensions()) {
                log.warn("LocalAiEmbeddingProvider: vector size mismatch expected={} actual={}",
                        searchProperties.getEmbedding().getDimensions(),
                        rawVector.size());
                return Optional.empty();
            }

            List<Float> vector = rawVector.stream()
                    .map(value -> value == null ? 0F : value.floatValue())
                    .collect(Collectors.toList());
            return Optional.of(vector);
        } catch (Exception exception) {
            log.debug("LocalAiEmbeddingProvider: embedding request skipped because {}", exception.getMessage());
            return Optional.empty();
        }
    }

    private URI resolveEmbedUri() {
        String baseUrl = searchProperties.getEmbedding().getBaseUrl();
        String normalizedBaseUrl = baseUrl == null ? "" : baseUrl.trim();
        if (normalizedBaseUrl.endsWith("/")) {
            normalizedBaseUrl = normalizedBaseUrl.substring(0, normalizedBaseUrl.length() - 1);
        }
        return URI.create(normalizedBaseUrl + "/embed");
    }
}
