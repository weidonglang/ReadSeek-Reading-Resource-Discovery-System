package com.weidonglang.NewBookRecommendationSystem.transformer;

import com.weidonglang.NewBookRecommendationSystem.dto.BookDto;
import com.weidonglang.NewBookRecommendationSystem.entity.Book;
import com.weidonglang.NewBookRecommendationSystem.transformer.base.BaseTransformer;
import com.weidonglang.NewBookRecommendationSystem.transformer.mapper.BookMapper;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;
@Component
@AllArgsConstructor
public class BookTransformer implements BaseTransformer<Book, BookDto, BookMapper> {
    private final BookMapper bookMapper;

    @Override
    public BookMapper getMapper() {
        return bookMapper;
    }
}
