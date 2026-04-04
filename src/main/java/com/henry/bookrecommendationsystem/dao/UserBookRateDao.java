package com.henry.bookrecommendationsystem.dao;

import com.henry.bookrecommendationsystem.dao.base.BaseDao;
import com.henry.bookrecommendationsystem.entity.UserBookRate;
import com.henry.bookrecommendationsystem.repository.UserBookRatingRepository;

import java.util.List;
import java.util.Optional;
public interface UserBookRateDao extends BaseDao<UserBookRate, UserBookRatingRepository> {
    Optional<UserBookRate> findUserBookRateByUserIdAndBookId(Long userId, Long bookId);

    List<UserBookRate> findAllByUserId(Long userId);
}
