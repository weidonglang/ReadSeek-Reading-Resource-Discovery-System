package com.weidonglang.NewBookRecommendationSystem.transformer.mapper;

import com.weidonglang.NewBookRecommendationSystem.dto.UserReadingInfoDto;
import com.weidonglang.NewBookRecommendationSystem.entity.UserReadingInfo;
import com.weidonglang.NewBookRecommendationSystem.transformer.mapper.base.BaseMapper;
import com.weidonglang.NewBookRecommendationSystem.transformer.mapper.base.GenericMapperConfiguration;
import org.mapstruct.InjectionStrategy;
import org.mapstruct.Mapper;
@Mapper(componentModel = "spring", injectionStrategy = InjectionStrategy.CONSTRUCTOR, config = GenericMapperConfiguration.class)
public interface UserReadingInfoMapper extends BaseMapper<UserReadingInfo, UserReadingInfoDto> {
}
