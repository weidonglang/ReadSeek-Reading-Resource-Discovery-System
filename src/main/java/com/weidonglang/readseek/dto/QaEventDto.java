package com.weidonglang.readseek.dto;

import com.weidonglang.readseek.enums.QaEventType;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class QaEventDto {
    private Long id;
    private QaEventType eventType;
    private Long userId;
    private String userEmail;
    private Long bookId;
    private String bookName;
    private String question;
    private String answerMode;
    private String ragMode;
    private String provider;
    private String model;
    private Boolean answerable;
    private Integer evidenceCount;
    private Integer citationCount;
    private String retrievalStrategy;
    private Boolean fallbackApplied;
    private String fallbackReason;
    private Double confidence;
    private Long totalLatencyMs;
    private String citation;
    private LocalDateTime createdDate;
}
