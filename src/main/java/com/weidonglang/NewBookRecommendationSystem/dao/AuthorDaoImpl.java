package com.weidonglang.NewBookRecommendationSystem.dao;

import com.weidonglang.NewBookRecommendationSystem.dto.AuthorFilterPaginationRequest;
import com.weidonglang.NewBookRecommendationSystem.dto.base.pagination.FilterPaginationRequest;
import com.weidonglang.NewBookRecommendationSystem.entity.Author;
import com.weidonglang.NewBookRecommendationSystem.repository.AuthorRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Component;
@Component
public class AuthorDaoImpl implements AuthorDao {
    private final AuthorRepository authorRepository;

    public AuthorDaoImpl(AuthorRepository authorRepository) {
        this.authorRepository = authorRepository;
    }

    @Override
    public AuthorRepository getRepository() {
        return authorRepository;
    }

    @Override
    public Page<Author> findAllAuthorsPaginatedAndFiltered(FilterPaginationRequest<AuthorFilterPaginationRequest> authorFilterPaginationRequest) {
        PageRequest pageRequest = getPageRequest(authorFilterPaginationRequest);
        AuthorFilterPaginationRequest criteria = authorFilterPaginationRequest.getCriteria();
        if (criteria == null)
            return getRepository().findAll(pageRequest, authorFilterPaginationRequest.getDeletedRecords());
        return getRepository().findAllAuthorsPaginatedAndFiltered(criteria.getName(), authorFilterPaginationRequest.getDeletedRecords(), pageRequest);
    }

    private PageRequest getPageRequest(FilterPaginationRequest<AuthorFilterPaginationRequest> authorFilterPaginationRequest) {
        if (authorFilterPaginationRequest.getPageSize() == -1)
            authorFilterPaginationRequest.setPageSize(Integer.MAX_VALUE);
        return PageRequest.of(authorFilterPaginationRequest.getPageNumber() - 1, authorFilterPaginationRequest.getPageSize(), buildSort(authorFilterPaginationRequest, Author.class));
    }
}
/*
weidonglang
2026.3-2027.9
*/
