package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dto.BookSearchHitDto;

import java.util.List;

public interface VectorBookSearchService {
    List<BookSearchHitDto> search(String query, Integer limit);

    default boolean isAvailable() {
        return false;
    }
}
