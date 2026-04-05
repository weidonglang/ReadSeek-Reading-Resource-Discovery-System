package com.weidonglang.NewBookRecommendationSystem.repository;

import com.weidonglang.NewBookRecommendationSystem.entity.UserBookCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
@Repository
public interface UserBookCategoryRepository extends JpaRepository<UserBookCategory, Long> {
    List<UserBookCategory> findAllByUserIdAndMarkedAsDeletedFalse(Long userId);

    @Modifying
    @Query("delete from UserBookCategory ubc where ubc.user.id = :userId")
    void deleteAllByUserId(@Param("userId") Long userId);
}
/*
weidonglang
2026.3-2027.9
*/
