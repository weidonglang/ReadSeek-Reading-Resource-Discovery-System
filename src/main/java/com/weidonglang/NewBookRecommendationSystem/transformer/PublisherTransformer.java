package com.weidonglang.NewBookRecommendationSystem.transformer;

import com.weidonglang.NewBookRecommendationSystem.dto.PublisherDto;
import com.weidonglang.NewBookRecommendationSystem.entity.Publisher;
import com.weidonglang.NewBookRecommendationSystem.transformer.base.BaseTransformer;
import com.weidonglang.NewBookRecommendationSystem.transformer.mapper.PublisherMapper;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;
@Component
@AllArgsConstructor
public class PublisherTransformer implements BaseTransformer<Publisher, PublisherDto, PublisherMapper> {
    private final PublisherMapper publisherMapper;

    @Override
    public PublisherMapper getMapper() {
        return publisherMapper;
    }
}
