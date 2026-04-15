package com.weidonglang.NewBookRecommendationSystem.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.elasticsearch.repository.config.EnableElasticsearchRepositories;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@Configuration
@EnableJpaRepositories(basePackages = "com.weidonglang.NewBookRecommendationSystem.repository")
@EnableElasticsearchRepositories(basePackages = "com.weidonglang.NewBookRecommendationSystem.search")
public class DataStoreConfigurations {
}
