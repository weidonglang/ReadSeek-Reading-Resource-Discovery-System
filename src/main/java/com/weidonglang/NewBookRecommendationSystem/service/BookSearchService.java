package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.dto.BookSearchResponseDto;

public interface BookSearchService {
    BookSearchResponseDto searchByBm25(String query, Integer limit);

    BookSearchResponseDto searchBooks(String query, Integer limit);
}
