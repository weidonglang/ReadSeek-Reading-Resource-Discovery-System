package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.dao.BookCategoryDao;
import com.weidonglang.NewBookRecommendationSystem.dto.BookCategoryDto;
import com.weidonglang.NewBookRecommendationSystem.entity.BookCategory;
import com.weidonglang.NewBookRecommendationSystem.service.base.BaseService;
import com.weidonglang.NewBookRecommendationSystem.transformer.BookCategoryTransformer;
public interface BookCategoryService extends BaseService<BookCategory, BookCategoryDto, BookCategoryDao, BookCategoryTransformer> {
}
/*
weidonglang
2026.3-2027.9
*/
