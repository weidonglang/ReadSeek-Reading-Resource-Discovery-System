package com.weidonglang.NewBookRecommendationSystem.dao;

import com.weidonglang.NewBookRecommendationSystem.entity.UserReadingInfo;
import com.weidonglang.NewBookRecommendationSystem.repository.UserReadingInfoRepository;
import org.springframework.stereotype.Component;

import java.util.Optional;
@Component
public class UserReadingInfoDaoImpl implements UserReadingInfoDao {
    private final UserReadingInfoRepository userReadingInfoRepository;

    public UserReadingInfoDaoImpl(UserReadingInfoRepository userReadingInfoRepository) {
        this.userReadingInfoRepository = userReadingInfoRepository;
    }

    @Override
    public UserReadingInfoRepository getRepository() {
        return userReadingInfoRepository;
    }

    @Override
    public Optional<UserReadingInfo> findByUserId(Long userId) {
        return getRepository().findByUserId(userId);
    }
}
/*
weidonglang
2026.3-2027.9
*/
