package com.weidonglang.NewBookRecommendationSystem.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookSearchHitDto {
    private BookDto book;
    private Double score;
    private String matchType;
    private String reason;
}
