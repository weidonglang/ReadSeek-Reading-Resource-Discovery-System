package com.henry.bookrecommendationsystem.dto;

import com.henry.bookrecommendationsystem.dto.base.BaseDto;
import com.henry.bookrecommendationsystem.enums.BookReservationStatus;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BookReservationDto extends BaseDto {
    private Long id;
    private UserDto user;
    private BookDto book;
    private LocalDateTime requestedAt;
    private LocalDateTime fulfilledAt;
    private LocalDateTime cancelledAt;
    private BookReservationStatus status;
}
