package com.weidonglang.NewBookRecommendationSystem.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EmbeddingRequestDto {
    private String text;
    private String model;
    private String inputType;
}
