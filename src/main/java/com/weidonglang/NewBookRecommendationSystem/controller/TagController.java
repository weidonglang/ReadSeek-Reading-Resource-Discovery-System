package com.weidonglang.NewBookRecommendationSystem.controller;

import com.weidonglang.NewBookRecommendationSystem.controller.base.BaseController;
import com.weidonglang.NewBookRecommendationSystem.dto.TagDto;
import com.weidonglang.NewBookRecommendationSystem.dto.base.response.ApiResponse;
import com.weidonglang.NewBookRecommendationSystem.service.TagService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
@Slf4j
@CrossOrigin
@RestController
@AllArgsConstructor
@RequestMapping("/api/tag")
public class TagController implements BaseController<TagService> {
    private final TagService tagService;

    @Override
    public TagService getService() {
        return tagService;
    }

    @GetMapping
    public ApiResponse findAllTags() {
        log.info("TagController: findAllTags() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Tags fetched successfully.", getService().findAllActive());
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse createTag(@RequestBody TagDto tagDto) {
        log.info("TagController: createTag() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Tag created successfully.", getService().create(tagDto));
    }

    @PutMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse updateTag(@RequestBody TagDto tagDto) {
        log.info("TagController: updateTag() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Tag updated successfully.", getService().update(tagDto, tagDto.getId()));
    }

    @DeleteMapping("/{tagId}")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse deleteTag(@PathVariable Long tagId) {
        log.info("TagController: deleteTag() called");
        getService().deleteById(tagId);
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Tag deleted successfully.", true);
    }
}
/*
weidonglang
2026.3-2027.9
*/
