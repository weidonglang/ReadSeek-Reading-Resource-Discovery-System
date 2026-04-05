package com.weidonglang.NewBookRecommendationSystem.controller;

import com.weidonglang.NewBookRecommendationSystem.controller.base.BaseController;
import com.weidonglang.NewBookRecommendationSystem.dto.PublisherDto;
import com.weidonglang.NewBookRecommendationSystem.dto.base.response.ApiResponse;
import com.weidonglang.NewBookRecommendationSystem.service.PublisherService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
@Slf4j
@CrossOrigin
@RestController
@AllArgsConstructor
@RequestMapping("/api/publisher")
public class PublisherController implements BaseController<PublisherService> {
    private final PublisherService publisherService;

    @Override
    public PublisherService getService() {
        return publisherService;
    }

    @GetMapping
    public ApiResponse findAllPublishers() {
        log.info("PublisherController: findAllPublishers() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Publishers fetched successfully.", getService().findAllActive());
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse createPublisher(@RequestBody PublisherDto publisherDto) {
        log.info("PublisherController: createPublisher() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Publisher created successfully.", getService().create(publisherDto));
    }

    @PutMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse updatePublisher(@RequestBody PublisherDto publisherDto) {
        log.info("PublisherController: updatePublisher() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Publisher updated successfully.", getService().update(publisherDto, publisherDto.getId()));
    }

    @DeleteMapping("/{publisherId}")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse deletePublisher(@PathVariable Long publisherId) {
        log.info("PublisherController: deletePublisher() called");
        getService().deleteById(publisherId);
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Publisher deleted successfully.", true);
    }
}
/*
weidonglang
2026.3-2027.9
*/
