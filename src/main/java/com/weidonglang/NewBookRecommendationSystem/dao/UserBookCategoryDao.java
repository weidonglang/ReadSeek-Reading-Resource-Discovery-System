package com.weidonglang.NewBookRecommendationSystem.dao;

import com.weidonglang.NewBookRecommendationSystem.dao.base.BaseDao;
import com.weidonglang.NewBookRecommendationSystem.entity.UserBookCategory;
import com.weidonglang.NewBookRecommendationSystem.repository.UserBookCategoryRepository;

import java.util.List;
public interface UserBookCategoryDao extends BaseDao<UserBookCategory, UserBookCategoryRepository> {
    List<UserBookCategory> findAllByUserId(Long userId);

    void deleteAllByUserId(Long userId);
}
/*
weidonglang
2026.3-2027.9
*/
