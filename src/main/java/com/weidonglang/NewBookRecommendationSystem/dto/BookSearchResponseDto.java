package com.weidonglang.NewBookRecommendationSystem.dto;

import com.weidonglang.NewBookRecommendationSystem.enums.SearchQueryIntent;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookSearchResponseDto {
    private String query;
    private SearchQueryIntent queryIntent;
    private String strategy;
    private boolean fallbackApplied;
    private Integer returnedCount;
    private List<BookSearchHitDto> hits;
}
