package com.weidonglang.NewBookRecommendationSystem.transformer;

import com.weidonglang.NewBookRecommendationSystem.dto.UserReadingInfoDto;
import com.weidonglang.NewBookRecommendationSystem.entity.UserReadingInfo;
import com.weidonglang.NewBookRecommendationSystem.transformer.base.BaseTransformer;
import com.weidonglang.NewBookRecommendationSystem.transformer.mapper.UserReadingInfoMapper;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;
@Component
@AllArgsConstructor
public class UserReadingInfoTransformer implements BaseTransformer<UserReadingInfo, UserReadingInfoDto, UserReadingInfoMapper> {
    private final UserReadingInfoMapper userReadingInfoMapper;

    @Override
    public UserReadingInfoMapper getMapper() {
        return userReadingInfoMapper;
    }
}
