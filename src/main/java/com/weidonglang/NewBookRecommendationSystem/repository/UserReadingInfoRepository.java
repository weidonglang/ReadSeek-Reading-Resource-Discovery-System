package com.weidonglang.NewBookRecommendationSystem.repository;

import com.weidonglang.NewBookRecommendationSystem.entity.UserReadingInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
@Repository
public interface UserReadingInfoRepository extends JpaRepository<UserReadingInfo, Long> {
    Optional<UserReadingInfo> findByUserId(Long userId);
}
/*
weidonglang
2026.3-2027.9
*/
