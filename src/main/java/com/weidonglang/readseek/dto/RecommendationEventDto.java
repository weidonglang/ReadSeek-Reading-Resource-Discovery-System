package com.weidonglang.readseek.dto;

import com.weidonglang.readseek.enums.RecommendationEventType;
import com.weidonglang.readseek.enums.RecommendationFeedbackType;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RecommendationEventDto {
    private Long id;
    private Long userId;
    private String userEmail;
    private Long bookId;
    private String bookName;
    private RecommendationEventType eventType;
    private RecommendationFeedbackType feedbackType;
    private String shelfKey;
    private String shelfTitle;
    private String source;
    private String reason;
    private String reasonType;
    private Integer rankPosition;
    private String requestContext;
    private String comment;
    private LocalDateTime createdDate;
}
