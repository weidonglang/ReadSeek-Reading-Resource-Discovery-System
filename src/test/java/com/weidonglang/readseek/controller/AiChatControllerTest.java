package com.weidonglang.readseek.controller;

import com.weidonglang.readseek.dto.AiChatMessageRequestDto;
import com.weidonglang.readseek.dto.AiChatResponseDto;
import com.weidonglang.readseek.dto.AiChatSessionDto;
import com.weidonglang.readseek.dto.base.response.ApiResponse;
import com.weidonglang.readseek.service.AiChatService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AiChatControllerTest {
    @Mock
    private AiChatService aiChatService;

    private AiChatController controller;

    @BeforeEach
    void setUp() {
        controller = new AiChatController(aiChatService);
    }

    @Test
    void sendMessageShouldReturnServiceResponse() {
        AiChatMessageRequestDto request = new AiChatMessageRequestDto(null, "hello", "fast", "ollama", 5);
        AiChatResponseDto chatResponse = new AiChatResponseDto();
        UsernamePasswordAuthenticationToken authentication =
                new UsernamePasswordAuthenticationToken("reader@example.com", "n/a");
        when(aiChatService.sendMessage("reader@example.com", request)).thenReturn(chatResponse);

        ApiResponse response = controller.sendMessage(request, authentication);

        assertTrue(response.getSuccess());
        assertEquals("AI chat message handled successfully.", response.getMessage());
        assertSame(chatResponse, response.getBody());
        verify(aiChatService).sendMessage("reader@example.com", request);
    }

    @Test
    void findSessionsShouldUseCurrentPrincipal() {
        List<AiChatSessionDto> sessions = List.of(new AiChatSessionDto());
        UsernamePasswordAuthenticationToken authentication =
                new UsernamePasswordAuthenticationToken("reader@example.com", "n/a");
        when(aiChatService.findSessions("reader@example.com")).thenReturn(sessions);

        ApiResponse response = controller.findSessions(authentication);

        assertSame(sessions, response.getBody());
        verify(aiChatService).findSessions("reader@example.com");
    }
}
