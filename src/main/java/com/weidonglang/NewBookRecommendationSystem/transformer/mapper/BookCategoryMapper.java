package com.weidonglang.NewBookRecommendationSystem.transformer.mapper;

import com.weidonglang.NewBookRecommendationSystem.dto.BookCategoryDto;
import com.weidonglang.NewBookRecommendationSystem.entity.BookCategory;
import com.weidonglang.NewBookRecommendationSystem.transformer.mapper.base.BaseMapper;
import com.weidonglang.NewBookRecommendationSystem.transformer.mapper.base.GenericMapperConfiguration;
import org.mapstruct.InjectionStrategy;
import org.mapstruct.Mapper;
@Mapper(componentModel = "spring", injectionStrategy = InjectionStrategy.CONSTRUCTOR, config = GenericMapperConfiguration.class)
public interface BookCategoryMapper extends BaseMapper<BookCategory, BookCategoryDto> {
}
