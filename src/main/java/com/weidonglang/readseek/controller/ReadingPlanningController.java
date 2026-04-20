package com.weidonglang.readseek.controller;

import com.weidonglang.readseek.dto.ReadingPathRequestDto;
import com.weidonglang.readseek.dto.ResourceComparisonRequestDto;
import com.weidonglang.readseek.dto.base.response.ApiResponse;
import com.weidonglang.readseek.service.ReadingPlanningService;
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
@RequestMapping("/api/reading-plans")
public class ReadingPlanningController {
    private final ReadingPlanningService readingPlanningService;

    @PostMapping("/compare")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse compareResources(@RequestBody ResourceComparisonRequestDto requestDto) {
        log.info("ReadingPlanningController: compareResources() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Reading resources compared successfully.",
                readingPlanningService.compareResources(requestDto));
    }

    @PostMapping("/path")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse suggestReadingPath(@RequestBody ReadingPathRequestDto requestDto) {
        log.info("ReadingPlanningController: suggestReadingPath() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Reading path generated successfully.",
                readingPlanningService.suggestReadingPath(requestDto));
    }
}
