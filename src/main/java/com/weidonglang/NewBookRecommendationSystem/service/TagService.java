package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.dao.TagDao;
import com.weidonglang.NewBookRecommendationSystem.dto.TagDto;
import com.weidonglang.NewBookRecommendationSystem.entity.Tag;
import com.weidonglang.NewBookRecommendationSystem.service.base.BaseService;
import com.weidonglang.NewBookRecommendationSystem.transformer.TagTransformer;

import java.util.List;
public interface TagService extends BaseService<Tag, TagDto, TagDao, TagTransformer> {
    List<TagDto> findAllActive();
}
/*
weidonglang
2026.3-2027.9
*/
