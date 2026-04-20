package com.weidonglang.readseek.controller;

import com.weidonglang.readseek.dto.RecommendationFeedbackRequestDto;
import com.weidonglang.readseek.dto.base.response.ApiResponse;
import com.weidonglang.readseek.service.RecommendationEventService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;

@Slf4j
@CrossOrigin
@RestController
@AllArgsConstructor
@RequestMapping("/api/recommendation-events")
public class RecommendationEventController {
    private final RecommendationEventService recommendationEventService;

    @PostMapping("/feedback")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse recordFeedback(@RequestBody RecommendationFeedbackRequestDto requestDto) {
        log.info("RecommendationEventController: recordFeedback() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Recommendation feedback recorded successfully.",
                recommendationEventService.recordFeedback(requestDto));
    }

    @GetMapping("/recent")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse findRecentEvents(@RequestParam(defaultValue = "20") Integer limit) {
        log.info("RecommendationEventController: findRecentEvents() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Recent recommendation events fetched successfully.",
                recommendationEventService.findRecentEvents(limit));
    }

    @GetMapping("/feedback/recent")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse findRecentFeedback(@RequestParam(defaultValue = "20") Integer limit) {
        log.info("RecommendationEventController: findRecentFeedback() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Recent recommendation feedback fetched successfully.",
                recommendationEventService.findRecentFeedback(limit));
    }
}
