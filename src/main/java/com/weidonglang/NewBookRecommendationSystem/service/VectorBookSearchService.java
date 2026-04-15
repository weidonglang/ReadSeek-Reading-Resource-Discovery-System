package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.dto.BookSearchHitDto;

import java.util.List;

public interface VectorBookSearchService {
    List<BookSearchHitDto> search(String query, Integer limit);

    default boolean isAvailable() {
        return false;
    }
}
