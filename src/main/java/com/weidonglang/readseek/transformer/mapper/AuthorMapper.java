package com.weidonglang.readseek.transformer.mapper;

import com.weidonglang.readseek.dto.AuthorDto;
import com.weidonglang.readseek.entity.Author;
import com.weidonglang.readseek.transformer.mapper.base.BaseMapper;
import com.weidonglang.readseek.transformer.mapper.base.GenericMapperConfiguration;
import org.mapstruct.InjectionStrategy;
import org.mapstruct.Mapper;
@Mapper(componentModel = "spring", injectionStrategy = InjectionStrategy.CONSTRUCTOR, config = GenericMapperConfiguration.class)
public interface AuthorMapper extends BaseMapper<Author, AuthorDto> {
}
