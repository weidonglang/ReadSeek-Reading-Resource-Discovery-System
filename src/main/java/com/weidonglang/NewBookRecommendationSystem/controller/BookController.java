package com.weidonglang.NewBookRecommendationSystem.controller;

import com.weidonglang.NewBookRecommendationSystem.controller.base.BaseController;
import com.weidonglang.NewBookRecommendationSystem.dto.BookDto;
import com.weidonglang.NewBookRecommendationSystem.dto.BookFilterPaginationRequest;
import com.weidonglang.NewBookRecommendationSystem.dto.BookRecommendationOverviewDto;
import com.weidonglang.NewBookRecommendationSystem.dto.SearchLogRecordDto;
import com.weidonglang.NewBookRecommendationSystem.dto.UserBookRateDto;
import com.weidonglang.NewBookRecommendationSystem.dto.base.pagination.FilterPaginationRequest;
import com.weidonglang.NewBookRecommendationSystem.dto.base.response.ApiResponse;
import com.weidonglang.NewBookRecommendationSystem.dto.base.response.PaginationResponse;
import com.weidonglang.NewBookRecommendationSystem.service.BookCategoryService;
import com.weidonglang.NewBookRecommendationSystem.service.BookService;
import com.weidonglang.NewBookRecommendationSystem.service.UserBehaviorLogService;
import com.weidonglang.NewBookRecommendationSystem.service.UserBookRateService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;
@Slf4j
@CrossOrigin
@RestController
@RequestMapping("/api/book")
public class BookController implements BaseController<BookService> {
    private final BookService bookService;
    private final BookCategoryService bookCategoryService;
    private final UserBookRateService userBookRateService;
    private final UserBehaviorLogService userBehaviorLogService;

    @Autowired
    public BookController(BookService bookService,
                          BookCategoryService bookCategoryService,
                          UserBookRateService userBookRateService,
                          UserBehaviorLogService userBehaviorLogService) {
        this.bookService = bookService;
        this.bookCategoryService = bookCategoryService;
        this.userBookRateService = userBookRateService;
        this.userBehaviorLogService = userBehaviorLogService;
    }

    public BookController(BookService bookService,
                          BookCategoryService bookCategoryService,
                          UserBookRateService userBookRateService) {
        this(bookService, bookCategoryService, userBookRateService, null);
    }

    @Override
    public BookService getService() {
        return bookService;
    }

    @GetMapping("/find-by-id/{bookId}")
    public ApiResponse findBookByBookId(@PathVariable Long bookId) {
        return findBookByBookId(bookId, null, null);
    }

    @GetMapping(value = "/find-by-id/{bookId}", params = {"source"})
    public ApiResponse findBookByBookId(@PathVariable Long bookId,
                                        @RequestParam(required = false) String source,
                                        @RequestParam(required = false) String reason) {
        log.info("BookController: findBookByBookId() called");
        recordBookClickBehavior(bookId, source, reason);
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Book fetched successfully.", getService().findById(bookId));
    }

    @GetMapping("find-all-recommended")
    public ApiResponse findAllRecommendBooks() {
        log.info("BookController: getBookCategories() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Books recommended fetched successfully.", getService().findAllRecommendedBooks());
    }

    @GetMapping("/recommendations/popular")
    public ApiResponse findPopularBooks(@RequestParam(defaultValue = "8") Integer limit,
                                        @RequestParam(required = false) Integer recentDays) {
        log.info("BookController: findPopularBooks() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Popular books fetched successfully.", getService().findPopularBooks(limit, recentDays));
    }

    @GetMapping("/recommendations/overview")
    public ApiResponse findRecommendationOverview(@RequestParam(required = false) Integer recentDays) {
        log.info("BookController: findRecommendationOverview() called");
        BookRecommendationOverviewDto overview = getService().findRecommendationOverview(recentDays);
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Recommendation overview fetched successfully.", overview);
    }

    @GetMapping("/recommendations/similar/{bookId}")
    public ApiResponse findSimilarBookRecommendations(@PathVariable Long bookId) {
        log.info("BookController: findSimilarBookRecommendations() called");
        BookRecommendationOverviewDto overview = getService().findBookSimilarityRecommendations(bookId);
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Similar book recommendations fetched successfully.", overview);
    }

    @GetMapping("/find-all-by-author-id/{authorId}")
    public ApiResponse findAllBooksByAuthorId(@PathVariable Long authorId) {
        log.info("BookController: findAllBooksByAuthorId() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Books of author fetched successfully.", getService().findAllBooksByAuthorId(authorId));
    }

    @GetMapping("/find-all-categories")
    public ApiResponse getBookCategories() {
        log.info("BookController: getBookCategories() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Book categories fetched successfully.", bookCategoryService.findAll());
    }

