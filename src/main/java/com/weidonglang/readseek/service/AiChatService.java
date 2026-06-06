package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dto.AiChatMessageRequestDto;
import com.weidonglang.readseek.dto.AiChatResponseDto;
import com.weidonglang.readseek.dto.AiChatSessionDto;

import java.util.List;

public interface AiChatService {
    AiChatResponseDto sendMessage(String owner, AiChatMessageRequestDto requestDto);

    List<AiChatSessionDto> findSessions(String owner);

    AiChatSessionDto findSession(String owner, String sessionId);

    void deleteSession(String owner, String sessionId);
}
