package com.weidonglang.NewBookRecommendationSystem.dao;

import com.weidonglang.NewBookRecommendationSystem.dao.base.BaseDao;
import com.weidonglang.NewBookRecommendationSystem.dto.BookFilterPaginationRequest;
import com.weidonglang.NewBookRecommendationSystem.dto.base.pagination.FilterPaginationRequest;
import com.weidonglang.NewBookRecommendationSystem.entity.Book;
import com.weidonglang.NewBookRecommendationSystem.repository.BookRepository;
import org.springframework.data.domain.Page;

import java.util.List;
public interface BookDao extends BaseDao<Book, BookRepository> {
    List<Book> findAllBooksByAuthorId(Long authorId);

    List<Book> findAllBooksByCategoriesAndLimit(List<String> categories, Integer limit);

    Page<Book> findAllBooksPaginatedAndFiltered(FilterPaginationRequest<BookFilterPaginationRequest> bookFilterPaginationRequest);
}
/*
weidonglang
2026.3-2027.9
*/
