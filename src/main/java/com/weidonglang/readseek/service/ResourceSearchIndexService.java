package com.weidonglang.readseek.service;

public interface ResourceSearchIndexService {
    long rebuildResourceIndex();

    void indexResource(Long resourceId);
}
