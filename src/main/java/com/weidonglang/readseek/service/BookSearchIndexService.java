package com.weidonglang.readseek.service;

public interface BookSearchIndexService {
    long rebuildBookIndex();

    void indexBook(Long bookId);
}
