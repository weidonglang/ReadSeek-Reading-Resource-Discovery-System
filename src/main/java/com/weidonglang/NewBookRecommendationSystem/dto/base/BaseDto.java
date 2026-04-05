package com.weidonglang.NewBookRecommendationSystem.dto.base;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
@Data
@NoArgsConstructor
@AllArgsConstructor
public abstract class BaseDto {
    private LocalDateTime creationDate;
    private LocalDateTime lastModificationDate;
    private Boolean markedAsDeleted = false;
}
/*
weidonglang
2026.3-2027.9
*/
