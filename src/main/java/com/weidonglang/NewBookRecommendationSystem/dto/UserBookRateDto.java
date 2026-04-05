package com.weidonglang.NewBookRecommendationSystem.dto;

import com.weidonglang.NewBookRecommendationSystem.dto.base.BaseDto;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserBookRateDto extends BaseDto {
    private Long id;
    private UserDto user;
    private BookDto book;
    private Integer rate;
    private String comment;
}
/*
weidonglang
2026.3-2027.9
*/
