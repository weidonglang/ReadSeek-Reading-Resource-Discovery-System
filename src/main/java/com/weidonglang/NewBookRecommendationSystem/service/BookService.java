package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.dao.BookDao;
import com.weidonglang.NewBookRecommendationSystem.dto.BookDto;
import com.weidonglang.NewBookRecommendationSystem.dto.BookFilterPaginationRequest;
import com.weidonglang.NewBookRecommendationSystem.dto.BookRecommendationOverviewDto;
import com.weidonglang.NewBookRecommendationSystem.dto.base.pagination.FilterPaginationRequest;
import com.weidonglang.NewBookRecommendationSystem.dto.base.response.PaginationResponse;
import com.weidonglang.NewBookRecommendationSystem.entity.Book;
import com.weidonglang.NewBookRecommendationSystem.service.base.BaseService;
import com.weidonglang.NewBookRecommendationSystem.transformer.BookTransformer;

import java.util.List;
public interface BookService extends BaseService<Book, BookDto, BookDao, BookTransformer> {
    List<BookDto> findAllBooksByAuthorId(Long authorId);

    PaginationResponse<BookDto> findAllBooksPaginatedAndFiltered(FilterPaginationRequest<BookFilterPaginationRequest> bookFilterPaginationRequest);

    List<BookDto> findAllRecommendedBooks();

    List<BookDto> findPopularBooks(Integer limit);

    BookRecommendationOverviewDto findRecommendationOverview();

    BookRecommendationOverviewDto findBookSimilarityRecommendations(Long bookId);
}
/*
weidonglang
2026.3-2027.9
*/
