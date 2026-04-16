package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dto.BookSearchResponseDto;

public interface BookSearchService {
    BookSearchResponseDto searchByBm25(String query, Integer limit);

    BookSearchResponseDto searchBooks(String query, Integer limit);
}
