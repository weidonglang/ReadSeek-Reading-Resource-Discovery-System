package com.weidonglang.readseek.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AiChatRecommendationDto {
    private Long resourceId;
    private String title;
    private String author;
    private String category;
    private String source;
    private String reason;
    private Integer rank;
}
