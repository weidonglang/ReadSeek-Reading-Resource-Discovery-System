package com.weidonglang.NewBookRecommendationSystem.repository;

import com.weidonglang.NewBookRecommendationSystem.entity.UserBookRate;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
@Repository
public interface UserBookRatingRepository extends JpaRepository<UserBookRate, Long> {
    Optional<UserBookRate> findUserBookRateByUserIdAndBookId(Long userId, Long bookId);

    List<UserBookRate> findAllByUserIdAndMarkedAsDeletedFalse(Long userID);
}
/*
weidonglang
2026.3-2027.9
*/
