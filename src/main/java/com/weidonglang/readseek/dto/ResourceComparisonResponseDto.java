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
public class ResourceComparisonResponseDto {
    private List<ResourceComparisonItemDto> items;
    private String summary;
    private List<String> sharedCategories;
    private List<String> sharedAuthors;
    private List<String> sharedTags;
    private List<String> dimensionNotes;
    private List<String> decisionSuggestions;
}
