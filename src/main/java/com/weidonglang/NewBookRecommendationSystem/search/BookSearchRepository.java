package com.weidonglang.NewBookRecommendationSystem.search;

import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;

public interface BookSearchRepository extends ElasticsearchRepository<BookSearchDocument, Long> {
}
