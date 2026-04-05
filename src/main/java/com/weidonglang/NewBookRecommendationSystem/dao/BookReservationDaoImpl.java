package com.weidonglang.NewBookRecommendationSystem.dao;

import com.weidonglang.NewBookRecommendationSystem.entity.BookReservation;
import com.weidonglang.NewBookRecommendationSystem.enums.BookReservationStatus;
import com.weidonglang.NewBookRecommendationSystem.repository.BookReservationRepository;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;
@Component
public class BookReservationDaoImpl implements BookReservationDao {
    private final BookReservationRepository bookReservationRepository;

    public BookReservationDaoImpl(BookReservationRepository bookReservationRepository) {
        this.bookReservationRepository = bookReservationRepository;
    }

    @Override
    public BookReservationRepository getRepository() {
        return bookReservationRepository;
    }

    @Override
    public Optional<BookReservation> findByIdAndUserId(Long id, Long userId) {
        return getRepository().findByIdAndUserIdAndMarkedAsDeletedFalse(id, userId);
    }

    @Override
    public Optional<BookReservation> findActiveReservationByUserIdAndBookId(Long userId, Long bookId) {
        return getRepository().findByUserIdAndBookIdAndStatusAndMarkedAsDeletedFalse(userId, bookId, BookReservationStatus.ACTIVE);
    }

    @Override
    public Optional<BookReservation> findFirstActiveReservationByBookId(Long bookId) {
        return getRepository().findFirstByBookIdAndStatusAndMarkedAsDeletedFalseOrderByRequestedAtAsc(bookId, BookReservationStatus.ACTIVE);
    }

    @Override
    public List<BookReservation> findActiveReservationsByBookId(Long bookId) {
        return getRepository().findAllByBookIdAndStatusAndMarkedAsDeletedFalseOrderByRequestedAtAsc(bookId, BookReservationStatus.ACTIVE);
    }

    @Override
    public List<BookReservation> findCurrentUserActiveReservations(Long userId) {
        return getRepository().findAllByUserIdAndStatusAndMarkedAsDeletedFalseOrderByRequestedAtAsc(userId, BookReservationStatus.ACTIVE);
    }

    @Override
    public List<BookReservation> findCurrentUserReservationHistory(Long userId) {
        return getRepository().findAllByUserIdAndStatusInAndMarkedAsDeletedFalseOrderByRequestedAtDesc(
                userId, Arrays.asList(BookReservationStatus.FULFILLED, BookReservationStatus.CANCELLED));
    }

    @Override
    public Long countActiveReservationsByBookId(Long bookId) {
        return getRepository().countByBookIdAndStatusAndMarkedAsDeletedFalse(bookId, BookReservationStatus.ACTIVE);
    }

    @Override
    public List<BookReservation> findAllActiveReservations() {
        return getRepository().findAllByStatusAndMarkedAsDeletedFalseOrderByRequestedAtAsc(BookReservationStatus.ACTIVE);
    }

    @Override
    public List<BookReservation> findAllReservationHistory() {
        return getRepository().findAllByStatusInAndMarkedAsDeletedFalseOrderByRequestedAtDesc(
                Arrays.asList(BookReservationStatus.FULFILLED, BookReservationStatus.CANCELLED));
    }
}
/*
weidonglang
2026.3-2027.9
*/
