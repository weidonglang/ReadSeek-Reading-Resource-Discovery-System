package com.weidonglang.NewBookRecommendationSystem.transformer;

import com.weidonglang.NewBookRecommendationSystem.dto.UserBookRateDto;
import com.weidonglang.NewBookRecommendationSystem.entity.UserBookRate;
import com.weidonglang.NewBookRecommendationSystem.transformer.base.BaseTransformer;
import com.weidonglang.NewBookRecommendationSystem.transformer.mapper.UserBookRateMapper;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;
@Component
@AllArgsConstructor
public class UserBookRateTransformer implements BaseTransformer<UserBookRate, UserBookRateDto, UserBookRateMapper> {
    private final UserBookRateMapper userBookRateMapper;

    @Override
    public UserBookRateMapper getMapper() {
        return userBookRateMapper;
    }
}
