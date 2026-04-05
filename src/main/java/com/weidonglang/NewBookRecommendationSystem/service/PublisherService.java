package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.dao.PublisherDao;
import com.weidonglang.NewBookRecommendationSystem.dto.PublisherDto;
import com.weidonglang.NewBookRecommendationSystem.entity.Publisher;
import com.weidonglang.NewBookRecommendationSystem.service.base.BaseService;
import com.weidonglang.NewBookRecommendationSystem.transformer.PublisherTransformer;

import java.util.List;
public interface PublisherService extends BaseService<Publisher, PublisherDto, PublisherDao, PublisherTransformer> {
    List<PublisherDto> findAllActive();
}
/*
weidonglang
2026.3-2027.9
*/
