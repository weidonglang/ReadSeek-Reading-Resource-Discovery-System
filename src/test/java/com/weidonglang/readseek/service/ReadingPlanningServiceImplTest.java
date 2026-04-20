package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dto.AuthorDto;
import com.weidonglang.readseek.dto.BookCategoryDto;
import com.weidonglang.readseek.dto.BookDto;
import com.weidonglang.readseek.dto.BookSearchHitDto;
import com.weidonglang.readseek.dto.BookSearchResponseDto;
import com.weidonglang.readseek.dto.ReadingPathRequestDto;
import com.weidonglang.readseek.dto.ReadingPathResponseDto;
import com.weidonglang.readseek.dto.ResourceComparisonRequestDto;
import com.weidonglang.readseek.dto.ResourceComparisonResponseDto;
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
class ReadingPlanningServiceImplTest {

    @Mock
    private BookService bookService;

    @Mock
    private BookSearchService bookSearchService;

    private ReadingPlanningServiceImpl service;

    @BeforeEach
    void setUp() {
        service = new ReadingPlanningServiceImpl(bookService, bookSearchService);
    }

    @Test
    void compareResourcesShouldBuildSharedDimensionSummary() {
        BookDto first = buildBook(1L, "Pride and Prejudice", "Jane Austen", "Romantic", 14D, 448);
        BookDto second = buildBook(2L, "Sense and Sensibility", "Jane Austen", "Romantic", 5D, 372);
        when(bookService.findById(1L)).thenReturn(first);
        when(bookService.findById(2L)).thenReturn(second);

        ResourceComparisonResponseDto response = service.compareResources(new ResourceComparisonRequestDto(List.of(1L, 2L)));

        assertEquals(2, response.getItems().size());
        assertTrue(response.getSharedAuthors().contains("Jane Austen"));
        assertTrue(response.getSharedCategories().contains("Romantic"));
        assertFalse(response.getDecisionSuggestions().isEmpty());
        verify(bookService).findById(1L);
        verify(bookService).findById(2L);
    }

    @Test
    void suggestReadingPathShouldSplitEvidenceIntoStages() {
        BookDto first = buildBook(1L, "Pride and Prejudice", "Jane Austen", "Romantic", 14D, 448);
        BookDto second = buildBook(2L, "Sense and Sensibility", "Jane Austen", "Romantic", 5D, 372);
        BookSearchResponseDto searchResponse = new BookSearchResponseDto(
                "classic romance",
                SearchQueryIntent.NATURAL_LANGUAGE,
                "hybrid-v2(exact-db+vector+bm25)",
                false,
                2,
                List.of(
                        new BookSearchHitDto(first, 9.0, "VECTOR", "semantic"),
                        new BookSearchHitDto(second, 8.0, "BM25", "keyword")
                )
        );
        when(bookSearchService.searchBooks("classic romance", 6)).thenReturn(searchResponse);

        ReadingPathResponseDto response = service.suggestReadingPath(new ReadingPathRequestDto("classic romance", "BEGINNER", 6));

        assertEquals("classic romance", response.getTopic());
        assertEquals("BEGINNER", response.getReadingLevel());
        assertEquals(2, response.getResourceCount());
        assertFalse(response.getSteps().isEmpty());
        assertFalse(response.getPathRationale().isEmpty());
        verify(bookSearchService).searchBooks("classic romance", 6);
    }

    @Test
    void suggestReadingPathShouldApplyPlanningFallbackWhenTopicHasNoHits() {
        BookDto first = buildBook(1L, "Pride and Prejudice", "Jane Austen", "Romantic", 14D, 448);
        BookSearchResponseDto emptyResponse = new BookSearchResponseDto(
                "经典爱情小说",
                SearchQueryIntent.KEYWORD,
                "hybrid-v2",
                false,
                0,
                List.of()
        );
        BookSearchResponseDto fallbackResponse = new BookSearchResponseDto(
                "想找一本经典爱情小说",
                SearchQueryIntent.NATURAL_LANGUAGE,
                "hybrid-v2",
                false,
                1,
                List.of(new BookSearchHitDto(first, 9.0, "VECTOR", "semantic"))
        );
        when(bookSearchService.searchBooks("经典爱情小说", 6)).thenReturn(emptyResponse);
        when(bookSearchService.searchBooks("想找一本经典爱情小说", 6)).thenReturn(fallbackResponse);

        ReadingPathResponseDto response = service.suggestReadingPath(new ReadingPathRequestDto("经典爱情小说", "INTERMEDIATE", 6));

        assertEquals("经典爱情小说", response.getTopic());
        assertEquals(1, response.getResourceCount());
        assertFalse(response.getSteps().isEmpty());
        assertTrue(response.getStrategy().contains("planning-query-expansion"));
        verify(bookSearchService).searchBooks("经典爱情小说", 6);
        verify(bookSearchService).searchBooks("想找一本经典爱情小说", 6);
    }

    private BookDto buildBook(Long id, String title, String authorName, String categoryName, Double rating, Integer pages) {
        BookDto book = new BookDto();
        book.setId(id);
        book.setName(title);
        book.setRate(rating);
        book.setUsersRateCount(10L);
        book.setPagesNumber(pages);
        book.setReadingDuration(pages == null ? null : pages * 2);
        book.setAvailableCopies(1);
        book.setTotalCopies(1);
        book.setDescription(title + " description");

        AuthorDto author = new AuthorDto();
        author.setName(authorName);
        book.setAuthor(author);

        BookCategoryDto category = new BookCategoryDto();
        category.setName(categoryName);
        book.setCategory(category);
        return book;
    }
}
