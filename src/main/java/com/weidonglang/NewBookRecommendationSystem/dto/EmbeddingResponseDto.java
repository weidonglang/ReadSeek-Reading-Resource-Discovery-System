package com.weidonglang.NewBookRecommendationSystem.dto;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Collections;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class EmbeddingResponseDto {
    @JsonAlias({"vector", "embedding"})
    private List<Double> vector;
    private String model;
    private Integer dimensions;
    private List<EmbeddingItemDto> data;

    public List<Double> resolveVector() {
        if (vector != null && !vector.isEmpty()) {
            return vector;
        }
        if (data != null && !data.isEmpty() && data.get(0) != null) {
            List<Double> nestedVector = data.get(0).getVector();
            if (nestedVector != null && !nestedVector.isEmpty()) {
                return nestedVector;
            }
        }
        return Collections.emptyList();
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class EmbeddingItemDto {
        @JsonAlias({"vector", "embedding"})
        private List<Double> vector;
    }
}
