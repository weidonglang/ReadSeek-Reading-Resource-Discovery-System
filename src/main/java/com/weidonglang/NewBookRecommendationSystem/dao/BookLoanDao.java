package com.weidonglang.NewBookRecommendationSystem.dao;

import com.weidonglang.NewBookRecommendationSystem.dao.base.BaseDao;
import com.weidonglang.NewBookRecommendationSystem.entity.BookLoan;
import com.weidonglang.NewBookRecommendationSystem.repository.BookLoanRepository;

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
/*
weidonglang
2026.3-2027.9
*/
