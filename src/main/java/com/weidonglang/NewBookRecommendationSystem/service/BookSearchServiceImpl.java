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
import org.springframework.data.domain.PageRequest;
import org.springframework.data.elasticsearch.client.elc.NativeQuery;
import org.springframework.data.elasticsearch.core.ElasticsearchOperations;
import org.springframework.data.elasticsearch.core.SearchHit;
import org.springframework.data.elasticsearch.core.SearchHits;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class BookSearchServiceImpl implements BookSearchService {
    private static final int DEFAULT_LIMIT = 10;

    private final SearchProperties searchProperties;
    private final BookRepository bookRepository;
    private final BookTransformer bookTransformer;
    private final ElasticsearchOperations elasticsearchOperations;
    private final SearchQueryIntentClassifier searchQueryIntentClassifier;
    private final SearchQueryExpander searchQueryExpander;
    private final VectorBookSearchService vectorBookSearchService;

    public BookSearchServiceImpl(SearchProperties searchProperties,
                                 BookRepository bookRepository,
                                 BookTransformer bookTransformer,
                                 ElasticsearchOperations elasticsearchOperations,
                                 SearchQueryIntentClassifier searchQueryIntentClassifier,
                                 SearchQueryExpander searchQueryExpander,
                                 VectorBookSearchService vectorBookSearchService) {
        this.searchProperties = searchProperties;
        this.bookRepository = bookRepository;
        this.bookTransformer = bookTransformer;
        this.elasticsearchOperations = elasticsearchOperations;
        this.searchQueryIntentClassifier = searchQueryIntentClassifier;
        this.searchQueryExpander = searchQueryExpander;
        this.vectorBookSearchService = vectorBookSearchService;
    }

    @Override
    public BookSearchResponseDto searchByBm25(String query, Integer limit) {
        String normalizedQuery = normalizeQuery(query);
        int normalizedLimit = normalizeLimit(limit);
        SearchQueryIntent intent = searchQueryIntentClassifier.classify(normalizedQuery);
        String expandedQuery = searchQueryExpander.expand(normalizedQuery, intent);
        List<BookSearchHitDto> hits = performBm25Search(expandedQuery, normalizedLimit);
        return new BookSearchResponseDto(
                normalizedQuery,
                intent,
                "bm25",
                false,
                hits.size(),
                hits
        );
    }

    @Override
    public BookSearchResponseDto searchBooks(String query, Integer limit) {
        String normalizedQuery = normalizeQuery(query);
        int normalizedLimit = normalizeLimit(limit);
        SearchQueryIntent intent = searchQueryIntentClassifier.classify(normalizedQuery);
        String expandedQuery = searchQueryExpander.expand(normalizedQuery, intent);

        LinkedHashMap<Long, BookSearchHitDto> mergedHits = new LinkedHashMap<>();
        List<BookSearchHitDto> exactHits = findExactMatches(
                searchQueryExpander.resolveExactCandidateQueries(normalizedQuery),
                normalizedLimit
        );
        exactHits.forEach(hit -> mergedHits.put(hit.getBook().getId(), hit));

        List<BookSearchHitDto> vectorHits = vectorBookSearchService.search(expandedQuery, normalizedLimit * 2);
        List<BookSearchHitDto> bm25Hits = performBm25Search(expandedQuery, normalizedLimit * 2);

        if (intent == SearchQueryIntent.NATURAL_LANGUAGE && !vectorHits.isEmpty()) {
            mergeHits(mergedHits, vectorHits, normalizedLimit);
            mergeHits(mergedHits, bm25Hits, normalizedLimit);
        } else {
            mergeHits(mergedHits, bm25Hits, normalizedLimit);
            mergeHits(mergedHits, vectorHits, normalizedLimit);
        }

        List<BookSearchHitDto> hits = new ArrayList<>(mergedHits.values());
        if (hits.size() > normalizedLimit) {
            hits = hits.subList(0, normalizedLimit);
        }

        boolean fallbackApplied = intent == SearchQueryIntent.EXACT_LOOKUP
                && exactHits.isEmpty()
                && (!bm25Hits.isEmpty() || !vectorHits.isEmpty());
        return new BookSearchResponseDto(
                normalizedQuery,
                intent,
                resolveHybridStrategy(intent, vectorHits),
                fallbackApplied,
                hits.size(),
                hits
        );
    }

    private void mergeHits(LinkedHashMap<Long, BookSearchHitDto> mergedHits,
                           List<BookSearchHitDto> candidateHits,
                           int limit) {
        for (BookSearchHitDto hit : candidateHits) {
            Long bookId = hit.getBook() == null ? null : hit.getBook().getId();
            if (bookId != null && !mergedHits.containsKey(bookId)) {
                mergedHits.put(bookId, hit);
            }
            if (mergedHits.size() >= limit) {
                return;
            }
        }
    }

    private String resolveHybridStrategy(SearchQueryIntent intent, List<BookSearchHitDto> vectorHits) {
        if (vectorHits == null || vectorHits.isEmpty()) {
            return "hybrid-v1(exact-db+bm25)";
        }
        if (intent == SearchQueryIntent.NATURAL_LANGUAGE) {
            return "hybrid-v2(exact-db+vector+bm25)";
        }
        return "hybrid-v2(exact-db+bm25+vector)";
    }

    private String normalizeQuery(String query) {
        if (query == null || query.trim().isBlank()) {
            throw new IllegalArgumentException("Search query cannot be blank.");
        }
        return query.trim();
    }

    private int normalizeLimit(Integer limit) {
        if (limit == null || limit < 1) {
            return Math.min(DEFAULT_LIMIT, searchProperties.getMaxResults());
        }
        return Math.min(limit, searchProperties.getMaxResults());
    }

    private List<BookSearchHitDto> findExactMatches(List<String> candidateQueries, int limit) {
        if (candidateQueries == null || candidateQueries.isEmpty()) {
            return List.of();
        }

        LinkedHashMap<Long, Book> exactBooks = new LinkedHashMap<>();
        for (String candidateQuery : candidateQueries) {
            List<Book> books = bookRepository.findExactMatches(candidateQuery, PageRequest.of(0, limit));
            for (Book book : books) {
                if (book != null && book.getId() != null && !exactBooks.containsKey(book.getId())) {
                    exactBooks.put(book.getId(), book);
                }
                if (exactBooks.size() >= limit) {
                    break;
                }
            }
            if (exactBooks.size() >= limit) {
                break;
            }
        }

        if (exactBooks.isEmpty()) {
            return List.of();
        }

        List<BookDto> bookDtos = bookTransformer.transformEntityToDto(new ArrayList<>(exactBooks.values()));
        List<BookSearchHitDto> hits = new ArrayList<>();
        for (BookDto bookDto : bookDtos) {
            hits.add(new BookSearchHitDto(
                    bookDto,
                    1000D,
                    "EXACT_DB",
                    "Exact match on title, author, or ISBN."
            ));
        }
        return hits;
    }

    private List<BookSearchHitDto> performBm25Search(String query, int limit) {
        if (!searchProperties.isEnabled()) {
            return List.of();
        }

        try {
            NativeQuery searchQuery = NativeQuery.builder()
                    .withQuery(q -> q.multiMatch(mm -> mm
                            .query(query)
                            .fields(
                                    "name^6",
                                    "isbn^8",
                                    "authorName^4",
                                    "categoryName^2",
                                    "publisherName^2",
                                    "tagNames^3",
                                    "description",
                                    "searchableText"
                            )
                            .fuzziness("AUTO")
                    ))
                    .withPageable(PageRequest.of(0, limit))
                    .build();

            SearchHits<BookSearchDocument> searchHits = elasticsearchOperations.search(searchQuery, BookSearchDocument.class);
            if (searchHits.isEmpty()) {
                return List.of();
            }

            List<Long> ids = searchHits.getSearchHits().stream()
                    .map(hit -> hit.getContent() == null ? null : hit.getContent().getId())
                    .filter(Objects::nonNull)
                    .collect(Collectors.toList());

            Map<Long, BookDto> booksById = bookTransformer.transformEntityToDto(bookRepository.findAllById(ids)).stream()
                    .collect(Collectors.toMap(BookDto::getId, Function.identity()));

            List<BookSearchHitDto> hits = new ArrayList<>();
            for (SearchHit<BookSearchDocument> searchHit : searchHits.getSearchHits()) {
                Long bookId = searchHit.getContent() == null ? null : searchHit.getContent().getId();
                BookDto bookDto = booksById.get(bookId);
                if (bookId != null && bookDto != null) {
                    hits.add(new BookSearchHitDto(
                            bookDto,
                            Double.valueOf(searchHit.getScore()),
                            "BM25",
                            "Keyword relevance from Elasticsearch BM25 ranking."
                    ));
                }
            }
            return hits;
        } catch (Exception exception) {
            return List.of();
        }
    }
}
