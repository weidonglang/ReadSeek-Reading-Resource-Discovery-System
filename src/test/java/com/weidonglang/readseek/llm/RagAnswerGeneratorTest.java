package com.weidonglang.readseek.llm;

import com.weidonglang.readseek.config.RagProperties;
import com.weidonglang.readseek.dto.EvidenceSnippetDto;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class RagAnswerGeneratorTest {

    @Test
    void generateShouldUseOllamaClientWhenAvailable() {
        RagProperties properties = new RagProperties();
        RagAnswerGenerator generator = new RagAnswerGenerator(properties, List.of(new StubClient(false)));

        RagAnswerGenerator.GeneratedAnswer answer = generator.generate(
                "想看成长主题",
                "RECOMMENDATION",
                "standard",
                "ollama",
                List.of(snippet()),
                true
        );

        assertEquals("qwen3:8b@ollama", answer.getBackend());
        assertEquals("ollama", answer.getProvider());
        assertEquals("qwen3:8b", answer.getModel());
        assertFalse(answer.isFallbackApplied());
        assertTrue(answer.getAnswer().contains("[1]"));
    }

    @Test
    void generateShouldFallbackWhenProviderFails() {
        RagProperties properties = new RagProperties();
        RagAnswerGenerator generator = new RagAnswerGenerator(properties, List.of(new StubClient(true)));

        RagAnswerGenerator.GeneratedAnswer answer = generator.generate(
                "比较两本书",
                "COMPARISON",
                "fast",
                "ollama",
                List.of(snippet()),
                true
        );

        assertTrue(answer.isFallbackApplied());
        assertTrue(answer.getBackend().contains("fallback"));
        assertTrue(answer.getAnswer().contains("[1]"));
    }

    @Test
    void generateShouldRefuseWhenEvidenceIsInsufficient() {
        RagProperties properties = new RagProperties();
        RagAnswerGenerator generator = new RagAnswerGenerator(properties, List.of(new StubClient(false)));

        RagAnswerGenerator.GeneratedAnswer answer = generator.generate(
                "不存在的书",
                "FACTUAL_LOOKUP",
                "standard",
                "ollama",
                List.of(),
                false
        );

        assertTrue(answer.getAnswer().contains("不能可靠回答"));
        assertFalse(answer.isFallbackApplied());
    }

    private EvidenceSnippetDto snippet() {
        EvidenceSnippetDto snippet = new EvidenceSnippetDto();
        snippet.setResourceId(1L);
        snippet.setTitle("Atomic Habits");
        snippet.setAuthor("James Clear");
        snippet.setCategory("Self-Help");
        snippet.setDescription("A practical book about habit formation.");
        snippet.setMatchType("VECTOR+RERANK");
        snippet.setReason("semantic match");
        snippet.setCitation("[1]");
        snippet.setSource("vector,reranker");
        return snippet;
    }

    private static class StubClient implements LlmChatClient {
        private final boolean fail;

        private StubClient(boolean fail) {
            this.fail = fail;
        }

        @Override
        public boolean supports(String provider) {
            return "ollama".equals(provider);
        }

        @Override
        public LlmChatResult chat(LlmChatRequest request) {
            if (fail) {
                throw new LlmProviderException("offline");
            }
            return new LlmChatResult("建议阅读 Atomic Habits。", "ollama", request.getModel(), request.getModel() + "@ollama", 25L);
        }
    }
}
