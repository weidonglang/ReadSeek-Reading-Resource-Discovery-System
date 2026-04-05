package com.weidonglang.NewBookRecommendationSystem.dao;

import com.weidonglang.NewBookRecommendationSystem.dao.base.BaseDao;
import com.weidonglang.NewBookRecommendationSystem.entity.UserBookRate;
import com.weidonglang.NewBookRecommendationSystem.repository.UserBookRatingRepository;

import java.util.List;
import java.util.Optional;
public interface UserBookRateDao extends BaseDao<UserBookRate, UserBookRatingRepository> {
    Optional<UserBookRate> findUserBookRateByUserIdAndBookId(Long userId, Long bookId);

    List<UserBookRate> findAllByUserId(Long userId);
}
/*
weidonglang
2026.3-2027.9
*/
