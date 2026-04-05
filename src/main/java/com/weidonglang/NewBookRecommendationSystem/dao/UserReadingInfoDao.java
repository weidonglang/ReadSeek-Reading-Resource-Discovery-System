package com.weidonglang.NewBookRecommendationSystem.dao;

import com.weidonglang.NewBookRecommendationSystem.dao.base.BaseDao;
import com.weidonglang.NewBookRecommendationSystem.entity.UserReadingInfo;
import com.weidonglang.NewBookRecommendationSystem.repository.UserReadingInfoRepository;

import java.util.Optional;
public interface UserReadingInfoDao extends BaseDao<UserReadingInfo, UserReadingInfoRepository> {
    Optional<UserReadingInfo> findByUserId(Long userId);
}
/*
weidonglang
2026.3-2027.9
*/
