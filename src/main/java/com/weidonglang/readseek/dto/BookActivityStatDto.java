package com.weidonglang.readseek.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BookActivityStatDto {
    private Long bookId;
    private String bookName;
    private String imageUrl;
    private Long count;
    private String metric;
}
