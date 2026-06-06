package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dto.AiChatMessageRequestDto;
import com.weidonglang.readseek.dto.AiChatResponseDto;
import com.weidonglang.readseek.dto.AiChatSessionDto;
import com.weidonglang.readseek.dto.EvidenceQaRequestDto;
import com.weidonglang.readseek.dto.EvidenceQaResponseDto;
import com.weidonglang.readseek.dto.EvidenceSnippetDto;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AiChatServiceImplTest {
    @Mock
    private EvidenceQaService evidenceQaService;

    private AiChatServiceImpl service;

    @BeforeEach
    void setUp() {
        service = new AiChatServiceImpl(evidenceQaService);
    }

    @Test
    void sendMessageShouldReuseRagEvidenceAndStoreSessionMessages() {
        EvidenceSnippetDto evidence = new EvidenceSnippetDto(1L, "Deep Work", "Cal Newport", "Self-Help",
                "Focus and attention.", "BM25+RERANK", 0.9D, "Reranked evidence.", 1);
        evidence.setCitation("[1]");
        evidence.setSource("bm25,reranker");

        EvidenceQaResponseDto qaResponse = new EvidenceQaResponseDto();
        qaResponse.setAnswer("Start with Deep Work. [1]");
        qaResponse.setAnswerable(true);
        qaResponse.setEvidence(List.of(evidence));
        qaResponse.setCitations(List.of("[1] Deep Work"));
        qaResponse.setStrategy("hybrid-v3");
        qaResponse.setRagMode("fast");
        qaResponse.setLlmProvider("ollama");
        qaResponse.setModel("qwen2.5:7b");
        qaResponse.setGenerationBackend("qwen2.5:7b@ollama");
        qaResponse.setLlmFallbackApplied(false);
        qaResponse.setRetrievalLatencyMs(12L);
        qaResponse.setGenerationLatencyMs(34L);
        qaResponse.setTotalLatencyMs(46L);
        when(evidenceQaService.answer(org.mockito.ArgumentMatchers.any(EvidenceQaRequestDto.class))).thenReturn(qaResponse);

        AiChatResponseDto response = service.sendMessage("reader@example.com",
                new AiChatMessageRequestDto(null, "Recommend a focus book", "fast", "ollama", 5));

        assertNotNull(response.getSessionId());
        assertEquals("Start with Deep Work. [1]", response.getAnswer());
        assertEquals(1, response.getEvidence().size());
        assertEquals(1, response.getRecommendations().size());
        assertEquals("Deep Work", response.getRecommendations().get(0).getTitle());
        assertFalse(response.getLlmFallbackApplied());

        List<AiChatSessionDto> sessions = service.findSessions("reader@example.com");
        assertEquals(1, sessions.size());
        assertEquals(2, sessions.get(0).getMessages().size());

        ArgumentCaptor<EvidenceQaRequestDto> captor = ArgumentCaptor.forClass(EvidenceQaRequestDto.class);
        verify(evidenceQaService).answer(captor.capture());
        assertEquals("Recommend a focus book", captor.getValue().getQuestion());
        assertEquals("fast", captor.getValue().getMode());
        assertEquals("ollama", captor.getValue().getProvider());
    }

    @Test
    void deleteSessionShouldRemoveOnlyOwnedSession() {
        String sessionId = service.sendMessage("owner@example.com",
                new AiChatMessageRequestDto(null, "hello", null, null, null)).getSessionId();

        service.deleteSession("other@example.com", sessionId);
        assertEquals(1, service.findSessions("owner@example.com").size());

        service.deleteSession("owner@example.com", sessionId);
        assertTrue(service.findSessions("owner@example.com").isEmpty());
        verifyNoInteractions(evidenceQaService);
    }

    @Test
    void generalChatShouldNotRequireCatalogEvidence() {
        AiChatResponseDto response = service.sendMessage("reader@example.com",
                new AiChatMessageRequestDto(null, "Explain artificial intelligence in simple terms", "standard", "ollama", 5));

        assertNotNull(response.getSessionId());
        assertTrue(response.getAnswerable());
        assertEquals("open-chat", response.getStrategy());
        verifyNoInteractions(evidenceQaService);
    }
}
