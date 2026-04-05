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
public class UserBookCategoryDto extends BaseDto {
    private Long id;
    private UserDto user;
    private BookCategoryDto category;
}
/*
weidonglang
2026.3-2027.9
*/
