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
public class ResourceComparisonItemDto {
    private Long id;
    private String title;
    private String author;
    private String category;
    private Double rating;
    private Long ratingCount;
    private Integer pagesNumber;
    private Integer readingDuration;
    private Integer availableCopies;
    private Integer totalCopies;
    private List<String> tags;
    private String summary;
}
