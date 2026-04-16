package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dto.BookSearchResponseDto;

public interface ResourceSearchService {
    BookSearchResponseDto searchByBm25(String query, Integer limit);

    BookSearchResponseDto searchResources(String query, Integer limit);
}
