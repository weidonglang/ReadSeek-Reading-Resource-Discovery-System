package com.weidonglang.readseek.repository;

import com.weidonglang.readseek.entity.BookReservation;
import com.weidonglang.readseek.enums.BookReservationStatus;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
@Repository
public interface BookReservationRepository extends JpaRepository<BookReservation, Long> {
    Optional<BookReservation> findByIdAndUserIdAndMarkedAsDeletedFalse(Long id, Long userId);

    Optional<BookReservation> findByUserIdAndBookIdAndStatusAndMarkedAsDeletedFalse(Long userId, Long bookId, BookReservationStatus status);

    Optional<BookReservation> findFirstByBookIdAndStatusAndMarkedAsDeletedFalseOrderByRequestedAtAsc(Long bookId, BookReservationStatus status);

    @EntityGraph(attributePaths = {"user", "book", "book.author", "book.category", "book.publisher", "book.tags"})
    List<BookReservation> findAllByBookIdAndStatusAndMarkedAsDeletedFalseOrderByRequestedAtAsc(Long bookId, BookReservationStatus status);

    @EntityGraph(attributePaths = {"user", "book", "book.author", "book.category", "book.publisher", "book.tags"})
    List<BookReservation> findAllByUserIdAndStatusAndMarkedAsDeletedFalseOrderByRequestedAtAsc(Long userId, BookReservationStatus status);

    @EntityGraph(attributePaths = {"user", "book", "book.author", "book.category", "book.publisher", "book.tags"})
    List<BookReservation> findAllByUserIdAndStatusInAndMarkedAsDeletedFalseOrderByRequestedAtDesc(Long userId, List<BookReservationStatus> statuses);

    @EntityGraph(attributePaths = {"user", "book", "book.author", "book.category", "book.publisher", "book.tags"})
    List<BookReservation> findAllByStatusAndMarkedAsDeletedFalseOrderByRequestedAtAsc(BookReservationStatus status);

    @EntityGraph(attributePaths = {"user", "book", "book.author", "book.category", "book.publisher", "book.tags"})
    List<BookReservation> findAllByStatusInAndMarkedAsDeletedFalseOrderByRequestedAtDesc(List<BookReservationStatus> statuses);

    Long countByBookIdAndStatusAndMarkedAsDeletedFalse(Long bookId, BookReservationStatus status);
}
/*
weidonglang
2026.3-2027.9
*/
