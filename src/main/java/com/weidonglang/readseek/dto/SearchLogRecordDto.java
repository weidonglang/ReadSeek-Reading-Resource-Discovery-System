package com.weidonglang.readseek.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SearchLogRecordDto {
    private String keyword;
    private String source;
    private String reason;
    private String categoryIds;
    private String authorIds;
    private String publisherIds;
    private String tagIds;
    private Double fromPrice;
    private Double toPrice;
    private Integer fromPagesNumber;
    private Integer toPagesNumber;
    private Integer fromReadingDuration;
    private Integer toReadingDuration;
    private String sortBy;
    private Integer pageNumber;
    private Integer pageSize;
    private Boolean deletedRecords;
    private Long resultCount;
}
