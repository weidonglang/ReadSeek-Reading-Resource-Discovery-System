package com.henry.bookrecommendationsystem.dto;

import com.henry.bookrecommendationsystem.enums.UserBehaviorActionType;
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
