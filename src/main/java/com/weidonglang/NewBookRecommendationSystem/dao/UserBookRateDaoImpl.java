package com.weidonglang.NewBookRecommendationSystem.dao;

import com.weidonglang.NewBookRecommendationSystem.entity.UserBookRate;
import com.weidonglang.NewBookRecommendationSystem.repository.UserBookRatingRepository;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
@Component
public class UserBookRateDaoImpl implements UserBookRateDao {
    private final UserBookRatingRepository userBookRatingRepository;

    public UserBookRateDaoImpl(UserBookRatingRepository userBookRatingRepository) {
        this.userBookRatingRepository = userBookRatingRepository;
    }

    @Override
    public UserBookRatingRepository getRepository() {
        return userBookRatingRepository;
    }

    @Override
    public Optional<UserBookRate> findUserBookRateByUserIdAndBookId(Long userId, Long bookId) {
        return getRepository().findUserBookRateByUserIdAndBookId(userId, bookId);
    }

    @Override
    public List<UserBookRate> findAllByUserId(Long userId) {
        return getRepository().findAllByUserIdAndMarkedAsDeletedFalse(userId);
    }
}
/*
weidonglang
2026.3-2027.9
*/
