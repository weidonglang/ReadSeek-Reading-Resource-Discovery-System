package com.weidonglang.readseek.dto;

import com.weidonglang.readseek.enums.RecommendationFeedbackType;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RecommendationFeedbackRequestDto {
    private Long bookId;
    private RecommendationFeedbackType feedbackType;
    private String source;
    private String reason;
    private String reasonType;
    private Integer rankPosition;
    private String requestContext;
    private String comment;
}
