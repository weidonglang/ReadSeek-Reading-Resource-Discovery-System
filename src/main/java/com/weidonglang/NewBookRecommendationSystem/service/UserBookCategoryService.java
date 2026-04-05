package com.weidonglang.NewBookRecommendationSystem.service;


import com.weidonglang.NewBookRecommendationSystem.dao.UserBookCategoryDao;
import com.weidonglang.NewBookRecommendationSystem.dto.UserBookCategoryDto;
import com.weidonglang.NewBookRecommendationSystem.entity.UserBookCategory;
import com.weidonglang.NewBookRecommendationSystem.service.base.BaseService;
import com.weidonglang.NewBookRecommendationSystem.transformer.UserBookCategoryTransformer;

import java.util.List;
public interface UserBookCategoryService extends BaseService<UserBookCategory, UserBookCategoryDto, UserBookCategoryDao, UserBookCategoryTransformer> {
    List<UserBookCategoryDto> findAllUserBookCategories();

    void deleteAllCurrentUserBookCategories();
}
