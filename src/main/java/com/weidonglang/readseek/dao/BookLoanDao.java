package com.weidonglang.readseek.dao;

import com.weidonglang.readseek.dao.base.BaseDao;
import com.weidonglang.readseek.entity.BookLoan;
import com.weidonglang.readseek.repository.BookLoanRepository;

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
