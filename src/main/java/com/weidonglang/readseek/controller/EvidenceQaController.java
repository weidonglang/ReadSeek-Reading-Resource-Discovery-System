package com.weidonglang.readseek.controller;

import com.weidonglang.readseek.dto.EvidenceQaRequestDto;
import com.weidonglang.readseek.dto.base.response.ApiResponse;
import com.weidonglang.readseek.service.EvidenceQaService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;

@Slf4j
@CrossOrigin
@RestController
@AllArgsConstructor
@RequestMapping("/api/qa")
public class EvidenceQaController {
    private final EvidenceQaService evidenceQaService;

    @PostMapping("/evidence")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse answerWithEvidence(@RequestBody EvidenceQaRequestDto requestDto) {
        log.info("EvidenceQaController: answerWithEvidence() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Evidence-grounded answer generated successfully.",
                evidenceQaService.answer(requestDto));
    }
}
