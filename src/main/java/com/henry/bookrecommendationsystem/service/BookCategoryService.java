package com.henry.bookrecommendationsystem.service;

import com.henry.bookrecommendationsystem.dao.BookCategoryDao;
import com.henry.bookrecommendationsystem.dto.BookCategoryDto;
import com.henry.bookrecommendationsystem.entity.BookCategory;
import com.henry.bookrecommendationsystem.service.base.BaseService;
import com.henry.bookrecommendationsystem.transformer.BookCategoryTransformer;
public interface BookCategoryService extends BaseService<BookCategory, BookCategoryDto, BookCategoryDao, BookCategoryTransformer> {
}
