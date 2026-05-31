package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dto.EvidenceQaResponseDto;
import com.weidonglang.readseek.dto.QaAnalyticsDto;
import com.weidonglang.readseek.dto.QaCitationClickRequestDto;
import com.weidonglang.readseek.dto.QaEventDto;

import java.util.List;

public interface QaEventService {
    QaEventDto recordQuestion(EvidenceQaResponseDto responseDto);

    QaEventDto recordCitationClick(QaCitationClickRequestDto requestDto);

    List<QaEventDto> findRecentEvents(Integer limit);

    QaAnalyticsDto buildAnalytics(Integer recentDays, Integer limit);
}
