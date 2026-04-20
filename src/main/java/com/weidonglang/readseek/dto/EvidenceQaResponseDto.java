package com.weidonglang.readseek.dto;

import com.weidonglang.readseek.enums.SearchQueryIntent;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class EvidenceQaResponseDto {
    private String question;
    private String answer;
    private String answerMode;
    private String strategy;
    private SearchQueryIntent queryIntent;
    private Boolean fallbackApplied;
    private Integer evidenceCount;
    private List<EvidenceSnippetDto> evidence;
    private List<String> limitations;
    private List<String> followUpSuggestions;
}
