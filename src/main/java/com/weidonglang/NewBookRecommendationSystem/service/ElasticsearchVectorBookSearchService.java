package com.weidonglang.NewBookRecommendationSystem.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.weidonglang.NewBookRecommendationSystem.config.SearchProperties;
import com.weidonglang.NewBookRecommendationSystem.dto.BookDto;
import com.weidonglang.NewBookRecommendationSystem.dto.BookSearchHitDto;
import com.weidonglang.NewBookRecommendationSystem.repository.BookRepository;
import com.weidonglang.NewBookRecommendationSystem.search.BookSearchDocument;
import com.weidonglang.NewBookRecommendationSystem.transformer.BookTransformer;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.elasticsearch.core.ElasticsearchOperations;
import org.springframework.data.elasticsearch.core.SearchHit;
import org.springframework.data.elasticsearch.core.SearchHits;
import org.springframework.data.elasticsearch.core.query.StringQuery;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.function.Function;
import java.util.stream.Collectors;

@Slf4j
@Service
public class ElasticsearchVectorBookSearchService implements VectorBookSearchService {
    private static final String EMBEDDING_FIELD = "embedding";

    private final SearchProperties searchProperties;
    private final EmbeddingProvider embeddingProvider;
    private final ElasticsearchOperations elasticsearchOperations;
    private final BookRepository bookRepository;
    private final BookTransformer bookTransformer;
    private final ObjectMapper objectMapper;

    public ElasticsearchVectorBookSearchService(SearchProperties searchProperties,
                                                EmbeddingProvider embeddingProvider,
                                                ElasticsearchOperations elasticsearchOperations,
                                                BookRepository bookRepository,
                                                BookTransformer bookTransformer,
                                                ObjectMapper objectMapper) {
        this.searchProperties = searchProperties;
        this.embeddingProvider = embeddingProvider;
        this.elasticsearchOperations = elasticsearchOperations;
        this.bookRepository = bookRepository;
        this.bookTransformer = bookTransformer;
        this.objectMapper = objectMapper;
    }

    @Override
    public List<BookSearchHitDto> search(String query, Integer limit) {
        if (!isAvailable()) {
            return List.of();
        }

        int normalizedLimit = normalizeLimit(limit);
        return embeddingProvider.embedQuery(query)
                .map(embedding -> performVectorSearch(embedding, normalizedLimit))
                .orElse(List.of());
    }

    @Override
    public boolean isAvailable() {
        return searchProperties.isEnabled()
                && searchProperties.getVector().isEnabled()
                && embeddingProvider.isEnabled();
    }

    private List<BookSearchHitDto> performVectorSearch(List<Float> queryVector, int limit) {
        try {
            String vectorJson = objectMapper.writeValueAsString(queryVector);
            String queryJson = """
                    {
                      "script_score": {
                        "query": {
                          "exists": {
                            "field": "%s"
                          }
                        },
                        "script": {
                          "source": "cosineSimilarity(params.queryVector, '%s') + 1.0",
                          "params": {
                            "queryVector": %s
                          }
                        }
                      }
                    }
                    """.formatted(EMBEDDING_FIELD, EMBEDDING_FIELD, vectorJson);

            StringQuery vectorQuery = new StringQuery(queryJson);
            vectorQuery.setPageable(PageRequest.of(0, limit));
            SearchHits<BookSearchDocument> searchHits = elasticsearchOperations.search(vectorQuery, BookSearchDocument.class);
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
            for (SearchHit<BookSearchDocument> hit : searchHits.getSearchHits()) {
                Long bookId = hit.getContent() == null ? null : hit.getContent().getId();
                BookDto bookDto = booksById.get(bookId);
                if (bookId != null && bookDto != null && hit.getScore() >= searchProperties.getVector().getMinScore()) {
                    hits.add(new BookSearchHitDto(
                            bookDto,
                            Double.valueOf(hit.getScore()),
                            "VECTOR",
                            "Semantic similarity from vector search."
                    ));
                }
            }
            return hits;
        } catch (Exception exception) {
            log.debug("ElasticsearchVectorBookSearchService: vector search skipped because {}", exception.getMessage());
            return List.of();
        }
    }

    private int normalizeLimit(Integer limit) {
        if (limit == null || limit < 1) {
            return searchProperties.getVector().getCandidateLimit();
        }
        return Math.min(limit, searchProperties.getVector().getCandidateLimit());
    }
}
