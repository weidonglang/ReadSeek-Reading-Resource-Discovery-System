package com.weidonglang.NewBookRecommendationSystem.dao;

import com.weidonglang.NewBookRecommendationSystem.dao.base.BaseDao;
import com.weidonglang.NewBookRecommendationSystem.entity.Publisher;
import com.weidonglang.NewBookRecommendationSystem.repository.PublisherRepository;

import java.util.List;
public interface PublisherDao extends BaseDao<Publisher, PublisherRepository> {
    List<Publisher> findAllActive();
}
/*
weidonglang
2026.3-2027.9
*/
