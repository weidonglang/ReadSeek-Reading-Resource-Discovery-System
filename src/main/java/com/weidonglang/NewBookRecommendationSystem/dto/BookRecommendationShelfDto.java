package com.weidonglang.NewBookRecommendationSystem.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BookRecommendationShelfDto {
    private String key;
    private String title;
    private String description;
    private List<BookDto> books;
}
/*
weidonglang
2026.3-2027.9
*/
