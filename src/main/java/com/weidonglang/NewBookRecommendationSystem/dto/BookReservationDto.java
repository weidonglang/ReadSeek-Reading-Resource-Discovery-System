package com.weidonglang.NewBookRecommendationSystem.dto;

import com.weidonglang.NewBookRecommendationSystem.dto.base.BaseDto;
import com.weidonglang.NewBookRecommendationSystem.enums.BookReservationStatus;
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
/*
weidonglang
2026.3-2027.9
*/
