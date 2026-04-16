package com.weidonglang.readseek.transformer;

import com.weidonglang.readseek.dto.BookLoanDto;
import com.weidonglang.readseek.entity.BookLoan;
import com.weidonglang.readseek.transformer.base.BaseTransformer;
import com.weidonglang.readseek.transformer.mapper.BookLoanMapper;
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
