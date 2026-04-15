package com.weidonglang.NewBookRecommendationSystem.service;

import java.util.List;
import java.util.Optional;

public interface EmbeddingProvider {
    Optional<List<Float>> embedQuery(String text);

    Optional<List<Float>> embedDocument(String text);

    default boolean isEnabled() {
        return false;
    }

    default String getProviderName() {
        return "none";
    }
}
