package com.henry.bookrecommendationsystem.repository;

import com.henry.bookrecommendationsystem.entity.BookLoan;
import com.henry.bookrecommendationsystem.enums.BookLoanStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
@Repository
public interface BookLoanRepository extends JpaRepository<BookLoan, Long> {
    Optional<BookLoan> findByIdAndUserIdAndMarkedAsDeletedFalse(Long id, Long userId);

    Optional<BookLoan> findByUserIdAndBookIdAndStatusAndMarkedAsDeletedFalse(Long userId, Long bookId, BookLoanStatus status);

    Long countByUserIdAndStatusAndMarkedAsDeletedFalse(Long userId, BookLoanStatus status);

    Long countByBookIdAndStatusAndMarkedAsDeletedFalse(Long bookId, BookLoanStatus status);

    @Query("SELECT bl FROM BookLoan bl WHERE bl.user.id = :userId AND bl.status = :status AND bl.markedAsDeleted = false ORDER BY bl.dueDate ASC, bl.borrowedAt DESC")
    List<BookLoan> findCurrentUserLoansByStatus(@Param("userId") Long userId, @Param("status") BookLoanStatus status);

    @Query("SELECT bl FROM BookLoan bl WHERE bl.user.id = :userId AND bl.status = :status AND bl.markedAsDeleted = false ORDER BY bl.returnedAt DESC, bl.borrowedAt DESC")
    List<BookLoan> findCurrentUserLoanHistory(@Param("userId") Long userId, @Param("status") BookLoanStatus status);

    @Query("SELECT bl FROM BookLoan bl WHERE bl.status = :status AND bl.markedAsDeleted = false ORDER BY bl.dueDate ASC, bl.borrowedAt DESC")
    List<BookLoan> findAllLoansByStatusOrderByDueDateAsc(@Param("status") BookLoanStatus status);

    @Query("SELECT bl FROM BookLoan bl WHERE bl.status = :status AND bl.markedAsDeleted = false ORDER BY bl.returnedAt DESC, bl.borrowedAt DESC")
    List<BookLoan> findAllLoanHistoryByStatusOrderByReturnedAtDesc(@Param("status") BookLoanStatus status);
}