    @PostMapping("/find-all-paginated-filtered")
    public ApiResponse findAllBooksPaginatedAndFiltered(@RequestBody FilterPaginationRequest<BookFilterPaginationRequest> bookFilterPaginationRequest) {
        log.info("BookController: findAllBooksPaginatedAndFiltered() called");
        PaginationResponse<BookDto> paginationResponse = getService().findAllBooksPaginatedAndFiltered(bookFilterPaginationRequest);
        recordSearchBehavior(bookFilterPaginationRequest, paginationResponse);
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Books paginated filtered fetched successfully.", paginationResponse);
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse createBook(@RequestBody BookDto bookDto) {
        log.info("BookController: createBook() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Book created successfully.", getService().create(bookDto));
    }

    @PostMapping("/create-list")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse createBooks(@RequestBody List<BookDto> bookDtos) {
        log.info("BookController: createBooks() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Books created successfully.", getService().create(bookDtos));
    }

    @PostMapping("/rate")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse rateBook(@RequestBody UserBookRateDto userBookRateDto) {
        log.info("BookController: rateBook() called");
        UserBookRateDto ratedBook = userBookRateService.rateBook(userBookRateDto);
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Book rated successfully.", ratedBook);
    }

    @PutMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse updateBook(@RequestBody BookDto bookDto) {
        log.info("BookController: updateBook() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Book updated successfully.", getService().update(bookDto, bookDto.getId()));
    }

    @DeleteMapping("/{bookId}")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse deleteBook(@PathVariable Long bookId) {
        log.info("BookController: deleteBook() called");
        getService().deleteById(bookId);
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Book deleted successfully.", true);
    }

    private void recordSearchBehavior(FilterPaginationRequest<BookFilterPaginationRequest> request,
                                      PaginationResponse<BookDto> paginationResponse) {
        if (userBehaviorLogService == null || request == null) {
            return;
        }

        BookFilterPaginationRequest criteria = request.getCriteria();
        userBehaviorLogService.recordSearch(new SearchLogRecordDto(
                buildSearchKeyword(criteria),
                "book-search",
                buildSearchReason(request, paginationResponse),
                joinCriteriaValues(criteria == null ? null : criteria.getCategories()),
                joinCriteriaValues(criteria == null ? null : criteria.getAuthors()),
                joinCriteriaValues(criteria == null ? null : criteria.getPublishers()),
                joinCriteriaValues(criteria == null ? null : criteria.getTags()),
                criteria == null ? null : criteria.getFromPrice(),
                criteria == null ? null : criteria.getToPrice(),
                criteria == null ? null : criteria.getFromPagesNumber(),
                criteria == null ? null : criteria.getToPagesNumber(),
                criteria == null ? null : criteria.getFromReadingDuration(),
                criteria == null ? null : criteria.getToReadingDuration(),
                stringifySorts(request),
                request.getPageNumber(),
                request.getPageSize(),
                request.getDeletedRecords(),
                paginationResponse == null ? null : paginationResponse.getTotalNumberOfElements()
        ));
    }

    private String buildSearchKeyword(BookFilterPaginationRequest criteria) {
        if (criteria == null) {
            return "browse-books";
        }

        if (criteria.getName() != null && !criteria.getName().isBlank()) {
            return criteria.getName().trim();
        }

        if (criteria.getAuthors() != null && !criteria.getAuthors().isEmpty()) {
            return buildFilterKeyword("author", criteria.getAuthors());
        }

        if (criteria.getCategories() != null && !criteria.getCategories().isEmpty()) {
            return buildFilterKeyword("category", criteria.getCategories());
        }

        if (criteria.getTags() != null && !criteria.getTags().isEmpty()) {
            return buildFilterKeyword("tag", criteria.getTags());
        }

        if (criteria.getPublishers() != null && !criteria.getPublishers().isEmpty()) {
            return buildFilterKeyword("publisher", criteria.getPublishers());
        }

        if (criteria.getFromPrice() != null || criteria.getToPrice() != null
                || criteria.getFromPagesNumber() != null || criteria.getToPagesNumber() != null
                || criteria.getFromReadingDuration() != null || criteria.getToReadingDuration() != null) {
            return "filtered-search";
        }

        return "browse-books";
    }

    private String joinCriteriaValues(Collection<?> values) {
        if (values == null || values.isEmpty()) {
            return null;
        }
        return values.stream()
                .map(String::valueOf)
                .collect(Collectors.joining(","));
    }

    private String buildFilterKeyword(String prefix, Collection<?> values) {
        String joinedValues = joinCriteriaValues(values);
        if (joinedValues == null || joinedValues.isBlank()) {
            return "filtered-search";
        }
        return prefix + ":" + joinedValues;
    }

    private String stringifySorts(FilterPaginationRequest<BookFilterPaginationRequest> request) {
        if (request == null || request.getSortingByList() == null || request.getSortingByList().isEmpty()) {
            return null;
        }
        return request.getSortingByList().stream()
                .map(String::valueOf)
                .collect(Collectors.joining(" | "));
    }

    private String buildSearchReason(FilterPaginationRequest<BookFilterPaginationRequest> request,
                                     PaginationResponse<BookDto> paginationResponse) {
        BookFilterPaginationRequest criteria = request == null ? null : request.getCriteria();
        return String.format(
                "filters categories=%s authors=%s publishers=%s tags=%s ranges price=%s-%s pages=%s-%s duration=%s-%s sort=%s results=%s",
                criteria == null ? null : criteria.getCategories(),
                criteria == null ? null : criteria.getAuthors(),
                criteria == null ? null : criteria.getPublishers(),
                criteria == null ? null : criteria.getTags(),
                criteria == null ? null : criteria.getFromPrice(),
                criteria == null ? null : criteria.getToPrice(),
                criteria == null ? null : criteria.getFromPagesNumber(),
                criteria == null ? null : criteria.getToPagesNumber(),
                criteria == null ? null : criteria.getFromReadingDuration(),
                criteria == null ? null : criteria.getToReadingDuration(),
                stringifySorts(request),
                paginationResponse == null ? null : paginationResponse.getTotalNumberOfElements()
        );
    }

    private void recordBookClickBehavior(Long bookId, String source, String reason) {
        if (userBehaviorLogService == null) {
            return;
        }
        String normalizedSource = source == null ? null : source.trim();
        if (normalizedSource == null || normalizedSource.isBlank()) {
            userBehaviorLogService.recordBookDetailClick(bookId, "direct", reason);
            return;
        }
        userBehaviorLogService.recordRecommendationClick(bookId, normalizedSource, reason);
    }
}
/*
weidonglang
2026.3-2027.9
*/
