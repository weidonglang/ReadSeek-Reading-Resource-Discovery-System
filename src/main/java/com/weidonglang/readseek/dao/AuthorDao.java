package com.weidonglang.readseek.dao;

import com.weidonglang.readseek.dao.base.BaseDao;
import com.weidonglang.readseek.dto.AuthorFilterPaginationRequest;
import com.weidonglang.readseek.dto.base.pagination.FilterPaginationRequest;
import com.weidonglang.readseek.entity.Author;
import com.weidonglang.readseek.repository.AuthorRepository;
import org.springframework.data.domain.Page;
public interface AuthorDao extends BaseDao<Author, AuthorRepository> {
    Page<Author> findAllAuthorsPaginatedAndFiltered(FilterPaginationRequest<AuthorFilterPaginationRequest> authorFilterPaginationRequest);
}
/*
weidonglang
2026.3-2027.9
*/
