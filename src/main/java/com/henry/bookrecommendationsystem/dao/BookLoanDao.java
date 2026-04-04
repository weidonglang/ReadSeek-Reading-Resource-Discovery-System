package com.henry.bookrecommendationsystem.dao;

import com.henry.bookrecommendationsystem.dao.base.BaseDao;
import com.henry.bookrecommendationsystem.entity.BookLoan;
import com.henry.bookrecommendationsystem.repository.BookLoanRepository;

import java.util.List;
import java.util.Optional;
public interface BookLoanDao extends BaseDao<BookLoan, BookLoanRepository> {
    Optional<BookLoan> findByIdAndUserId(Long id, Long userId);

    Optional<BookLoan> findActiveLoanByUserIdAndBookId(Long userId, Long bookId);

    Long countActiveLoansByUserId(Long userId);

    Long countActiveLoansByBookId(Long bookId);

    List<BookLoan> findCurrentUserActiveLoans(Long userId);

    List<BookLoan> findCurrentUserLoanHistory(Long userId);

    List<BookLoan> findAllActiveLoans();

    List<BookLoan> findAllLoanHistory();
}
