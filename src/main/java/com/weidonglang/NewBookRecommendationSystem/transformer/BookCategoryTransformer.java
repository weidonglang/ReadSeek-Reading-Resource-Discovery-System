package com.weidonglang.NewBookRecommendationSystem.transformer;

import com.weidonglang.NewBookRecommendationSystem.dto.BookCategoryDto;
import com.weidonglang.NewBookRecommendationSystem.entity.BookCategory;
import com.weidonglang.NewBookRecommendationSystem.transformer.base.BaseTransformer;
import com.weidonglang.NewBookRecommendationSystem.transformer.mapper.BookCategoryMapper;
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
