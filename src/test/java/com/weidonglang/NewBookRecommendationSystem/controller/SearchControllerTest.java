package com.weidonglang.NewBookRecommendationSystem.controller;

import com.weidonglang.NewBookRecommendationSystem.dto.BookSearchResponseDto;
import com.weidonglang.NewBookRecommendationSystem.enums.SearchQueryIntent;
import com.weidonglang.NewBookRecommendationSystem.service.BookSearchIndexService;
import com.weidonglang.NewBookRecommendationSystem.service.BookSearchService;
import com.weidonglang.NewBookRecommendationSystem.service.UserBehaviorLogService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SearchControllerTest {

    @Mock
    private BookSearchService bookSearchService;

    @Mock
    private BookSearchIndexService bookSearchIndexService;

    @Mock
    private UserBehaviorLogService userBehaviorLogService;

    private SearchController controller;

    @BeforeEach
    void setUp() {
        controller = new SearchController(bookSearchService, bookSearchIndexService, userBehaviorLogService);
    }

    @Test
    void searchBooksReturnsHybridResponse() {
        BookSearchResponseDto responseDto = new BookSearchResponseDto("harry potter", SearchQueryIntent.KEYWORD,
                "hybrid-v1(exact-db+bm25)", false, 0, List.of());
        when(bookSearchService.searchBooks("harry potter", 8)).thenReturn(responseDto);

        var response = controller.searchBooks("harry potter", 8);

        assertTrue(response.getSuccess());
        assertEquals("Hybrid book search completed successfully.", response.getMessage());
        assertSame(responseDto, response.getBody());
        verify(bookSearchService).searchBooks("harry potter", 8);
        verify(userBehaviorLogService).recordSearch(org.mockito.ArgumentMatchers.any());
    }

    @Test
    void rebuildBookIndexReturnsIndexedCount() {
        when(bookSearchIndexService.rebuildBookIndex()).thenReturn(123L);

        var response = controller.rebuildBookIndex();

        assertTrue(response.getSuccess());
        assertEquals("Book search index rebuilt successfully.", response.getMessage());
        assertEquals(Map.of("indexedCount", 123L), response.getBody());
        verify(bookSearchIndexService).rebuildBookIndex();
    }
}
