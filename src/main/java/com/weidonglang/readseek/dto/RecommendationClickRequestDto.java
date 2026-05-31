package com.weidonglang.readseek.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RecommendationClickRequestDto {
    private Long bookId;
    private String source;
    private String reason;
    private String reasonType;
    private Integer rankPosition;
    private String requestContext;
}
