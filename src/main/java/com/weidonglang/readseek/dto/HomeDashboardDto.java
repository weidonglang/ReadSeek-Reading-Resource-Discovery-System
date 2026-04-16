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
public class HomeDashboardDto {
    private Integer readingStreakDays;
    private Long activeLoansCount;
    private Long activeReservationsCount;
    private Long dueSoonCount;
    private Long overdueCount;
    private Long monthlyBorrowCount;
    private Long monthlyRatingCount;
    private String readingLevel;
    private List<String> preferredCategories;
    private List<BookLoanDto> dueSoonLoans;
    private List<BookReservationDto> activeReservations;
    private List<BookDto> recentViewedBooks;
    private List<SearchKeywordStatDto> hotKeywords;
    private List<NamedCountStatDto> hotCategories;
    private List<BookDto> newArrivalBooks;
    private List<BookDto> popularBooks;
}
