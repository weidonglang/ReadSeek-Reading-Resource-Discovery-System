package com.weidonglang.readseek.controller;

import com.weidonglang.readseek.dto.EvidenceQaRequestDto;
import com.weidonglang.readseek.dto.EvidenceQaResponseDto;
import com.weidonglang.readseek.dto.base.response.ApiResponse;
import com.weidonglang.readseek.service.EvidenceQaService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class EvidenceQaControllerTest {

    @Mock
    private EvidenceQaService evidenceQaService;

    private EvidenceQaController controller;

    @BeforeEach
    void setUp() {
        controller = new EvidenceQaController(evidenceQaService);
    }

    @Test
    void answerWithEvidenceShouldReturnServiceResponse() {
        EvidenceQaRequestDto request = new EvidenceQaRequestDto("想看简奥斯汀的代表作", 5);
        EvidenceQaResponseDto answer = new EvidenceQaResponseDto();
        answer.setQuestion(request.getQuestion());
        answer.setEvidenceCount(2);
        answer.setLimitations(List.of("template"));
        when(evidenceQaService.answer(request)).thenReturn(answer);

        ApiResponse response = controller.answerWithEvidence(request);

        assertTrue(response.getSuccess());
        assertEquals("Evidence-grounded answer generated successfully.", response.getMessage());
        assertSame(answer, response.getBody());
        assertNotNull(response.getTimestamp());
        verify(evidenceQaService).answer(request);
    }
}
