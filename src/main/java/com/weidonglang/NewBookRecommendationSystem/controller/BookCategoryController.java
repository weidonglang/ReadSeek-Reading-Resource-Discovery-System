package com.weidonglang.NewBookRecommendationSystem.controller;

import com.weidonglang.NewBookRecommendationSystem.controller.base.BaseController;
import com.weidonglang.NewBookRecommendationSystem.dto.BookCategoryDto;
import com.weidonglang.NewBookRecommendationSystem.dto.base.response.ApiResponse;
import com.weidonglang.NewBookRecommendationSystem.service.BookCategoryService;
import lombok.AllArgsConstructor;
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
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
@Slf4j
@CrossOrigin
@RestController
@AllArgsConstructor
@RequestMapping("/api/category")
public class BookCategoryController implements BaseController<BookCategoryService> {
    private final BookCategoryService bookCategoryService;

    @Override
    public BookCategoryService getService() {
        return bookCategoryService;
    }

    @GetMapping
    public ApiResponse findAllCategories() {
        log.info("BookCategoryController: findAllCategories() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Book categories fetched successfully.", getService().findAll());
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse createCategory(@RequestBody BookCategoryDto bookCategoryDto) {
        log.info("BookCategoryController: createCategory() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Book category created successfully.", getService().create(bookCategoryDto));
    }

    @PutMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse updateCategory(@RequestBody BookCategoryDto bookCategoryDto) {
        log.info("BookCategoryController: updateCategory() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Book category updated successfully.", getService().update(bookCategoryDto, bookCategoryDto.getId()));
    }

    @DeleteMapping("/{categoryId}")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse deleteCategory(@PathVariable Long categoryId) {
        log.info("BookCategoryController: deleteCategory() called");
        getService().deleteById(categoryId);
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Book category deleted successfully.", true);
    }
}
/*
weidonglang
2026.3-2027.9
*/
