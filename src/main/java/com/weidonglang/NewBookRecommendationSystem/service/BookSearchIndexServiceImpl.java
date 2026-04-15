package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.config.SearchProperties;
import com.weidonglang.NewBookRecommendationSystem.entity.Book;
import com.weidonglang.NewBookRecommendationSystem.repository.BookRepository;
import com.weidonglang.NewBookRecommendationSystem.search.BookSearchDocument;
import com.weidonglang.NewBookRecommendationSystem.search.BookSearchRepository;
import org.springframework.data.elasticsearch.core.ElasticsearchOperations;
import org.springframework.data.elasticsearch.core.IndexOperations;
import org.springframework.stereotype.Service;

import jakarta.persistence.EntityNotFoundException;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
public class BookSearchIndexServiceImpl implements BookSearchIndexService {
    private final SearchProperties searchProperties;
    private final BookRepository bookRepository;
    private final BookSearchRepository bookSearchRepository;
    private final ElasticsearchOperations elasticsearchOperations;
    private final EmbeddingProvider embeddingProvider;

    public BookSearchIndexServiceImpl(SearchProperties searchProperties,
                                      BookRepository bookRepository,
                                      BookSearchRepository bookSearchRepository,
                                      ElasticsearchOperations elasticsearchOperations,
                                      EmbeddingProvider embeddingProvider) {
        this.searchProperties = searchProperties;
        this.bookRepository = bookRepository;
        this.bookSearchRepository = bookSearchRepository;
        this.elasticsearchOperations = elasticsearchOperations;
        this.embeddingProvider = embeddingProvider;
    }

    @Override
    public long rebuildBookIndex() {
        if (!searchProperties.isEnabled()) {
            return 0L;
        }

        IndexOperations indexOperations = elasticsearchOperations.indexOps(BookSearchDocument.class);
        if (indexOperations.exists()) {
            indexOperations.delete();
        }
        indexOperations.create();
        indexOperations.putMapping(indexOperations.createMapping(BookSearchDocument.class));

        List<BookSearchDocument> documents = bookRepository.findAll().stream()
                .filter(book -> !Boolean.TRUE.equals(book.getMarkedAsDeleted()))
                .map(this::toDocument)
                .collect(Collectors.toList());

        if (documents.isEmpty()) {
            return 0L;
        }

        bookSearchRepository.saveAll(documents);
        return documents.size();
    }

    @Override
    public void indexBook(Long bookId) {
        if (!searchProperties.isEnabled()) {
            return;
        }
        ensureIndex();
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new EntityNotFoundException("Book not found for id: " + bookId));
        if (Boolean.TRUE.equals(book.getMarkedAsDeleted())) {
            bookSearchRepository.deleteById(bookId);
            return;
        }
        bookSearchRepository.save(toDocument(book));
    }

    private void ensureIndex() {
        IndexOperations indexOperations = elasticsearchOperations.indexOps(BookSearchDocument.class);
        if (!indexOperations.exists()) {
            indexOperations.create();
            indexOperations.putMapping(indexOperations.createMapping(BookSearchDocument.class));
        }
    }

    private BookSearchDocument toDocument(Book book) {
        List<String> tagNames = book.getTags() == null
                ? Collections.emptyList()
                : book.getTags().stream()
                .filter(Objects::nonNull)
                .map(tag -> tag.getName())
                .filter(Objects::nonNull)
                .map(String::trim)
                .filter(tagName -> !tagName.isBlank())
                .distinct()
                .collect(Collectors.toList());

        String searchableText = String.join(" ",
                safe(book.getName()),
                safe(book.getIsbn()),
                safe(book.getDescription()),
                book.getAuthor() == null ? "" : safe(book.getAuthor().getName()),
                book.getCategory() == null ? "" : safe(book.getCategory().getName()),
                book.getPublisher() == null ? "" : safe(book.getPublisher().getName()),
                String.join(" ", tagNames)
        ).trim();

        return BookSearchDocument.builder()
                .id(book.getId())
                .isbn(safe(book.getIsbn()))
                .name(safe(book.getName()))
                .description(safe(book.getDescription()))
                .authorName(book.getAuthor() == null ? "" : safe(book.getAuthor().getName()))
                .categoryName(book.getCategory() == null ? "" : safe(book.getCategory().getName()))
                .publisherName(book.getPublisher() == null ? "" : safe(book.getPublisher().getName()))
                .tagNames(tagNames)
                .searchableText(searchableText)
                .embedding(embeddingProvider.embedDocument(searchableText).orElse(null))
                .rate(book.getRate())
                .usersRateCount(book.getUsersRateCount())
                .availableCopies(book.getAvailableCopies())
                .build();
    }

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }
}
