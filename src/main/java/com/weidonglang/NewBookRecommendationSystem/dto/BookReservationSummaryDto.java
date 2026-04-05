package com.weidonglang.NewBookRecommendationSystem.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BookReservationSummaryDto {
    private Long bookId;
    private Long activeReservationsCount;
    private Boolean currentUserHasActiveReservation;
    private Boolean currentUserIsFirstInQueue;
    private Integer currentUserQueuePosition;
    private Long currentUserReservationId;
}
/*
weidonglang
2026.3-2027.9
*/
