package com.weidonglang.NewBookRecommendationSystem.dao;

import com.weidonglang.NewBookRecommendationSystem.dao.base.BaseDao;
import com.weidonglang.NewBookRecommendationSystem.dto.AuthorFilterPaginationRequest;
import com.weidonglang.NewBookRecommendationSystem.dto.base.pagination.FilterPaginationRequest;
import com.weidonglang.NewBookRecommendationSystem.entity.Author;
import com.weidonglang.NewBookRecommendationSystem.repository.AuthorRepository;
import org.springframework.data.domain.Page;
public interface AuthorDao extends BaseDao<Author, AuthorRepository> {
    Page<Author> findAllAuthorsPaginatedAndFiltered(FilterPaginationRequest<AuthorFilterPaginationRequest> authorFilterPaginationRequest);
}
/*
weidonglang
2026.3-2027.9
*/
