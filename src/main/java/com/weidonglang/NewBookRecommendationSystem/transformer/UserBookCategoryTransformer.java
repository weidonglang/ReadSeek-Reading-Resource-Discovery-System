package com.weidonglang.NewBookRecommendationSystem.transformer;

import com.weidonglang.NewBookRecommendationSystem.dto.UserBookCategoryDto;
import com.weidonglang.NewBookRecommendationSystem.entity.UserBookCategory;
import com.weidonglang.NewBookRecommendationSystem.transformer.base.BaseTransformer;
import com.weidonglang.NewBookRecommendationSystem.transformer.mapper.UserBookCategoryMapper;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;
@Component
@AllArgsConstructor
public class UserBookCategoryTransformer implements BaseTransformer<UserBookCategory, UserBookCategoryDto, UserBookCategoryMapper> {
    private final UserBookCategoryMapper userBookCategoryMapper;

    @Override
    public UserBookCategoryMapper getMapper() {
        return userBookCategoryMapper;
    }
}
