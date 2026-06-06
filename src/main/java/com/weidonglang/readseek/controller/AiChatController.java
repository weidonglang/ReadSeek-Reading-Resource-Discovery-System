package com.weidonglang.readseek.controller;

import com.weidonglang.readseek.dto.AiChatMessageRequestDto;
import com.weidonglang.readseek.dto.base.response.ApiResponse;
import com.weidonglang.readseek.service.AiChatService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;

@Slf4j
@CrossOrigin
@RestController
@AllArgsConstructor
@RequestMapping("/api/ai-chat")
public class AiChatController {
    private final AiChatService aiChatService;

    @PostMapping("/message")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse sendMessage(@RequestBody AiChatMessageRequestDto requestDto,
                                   Authentication authentication) {
        log.info("AiChatController: sendMessage() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "AI chat message handled successfully.",
                aiChatService.sendMessage(resolveOwner(authentication), requestDto));
    }

    @GetMapping("/sessions")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse findSessions(Authentication authentication) {
        log.info("AiChatController: findSessions() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "AI chat sessions fetched successfully.",
                aiChatService.findSessions(resolveOwner(authentication)));
    }

    @GetMapping("/sessions/{id}")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse findSession(@PathVariable String id, Authentication authentication) {
        log.info("AiChatController: findSession() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "AI chat session fetched successfully.",
                aiChatService.findSession(resolveOwner(authentication), id));
    }

    @DeleteMapping("/sessions/{id}")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse deleteSession(@PathVariable String id, Authentication authentication) {
        log.info("AiChatController: deleteSession() called");
        aiChatService.deleteSession(resolveOwner(authentication), id);
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "AI chat session deleted successfully.", null);
    }

    private String resolveOwner(Authentication authentication) {
        return authentication == null ? "anonymous" : authentication.getName();
    }
}
