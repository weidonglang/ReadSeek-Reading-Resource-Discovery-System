package com.weidonglang.NewBookRecommendationSystem.transformer;

import com.weidonglang.NewBookRecommendationSystem.dto.BookLoanDto;
import com.weidonglang.NewBookRecommendationSystem.entity.BookLoan;
import com.weidonglang.NewBookRecommendationSystem.transformer.base.BaseTransformer;
import com.weidonglang.NewBookRecommendationSystem.transformer.mapper.BookLoanMapper;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;
@Component
@AllArgsConstructor
public class BookLoanTransformer implements BaseTransformer<BookLoan, BookLoanDto, BookLoanMapper> {
    private final BookLoanMapper bookLoanMapper;

    @Override
    public BookLoanMapper getMapper() {
        return bookLoanMapper;
    }
}
