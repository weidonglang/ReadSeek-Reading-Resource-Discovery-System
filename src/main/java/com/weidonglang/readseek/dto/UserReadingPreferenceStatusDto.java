package com.weidonglang.readseek.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserReadingPreferenceStatusDto {
    private Boolean initialized;
    private Integer preferredCategoryCount;
    private UserReadingInfoDto readingInfo;
}
