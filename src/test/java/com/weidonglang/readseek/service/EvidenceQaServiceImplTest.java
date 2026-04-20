package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dto.AuthorDto;
import com.weidonglang.readseek.dto.BookCategoryDto;
import com.weidonglang.readseek.dto.BookDto;
import com.weidonglang.readseek.dto.BookSearchHitDto;
import com.weidonglang.readseek.dto.BookSearchResponseDto;
import com.weidonglang.readseek.dto.EvidenceQaRequestDto;
import com.weidonglang.readseek.dto.EvidenceQaResponseDto;
import com.weidonglang.readseek.enums.SearchQueryIntent;
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

@ExtendWith(MockitoExtension.class)
class EvidenceQaServiceImplTest {

    @Mock
    private BookSearchService bookSearchService;

    private EvidenceQaServiceImpl service;

    @BeforeEach
    void setUp() {
        service = new EvidenceQaServiceImpl(bookSearchService);
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
        assertTrue(response.getAnswer().contains("Pride and Prejudice"));
        assertFalse(response.getLimitations().isEmpty());
        verify(bookSearchService).searchBooks("想看简奥斯汀的代表作", 5);
    }
}
