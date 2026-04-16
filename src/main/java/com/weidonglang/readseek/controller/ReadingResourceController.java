package com.weidonglang.readseek.controller;

import com.weidonglang.readseek.dto.BookDto;
import com.weidonglang.readseek.dto.BookFilterPaginationRequest;
import com.weidonglang.readseek.dto.BookRecommendationOverviewDto;
import com.weidonglang.readseek.dto.SearchLogRecordDto;
import com.weidonglang.readseek.dto.UserBookRateDto;
import com.weidonglang.readseek.dto.base.pagination.FilterPaginationRequest;
import com.weidonglang.readseek.dto.base.response.ApiResponse;
import com.weidonglang.readseek.dto.base.response.PaginationResponse;
import com.weidonglang.readseek.service.BookCategoryService;
import com.weidonglang.readseek.service.BookService;
import com.weidonglang.readseek.service.UserBehaviorLogService;
import com.weidonglang.readseek.service.UserBookRateService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@CrossOrigin
@RestController
@RequestMapping("/api/resources")
public class ReadingResourceController {
    private final BookService bookService;
    private final BookCategoryService bookCategoryService;
    private final UserBookRateService userBookRateService;
    private final UserBehaviorLogService userBehaviorLogService;

    public ReadingResourceController(BookService bookService,
                                     BookCategoryService bookCategoryService,
                                     UserBookRateService userBookRateService,
                                     UserBehaviorLogService userBehaviorLogService) {
        this.bookService = bookService;
        this.bookCategoryService = bookCategoryService;
        this.userBookRateService = userBookRateService;
        this.userBehaviorLogService = userBehaviorLogService;
    }

    @GetMapping("/{resourceId}")
    public ApiResponse findResourceById(@PathVariable Long resourceId,
                                        @RequestParam(required = false) String source,
                                        @RequestParam(required = false) String reason) {
        log.info("ReadingResourceController: findResourceById() called");
        recordResourceClickBehavior(resourceId, source, reason);
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Reading resource fetched successfully.", bookService.findById(resourceId));
    }

    @PostMapping("/search")
    public ApiResponse findResourcesPaginatedAndFiltered(
            @RequestBody FilterPaginationRequest<BookFilterPaginationRequest> request) {
        log.info("ReadingResourceController: findResourcesPaginatedAndFiltered() called");
        PaginationResponse<BookDto> response = bookService.findAllBooksPaginatedAndFiltered(request);
        recordSearchBehavior(request, response);
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Reading resources fetched successfully.", response);
    }

    @GetMapping("/recommended")
    public ApiResponse findAllRecommendedResources() {
        log.info("ReadingResourceController: findAllRecommendedResources() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Recommended reading resources fetched successfully.", bookService.findAllRecommendedBooks());
    }

    @GetMapping("/recommendations/popular")
    public ApiResponse findPopularResources(@RequestParam(defaultValue = "8") Integer limit,
                                            @RequestParam(required = false) Integer recentDays) {
        log.info("ReadingResourceController: findPopularResources() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Popular reading resources fetched successfully.", bookService.findPopularBooks(limit, recentDays));
    }

    @GetMapping("/recommendations/overview")
    public ApiResponse findRecommendationOverview(@RequestParam(required = false) Integer recentDays) {
        log.info("ReadingResourceController: findRecommendationOverview() called");
        BookRecommendationOverviewDto overview = bookService.findRecommendationOverview(recentDays);
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Reading-resource recommendation overview fetched successfully.", overview);
    }

    @GetMapping("/recommendations/similar/{resourceId}")
    public ApiResponse findSimilarResourceRecommendations(@PathVariable Long resourceId) {
        log.info("ReadingResourceController: findSimilarResourceRecommendations() called");
        BookRecommendationOverviewDto overview = bookService.findBookSimilarityRecommendations(resourceId);
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Similar reading-resource recommendations fetched successfully.", overview);
    }

    @GetMapping("/authors/{authorId}")
    public ApiResponse findResourcesByAuthor(@PathVariable Long authorId) {
        log.info("ReadingResourceController: findResourcesByAuthor() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Reading resources by author fetched successfully.", bookService.findAllBooksByAuthorId(authorId));
    }

    @GetMapping("/categories")
    public ApiResponse findResourceCategories() {
        log.info("ReadingResourceController: findResourceCategories() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Reading resource categories fetched successfully.", bookCategoryService.findAll());
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse createResource(@RequestBody BookDto resourceDto) {
        log.info("ReadingResourceController: createResource() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Reading resource created successfully.", bookService.create(resourceDto));
    }

    @PostMapping("/batch")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse createResources(@RequestBody List<BookDto> resourceDtos) {
        log.info("ReadingResourceController: createResources() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Reading resources created successfully.", bookService.create(resourceDtos));
    }

    @PutMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse updateResource(@RequestBody BookDto resourceDto) {
        log.info("ReadingResourceController: updateResource() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Reading resource updated successfully.", bookService.update(resourceDto, resourceDto.getId()));
    }

    @DeleteMapping("/{resourceId}")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse deleteResource(@PathVariable Long resourceId) {
        log.info("ReadingResourceController: deleteResource() called");
        bookService.deleteById(resourceId);
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Reading resource deleted successfully.", true);
    }

    @PostMapping("/rate")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse rateResource(@RequestBody UserBookRateDto rateDto) {
        log.info("ReadingResourceController: rateResource() called");
        UserBookRateDto ratedResource = userBookRateService.rateBook(rateDto);
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Reading resource rated successfully.", ratedResource);
    }

    private void recordSearchBehavior(FilterPaginationRequest<BookFilterPaginationRequest> request,
                                      PaginationResponse<BookDto> response) {
        if (userBehaviorLogService == null || request == null) {
            return;
        }

        BookFilterPaginationRequest criteria = request.getCriteria();
        userBehaviorLogService.recordSearch(new SearchLogRecordDto(
                buildSearchKeyword(criteria),
                "resource-search",
                buildSearchReason(request, response),
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
                response == null ? null : response.getTotalNumberOfElements()
        ));
    }

    private String buildSearchKeyword(BookFilterPaginationRequest criteria) {
        if (criteria == null) {
            return "browse-resources";
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
        return "browse-resources";
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
        return joinedValues == null || joinedValues.isBlank() ? "filtered-resource-search" : prefix + ":" + joinedValues;
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
                                     PaginationResponse<BookDto> response) {
        BookFilterPaginationRequest criteria = request == null ? null : request.getCriteria();
        return String.format(
                "resource filters categories=%s authors=%s publishers=%s tags=%s ranges price=%s-%s pages=%s-%s duration=%s-%s sort=%s results=%s",
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
                response == null ? null : response.getTotalNumberOfElements()
        );
    }

    private void recordResourceClickBehavior(Long resourceId, String source, String reason) {
        if (userBehaviorLogService == null) {
            return;
        }
        String normalizedSource = source == null ? null : source.trim();
        if (normalizedSource == null || normalizedSource.isBlank()) {
            userBehaviorLogService.recordBookDetailClick(resourceId, "direct", reason);
            return;
        }
        userBehaviorLogService.recordRecommendationClick(resourceId, normalizedSource, reason);
    }
}
