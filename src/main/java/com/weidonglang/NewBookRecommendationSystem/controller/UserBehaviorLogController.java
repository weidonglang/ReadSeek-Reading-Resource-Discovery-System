package com.weidonglang.NewBookRecommendationSystem.controller;

import com.weidonglang.NewBookRecommendationSystem.dto.UserBehaviorLogRequestDto;
import com.weidonglang.NewBookRecommendationSystem.dto.base.response.ApiResponse;
import com.weidonglang.NewBookRecommendationSystem.service.UserBehaviorLogService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
@Slf4j
@CrossOrigin
@RestController
@AllArgsConstructor
@RequestMapping("/api/behavior-log")
public class UserBehaviorLogController {
    private final UserBehaviorLogService userBehaviorLogService;

    @PostMapping
    @PreAuthorize("isAuthenticated()")
    public ApiResponse recordBehavior(@RequestBody UserBehaviorLogRequestDto requestDto) {
        log.info("UserBehaviorLogController: recordBehavior() called");
        userBehaviorLogService.record(
                requestDto.getActionType(),
                requestDto.getBookId(),
                requestDto.getKeyword(),
                requestDto.getSource(),
                requestDto.getReason()
        );
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Behavior log recorded successfully.", true);
    }
}
/*
weidonglang
2026.3-2027.9
*/
