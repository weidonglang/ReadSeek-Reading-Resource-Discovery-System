package com.henry.bookrecommendationsystem.transformer;

import com.henry.bookrecommendationsystem.dto.BookReservationDto;
import com.henry.bookrecommendationsystem.entity.BookReservation;
import com.henry.bookrecommendationsystem.transformer.base.BaseTransformer;
import com.henry.bookrecommendationsystem.transformer.mapper.BookReservationMapper;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;
@Component
@AllArgsConstructor
public class BookReservationTransformer implements BaseTransformer<BookReservation, BookReservationDto, BookReservationMapper> {
    private final BookReservationMapper bookReservationMapper;

    @Override
    public BookReservationMapper getMapper() {
        return bookReservationMapper;
    }
}
