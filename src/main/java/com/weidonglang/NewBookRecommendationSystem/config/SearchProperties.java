package com.weidonglang.NewBookRecommendationSystem.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Getter
@Setter
@Component
@ConfigurationProperties(prefix = "library.search")
public class SearchProperties {
    private boolean enabled = true;
    private String bookIndexName = "book-search-v1";
    private int maxResults = 20;
    private VectorProperties vector = new VectorProperties();
    private EmbeddingProperties embedding = new EmbeddingProperties();

    @Getter
    @Setter
    public static class VectorProperties {
        private boolean enabled = false;
        private int candidateLimit = 12;
        private double minScore = 0.0D;
    }

    @Getter
    @Setter
    public static class EmbeddingProperties {
        private boolean enabled = false;
        private String provider = "local-ai";
        private String baseUrl = "http://localhost:8001";
        private String model = "bge-small-zh-v1.5";
        private int dimensions = 384;
        private long timeoutMs = 5000L;
        private String queryInputType = "query";
        private String documentInputType = "document";
    }
}
