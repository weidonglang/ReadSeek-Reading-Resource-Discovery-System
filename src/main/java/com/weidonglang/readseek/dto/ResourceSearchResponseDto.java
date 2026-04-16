package com.weidonglang.readseek.dto;

import com.weidonglang.readseek.enums.SearchQueryIntent;

import java.util.List;

public class ResourceSearchResponseDto extends BookSearchResponseDto {

    public ResourceSearchResponseDto() {
        super();
    }

    public ResourceSearchResponseDto(String query,
                                     SearchQueryIntent queryIntent,
                                     String strategy,
                                     boolean fallbackApplied,
                                     Integer returnedCount,
                                     List<BookSearchHitDto> hits) {
        super(query, queryIntent, strategy, fallbackApplied, returnedCount, hits);
    }
}
