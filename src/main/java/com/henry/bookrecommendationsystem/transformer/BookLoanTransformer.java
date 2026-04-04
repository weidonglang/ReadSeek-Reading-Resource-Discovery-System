package com.henry.bookrecommendationsystem.transformer;

import com.henry.bookrecommendationsystem.dto.BookLoanDto;
import com.henry.bookrecommendationsystem.entity.BookLoan;
import com.henry.bookrecommendationsystem.transformer.base.BaseTransformer;
import com.henry.bookrecommendationsystem.transformer.mapper.BookLoanMapper;
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
