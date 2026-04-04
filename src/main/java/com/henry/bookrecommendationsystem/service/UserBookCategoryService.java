package com.henry.bookrecommendationsystem.service;


import com.henry.bookrecommendationsystem.dao.UserBookCategoryDao;
import com.henry.bookrecommendationsystem.dto.UserBookCategoryDto;
import com.henry.bookrecommendationsystem.entity.UserBookCategory;
import com.henry.bookrecommendationsystem.service.base.BaseService;
import com.henry.bookrecommendationsystem.transformer.UserBookCategoryTransformer;

import java.util.List;
public interface UserBookCategoryService extends BaseService<UserBookCategory, UserBookCategoryDto, UserBookCategoryDao, UserBookCategoryTransformer> {
    List<UserBookCategoryDto> findAllUserBookCategories();

    void deleteAllCurrentUserBookCategories();
}
