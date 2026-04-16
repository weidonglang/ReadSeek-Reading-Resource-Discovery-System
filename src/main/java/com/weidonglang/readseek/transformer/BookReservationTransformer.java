package com.weidonglang.readseek.transformer;

import com.weidonglang.readseek.dto.BookReservationDto;
import com.weidonglang.readseek.entity.BookReservation;
import com.weidonglang.readseek.transformer.base.BaseTransformer;
import com.weidonglang.readseek.transformer.mapper.BookReservationMapper;
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
