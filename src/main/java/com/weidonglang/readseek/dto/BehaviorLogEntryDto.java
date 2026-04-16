package com.weidonglang.readseek.dto;

import com.weidonglang.readseek.enums.UserBehaviorActionType;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BehaviorLogEntryDto {
    private Long id;
    private UserBehaviorActionType actionType;
    private Long userId;
    private String userEmail;
    private Long bookId;
    private String bookName;
    private String keyword;
    private String source;
    private String reason;
    private LocalDateTime createdDate;
}
