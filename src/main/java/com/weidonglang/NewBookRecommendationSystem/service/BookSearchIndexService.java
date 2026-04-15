package com.weidonglang.NewBookRecommendationSystem.service;

public interface BookSearchIndexService {
    long rebuildBookIndex();

    void indexBook(Long bookId);
}
