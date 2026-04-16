package com.weidonglang.readseek.transformer;

import com.weidonglang.readseek.dto.UserBookCategoryDto;
import com.weidonglang.readseek.entity.UserBookCategory;
import com.weidonglang.readseek.transformer.base.BaseTransformer;
import com.weidonglang.readseek.transformer.mapper.UserBookCategoryMapper;
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
