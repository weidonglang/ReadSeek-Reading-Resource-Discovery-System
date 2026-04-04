package com.henry.bookrecommendationsystem.dto;

import com.henry.bookrecommendationsystem.dto.base.BaseDto;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;
import java.util.Set;

/**
 * @author Henry Azer
 * @since 05/11/2022
 */
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
}
