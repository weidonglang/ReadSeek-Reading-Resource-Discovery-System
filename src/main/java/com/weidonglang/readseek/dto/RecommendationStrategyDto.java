package com.weidonglang.readseek.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RecommendationStrategyDto {
    private Integer recentDays;
    private Integer borrowWeight;
    private Integer detailClickWeight;
    private Integer ratingWeight;
    private String formula;
    private String fallbackRule;
}
