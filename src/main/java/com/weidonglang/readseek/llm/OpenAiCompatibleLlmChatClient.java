package com.weidonglang.readseek.llm;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.weidonglang.readseek.config.RagProperties;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Component
public class OpenAiCompatibleLlmChatClient implements LlmChatClient {
    private final RagProperties ragProperties;
    private final ObjectMapper objectMapper;
    private final HttpClient httpClient;

    public OpenAiCompatibleLlmChatClient(RagProperties ragProperties, ObjectMapper objectMapper) {
        this.ragProperties = ragProperties;
        this.objectMapper = objectMapper;
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
    }

    @Override
    public boolean supports(String provider) {
        return "online".equalsIgnoreCase(provider)
                || "external".equalsIgnoreCase(provider)
                || "openai".equalsIgnoreCase(provider)
                || "openai-compatible".equalsIgnoreCase(provider);
    }

    @Override
    public LlmChatResult chat(LlmChatRequest request) {
        RagProperties.OnlineProperties online = ragProperties.getOnline();
        if (!online.isEnabled()) {
            throw new LlmProviderException("Online AI provider is disabled.");
        }
        if (online.getBaseUrl() == null || online.getBaseUrl().isBlank()) {
            throw new LlmProviderException("Online AI base URL is not configured.");
        }
        if (online.getApiKey() == null || online.getApiKey().isBlank()) {
            throw new LlmProviderException("Online AI API key is not configured.");
        }

        long startedAt = System.nanoTime();
        try {
            Map<String, Object> body = new LinkedHashMap<>();
            body.put("model", request.getModel());
            body.put("messages", List.of(
                    Map.of("role", "system", "content", request.getSystemPrompt()),
                    Map.of("role", "user", "content", request.getUserPrompt())
            ));
            body.put("stream", false);
            body.put("temperature", request.getTemperature());
            body.put("top_p", request.getTopP());
            body.put("max_tokens", request.getNumPredict());

            String apiKey = online.getApiKeyPrefix() == null
                    ? online.getApiKey()
                    : online.getApiKeyPrefix() + online.getApiKey();
            HttpRequest httpRequest = HttpRequest.newBuilder()
                    .uri(resolveChatEndpoint())
                    .timeout(Duration.ofSeconds(Math.max(1, request.getTimeoutSeconds())))
                    .header("Content-Type", "application/json")
                    .header(online.getApiKeyHeader(), apiKey)
                    .POST(HttpRequest.BodyPublishers.ofString(objectMapper.writeValueAsString(body)))
                    .build();
            HttpResponse<String> response = httpClient.send(httpRequest, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() < 200 || response.statusCode() >= 300) {
                throw new LlmProviderException("Online AI returned status " + response.statusCode());
            }
            JsonNode root = objectMapper.readTree(response.body());
            String content = root.path("choices").path(0).path("message").path("content").asText("");
            if (content == null || content.isBlank()) {
                throw new LlmProviderException("Online AI response did not contain choices[0].message.content.");
            }
            long latencyMs = Duration.ofNanos(System.nanoTime() - startedAt).toMillis();
            return new LlmChatResult(content, "online", request.getModel(), request.getModel() + "@openai-compatible", latencyMs);
        } catch (LlmProviderException exception) {
            throw exception;
        } catch (Exception exception) {
            log.debug("OpenAI-compatible chat failed", exception);
            throw new LlmProviderException("Online AI request failed: " + exception.getMessage(), exception);
        }
    }

    private URI resolveChatEndpoint() {
        RagProperties.OnlineProperties online = ragProperties.getOnline();
        String baseUrl = online.getBaseUrl().trim();
        String normalizedBase = baseUrl.endsWith("/") ? baseUrl.substring(0, baseUrl.length() - 1) : baseUrl;
        String endpoint = online.getChatCompletionsEndpoint();
        if (endpoint == null || endpoint.isBlank()) {
            endpoint = "/chat/completions";
        }
        if (endpoint.startsWith("http://") || endpoint.startsWith("https://")) {
            return URI.create(endpoint);
        }
        String normalizedEndpoint = endpoint.startsWith("/") ? endpoint : "/" + endpoint;
        return URI.create(normalizedBase + normalizedEndpoint);
    }
}
