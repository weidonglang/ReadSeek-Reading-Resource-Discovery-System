package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dao.BookLoanDao;
import com.weidonglang.readseek.dto.BookLoanDto;
import com.weidonglang.readseek.entity.BookLoan;
import com.weidonglang.readseek.service.base.BaseService;
import com.weidonglang.readseek.transformer.BookLoanTransformer;

import java.util.List;
public interface BookLoanService extends BaseService<BookLoan, BookLoanDto, BookLoanDao, BookLoanTransformer> {
    BookLoanDto borrowBook(Long bookId);

    BookLoanDto returnBook(Long loanId);

    BookLoanDto renewBook(Long loanId);

    List<BookLoanDto> findCurrentUserActiveLoans();

    List<BookLoanDto> findCurrentUserLoanHistory();

    List<BookLoanDto> findAllActiveLoans();

    List<BookLoanDto> findAllLoanHistory();
}
/*
weidonglang
2026.3-2027.9
*/
