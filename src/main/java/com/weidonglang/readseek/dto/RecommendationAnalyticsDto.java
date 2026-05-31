package com.weidonglang.readseek.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RecommendationAnalyticsDto {
    private Integer recentDaysApplied;
    private Long exposureCount;
    private Long clickCount;
    private Long feedbackCount;
    private Double ctr;
    private Double feedbackRate;
    private List<RecommendationEventDto> recentEvents;
}
