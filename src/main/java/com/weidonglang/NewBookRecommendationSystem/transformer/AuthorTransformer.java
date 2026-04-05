package com.weidonglang.NewBookRecommendationSystem.transformer;

import com.weidonglang.NewBookRecommendationSystem.dto.AuthorDto;
import com.weidonglang.NewBookRecommendationSystem.entity.Author;
import com.weidonglang.NewBookRecommendationSystem.transformer.base.BaseTransformer;
import com.weidonglang.NewBookRecommendationSystem.transformer.mapper.AuthorMapper;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;
@Component
@AllArgsConstructor
public class AuthorTransformer implements BaseTransformer<Author, AuthorDto, AuthorMapper> {
    private final AuthorMapper authorMapper;

    @Override
    public AuthorMapper getMapper() {
        return authorMapper;
    }
}
