package com.weidonglang.readseek.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookSearchHitDto {
    private BookDto book;
    private Double score;
    private String matchType;
    private String reason;
    private String source;
    private String retrievalStage;
    private Boolean reranked;
    private List<String> explanationTags;

    public BookSearchHitDto(BookDto book, Double score, String matchType, String reason) {
        this.book = book;
        this.score = score;
        this.matchType = matchType;
        this.reason = reason;
    }
}
