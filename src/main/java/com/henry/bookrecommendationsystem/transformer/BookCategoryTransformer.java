package com.henry.bookrecommendationsystem.transformer;

import com.henry.bookrecommendationsystem.dto.BookCategoryDto;
import com.henry.bookrecommendationsystem.entity.BookCategory;
import com.henry.bookrecommendationsystem.transformer.base.BaseTransformer;
import com.henry.bookrecommendationsystem.transformer.mapper.BookCategoryMapper;
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
