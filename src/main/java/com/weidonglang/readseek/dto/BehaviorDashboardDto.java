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
public class BehaviorDashboardDto {
    private Integer recentDaysApplied;
    private Long totalBehaviorEvents;
    private Long recentSearchCount;
    private Long recentDetailClickCount;
    private Long recentBorrowCount;
    private RecommendationStrategyDto recommendationStrategy;
    private List<BehaviorLogEntryDto> recentBehaviorLogs;
    private List<SearchLogEntryDto> recentSearchLogs;
    private List<SearchKeywordStatDto> topKeywords;
    private List<NamedCountStatDto> topCategories;
    private List<NamedCountStatDto> topAuthors;
    private List<NamedCountStatDto> topTags;
    private List<NamedCountStatDto> topPublishers;
    private List<BookActivityStatDto> topClickedBooks;
    private List<BookActivityStatDto> topBorrowedBooks;
}
