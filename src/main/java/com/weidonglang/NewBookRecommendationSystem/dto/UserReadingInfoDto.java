package com.weidonglang.NewBookRecommendationSystem.dto;

import com.weidonglang.NewBookRecommendationSystem.dto.base.BaseDto;
import com.weidonglang.NewBookRecommendationSystem.enums.UserReadingLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserReadingInfoDto extends BaseDto {
    private Long id;
    private UserDto user;
    private UserReadingLevel readingLevel;
    private List<UserBookCategoryDto> userBookCategories;
}
/*
weidonglang
2026.3-2027.9
*/
