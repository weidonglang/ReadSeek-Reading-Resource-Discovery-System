package com.weidonglang.NewBookRecommendationSystem.controller;

import com.weidonglang.NewBookRecommendationSystem.controller.base.BaseController;
import com.weidonglang.NewBookRecommendationSystem.dto.BookDto;
import com.weidonglang.NewBookRecommendationSystem.dto.BookFilterPaginationRequest;
import com.weidonglang.NewBookRecommendationSystem.dto.BookRecommendationOverviewDto;
import com.weidonglang.NewBookRecommendationSystem.dto.UserBookRateDto;
import com.weidonglang.NewBookRecommendationSystem.dto.base.pagination.FilterPaginationRequest;
import com.weidonglang.NewBookRecommendationSystem.dto.base.response.ApiResponse;
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
    public ApiResponse findPopularBooks(@RequestParam(defaultValue = "8") Integer limit) {
        log.info("BookController: findPopularBooks() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Popular books fetched successfully.", getService().findPopularBooks(limit));
    }

    @GetMapping("/recommendations/overview")
    public ApiResponse findRecommendationOverview() {
        log.info("BookController: findRecommendationOverview() called");
        BookRecommendationOverviewDto overview = getService().findRecommendationOverview();
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
        recordSearchBehavior(bookFilterPaginationRequest);
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Books paginated filtered fetched successfully.", getService().findAllBooksPaginatedAndFiltered(bookFilterPaginationRequest));
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
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Book rated successfully.", userBookRateService.rateBook(userBookRateDto));
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

    private void recordSearchBehavior(FilterPaginationRequest<BookFilterPaginationRequest> request) {
        if (userBehaviorLogService == null || request == null) {
            return;
        }

        BookFilterPaginationRequest criteria = request.getCriteria();
        String keyword = buildSearchKeyword(criteria);
        String reason = String.format("filters categories=%s authors=%s publishers=%s tags=%s sort=%s",
                criteria == null ? null : criteria.getCategories(),
                criteria == null ? null : criteria.getAuthors(),
                criteria == null ? null : criteria.getPublishers(),
                criteria == null ? null : criteria.getTags(),
                request.getSortingByList());
        userBehaviorLogService.recordSearch(keyword, "book-search", reason);
    }

    private String buildSearchKeyword(BookFilterPaginationRequest criteria) {
        if (criteria == null) {
            return "browse-books";
        }

        if (criteria.getName() != null && !criteria.getName().isBlank()) {
            return criteria.getName().trim();
        }

        if (criteria.getAuthors() != null && !criteria.getAuthors().isEmpty()) {
            return joinCriteriaValues(criteria.getAuthors());
        }

        if (criteria.getCategories() != null && !criteria.getCategories().isEmpty()) {
            return joinCriteriaValues(criteria.getCategories());
        }

        if (criteria.getTags() != null && !criteria.getTags().isEmpty()) {
            return joinCriteriaValues(criteria.getTags());
        }

        if (criteria.getPublishers() != null && !criteria.getPublishers().isEmpty()) {
            return joinCriteriaValues(criteria.getPublishers());
        }

        return "browse-books";
    }

    private String joinCriteriaValues(Collection<?> values) {
        return values.stream()
                .map(String::valueOf)
                .collect(Collectors.joining(","));
    }

    private void recordBookClickBehavior(Long bookId, String source, String reason) {
        if (userBehaviorLogService == null) {
            return;
        }
        if (source != null && !source.isBlank()) {
            return;
        }
        userBehaviorLogService.recordBookDetailClick(bookId, source == null ? "direct" : source, reason);
    }
}
/*
weidonglang
2026.3-2027.9
*/
