package com.henry.bookrecommendationsystem.dao;

import com.henry.bookrecommendationsystem.dao.base.BaseDao;
import com.henry.bookrecommendationsystem.entity.BookReservation;
import com.henry.bookrecommendationsystem.repository.BookReservationRepository;

import java.util.List;
import java.util.Optional;
public interface BookReservationDao extends BaseDao<BookReservation, BookReservationRepository> {
    Optional<BookReservation> findByIdAndUserId(Long id, Long userId);

    Optional<BookReservation> findActiveReservationByUserIdAndBookId(Long userId, Long bookId);

    Optional<BookReservation> findFirstActiveReservationByBookId(Long bookId);

    List<BookReservation> findActiveReservationsByBookId(Long bookId);

    List<BookReservation> findCurrentUserActiveReservations(Long userId);

    List<BookReservation> findCurrentUserReservationHistory(Long userId);

    Long countActiveReservationsByBookId(Long bookId);

    List<BookReservation> findAllActiveReservations();

    List<BookReservation> findAllReservationHistory();
}
