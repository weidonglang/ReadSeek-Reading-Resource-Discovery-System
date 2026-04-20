package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dto.EvidenceQaRequestDto;
import com.weidonglang.readseek.dto.EvidenceQaResponseDto;

public interface EvidenceQaService {
    EvidenceQaResponseDto answer(EvidenceQaRequestDto requestDto);
}
