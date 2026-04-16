package com.weidonglang.readseek.dao;

import com.weidonglang.readseek.dao.base.BaseDao;
import com.weidonglang.readseek.entity.UserBookCategory;
import com.weidonglang.readseek.repository.UserBookCategoryRepository;

import java.util.List;
public interface UserBookCategoryDao extends BaseDao<UserBookCategory, UserBookCategoryRepository> {
    List<UserBookCategory> findAllByUserId(Long userId);

    void deleteAllByUserId(Long userId);
}
/*
weidonglang
2026.3-2027.9
*/
