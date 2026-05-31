package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dto.AuthorDto;
import com.weidonglang.readseek.dto.BookCategoryDto;
import com.weidonglang.readseek.dto.BookDto;
import com.weidonglang.readseek.dto.BookSearchHitDto;
import com.weidonglang.readseek.dto.BookSearchResponseDto;
import com.weidonglang.readseek.dto.EvidenceQaRequestDto;
import com.weidonglang.readseek.dto.EvidenceQaResponseDto;
import com.weidonglang.readseek.enums.SearchQueryIntent;
import com.weidonglang.readseek.config.RagProperties;
import com.weidonglang.readseek.llm.RagAnswerGenerator;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.mockito.Mockito.any;

@ExtendWith(MockitoExtension.class)
class EvidenceQaServiceImplTest {

    @Mock
    private BookSearchService bookSearchService;

    @Mock
    private QaEventService qaEventService;

    private EvidenceQaServiceImpl service;

    @BeforeEach
    void setUp() {
        RagProperties ragProperties = new RagProperties();
        ragProperties.setLlmEnabled(false);
        RagAnswerGenerator answerGenerator = new RagAnswerGenerator(ragProperties, List.of());
        service = new EvidenceQaServiceImpl(bookSearchService, ragProperties, answerGenerator, qaEventService);
    }

    @Test
    void answerShouldBuildTemplateAnswerFromSearchEvidence() {
        BookDto book = new BookDto();
        book.setId(1L);
        book.setName("Pride and Prejudice");
        AuthorDto author = new AuthorDto();
        author.setId(2L);
        author.setName("Jane Austen");
        book.setAuthor(author);
        book.setCategory(new BookCategoryDto(3L, "Romantic", null));
        book.setDescription("Austen's classic novel.");
        BookSearchHitDto hit = new BookSearchHitDto(book, 9.2, "EXACT_DB", "Author match");
        BookSearchResponseDto searchResponse = new BookSearchResponseDto(
                "想看简奥斯汀的代表作",
                SearchQueryIntent.KEYWORD,
                "hybrid-v2(exact-db+bm25+vector)",
                false,
                1,
                List.of(hit)
        );
        when(bookSearchService.searchBooks("想看简奥斯汀的代表作", 5)).thenReturn(searchResponse);

        EvidenceQaResponseDto response = service.answer(new EvidenceQaRequestDto("想看简奥斯汀的代表作", 5));

        assertEquals("想看简奥斯汀的代表作", response.getQuestion());
        assertEquals("RECOMMENDATION", response.getAnswerMode());
        assertEquals(1, response.getEvidenceCount());
        assertEquals("Pride and Prejudice", response.getEvidence().get(0).getTitle());
        assertEquals("[1]", response.getEvidence().get(0).getCitation());
        assertTrue(response.getAnswerable());
        assertTrue(response.getAnswer().contains("Pride and Prejudice"));
        assertTrue(response.getAnswer().contains("[1]"));
        assertEquals("local-evidence-generator-v1", response.getGenerationBackend());
        assertEquals("standard", response.getRagMode());
        assertEquals("ollama", response.getLlmProvider());
        assertEquals("qwen3:8b", response.getModel());
        assertFalse(response.getCitations().isEmpty());
        assertFalse(response.getLimitations().isEmpty());
        verify(bookSearchService).searchBooks("想看简奥斯汀的代表作", 5);
        verify(qaEventService).recordQuestion(any(EvidenceQaResponseDto.class));
    }

    @Test
    void answerShouldRefuseWhenNoEvidenceIsAvailable() {
        BookSearchResponseDto searchResponse = new BookSearchResponseDto(
                "找一本不存在的书",
                SearchQueryIntent.NATURAL_LANGUAGE,
                "hybrid-v1(exact-db+bm25)",
                true,
                0,
                List.of()
        );
        when(bookSearchService.searchBooks("找一本不存在的书", 5)).thenReturn(searchResponse);

        EvidenceQaResponseDto response = service.answer(new EvidenceQaRequestDto("找一本不存在的书", 5));

        assertFalse(response.getAnswerable());
        assertEquals(0, response.getEvidenceCount());
        assertTrue(response.getAnswer().contains("不能可靠回答"));
        assertEquals(0.0D, response.getConfidence());
        assertTrue(response.getCitations().isEmpty());
    }
}
