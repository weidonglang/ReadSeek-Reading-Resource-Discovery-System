package com.weidonglang.readseek.repository;

import com.weidonglang.readseek.entity.BookLoan;
import com.weidonglang.readseek.enums.BookLoanStatus;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
@Repository
public interface BookLoanRepository extends JpaRepository<BookLoan, Long> {
    Optional<BookLoan> findByIdAndUserIdAndMarkedAsDeletedFalse(Long id, Long userId);

    Optional<BookLoan> findByUserIdAndBookIdAndStatusAndMarkedAsDeletedFalse(Long userId, Long bookId, BookLoanStatus status);

    Long countByUserIdAndStatusAndMarkedAsDeletedFalse(Long userId, BookLoanStatus status);

    Long countByBookIdAndStatusAndMarkedAsDeletedFalse(Long bookId, BookLoanStatus status);

    Long countByMarkedAsDeletedFalse();

    @Query("SELECT bl FROM BookLoan bl WHERE bl.user.id = :userId AND bl.status = :status AND bl.markedAsDeleted = false ORDER BY bl.dueDate ASC, bl.borrowedAt DESC")
    @EntityGraph(attributePaths = {"user", "book", "book.author", "book.category", "book.publisher", "book.tags"})
    List<BookLoan> findCurrentUserLoansByStatus(@Param("userId") Long userId, @Param("status") BookLoanStatus status);

    @Query("SELECT bl FROM BookLoan bl WHERE bl.user.id = :userId AND bl.status = :status AND bl.markedAsDeleted = false ORDER BY bl.returnedAt DESC, bl.borrowedAt DESC")
    @EntityGraph(attributePaths = {"user", "book", "book.author", "book.category", "book.publisher", "book.tags"})
    List<BookLoan> findCurrentUserLoanHistory(@Param("userId") Long userId, @Param("status") BookLoanStatus status);

    @Query("SELECT bl FROM BookLoan bl WHERE bl.status = :status AND bl.markedAsDeleted = false ORDER BY bl.dueDate ASC, bl.borrowedAt DESC")
    @EntityGraph(attributePaths = {"user", "book", "book.author", "book.category", "book.publisher", "book.tags"})
    List<BookLoan> findAllLoansByStatusOrderByDueDateAsc(@Param("status") BookLoanStatus status);

    @Query("SELECT bl FROM BookLoan bl WHERE bl.status = :status AND bl.markedAsDeleted = false ORDER BY bl.returnedAt DESC, bl.borrowedAt DESC")
    @EntityGraph(attributePaths = {"user", "book", "book.author", "book.category", "book.publisher", "book.tags"})
    List<BookLoan> findAllLoanHistoryByStatusOrderByReturnedAtDesc(@Param("status") BookLoanStatus status);

    @Query("SELECT bl.book.id, COUNT(bl.id) FROM BookLoan bl " +
            "WHERE bl.markedAsDeleted = false " +
            "GROUP BY bl.book.id ORDER BY COUNT(bl.id) DESC")
    List<Object[]> aggregateBorrowedBooks(org.springframework.data.domain.Pageable pageable);

    @Query("SELECT COUNT(bl.id) FROM BookLoan bl WHERE bl.markedAsDeleted = false AND bl.borrowedAt >= :fromDate")
    Long countBorrowedBooksSince(@Param("fromDate") java.time.LocalDateTime fromDate);

    @Query("SELECT COUNT(bl.id) FROM BookLoan bl " +
            "WHERE bl.markedAsDeleted = false " +
            "AND bl.user.id = :userId " +
            "AND bl.borrowedAt >= :fromDate")
    Long countBorrowedBooksByUserSince(@Param("userId") Long userId,
                                       @Param("fromDate") LocalDateTime fromDate);

    @Query("SELECT bl.book.id, COUNT(bl.id) FROM BookLoan bl " +
            "WHERE bl.markedAsDeleted = false " +
            "AND bl.borrowedAt >= :fromDate " +
            "GROUP BY bl.book.id ORDER BY COUNT(bl.id) DESC")
    List<Object[]> aggregateBorrowedBooksSince(@Param("fromDate") java.time.LocalDateTime fromDate,
                                               org.springframework.data.domain.Pageable pageable);
}
/*
weidonglang
2026.3-2027.9
*/
