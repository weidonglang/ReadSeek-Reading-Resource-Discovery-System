package com.weidonglang.NewBookRecommendationSystem.repository;

import com.weidonglang.NewBookRecommendationSystem.entity.BookReservation;
import com.weidonglang.NewBookRecommendationSystem.enums.BookReservationStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
@Repository
public interface BookReservationRepository extends JpaRepository<BookReservation, Long> {
    Optional<BookReservation> findByIdAndUserIdAndMarkedAsDeletedFalse(Long id, Long userId);

    Optional<BookReservation> findByUserIdAndBookIdAndStatusAndMarkedAsDeletedFalse(Long userId, Long bookId, BookReservationStatus status);

    Optional<BookReservation> findFirstByBookIdAndStatusAndMarkedAsDeletedFalseOrderByRequestedAtAsc(Long bookId, BookReservationStatus status);

    List<BookReservation> findAllByBookIdAndStatusAndMarkedAsDeletedFalseOrderByRequestedAtAsc(Long bookId, BookReservationStatus status);

    List<BookReservation> findAllByUserIdAndStatusAndMarkedAsDeletedFalseOrderByRequestedAtAsc(Long userId, BookReservationStatus status);

    List<BookReservation> findAllByUserIdAndStatusInAndMarkedAsDeletedFalseOrderByRequestedAtDesc(Long userId, List<BookReservationStatus> statuses);

    List<BookReservation> findAllByStatusAndMarkedAsDeletedFalseOrderByRequestedAtAsc(BookReservationStatus status);

    List<BookReservation> findAllByStatusInAndMarkedAsDeletedFalseOrderByRequestedAtDesc(List<BookReservationStatus> statuses);

    Long countByBookIdAndStatusAndMarkedAsDeletedFalse(Long bookId, BookReservationStatus status);
}
/*
weidonglang
2026.3-2027.9
*/
