package com.weidonglang.NewBookRecommendationSystem.dao;

import com.weidonglang.NewBookRecommendationSystem.dao.base.BaseDao;
import com.weidonglang.NewBookRecommendationSystem.entity.Tag;
import com.weidonglang.NewBookRecommendationSystem.repository.TagRepository;

import java.util.List;
public interface TagDao extends BaseDao<Tag, TagRepository> {
    List<Tag> findAllActive();
}
/*
weidonglang
2026.3-2027.9
*/
