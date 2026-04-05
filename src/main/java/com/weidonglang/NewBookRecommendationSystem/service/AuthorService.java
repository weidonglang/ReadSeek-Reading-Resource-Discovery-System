package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.dao.AuthorDao;
import com.weidonglang.NewBookRecommendationSystem.dto.AuthorDto;
import com.weidonglang.NewBookRecommendationSystem.dto.AuthorFilterPaginationRequest;
import com.weidonglang.NewBookRecommendationSystem.dto.base.pagination.FilterPaginationRequest;
import com.weidonglang.NewBookRecommendationSystem.dto.base.response.PaginationResponse;
import com.weidonglang.NewBookRecommendationSystem.entity.Author;
import com.weidonglang.NewBookRecommendationSystem.service.base.BaseService;
import com.weidonglang.NewBookRecommendationSystem.transformer.AuthorTransformer;
public interface AuthorService extends BaseService<Author, AuthorDto, AuthorDao, AuthorTransformer> {
    PaginationResponse<AuthorDto> findAllAuthorsPaginatedAndFiltered(FilterPaginationRequest<AuthorFilterPaginationRequest> authorFilterPaginationRequest);
}
/*
weidonglang
2026.3-2027.9
*/
