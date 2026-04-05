package com.weidonglang.NewBookRecommendationSystem.dto;

import com.weidonglang.NewBookRecommendationSystem.enums.UserBehaviorActionType;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserBehaviorLogRequestDto {
    private UserBehaviorActionType actionType;
    private Long bookId;
    private String keyword;
    private String source;
    private String reason;
}
/*
weidonglang
2026.3-2027.9
*/
