package com.weidonglang.NewBookRecommendationSystem.transformer.mapper;

import com.weidonglang.NewBookRecommendationSystem.dto.UserBookRateDto;
import com.weidonglang.NewBookRecommendationSystem.entity.UserBookRate;
import com.weidonglang.NewBookRecommendationSystem.transformer.mapper.base.BaseMapper;
import com.weidonglang.NewBookRecommendationSystem.transformer.mapper.base.GenericMapperConfiguration;
import org.mapstruct.InjectionStrategy;
import org.mapstruct.Mapper;
@Mapper(componentModel = "spring", injectionStrategy = InjectionStrategy.CONSTRUCTOR, config = GenericMapperConfiguration.class)
public interface UserBookRateMapper extends BaseMapper<UserBookRate, UserBookRateDto> {
}
