package com.weidonglang.readseek.controller;

import com.weidonglang.readseek.dto.RecommendationEventDto;
import com.weidonglang.readseek.dto.RecommendationFeedbackRequestDto;
import com.weidonglang.readseek.dto.base.response.ApiResponse;
import com.weidonglang.readseek.enums.RecommendationFeedbackType;
import com.weidonglang.readseek.service.RecommendationEventService;
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
class RecommendationEventControllerTest {

    @Mock
    private RecommendationEventService recommendationEventService;

    private RecommendationEventController controller;

    @BeforeEach
    void setUp() {
        controller = new RecommendationEventController(recommendationEventService);
    }

    @Test
    void recordFeedbackShouldReturnSavedEvent() {
        RecommendationFeedbackRequestDto request = new RecommendationFeedbackRequestDto();
        request.setBookId(10L);
        request.setFeedbackType(RecommendationFeedbackType.INTERESTED);
        RecommendationEventDto saved = new RecommendationEventDto();
        saved.setId(99L);
        when(recommendationEventService.recordFeedback(request)).thenReturn(saved);

        ApiResponse response = controller.recordFeedback(request);

        assertTrue(response.getSuccess());
        assertEquals("Recommendation feedback recorded successfully.", response.getMessage());
        assertSame(saved, response.getBody());
        assertNotNull(response.getTimestamp());
        verify(recommendationEventService).recordFeedback(request);
    }

    @Test
    void findRecentFeedbackShouldReturnEvents() {
        List<RecommendationEventDto> events = List.of(new RecommendationEventDto());
        when(recommendationEventService.findRecentFeedback(5)).thenReturn(events);

        ApiResponse response = controller.findRecentFeedback(5);

        assertTrue(response.getSuccess());
        assertEquals("Recent recommendation feedback fetched successfully.", response.getMessage());
        assertSame(events, response.getBody());
        verify(recommendationEventService).findRecentFeedback(5);
    }
}
