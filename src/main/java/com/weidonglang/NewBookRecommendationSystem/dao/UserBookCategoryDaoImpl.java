package com.weidonglang.NewBookRecommendationSystem.dao;

import com.weidonglang.NewBookRecommendationSystem.entity.UserBookCategory;
import com.weidonglang.NewBookRecommendationSystem.repository.UserBookCategoryRepository;
import org.springframework.stereotype.Component;

import java.util.List;
@Component
public class UserBookCategoryDaoImpl implements UserBookCategoryDao {
    private final UserBookCategoryRepository userBookCategoryRepository;

    public UserBookCategoryDaoImpl(UserBookCategoryRepository userBookCategoryRepository) {
        this.userBookCategoryRepository = userBookCategoryRepository;
    }

    @Override
    public UserBookCategoryRepository getRepository() {
        return userBookCategoryRepository;
    }

    @Override
    public List<UserBookCategory> findAllByUserId(Long userId) {
        return getRepository().findAllByUserIdAndMarkedAsDeletedFalse(userId);
    }

    @Override
    public void deleteAllByUserId(Long userId) {
        getRepository().deleteAllByUserId(userId);
        getRepository().flush();
    }
}
/*
weidonglang
2026.3-2027.9
*/
