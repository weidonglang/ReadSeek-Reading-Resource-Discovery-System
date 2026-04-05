package com.weidonglang.NewBookRecommendationSystem.transformer;

import com.weidonglang.NewBookRecommendationSystem.dto.TagDto;
import com.weidonglang.NewBookRecommendationSystem.entity.Tag;
import com.weidonglang.NewBookRecommendationSystem.transformer.base.BaseTransformer;
import com.weidonglang.NewBookRecommendationSystem.transformer.mapper.TagMapper;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;
@Component
@AllArgsConstructor
public class TagTransformer implements BaseTransformer<Tag, TagDto, TagMapper> {
    private final TagMapper tagMapper;

    @Override
    public TagMapper getMapper() {
        return tagMapper;
    }
}
