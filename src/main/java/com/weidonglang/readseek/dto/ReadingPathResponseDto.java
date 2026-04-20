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
public class ReadingPathResponseDto {
    private String topic;
    private String readingLevel;
    private String strategy;
    private SearchQueryIntent queryIntent;
    private Integer resourceCount;
    private List<ReadingPathStepDto> steps;
    private List<String> pathRationale;
    private List<String> limitations;
}
