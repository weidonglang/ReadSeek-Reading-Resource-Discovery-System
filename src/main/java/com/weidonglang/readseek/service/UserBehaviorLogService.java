package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dto.SearchLogRecordDto;
import com.weidonglang.readseek.enums.UserBehaviorActionType;
public interface UserBehaviorLogService {
    void record(UserBehaviorActionType actionType, Long bookId, String keyword, String source, String reason);

    void recordSearch(SearchLogRecordDto searchLogRecordDto);

    default void recordSearch(String keyword, String source, String reason) {
        recordSearch(new SearchLogRecordDto(keyword, source, reason,
                null, null, null, null,
                null, null, null, null, null, null,
                null, null, null, null, null));
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
/*
weidonglang
2026.3-2027.9
*/
