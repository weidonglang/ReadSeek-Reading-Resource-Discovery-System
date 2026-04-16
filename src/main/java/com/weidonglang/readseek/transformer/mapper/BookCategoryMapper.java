package com.weidonglang.readseek.transformer.mapper;

import com.weidonglang.readseek.dto.BookCategoryDto;
import com.weidonglang.readseek.entity.BookCategory;
import com.weidonglang.readseek.transformer.mapper.base.BaseMapper;
import com.weidonglang.readseek.transformer.mapper.base.GenericMapperConfiguration;
import org.mapstruct.InjectionStrategy;
import org.mapstruct.Mapper;
@Mapper(componentModel = "spring", injectionStrategy = InjectionStrategy.CONSTRUCTOR, config = GenericMapperConfiguration.class)
public interface BookCategoryMapper extends BaseMapper<BookCategory, BookCategoryDto> {
}
