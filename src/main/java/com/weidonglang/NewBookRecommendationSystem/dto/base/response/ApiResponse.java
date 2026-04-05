package com.weidonglang.NewBookRecommendationSystem.dto.base.response;

import lombok.AllArgsConstructor;
import lombok.Data;
@Data
@AllArgsConstructor
public class ApiResponse {
    private Boolean success;
    private String timestamp;
    private String message;
    private Object body;
}
/*
weidonglang
2026.3-2027.9
*/
