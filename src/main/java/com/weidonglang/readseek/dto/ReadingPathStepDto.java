package com.weidonglang.readseek.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ReadingPathStepDto {
    private Integer stepOrder;
    private String stage;
    private String goal;
    private List<EvidenceSnippetDto> resources;
}
