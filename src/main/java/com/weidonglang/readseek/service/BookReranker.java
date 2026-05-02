package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dto.BookSearchHitDto;

import java.util.List;
import java.util.Optional;

public interface BookReranker {
    Optional<List<BookSearchHitDto>> rerank(String query, List<BookSearchHitDto> candidates, int topN);

    boolean isEnabled();
}
