package com.weidonglang.readseek.controller;

import com.weidonglang.readseek.dto.ReadingPathRequestDto;
import com.weidonglang.readseek.dto.ReadingPathResponseDto;
import com.weidonglang.readseek.dto.ResourceComparisonRequestDto;
import com.weidonglang.readseek.dto.ResourceComparisonResponseDto;
import com.weidonglang.readseek.dto.base.response.ApiResponse;
import com.weidonglang.readseek.service.ReadingPlanningService;
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
class ReadingPlanningControllerTest {

    @Mock
    private ReadingPlanningService readingPlanningService;

    private ReadingPlanningController controller;

    @BeforeEach
    void setUp() {
        controller = new ReadingPlanningController(readingPlanningService);
    }

    @Test
    void compareResourcesShouldReturnServiceResponse() {
        ResourceComparisonRequestDto request = new ResourceComparisonRequestDto(List.of(1L, 2L));
        ResourceComparisonResponseDto result = new ResourceComparisonResponseDto();
        when(readingPlanningService.compareResources(request)).thenReturn(result);

        ApiResponse response = controller.compareResources(request);

        assertTrue(response.getSuccess());
        assertEquals("Reading resources compared successfully.", response.getMessage());
        assertSame(result, response.getBody());
        assertNotNull(response.getTimestamp());
        verify(readingPlanningService).compareResources(request);
    }

    @Test
    void suggestReadingPathShouldReturnServiceResponse() {
        ReadingPathRequestDto request = new ReadingPathRequestDto("classic romance", "BEGINNER", 6);
        ReadingPathResponseDto result = new ReadingPathResponseDto();
        when(readingPlanningService.suggestReadingPath(request)).thenReturn(result);

        ApiResponse response = controller.suggestReadingPath(request);

        assertTrue(response.getSuccess());
        assertEquals("Reading path generated successfully.", response.getMessage());
        assertSame(result, response.getBody());
        assertNotNull(response.getTimestamp());
        verify(readingPlanningService).suggestReadingPath(request);
    }
}
