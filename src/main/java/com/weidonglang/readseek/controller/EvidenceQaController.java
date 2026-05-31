package com.weidonglang.readseek.controller;

import com.weidonglang.readseek.dto.EvidenceQaRequestDto;
import com.weidonglang.readseek.dto.QaCitationClickRequestDto;
import com.weidonglang.readseek.dto.base.response.ApiResponse;
import com.weidonglang.readseek.service.EvidenceQaService;
import com.weidonglang.readseek.service.QaEventService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;

@Slf4j
@CrossOrigin
@RestController
@AllArgsConstructor
@RequestMapping("/api/qa")
public class EvidenceQaController {
    private final EvidenceQaService evidenceQaService;
    private final QaEventService qaEventService;

    @PostMapping("/evidence")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse answerWithEvidence(@RequestBody EvidenceQaRequestDto requestDto) {
        log.info("EvidenceQaController: answerWithEvidence() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Evidence-grounded answer generated successfully.",
                evidenceQaService.answer(requestDto));
    }

    @PostMapping("/citation-click")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse recordCitationClick(@RequestBody QaCitationClickRequestDto requestDto) {
        log.info("EvidenceQaController: recordCitationClick() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "QA citation click recorded successfully.",
                qaEventService.recordCitationClick(requestDto));
    }

    @GetMapping("/events/recent")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse findRecentEvents(@RequestParam(defaultValue = "20") Integer limit) {
        log.info("EvidenceQaController: findRecentEvents() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Recent QA events fetched successfully.",
                qaEventService.findRecentEvents(limit));
    }

    @GetMapping("/analytics")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse getAnalytics(@RequestParam(required = false) Integer recentDays,
                                    @RequestParam(defaultValue = "20") Integer limit) {
        log.info("EvidenceQaController: getAnalytics() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "QA analytics fetched successfully.",
                qaEventService.buildAnalytics(recentDays, limit));
    }
}
