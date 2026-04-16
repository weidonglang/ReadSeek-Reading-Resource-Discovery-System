package com.weidonglang.readseek.controller;

import com.weidonglang.readseek.dto.UserBehaviorLogRequestDto;
import com.weidonglang.readseek.dto.base.response.ApiResponse;
import com.weidonglang.readseek.service.BehaviorAnalyticsService;
import com.weidonglang.readseek.service.UserBehaviorLogService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
    private final BehaviorAnalyticsService behaviorAnalyticsService;

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

    @GetMapping("/dashboard")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse getDashboard(@RequestParam(defaultValue = "10") Integer limit,
                                    @RequestParam(required = false) Integer recentDays) {
        log.info("UserBehaviorLogController: getDashboard() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Behavior dashboard fetched successfully.", behaviorAnalyticsService.buildDashboard(limit, recentDays));
    }

    @GetMapping("/recent")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse getRecentBehavior(@RequestParam(defaultValue = "10") Integer limit) {
        log.info("UserBehaviorLogController: getRecentBehavior() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Recent behavior logs fetched successfully.", behaviorAnalyticsService.findRecentBehaviorLogs(limit));
    }

    @GetMapping("/searches/recent")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse getRecentSearches(@RequestParam(defaultValue = "10") Integer limit) {
        log.info("UserBehaviorLogController: getRecentSearches() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Recent search logs fetched successfully.", behaviorAnalyticsService.findRecentSearchLogs(limit));
    }

    @GetMapping("/searches/top-keywords")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse getTopKeywords(@RequestParam(defaultValue = "10") Integer limit,
                                      @RequestParam(required = false) Integer recentDays) {
        log.info("UserBehaviorLogController: getTopKeywords() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Top search keywords fetched successfully.", behaviorAnalyticsService.findTopKeywords(limit, recentDays));
    }

    @GetMapping("/books/top-clicked")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse getTopClickedBooks(@RequestParam(defaultValue = "10") Integer limit,
                                          @RequestParam(required = false) Integer recentDays) {
        log.info("UserBehaviorLogController: getTopClickedBooks() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Top clicked books fetched successfully.", behaviorAnalyticsService.findTopClickedBooks(limit, recentDays));
    }

    @GetMapping("/books/top-borrowed")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse getTopBorrowedBooks(@RequestParam(defaultValue = "10") Integer limit,
                                           @RequestParam(required = false) Integer recentDays) {
        log.info("UserBehaviorLogController: getTopBorrowedBooks() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Top borrowed books fetched successfully.", behaviorAnalyticsService.findTopBorrowedBooks(limit, recentDays));
    }

    @GetMapping("/user/{userId}")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse getBehaviorByUser(@PathVariable Long userId,
                                         @RequestParam(defaultValue = "10") Integer limit) {
        log.info("UserBehaviorLogController: getBehaviorByUser() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "User behavior logs fetched successfully.", behaviorAnalyticsService.findRecentBehaviorByUser(userId, limit));
    }

    @GetMapping("/book/{bookId}")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse getBehaviorByBook(@PathVariable Long bookId,
                                         @RequestParam(defaultValue = "10") Integer limit) {
        log.info("UserBehaviorLogController: getBehaviorByBook() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Book behavior logs fetched successfully.", behaviorAnalyticsService.findRecentBehaviorByBook(bookId, limit));
    }
}
/*
weidonglang
2026.3-2027.9
*/
