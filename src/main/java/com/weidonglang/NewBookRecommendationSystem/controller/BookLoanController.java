package com.weidonglang.NewBookRecommendationSystem.controller;

import com.weidonglang.NewBookRecommendationSystem.dto.BorrowBookRequestDto;
import com.weidonglang.NewBookRecommendationSystem.dto.base.response.ApiResponse;
import com.weidonglang.NewBookRecommendationSystem.service.BookLoanService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
@Slf4j
@CrossOrigin
@RestController
@AllArgsConstructor
@RequestMapping("/api/loan")
public class BookLoanController {
    private final BookLoanService bookLoanService;

    @GetMapping("/my-active")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse findCurrentUserActiveLoans() {
        log.info("BookLoanController: findCurrentUserActiveLoans() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Current user active loans fetched successfully.", bookLoanService.findCurrentUserActiveLoans());
    }

    @GetMapping("/my-history")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse findCurrentUserLoanHistory() {
        log.info("BookLoanController: findCurrentUserLoanHistory() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Current user loan history fetched successfully.", bookLoanService.findCurrentUserLoanHistory());
    }

    @GetMapping("/admin/active")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse findAllActiveLoans() {
        log.info("BookLoanController: findAllActiveLoans() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "All active loans fetched successfully.", bookLoanService.findAllActiveLoans());
    }

    @GetMapping("/admin/history")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse findAllLoanHistory() {
        log.info("BookLoanController: findAllLoanHistory() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "All loan history fetched successfully.", bookLoanService.findAllLoanHistory());
    }

    @PostMapping("/borrow")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse borrowBook(@RequestBody BorrowBookRequestDto requestDto) {
        log.info("BookLoanController: borrowBook() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Book borrowed successfully.", bookLoanService.borrowBook(requestDto.getBookId()));
    }

    @PostMapping("/{loanId}/return")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse returnBook(@PathVariable Long loanId) {
        log.info("BookLoanController: returnBook() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Book returned successfully.", bookLoanService.returnBook(loanId));
    }

    @PostMapping("/{loanId}/renew")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse renewBook(@PathVariable Long loanId) {
        log.info("BookLoanController: renewBook() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Book renewed successfully.", bookLoanService.renewBook(loanId));
    }
}
/*
weidonglang
2026.3-2027.9
*/
