package com.weidonglang.readseek.service;


import com.weidonglang.readseek.dao.UserBookCategoryDao;
import com.weidonglang.readseek.dto.UserBookCategoryDto;
import com.weidonglang.readseek.entity.UserBookCategory;
import com.weidonglang.readseek.service.base.BaseService;
import com.weidonglang.readseek.transformer.UserBookCategoryTransformer;

import java.util.List;
public interface UserBookCategoryService extends BaseService<UserBookCategory, UserBookCategoryDto, UserBookCategoryDao, UserBookCategoryTransformer> {
    List<UserBookCategoryDto> findAllUserBookCategories();

    void deleteAllCurrentUserBookCategories();
}
