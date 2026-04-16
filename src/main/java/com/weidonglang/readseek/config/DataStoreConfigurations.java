package com.weidonglang.readseek.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.elasticsearch.repository.config.EnableElasticsearchRepositories;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@Configuration
@EnableJpaRepositories(basePackages = "com.weidonglang.readseek.repository")
@EnableElasticsearchRepositories(basePackages = "com.weidonglang.readseek.search")
public class DataStoreConfigurations {
}
