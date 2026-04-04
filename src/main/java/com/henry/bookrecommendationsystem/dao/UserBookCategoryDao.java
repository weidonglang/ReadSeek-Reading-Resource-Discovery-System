package com.henry.bookrecommendationsystem.dao;

import com.henry.bookrecommendationsystem.dao.base.BaseDao;
import com.henry.bookrecommendationsystem.entity.UserBookCategory;
import com.henry.bookrecommendationsystem.repository.UserBookCategoryRepository;

import java.util.List;
public interface UserBookCategoryDao extends BaseDao<UserBookCategory, UserBookCategoryRepository> {
    List<UserBookCategory> findAllByUserId(Long userId);

    void deleteAllByUserId(Long userId);
}
