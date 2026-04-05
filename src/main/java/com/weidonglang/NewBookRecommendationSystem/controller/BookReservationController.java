package com.weidonglang.NewBookRecommendationSystem.controller;

import com.weidonglang.NewBookRecommendationSystem.dto.ReserveBookRequestDto;
import com.weidonglang.NewBookRecommendationSystem.dto.base.response.ApiResponse;
import com.weidonglang.NewBookRecommendationSystem.service.BookReservationService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
@Slf4j
@CrossOrigin
@RestController
@AllArgsConstructor
@RequestMapping("/api/reservation")
public class BookReservationController {
    private final BookReservationService bookReservationService;

    @GetMapping("/my-active")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse findCurrentUserActiveReservations() {
        log.info("BookReservationController: findCurrentUserActiveReservations() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Current user active reservations fetched successfully.", bookReservationService.findCurrentUserActiveReservations());
    }

    @GetMapping("/my-history")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse findCurrentUserReservationHistory() {
        log.info("BookReservationController: findCurrentUserReservationHistory() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Current user reservation history fetched successfully.", bookReservationService.findCurrentUserReservationHistory());
    }

    @GetMapping("/admin/active")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse findAllActiveReservations() {
        log.info("BookReservationController: findAllActiveReservations() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "All active reservations fetched successfully.", bookReservationService.findAllActiveReservations());
    }

    @GetMapping("/admin/history")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse findAllReservationHistory() {
        log.info("BookReservationController: findAllReservationHistory() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "All reservation history fetched successfully.", bookReservationService.findAllReservationHistory());
    }

    @GetMapping("/book/{bookId}/summary")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse findBookReservationSummary(@PathVariable Long bookId) {
        log.info("BookReservationController: findBookReservationSummary() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Book reservation summary fetched successfully.", bookReservationService.findBookReservationSummary(bookId));
    }

    @PostMapping("/reserve")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse reserveBook(@RequestBody ReserveBookRequestDto requestDto) {
        log.info("BookReservationController: reserveBook() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Book reserved successfully.", bookReservationService.reserveBook(requestDto.getBookId()));
    }

    @PostMapping("/{reservationId}/cancel")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse cancelReservation(@PathVariable Long reservationId) {
        log.info("BookReservationController: cancelReservation() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Reservation cancelled successfully.", bookReservationService.cancelReservation(reservationId));
    }
}
/*
weidonglang
2026.3-2027.9
*/
