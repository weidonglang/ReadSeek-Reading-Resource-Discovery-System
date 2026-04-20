package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dto.ReadingPathRequestDto;
import com.weidonglang.readseek.dto.ReadingPathResponseDto;
import com.weidonglang.readseek.dto.ResourceComparisonRequestDto;
import com.weidonglang.readseek.dto.ResourceComparisonResponseDto;

public interface ReadingPlanningService {
    ResourceComparisonResponseDto compareResources(ResourceComparisonRequestDto requestDto);

    ReadingPathResponseDto suggestReadingPath(ReadingPathRequestDto requestDto);
}
