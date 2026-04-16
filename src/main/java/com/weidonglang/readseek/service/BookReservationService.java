package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dao.BookReservationDao;
import com.weidonglang.readseek.dto.BookReservationDto;
import com.weidonglang.readseek.dto.BookReservationSummaryDto;
import com.weidonglang.readseek.entity.BookReservation;
import com.weidonglang.readseek.service.base.BaseService;
import com.weidonglang.readseek.transformer.BookReservationTransformer;

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
