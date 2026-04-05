package com.weidonglang.NewBookRecommendationSystem.transformer;

import com.weidonglang.NewBookRecommendationSystem.dto.BookReservationDto;
import com.weidonglang.NewBookRecommendationSystem.entity.BookReservation;
import com.weidonglang.NewBookRecommendationSystem.transformer.base.BaseTransformer;
import com.weidonglang.NewBookRecommendationSystem.transformer.mapper.BookReservationMapper;
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
