package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.dao.BookLoanDao;
import com.weidonglang.NewBookRecommendationSystem.dto.BookLoanDto;
import com.weidonglang.NewBookRecommendationSystem.entity.BookLoan;
import com.weidonglang.NewBookRecommendationSystem.service.base.BaseService;
import com.weidonglang.NewBookRecommendationSystem.transformer.BookLoanTransformer;

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
