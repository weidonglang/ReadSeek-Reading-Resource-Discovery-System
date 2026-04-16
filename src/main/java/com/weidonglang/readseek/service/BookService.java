package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dao.BookDao;
import com.weidonglang.readseek.dto.BookDto;
import com.weidonglang.readseek.dto.BookFilterPaginationRequest;
import com.weidonglang.readseek.dto.BookRecommendationOverviewDto;
import com.weidonglang.readseek.dto.base.pagination.FilterPaginationRequest;
import com.weidonglang.readseek.dto.base.response.PaginationResponse;
import com.weidonglang.readseek.entity.Book;
import com.weidonglang.readseek.service.base.BaseService;
import com.weidonglang.readseek.transformer.BookTransformer;

import java.util.List;
public interface BookService extends BaseService<Book, BookDto, BookDao, BookTransformer> {
    List<BookDto> findAllBooksByAuthorId(Long authorId);

    PaginationResponse<BookDto> findAllBooksPaginatedAndFiltered(FilterPaginationRequest<BookFilterPaginationRequest> bookFilterPaginationRequest);

    List<BookDto> findAllRecommendedBooks();

    default List<BookDto> findPopularBooks(Integer limit) {
        return findPopularBooks(limit, 30);
    }

    List<BookDto> findPopularBooks(Integer limit, Integer recentDays);

    default BookRecommendationOverviewDto findRecommendationOverview() {
        return findRecommendationOverview(30);
    }

    BookRecommendationOverviewDto findRecommendationOverview(Integer recentDays);

    BookRecommendationOverviewDto findBookSimilarityRecommendations(Long bookId);
}
/*
weidonglang
2026.3-2027.9
*/
