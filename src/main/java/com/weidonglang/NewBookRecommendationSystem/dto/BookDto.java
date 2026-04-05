package com.weidonglang.NewBookRecommendationSystem.dto;

import com.weidonglang.NewBookRecommendationSystem.dto.base.BaseDto;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;
import java.util.Set;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BookDto extends BaseDto {
    private Long id;
    private AuthorDto author;
    private String name;
    private String isbn;
    private Double rate;
    private Long usersRateCount;
    private BookCategoryDto category;
    private PublisherDto publisher;
    private Double price;
    private Integer pagesNumber;
    private Integer readingDuration;
    private Date publishDate;
    private String description;
    private String imageUrl;
    private Integer totalCopies;
    private Integer availableCopies;
    private Set<TagDto> tags;
    private String recommendationSource;
    private String recommendationReason;
}
/*
weidonglang
2026.3-2027.9
*/
