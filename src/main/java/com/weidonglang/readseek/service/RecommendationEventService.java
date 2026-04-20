package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dto.BookRecommendationOverviewDto;
import com.weidonglang.readseek.dto.RecommendationEventDto;
import com.weidonglang.readseek.dto.RecommendationFeedbackRequestDto;

import java.util.List;

public interface RecommendationEventService {
    void recordOverviewExposure(BookRecommendationOverviewDto overview, String requestContext);

    RecommendationEventDto recordFeedback(RecommendationFeedbackRequestDto requestDto);

    List<RecommendationEventDto> findRecentEvents(Integer limit);

    List<RecommendationEventDto> findRecentFeedback(Integer limit);
}
