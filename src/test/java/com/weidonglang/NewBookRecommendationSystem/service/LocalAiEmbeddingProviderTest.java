package com.weidonglang.NewBookRecommendationSystem.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.weidonglang.NewBookRecommendationSystem.config.SearchProperties;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class LocalAiEmbeddingProviderTest {

    private SearchProperties searchProperties;

    @BeforeEach
    void setUp() {
        searchProperties = new SearchProperties();
    }

    @Test
    void embedQueryShouldReturnEmptyWhenEmbeddingIsDisabled() {
        LocalAiEmbeddingProvider provider = new LocalAiEmbeddingProvider(searchProperties, new ObjectMapper());

        assertFalse(provider.isEnabled());
        assertTrue(provider.embedQuery("classic romance").isEmpty());
        assertTrue(provider.embedDocument("book description").isEmpty());
    }
}
