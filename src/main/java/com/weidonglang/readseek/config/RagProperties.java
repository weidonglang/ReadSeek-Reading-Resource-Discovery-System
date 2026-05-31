package com.weidonglang.readseek.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.util.Locale;

@Getter
@Setter
@Component
@ConfigurationProperties(prefix = "readseek.rag")
public class RagProperties {
    private boolean llmEnabled = true;
    private boolean fallbackToDeterministic = true;
    private String defaultMode = "standard";
    private String defaultProvider = "ollama";
    private String evidencePolicy = "answer only from retrieved catalog evidence; refuse when evidence is empty";
    private ModeProperties fast = new ModeProperties("qwen2.5:7b", 5, 3, 0.2D, 0.9D, 4096, 512, "5m", 60);
    private ModeProperties standard = new ModeProperties("qwen3:8b", 10, 5, 0.2D, 0.9D, 4096, 1024, "10m", 120);
    private ModeProperties expert = new ModeProperties("qwen3:14b", 20, 8, 0.1D, 0.85D, 8192, 1536, "2m", 240);
    private OllamaProperties ollama = new OllamaProperties();
    private OnlineProperties online = new OnlineProperties();

    public String normalizeMode(String requestedMode) {
        String normalized = requestedMode == null || requestedMode.isBlank()
                ? defaultMode
                : requestedMode.trim().toLowerCase(Locale.ROOT);
        return switch (normalized) {
            case "fast", "standard", "expert" -> normalized;
            default -> "standard";
        };
    }

    public String normalizeProvider(String requestedProvider) {
        String normalized = requestedProvider == null || requestedProvider.isBlank()
                ? defaultProvider
                : requestedProvider.trim().toLowerCase(Locale.ROOT);
        return switch (normalized) {
            case "ollama", "local" -> "ollama";
            case "online", "external", "openai", "openai-compatible" -> "online";
            case "deterministic", "template" -> "deterministic";
            default -> defaultProvider == null || defaultProvider.isBlank() ? "ollama" : defaultProvider;
        };
    }

    public ModeProperties mode(String mode) {
        return switch (normalizeMode(mode)) {
            case "fast" -> fast;
            case "expert" -> expert;
            default -> standard;
        };
    }

    @Getter
    @Setter
    public static class ModeProperties {
        private String model;
        private String onlineModel;
        private int topK;
        private int rerankTopK;
        private double temperature;
        private double topP;
        private int numCtx;
        private int numPredict;
        private String keepAlive;
        private int timeoutSeconds;

        public ModeProperties() {
        }

        public ModeProperties(String model,
                              int topK,
                              int rerankTopK,
                              double temperature,
                              double topP,
                              int numCtx,
                              int numPredict,
                              String keepAlive,
                              int timeoutSeconds) {
            this.model = model;
            this.onlineModel = model;
            this.topK = topK;
            this.rerankTopK = rerankTopK;
            this.temperature = temperature;
            this.topP = topP;
            this.numCtx = numCtx;
            this.numPredict = numPredict;
            this.keepAlive = keepAlive;
            this.timeoutSeconds = timeoutSeconds;
        }
    }

    @Getter
    @Setter
    public static class OllamaProperties {
        private boolean enabled = true;
        private String baseUrl = "http://localhost:11434";
        private String chatEndpoint = "http://localhost:11434/api/chat";
        private boolean stream = false;
        private boolean think = false;
    }

    @Getter
    @Setter
    public static class OnlineProperties {
        private boolean enabled = false;
        private String baseUrl = "";
        private String chatCompletionsEndpoint = "/chat/completions";
        private String apiKey = "";
        private String apiKeyHeader = "Authorization";
        private String apiKeyPrefix = "Bearer ";
        private String model = "";
    }
}
