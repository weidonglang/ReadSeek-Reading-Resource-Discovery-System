package com.weidonglang.readseek.dto;

public class ResourceSearchHitDto extends BookSearchHitDto {

    public ResourceSearchHitDto() {
        super();
    }

    public ResourceSearchHitDto(BookDto resource, Double score, String matchType, String reason) {
        super(resource, score, matchType, reason);
    }
}
