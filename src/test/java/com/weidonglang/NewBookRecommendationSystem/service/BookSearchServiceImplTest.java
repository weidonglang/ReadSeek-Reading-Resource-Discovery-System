package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.config.SearchProperties;
import com.weidonglang.NewBookRecommendationSystem.dto.BookDto;
import com.weidonglang.NewBookRecommendationSystem.dto.BookSearchHitDto;
import com.weidonglang.NewBookRecommendationSystem.dto.BookSearchResponseDto;
import com.weidonglang.NewBookRecommendationSystem.entity.Book;
import com.weidonglang.NewBookRecommendationSystem.enums.SearchQueryIntent;
import com.weidonglang.NewBookRecommendationSystem.repository.BookRepository;
import com.weidonglang.NewBookRecommendationSystem.search.BookSearchDocument;
import com.weidonglang.NewBookRecommendationSystem.transformer.BookTransformer;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Pageable;
import org.springframework.data.elasticsearch.core.ElasticsearchOperations;
import org.springframework.data.elasticsearch.core.SearchHit;
import org.springframework.data.elasticsearch.core.SearchHits;
import org.springframework.data.elasticsearch.core.query.Query;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyIterable;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class BookSearchServiceImplTest {

    @Mock
    private BookRepository bookRepository;

    @Mock
    private BookTransformer bookTransformer;

    @Mock
    private ElasticsearchOperations elasticsearchOperations;

    @Mock
    private SearchQueryIntentClassifier searchQueryIntentClassifier;

    @Mock
    private SearchQueryExpander searchQueryExpander;

    @Mock
    private VectorBookSearchService vectorBookSearchService;

    private SearchProperties searchProperties;
    private BookSearchServiceImpl service;

    @BeforeEach
    void setUp() {
        searchProperties = new SearchProperties();
        searchProperties.setEnabled(true);
        searchProperties.setMaxResults(20);
        service = new BookSearchServiceImpl(
                searchProperties,
                bookRepository,
                bookTransformer,
                elasticsearchOperations,
                searchQueryIntentClassifier,
                searchQueryExpander,
                vectorBookSearchService
        );
    }

    @Test
    void searchBooksShouldPrioritizeVectorHitsForNaturalLanguageQueries() {
        String query = "find me a classic romance";
        BookDto vectorBook = buildBookDto(1L, "Vector Match");
        BookDto bm25Book = buildBookDto(2L, "BM25 Match");

        when(searchQueryIntentClassifier.classify(query)).thenReturn(SearchQueryIntent.NATURAL_LANGUAGE);
        when(searchQueryExpander.expand(query, SearchQueryIntent.NATURAL_LANGUAGE)).thenReturn("expanded classic romance");
        when(bookRepository.findExactMatches(eq(query), any(Pageable.class))).thenReturn(List.of());
        when(vectorBookSearchService.search(query, 10))
                .thenReturn(List.of(new BookSearchHitDto(vectorBook, 1.8D, "VECTOR", "Semantic similarity from vector search.")));
        mockBm25Result(2L, bm25Book, 0.91f);

        BookSearchResponseDto response = service.searchBooks(query, 5);

        assertEquals("hybrid-v2(exact-db+vector+bm25)", response.getStrategy());
        assertEquals(List.of(1L, 2L), response.getHits().stream().map(hit -> hit.getBook().getId()).toList());
    }

    @Test
    void searchBooksShouldKeepBm25AheadOfVectorForKeywordQueries() {
        String query = "pride and prejudice";
        BookDto vectorBook = buildBookDto(1L, "Vector Match");
        BookDto bm25Book = buildBookDto(2L, "BM25 Match");

        when(searchQueryIntentClassifier.classify(query)).thenReturn(SearchQueryIntent.KEYWORD);
        when(searchQueryExpander.expand(query, SearchQueryIntent.KEYWORD)).thenReturn(query);
        when(bookRepository.findExactMatches(eq(query), any(Pageable.class))).thenReturn(List.of());
        when(vectorBookSearchService.search(query, 10))
                .thenReturn(List.of(new BookSearchHitDto(vectorBook, 1.2D, "VECTOR", "Semantic similarity from vector search.")));
        mockBm25Result(2L, bm25Book, 1.04f);

        BookSearchResponseDto response = service.searchBooks(query, 5);

        assertEquals("hybrid-v2(exact-db+bm25+vector)", response.getStrategy());
        assertEquals(List.of(2L, 1L), response.getHits().stream().map(hit -> hit.getBook().getId()).toList());
    }

    private void mockBm25Result(Long bookId, BookDto bookDto, float score) {
        SearchHits<BookSearchDocument> searchHits = mock(SearchHits.class);
        SearchHit<BookSearchDocument> searchHit = mock(SearchHit.class);
        BookSearchDocument document = BookSearchDocument.builder()
                .id(bookId)
                .name(bookDto.getName())
                .build();
        Book bookEntity = new Book();
        bookEntity.setId(bookId);
        bookEntity.setName(bookDto.getName());

        when(searchHits.isEmpty()).thenReturn(false);
        when(searchHits.getSearchHits()).thenReturn(List.of(searchHit));
        when(searchHit.getContent()).thenReturn(document);
        when(searchHit.getScore()).thenReturn(score);
        when(elasticsearchOperations.search(any(Query.class), eq(BookSearchDocument.class))).thenReturn(searchHits);
        when(bookRepository.findAllById(anyIterable())).thenReturn(List.of(bookEntity));
        when(bookTransformer.transformEntityToDto(any(List.class))).thenReturn(List.of(bookDto));
    }

    private BookDto buildBookDto(Long id, String name) {
        BookDto bookDto = new BookDto();
        bookDto.setId(id);
        bookDto.setName(name);
        return bookDto;
    }
}
