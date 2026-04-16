package com.weidonglang.readseek.dao;

import com.weidonglang.readseek.dao.base.BaseDao;
import com.weidonglang.readseek.entity.BookReservation;
import com.weidonglang.readseek.repository.BookReservationRepository;

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
/*
weidonglang
2026.3-2027.9
*/
