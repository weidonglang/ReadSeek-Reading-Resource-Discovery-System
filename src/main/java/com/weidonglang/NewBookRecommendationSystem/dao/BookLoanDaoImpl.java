package com.weidonglang.NewBookRecommendationSystem.dao;

import com.weidonglang.NewBookRecommendationSystem.entity.BookLoan;
import com.weidonglang.NewBookRecommendationSystem.enums.BookLoanStatus;
import com.weidonglang.NewBookRecommendationSystem.repository.BookLoanRepository;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
@Component
public class BookLoanDaoImpl implements BookLoanDao {
    private final BookLoanRepository bookLoanRepository;

    public BookLoanDaoImpl(BookLoanRepository bookLoanRepository) {
        this.bookLoanRepository = bookLoanRepository;
    }

    @Override
    public BookLoanRepository getRepository() {
        return bookLoanRepository;
    }

    @Override
    public Optional<BookLoan> findByIdAndUserId(Long id, Long userId) {
        return getRepository().findByIdAndUserIdAndMarkedAsDeletedFalse(id, userId);
    }

    @Override
    public Optional<BookLoan> findActiveLoanByUserIdAndBookId(Long userId, Long bookId) {
        return getRepository().findByUserIdAndBookIdAndStatusAndMarkedAsDeletedFalse(userId, bookId, BookLoanStatus.BORROWED);
    }

    @Override
    public Long countActiveLoansByUserId(Long userId) {
        return getRepository().countByUserIdAndStatusAndMarkedAsDeletedFalse(userId, BookLoanStatus.BORROWED);
    }

    @Override
    public Long countActiveLoansByBookId(Long bookId) {
        return getRepository().countByBookIdAndStatusAndMarkedAsDeletedFalse(bookId, BookLoanStatus.BORROWED);
    }

    @Override
    public List<BookLoan> findCurrentUserActiveLoans(Long userId) {
        return getRepository().findCurrentUserLoansByStatus(userId, BookLoanStatus.BORROWED);
    }

    @Override
    public List<BookLoan> findCurrentUserLoanHistory(Long userId) {
        return getRepository().findCurrentUserLoanHistory(userId, BookLoanStatus.RETURNED);
    }

    @Override
    public List<BookLoan> findAllActiveLoans() {
        return getRepository().findAllLoansByStatusOrderByDueDateAsc(BookLoanStatus.BORROWED);
    }

    @Override
    public List<BookLoan> findAllLoanHistory() {
        return getRepository().findAllLoanHistoryByStatusOrderByReturnedAtDesc(BookLoanStatus.RETURNED);
    }
}
/*
weidonglang
2026.3-2027.9
*/
