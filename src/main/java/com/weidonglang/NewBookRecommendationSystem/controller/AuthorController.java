package com.weidonglang.NewBookRecommendationSystem.controller;

import com.weidonglang.NewBookRecommendationSystem.controller.base.BaseController;
import com.weidonglang.NewBookRecommendationSystem.dto.AuthorDto;
import com.weidonglang.NewBookRecommendationSystem.dto.AuthorFilterPaginationRequest;
import com.weidonglang.NewBookRecommendationSystem.dto.base.pagination.FilterPaginationRequest;
import com.weidonglang.NewBookRecommendationSystem.dto.base.response.ApiResponse;
import com.weidonglang.NewBookRecommendationSystem.service.AuthorService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
@Slf4j
@CrossOrigin
@RestController
@AllArgsConstructor
@RequestMapping("/api/author")
public class AuthorController implements BaseController<AuthorService> {
    private final AuthorService authorService;

    @Override
    public AuthorService getService() {
        return authorService;
    }

    @GetMapping("/find-by-id/{authorId}")
    public ApiResponse findAuthorByAuthorId(@PathVariable Long authorId) {
        log.info("AuthorController: findAuthorByAuthorId() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Author fetched successfully.", getService().findById(authorId));
    }

    @PostMapping("/find-all-paginated-filtered")
    public ApiResponse findAllAuthorsPaginatedAndFiltered(@RequestBody FilterPaginationRequest<AuthorFilterPaginationRequest> authorFilterPaginationRequest) {
        log.info("AuthorController: findAllAuthorsPaginatedAndFiltered() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Authors paginated filtered fetched successfully.", getService().findAllAuthorsPaginatedAndFiltered(authorFilterPaginationRequest));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse createAuthor(@RequestBody AuthorDto authorDto) {
        log.info("AuthorController: createAuthor() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Author created successfully.", getService().create(authorDto));
    }

    @PostMapping("/create-list")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse createAuthors(@RequestBody List<AuthorDto> authorDtos) {
        log.info("AuthorController: createAuthors() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Authors created successfully.", getService().create(authorDtos));
    }

    @PutMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse updateAuthor(@RequestBody AuthorDto authorDto) {
        log.info("AuthorController: updateAuthor() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Author updated successfully.", getService().update(authorDto, authorDto.getId()));
    }

    @DeleteMapping("/{authorId}")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse deleteAuthor(@PathVariable Long authorId) {
        log.info("AuthorController: deleteAuthor() called");
        getService().deleteById(authorId);
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Author deleted successfully.", true);
    }
}
/*
weidonglang
2026.3-2027.9
*/
