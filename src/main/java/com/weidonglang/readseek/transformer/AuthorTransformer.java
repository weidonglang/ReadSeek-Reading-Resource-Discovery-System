package com.weidonglang.readseek.transformer;

import com.weidonglang.readseek.dto.AuthorDto;
import com.weidonglang.readseek.entity.Author;
import com.weidonglang.readseek.transformer.base.BaseTransformer;
import com.weidonglang.readseek.transformer.mapper.AuthorMapper;
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
