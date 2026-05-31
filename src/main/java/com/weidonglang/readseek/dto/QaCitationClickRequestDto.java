package com.weidonglang.readseek.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class QaCitationClickRequestDto {
    private Long qaEventId;
    private Long bookId;
    private String citation;
    private String question;
    private String answerMode;
    private String ragMode;
}
