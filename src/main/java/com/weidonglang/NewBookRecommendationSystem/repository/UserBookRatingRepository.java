package com.weidonglang.NewBookRecommendationSystem.repository;

import com.weidonglang.NewBookRecommendationSystem.entity.UserBookRate;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
@Repository
public interface UserBookRatingRepository extends JpaRepository<UserBookRate, Long> {
    Optional<UserBookRate> findUserBookRateByUserIdAndBookId(Long userId, Long bookId);

    List<UserBookRate> findAllByMarkedAsDeletedFalse();

    List<UserBookRate> findAllByUserIdAndMarkedAsDeletedFalse(Long userID);

    @Query("SELECT COUNT(ubr.id) FROM UserBookRate ubr " +
            "WHERE ubr.markedAsDeleted = false " +
            "AND ubr.user.id = :userId " +
            "AND ubr.createdDate >= :fromDate")
    Long countByUserIdAndCreatedDateGreaterThanEqualAndMarkedAsDeletedFalse(@Param("userId") Long userId,
                                                                             @Param("fromDate") LocalDateTime fromDate);
}
/*
weidonglang
2026.3-2027.9
*/
