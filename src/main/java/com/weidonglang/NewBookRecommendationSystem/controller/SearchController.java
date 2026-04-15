package com.weidonglang.NewBookRecommendationSystem.controller;

import com.weidonglang.NewBookRecommendationSystem.dto.BookSearchResponseDto;
import com.weidonglang.NewBookRecommendationSystem.dto.SearchLogRecordDto;
import com.weidonglang.NewBookRecommendationSystem.dto.base.response.ApiResponse;
import com.weidonglang.NewBookRecommendationSystem.service.BookSearchIndexService;
import com.weidonglang.NewBookRecommendationSystem.service.BookSearchService;
import com.weidonglang.NewBookRecommendationSystem.service.UserBehaviorLogService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/search")
public class SearchController {
    private final BookSearchService bookSearchService;
    private final BookSearchIndexService bookSearchIndexService;
    private final UserBehaviorLogService userBehaviorLogService;

    @Autowired
    public SearchController(BookSearchService bookSearchService,
                            BookSearchIndexService bookSearchIndexService,
                            UserBehaviorLogService userBehaviorLogService) {
        this.bookSearchService = bookSearchService;
        this.bookSearchIndexService = bookSearchIndexService;
        this.userBehaviorLogService = userBehaviorLogService;
    }

    public SearchController(BookSearchService bookSearchService,
                            BookSearchIndexService bookSearchIndexService) {
        this(bookSearchService, bookSearchIndexService, null);
    }

    @GetMapping("/books/bm25")
    public ApiResponse searchBooksByBm25(@RequestParam("q") String query,
                                         @RequestParam(defaultValue = "10") Integer limit) {
        log.info("SearchController: searchBooksByBm25() called, q='{}', limit={}", query, limit);
        BookSearchResponseDto response = bookSearchService.searchByBm25(query, limit);
        recordSearch(query, limit, response, "search-api-bm25");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "BM25 book search completed successfully.", response);
    }

    @GetMapping("/books")
    public ApiResponse searchBooks(@RequestParam("q") String query,
                                   @RequestParam(defaultValue = "10") Integer limit) {
        log.info("SearchController: searchBooks() called, q='{}', limit={}", query, limit);
        BookSearchResponseDto response = bookSearchService.searchBooks(query, limit);
        recordSearch(query, limit, response, "search-api-hybrid");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Hybrid book search completed successfully.", response);
    }

    @PostMapping("/index/books/rebuild")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse rebuildBookIndex() {
        long indexedCount = bookSearchIndexService.rebuildBookIndex();
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Book search index rebuilt successfully.", Map.of("indexedCount", indexedCount));
    }

    @PostMapping("/index/books/{bookId}")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse indexBook(@PathVariable Long bookId) {
        bookSearchIndexService.indexBook(bookId);
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Book indexed successfully.", Map.of("bookId", bookId));
    }

    private void recordSearch(String query,
                              Integer limit,
                              BookSearchResponseDto response,
                              String source) {
        if (userBehaviorLogService == null || response == null) {
            return;
        }

        userBehaviorLogService.recordSearch(new SearchLogRecordDto(
                query,
                source,
                String.format("intent=%s strategy=%s fallback=%s hits=%s",
                        response.getQueryIntent(),
                        response.getStrategy(),
                        response.isFallbackApplied(),
                        response.getReturnedCount()),
                null, null, null, null,
                null, null, null, null, null, null,
                response.getStrategy(),
                1,
                limit,
                false,
                response.getReturnedCount() == null ? null : response.getReturnedCount().longValue()
        ));
    }
}
