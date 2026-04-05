package com.weidonglang.NewBookRecommendationSystem.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BookRecommendationOverviewDto {
    private String title;
    private List<BookRecommendationShelfDto> shelves;
}
/*
weidonglang
2026.3-2027.9
*/
