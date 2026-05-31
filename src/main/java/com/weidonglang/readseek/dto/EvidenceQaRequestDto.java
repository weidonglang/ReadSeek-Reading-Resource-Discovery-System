package com.weidonglang.readseek.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class EvidenceQaRequestDto {
    private String question;
    private Integer limit;
    private String mode;
    private String provider;

    public EvidenceQaRequestDto(String question, Integer limit) {
        this.question = question;
        this.limit = limit;
    }
}
