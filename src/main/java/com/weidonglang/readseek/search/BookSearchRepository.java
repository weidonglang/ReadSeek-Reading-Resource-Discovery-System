package com.weidonglang.readseek.search;

import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;

public interface BookSearchRepository extends ElasticsearchRepository<BookSearchDocument, Long> {
}
