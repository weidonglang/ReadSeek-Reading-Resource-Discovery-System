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
public class OllamaLlmChatClient implements LlmChatClient {
    private final RagProperties ragProperties;
    private final ObjectMapper objectMapper;
    private final HttpClient httpClient;

    public OllamaLlmChatClient(RagProperties ragProperties, ObjectMapper objectMapper) {
        this.ragProperties = ragProperties;
        this.objectMapper = objectMapper;
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
    }

    @Override
    public boolean supports(String provider) {
        return "ollama".equalsIgnoreCase(provider) || "local".equalsIgnoreCase(provider);
    }

    @Override
    public LlmChatResult chat(LlmChatRequest request) {
        if (!ragProperties.getOllama().isEnabled()) {
            throw new LlmProviderException("Ollama provider is disabled.");
        }
        long startedAt = System.nanoTime();
        try {
            Map<String, Object> body = new LinkedHashMap<>();
            body.put("model", request.getModel());
            body.put("messages", List.of(
                    Map.of("role", "system", "content", request.getSystemPrompt()),
                    Map.of("role", "user", "content", request.getUserPrompt())
            ));
            body.put("think", ragProperties.getOllama().isThink());
            body.put("stream", ragProperties.getOllama().isStream());
            if (request.getKeepAlive() != null && !request.getKeepAlive().isBlank()) {
                body.put("keep_alive", request.getKeepAlive());
            }

            Map<String, Object> options = new LinkedHashMap<>();
            options.put("temperature", request.getTemperature());
            options.put("top_p", request.getTopP());
            options.put("num_ctx", request.getNumCtx());
            options.put("num_predict", request.getNumPredict());
            body.put("options", options);

            HttpRequest httpRequest = HttpRequest.newBuilder()
                    .uri(resolveChatEndpoint())
                    .timeout(Duration.ofSeconds(Math.max(1, request.getTimeoutSeconds())))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(objectMapper.writeValueAsString(body)))
                    .build();
            HttpResponse<String> response = httpClient.send(httpRequest, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() < 200 || response.statusCode() >= 300) {
                throw new LlmProviderException("Ollama returned status " + response.statusCode());
            }
            JsonNode root = objectMapper.readTree(response.body());
            String content = root.path("message").path("content").asText("");
            if (content == null || content.isBlank()) {
                throw new LlmProviderException("Ollama response did not contain message.content.");
            }
            long latencyMs = Duration.ofNanos(System.nanoTime() - startedAt).toMillis();
            return new LlmChatResult(content, "ollama", request.getModel(), request.getModel() + "@ollama", latencyMs);
        } catch (LlmProviderException exception) {
            throw exception;
        } catch (Exception exception) {
            log.debug("Ollama chat failed", exception);
            throw new LlmProviderException("Ollama request failed: " + exception.getMessage(), exception);
        }
    }

    private URI resolveChatEndpoint() {
        String endpoint = ragProperties.getOllama().getChatEndpoint();
        if (endpoint != null && !endpoint.isBlank()) {
            return URI.create(endpoint.trim());
        }
        String baseUrl = ragProperties.getOllama().getBaseUrl();
        if (baseUrl == null || baseUrl.isBlank()) {
            baseUrl = "http://localhost:11434";
        }
        String normalized = baseUrl.endsWith("/") ? baseUrl.substring(0, baseUrl.length() - 1) : baseUrl;
        return URI.create(normalized + "/api/chat");
    }
}
