package com.weidonglang.NewBookRecommendationSystem.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Set;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BookFilterPaginationRequest {
    private String name;
    private Set<Long> categories;
    private Set<Long> authors;
    private Set<Long> publishers;
    private Set<Long> tags;
    private Double fromPrice;
    private Double toPrice;
    private Integer fromPagesNumber;
    private Integer toPagesNumber;
    private Integer fromReadingDuration;
    private Integer toReadingDuration;

    public String getName() {
        if (name == null || name.trim().isEmpty()) return null;
        return name.trim().toLowerCase();
    }

    public Set<Long> getCategories() {
        if (categories == null || categories.isEmpty()) return null;
        return categories;
    }

    public Set<Long> getAuthors() {
        if (authors == null || authors.isEmpty()) return null;
        return authors;
    }

    public Set<Long> getPublishers() {
        if (publishers == null || publishers.isEmpty()) return null;
        return publishers;
    }

    public Set<Long> getTags() {
        if (tags == null || tags.isEmpty()) return null;
        return tags;
    }
}
/*
weidonglang
2026.3-2027.9
*/
