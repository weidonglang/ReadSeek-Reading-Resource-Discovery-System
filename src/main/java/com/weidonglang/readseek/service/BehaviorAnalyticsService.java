package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dto.BehaviorDashboardDto;
import com.weidonglang.readseek.dto.BehaviorLogEntryDto;
import com.weidonglang.readseek.dto.BookActivityStatDto;
import com.weidonglang.readseek.dto.BookDto;
import com.weidonglang.readseek.dto.NamedCountStatDto;
import com.weidonglang.readseek.dto.RecommendationStrategyDto;
import com.weidonglang.readseek.dto.SearchKeywordStatDto;
import com.weidonglang.readseek.dto.SearchLogEntryDto;

import java.util.List;

public interface BehaviorAnalyticsService {
    BehaviorDashboardDto buildDashboard(Integer limit, Integer recentDays);

    List<BehaviorLogEntryDto> findRecentBehaviorLogs(Integer limit);

    List<SearchLogEntryDto> findRecentSearchLogs(Integer limit);

    List<BehaviorLogEntryDto> findRecentBehaviorByUser(Long userId, Integer limit);

    List<BehaviorLogEntryDto> findRecentBehaviorByBook(Long bookId, Integer limit);

    List<SearchKeywordStatDto> findTopKeywords(Integer limit, Integer recentDays);

    List<BookActivityStatDto> findTopClickedBooks(Integer limit, Integer recentDays);

    List<BookActivityStatDto> findTopBorrowedBooks(Integer limit, Integer recentDays);

    List<NamedCountStatDto> findTopCategories(Integer limit, Integer recentDays);

    List<NamedCountStatDto> findTopAuthors(Integer limit, Integer recentDays);

    List<NamedCountStatDto> findTopTags(Integer limit, Integer recentDays);

    List<NamedCountStatDto> findTopPublishers(Integer limit, Integer recentDays);

    RecommendationStrategyDto getRecommendationStrategy(Integer recentDays);

    List<BookDto> findPopularBooks(Integer limit, Integer recentDays);
}
