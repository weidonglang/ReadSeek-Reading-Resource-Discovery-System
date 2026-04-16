package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dao.AuthorDao;
import com.weidonglang.readseek.dto.AuthorDto;
import com.weidonglang.readseek.dto.AuthorFilterPaginationRequest;
import com.weidonglang.readseek.dto.base.pagination.FilterPaginationRequest;
import com.weidonglang.readseek.dto.base.response.PaginationResponse;
import com.weidonglang.readseek.entity.Author;
import com.weidonglang.readseek.service.base.BaseService;
import com.weidonglang.readseek.transformer.AuthorTransformer;
public interface AuthorService extends BaseService<Author, AuthorDto, AuthorDao, AuthorTransformer> {
    PaginationResponse<AuthorDto> findAllAuthorsPaginatedAndFiltered(FilterPaginationRequest<AuthorFilterPaginationRequest> authorFilterPaginationRequest);
}
/*
weidonglang
2026.3-2027.9
*/
