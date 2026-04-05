package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.dao.BookReservationDao;
import com.weidonglang.NewBookRecommendationSystem.dto.BookReservationDto;
import com.weidonglang.NewBookRecommendationSystem.dto.BookReservationSummaryDto;
import com.weidonglang.NewBookRecommendationSystem.entity.BookReservation;
import com.weidonglang.NewBookRecommendationSystem.service.base.BaseService;
import com.weidonglang.NewBookRecommendationSystem.transformer.BookReservationTransformer;

import java.util.List;
public interface BookReservationService extends BaseService<BookReservation, BookReservationDto, BookReservationDao, BookReservationTransformer> {
    BookReservationDto reserveBook(Long bookId);

    BookReservationDto cancelReservation(Long reservationId);

    List<BookReservationDto> findCurrentUserActiveReservations();

    List<BookReservationDto> findCurrentUserReservationHistory();

    BookReservationSummaryDto findBookReservationSummary(Long bookId);

    List<BookReservationDto> findAllActiveReservations();

    List<BookReservationDto> findAllReservationHistory();
}
/*
weidonglang
2026.3-2027.9
*/
