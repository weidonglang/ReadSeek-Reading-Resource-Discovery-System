package com.henry.bookrecommendationsystem.service;

import com.henry.bookrecommendationsystem.dao.BookLoanDao;
import com.henry.bookrecommendationsystem.dto.BookLoanDto;
import com.henry.bookrecommendationsystem.entity.BookLoan;
import com.henry.bookrecommendationsystem.service.base.BaseService;
import com.henry.bookrecommendationsystem.transformer.BookLoanTransformer;

import java.util.List;

/**
 * @author Codex
 * @since 02/04/2026
 */
public interface BookLoanService extends BaseService<BookLoan, BookLoanDto, BookLoanDao, BookLoanTransformer> {
    BookLoanDto borrowBook(Long bookId);

    BookLoanDto returnBook(Long loanId);

    BookLoanDto renewBook(Long loanId);

    List<BookLoanDto> findCurrentUserActiveLoans();

    List<BookLoanDto> findCurrentUserLoanHistory();

    List<BookLoanDto> findAllActiveLoans();

    List<BookLoanDto> findAllLoanHistory();
}
