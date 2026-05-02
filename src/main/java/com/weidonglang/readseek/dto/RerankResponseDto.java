package com.weidonglang.readseek.dto;

import lombok.Data;

import java.util.List;

@Data
public class RerankResponseDto {
    private List<RerankResultDto> results;
    private String model;
    private String backend;
    private Integer topN;
    private Long elapsedMs;

    @Data
    public static class RerankResultDto {
        private Long id;
        private Double score;
        private Integer rank;
        private Integer inputRank;
    }
}
