package com.henry.bookrecommendationsystem.service;

import com.henry.bookrecommendationsystem.dao.BookReservationDao;
import com.henry.bookrecommendationsystem.dto.BookReservationDto;
import com.henry.bookrecommendationsystem.dto.BookReservationSummaryDto;
import com.henry.bookrecommendationsystem.entity.BookReservation;
import com.henry.bookrecommendationsystem.service.base.BaseService;
import com.henry.bookrecommendationsystem.transformer.BookReservationTransformer;

import java.util.List;

/**
 * @author Codex
 * @since 02/04/2026
 */
public interface BookReservationService extends BaseService<BookReservation, BookReservationDto, BookReservationDao, BookReservationTransformer> {
    BookReservationDto reserveBook(Long bookId);

    BookReservationDto cancelReservation(Long reservationId);

    List<BookReservationDto> findCurrentUserActiveReservations();

    List<BookReservationDto> findCurrentUserReservationHistory();

    BookReservationSummaryDto findBookReservationSummary(Long bookId);

    List<BookReservationDto> findAllActiveReservations();

    List<BookReservationDto> findAllReservationHistory();
}
