package com.henry.bookrecommendationsystem.service;

import com.henry.bookrecommendationsystem.enums.UserBehaviorActionType;
public interface UserBehaviorLogService {
    void record(UserBehaviorActionType actionType, Long bookId, String keyword, String source, String reason);

    default void recordSearch(String keyword, String source, String reason) {
        record(UserBehaviorActionType.SEARCH, null, keyword, source, reason);
    }

    default void recordBookDetailClick(Long bookId, String source, String reason) {
        record(UserBehaviorActionType.BOOK_DETAIL_CLICK, bookId, null, source, reason);
    }

    default void recordRecommendationClick(Long bookId, String source, String reason) {
        record(UserBehaviorActionType.RECOMMENDATION_CLICK, bookId, null, source, reason);
    }

    default void recordBookRate(Long bookId, String reason) {
        record(UserBehaviorActionType.RATE_BOOK, bookId, null, "rate-book", reason);
    }

    default void recordBookBorrow(Long bookId, String reason) {
        record(UserBehaviorActionType.BORROW_BOOK, bookId, null, "borrow", reason);
    }
}
