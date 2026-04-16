package com.weidonglang.readseek.dao;

import com.weidonglang.readseek.dao.base.BaseDao;
import com.weidonglang.readseek.dto.BookFilterPaginationRequest;
import com.weidonglang.readseek.dto.base.pagination.FilterPaginationRequest;
import com.weidonglang.readseek.entity.Book;
import com.weidonglang.readseek.repository.BookRepository;
import org.springframework.data.domain.Page;

import java.util.List;
import java.util.Optional;
public interface BookDao extends BaseDao<Book, BookRepository> {
    Optional<Book> findByIdForUpdate(Long id);

    List<Book> findAllBooksByAuthorId(Long authorId);

    List<Book> findAllBooksByCategoriesAndLimit(List<String> categories, Integer limit);

    Page<Book> findAllBooksPaginatedAndFiltered(FilterPaginationRequest<BookFilterPaginationRequest> bookFilterPaginationRequest);
}
/*
weidonglang
2026.3-2027.9
*/
