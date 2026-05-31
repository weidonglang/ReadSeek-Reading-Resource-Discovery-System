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
public class BookRecommendationShelfDto {
    private String key;
    private String title;
    private String description;
    private List<BookDto> books;
    private String source;
    private String reasonType;
    private String strategy;

    public BookRecommendationShelfDto(String key, String title, String description, List<BookDto> books) {
        this.key = key;
        this.title = title;
        this.description = description;
        this.books = books;
    }
}
/*
weidonglang
2026.3-2027.9
*/
