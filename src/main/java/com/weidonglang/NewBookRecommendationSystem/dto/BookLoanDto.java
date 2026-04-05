package com.weidonglang.NewBookRecommendationSystem.dto;

import com.weidonglang.NewBookRecommendationSystem.dto.base.BaseDto;
import com.weidonglang.NewBookRecommendationSystem.enums.BookLoanStatus;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BookLoanDto extends BaseDto {
    private Long id;
    private UserDto user;
    private BookDto book;
    private LocalDateTime borrowedAt;
    private LocalDateTime dueDate;
    private LocalDateTime returnedAt;
    private Integer renewCount;
    private BookLoanStatus status;
}
/*
weidonglang
2026.3-2027.9
*/
