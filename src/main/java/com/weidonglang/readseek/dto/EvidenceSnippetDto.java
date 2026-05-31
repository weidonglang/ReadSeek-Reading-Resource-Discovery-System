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
    private String citation;
    private String source;
    private Boolean reranked;

    public EvidenceSnippetDto(Long resourceId,
                              String title,
                              String author,
                              String category,
                              String description,
                              String matchType,
                              Double score,
                              String reason,
                              Integer rank) {
        this.resourceId = resourceId;
        this.title = title;
        this.author = author;
        this.category = category;
        this.description = description;
        this.matchType = matchType;
        this.score = score;
        this.reason = reason;
        this.rank = rank;
    }
}
