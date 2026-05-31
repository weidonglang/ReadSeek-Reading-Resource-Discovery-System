package com.weidonglang.readseek.dto;

import com.weidonglang.readseek.enums.SearchQueryIntent;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookSearchResponseDto {
    private String query;
    private SearchQueryIntent queryIntent;
    private String strategy;
    private boolean fallbackApplied;
    private Integer returnedCount;
    private List<BookSearchHitDto> hits;
    private String expandedQuery;
    private List<String> strategySteps;
    private Boolean rerankerApplied;
    private Integer candidateCount;

    public BookSearchResponseDto(String query,
                                 SearchQueryIntent queryIntent,
                                 String strategy,
                                 boolean fallbackApplied,
                                 Integer returnedCount,
                                 List<BookSearchHitDto> hits) {
        this.query = query;
        this.queryIntent = queryIntent;
        this.strategy = strategy;
        this.fallbackApplied = fallbackApplied;
        this.returnedCount = returnedCount;
        this.hits = hits;
    }
}
