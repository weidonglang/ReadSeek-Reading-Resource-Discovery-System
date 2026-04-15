package com.weidonglang.NewBookRecommendationSystem.controller;

import com.weidonglang.NewBookRecommendationSystem.dto.BookCategoryDto;
import com.weidonglang.NewBookRecommendationSystem.dto.BookDto;
import com.weidonglang.NewBookRecommendationSystem.dto.BookFilterPaginationRequest;
import com.weidonglang.NewBookRecommendationSystem.dto.BookRecommendationOverviewDto;
import com.weidonglang.NewBookRecommendationSystem.dto.BookRecommendationShelfDto;
import com.weidonglang.NewBookRecommendationSystem.dto.SearchLogRecordDto;
import com.weidonglang.NewBookRecommendationSystem.dto.UserBookRateDto;
import com.weidonglang.NewBookRecommendationSystem.dto.base.pagination.FilterPaginationRequest;
import com.weidonglang.NewBookRecommendationSystem.dto.base.pagination.SortingBy;
import com.weidonglang.NewBookRecommendationSystem.dto.base.pagination.SortingDirection;
import com.weidonglang.NewBookRecommendationSystem.dto.base.response.ApiResponse;
import com.weidonglang.NewBookRecommendationSystem.dto.base.response.PaginationResponse;
import com.weidonglang.NewBookRecommendationSystem.service.BookCategoryService;
import com.weidonglang.NewBookRecommendationSystem.service.BookService;
import com.weidonglang.NewBookRecommendationSystem.service.UserBehaviorLogService;
import com.weidonglang.NewBookRecommendationSystem.service.UserBookRateService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class BookControllerTest {

    @Mock
    private BookService bookService;

    @Mock
    private BookCategoryService bookCategoryService;

    @Mock
    private UserBookRateService userBookRateService;

    @Mock
    private UserBehaviorLogService userBehaviorLogService;

    private BookController controller;

    @BeforeEach
    void setUp() {
        controller = new BookController(bookService, bookCategoryService, userBookRateService, userBehaviorLogService);
    }

    @Test
    void testGetService() {
        assertSame(bookService, controller.getService());
    }

    @Test
    void testFindBookByBookId() {
        BookDto bookDto = new BookDto();
        bookDto.setId(5L);
        bookDto.setName("Domain-Driven Design");
        when(bookService.findById(5L)).thenReturn(bookDto);

        ApiResponse response = controller.findBookByBookId(5L);

        assertTrue(response.getSuccess());
        assertEquals("Book fetched successfully.", response.getMessage());
        assertSame(bookDto, response.getBody());
        assertNotNull(response.getTimestamp());
        verify(bookService).findById(5L);
        verify(userBehaviorLogService).recordBookDetailClick(5L, "direct", null);
    }

    @Test
    void testFindBookByBookIdWithSourceRecordsRecommendationClick() {
        BookDto bookDto = new BookDto();
        bookDto.setId(7L);
        when(bookService.findById(7L)).thenReturn(bookDto);

        ApiResponse response = controller.findBookByBookId(7L, "recommendation", "homepage");

        assertTrue(response.getSuccess());
        assertEquals("Book fetched successfully.", response.getMessage());
        assertSame(bookDto, response.getBody());
        verify(bookService).findById(7L);
        verify(userBehaviorLogService).recordRecommendationClick(7L, "recommendation", "homepage");
    }

    @Test
    void testFindAllRecommendBooks() {
        List<BookDto> books = List.of(new BookDto(), new BookDto());
        when(bookService.findAllRecommendedBooks()).thenReturn(books);

        ApiResponse response = controller.findAllRecommendBooks();

        assertTrue(response.getSuccess());
        assertEquals("Books recommended fetched successfully.", response.getMessage());
        assertSame(books, response.getBody());
        verify(bookService).findAllRecommendedBooks();
    }

    @Test
    void testFindPopularBooks() {
        List<BookDto> books = List.of(new BookDto());
        when(bookService.findPopularBooks(6, null)).thenReturn(books);

        ApiResponse response = controller.findPopularBooks(6, null);

        assertTrue(response.getSuccess());
        assertEquals("Popular books fetched successfully.", response.getMessage());
        assertSame(books, response.getBody());
        verify(bookService).findPopularBooks(6, null);
    }

    @Test
    void testFindRecommendationOverview() {
        BookRecommendationOverviewDto overview = new BookRecommendationOverviewDto("推荐书架", List.of(new BookRecommendationShelfDto()));
        when(bookService.findRecommendationOverview(null)).thenReturn(overview);

        ApiResponse response = controller.findRecommendationOverview(null);

        assertTrue(response.getSuccess());
        assertEquals("Recommendation overview fetched successfully.", response.getMessage());
        assertSame(overview, response.getBody());
        verify(bookService).findRecommendationOverview(null);
    }

    @Test
    void testFindSimilarBookRecommendations() {
        BookRecommendationOverviewDto overview = new BookRecommendationOverviewDto("相关图书", List.of());
        when(bookService.findBookSimilarityRecommendations(8L)).thenReturn(overview);

        ApiResponse response = controller.findSimilarBookRecommendations(8L);

        assertTrue(response.getSuccess());
        assertEquals("Similar book recommendations fetched successfully.", response.getMessage());
        assertSame(overview, response.getBody());
        verify(bookService).findBookSimilarityRecommendations(8L);
    }

    @Test
    void testFindAllBooksByAuthorId() {
        List<BookDto> books = List.of(new BookDto());
        when(bookService.findAllBooksByAuthorId(2L)).thenReturn(books);

        ApiResponse response = controller.findAllBooksByAuthorId(2L);

        assertTrue(response.getSuccess());
        assertEquals("Books of author fetched successfully.", response.getMessage());
        assertSame(books, response.getBody());
        verify(bookService).findAllBooksByAuthorId(2L);
    }

    @Test
    void testGetBookCategories() {
        List<BookCategoryDto> categories = List.of(new BookCategoryDto());
        when(bookCategoryService.findAll()).thenReturn(categories);

        ApiResponse response = controller.getBookCategories();

        assertTrue(response.getSuccess());
        assertEquals("Book categories fetched successfully.", response.getMessage());
        assertSame(categories, response.getBody());
        verify(bookCategoryService).findAll();
    }

    @Test
    void testFindAllBooksPaginatedAndFiltered() {
        BookFilterPaginationRequest criteria = new BookFilterPaginationRequest();
        criteria.setName("  Harry Potter  ");
        criteria.setCategories(Set.of(1L, 2L));
        FilterPaginationRequest<BookFilterPaginationRequest> request = new FilterPaginationRequest<>();
        request.setCriteria(criteria);
        request.setDeletedRecords(false);
        request.setSortingByList(List.of(new SortingBy("name", SortingDirection.ASC, false)));

        PaginationResponse<BookDto> paginationResponse = PaginationResponse.<BookDto>builder()
                .pageNumber(1)
                .pageSize(10)
                .totalNumberOfPages(1)
                .totalNumberOfElements(1)
                .result(List.of(new BookDto()))
                .isFirst(true)
                .isLast(true)
                .build();
        when(bookService.findAllBooksPaginatedAndFiltered(request)).thenReturn(paginationResponse);

        ApiResponse response = controller.findAllBooksPaginatedAndFiltered(request);

        assertTrue(response.getSuccess());
        assertEquals("Books paginated filtered fetched successfully.", response.getMessage());
        assertSame(paginationResponse, response.getBody());
        verify(bookService).findAllBooksPaginatedAndFiltered(request);

        ArgumentCaptor<SearchLogRecordDto> searchLogCaptor = ArgumentCaptor.forClass(SearchLogRecordDto.class);
        verify(userBehaviorLogService).recordSearch(searchLogCaptor.capture());
        SearchLogRecordDto searchLogRecordDto = searchLogCaptor.getValue();
        assertEquals("harry potter", searchLogRecordDto.getKeyword());
        assertEquals("book-search", searchLogRecordDto.getSource());
        assertTrue("1,2".equals(searchLogRecordDto.getCategoryIds()) || "2,1".equals(searchLogRecordDto.getCategoryIds()));
        assertEquals(1L, searchLogRecordDto.getResultCount());
        assertEquals("SortingBy(fieldName=name, direction=ASC, isNumber=false)", searchLogRecordDto.getSortBy());
    }

    @Test
    void testCreateBook() {
        BookDto bookDto = new BookDto();
        bookDto.setId(1L);
        when(bookService.create(bookDto)).thenReturn(bookDto);

        ApiResponse response = controller.createBook(bookDto);

        assertTrue(response.getSuccess());
        assertEquals("Book created successfully.", response.getMessage());
        assertSame(bookDto, response.getBody());
        verify(bookService).create(bookDto);
    }

    @Test
    void testCreateBooks() {
        List<BookDto> books = List.of(new BookDto(), new BookDto());
        when(bookService.create(books)).thenReturn(books);

        ApiResponse response = controller.createBooks(books);

        assertTrue(response.getSuccess());
        assertEquals("Books created successfully.", response.getMessage());
        assertSame(books, response.getBody());
        verify(bookService).create(books);
    }

    @Test
    void testRateBook() {
        UserBookRateDto rateDto = new UserBookRateDto();
        when(userBookRateService.rateBook(rateDto)).thenReturn(rateDto);

        ApiResponse response = controller.rateBook(rateDto);

        assertTrue(response.getSuccess());
        assertEquals("Book rated successfully.", response.getMessage());
        assertSame(rateDto, response.getBody());
        verify(userBookRateService).rateBook(rateDto);
    }

    @Test
    void testUpdateBook() {
        BookDto bookDto = new BookDto();
        bookDto.setId(12L);
        when(bookService.update(bookDto, 12L)).thenReturn(bookDto);

        ApiResponse response = controller.updateBook(bookDto);

        assertTrue(response.getSuccess());
        assertEquals("Book updated successfully.", response.getMessage());
        assertSame(bookDto, response.getBody());
        verify(bookService).update(bookDto, 12L);
    }

    @Test
    void testDeleteBook() {
        ApiResponse response = controller.deleteBook(13L);

        assertTrue(response.getSuccess());
        assertEquals("Book deleted successfully.", response.getMessage());
        assertEquals(true, response.getBody());
        verify(bookService).deleteById(13L);
    }
}
