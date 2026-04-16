package com.weidonglang.readseek.transformer;

import com.weidonglang.readseek.dto.BookCategoryDto;
import com.weidonglang.readseek.entity.BookCategory;
import com.weidonglang.readseek.transformer.base.BaseTransformer;
import com.weidonglang.readseek.transformer.mapper.BookCategoryMapper;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;
@Component
@AllArgsConstructor
public class BookCategoryTransformer implements BaseTransformer<BookCategory, BookCategoryDto, BookCategoryMapper> {
    private final BookCategoryMapper bookCategoryMapper;

    @Override
    public BookCategoryMapper getMapper() {
        return bookCategoryMapper;
    }
}
