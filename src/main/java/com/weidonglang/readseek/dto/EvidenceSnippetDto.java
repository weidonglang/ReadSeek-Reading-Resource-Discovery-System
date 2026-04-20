package com.weidonglang.readseek.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class EvidenceSnippetDto {
    private Long resourceId;
    private String title;
    private String author;
    private String category;
    private String description;
    private String matchType;
    private Double score;
    private String reason;
    private Integer rank;
}
