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
public class QaAnalyticsDto {
    private Integer recentDaysApplied;
    private Long requestCount;
    private Long answerableCount;
    private Long refusalCount;
    private Long citationClickCount;
    private Double citationClickRate;
    private Double averageLatencyMs;
    private List<QaEventDto> recentEvents;
}
