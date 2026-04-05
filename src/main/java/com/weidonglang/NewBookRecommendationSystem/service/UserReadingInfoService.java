package com.weidonglang.NewBookRecommendationSystem.service;


import com.weidonglang.NewBookRecommendationSystem.dao.UserReadingInfoDao;
import com.weidonglang.NewBookRecommendationSystem.dto.UserReadingInfoDto;
import com.weidonglang.NewBookRecommendationSystem.entity.UserReadingInfo;
import com.weidonglang.NewBookRecommendationSystem.service.base.BaseService;
import com.weidonglang.NewBookRecommendationSystem.transformer.UserReadingInfoTransformer;
public interface UserReadingInfoService extends BaseService<UserReadingInfo, UserReadingInfoDto, UserReadingInfoDao, UserReadingInfoTransformer> {
    UserReadingInfoDto findUserReadingInfo();
}
