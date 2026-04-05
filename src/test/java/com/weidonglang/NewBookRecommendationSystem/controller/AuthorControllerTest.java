package com.weidonglang.NewBookRecommendationSystem.controller;

import com.weidonglang.NewBookRecommendationSystem.dto.AuthorDto;
import com.weidonglang.NewBookRecommendationSystem.dto.AuthorFilterPaginationRequest;
import com.weidonglang.NewBookRecommendationSystem.dto.base.response.ApiResponse;
import com.weidonglang.NewBookRecommendationSystem.dto.base.response.PaginationResponse;
import com.weidonglang.NewBookRecommendationSystem.service.AuthorService;
import com.weidonglang.NewBookRecommendationSystem.dto.base.pagination.FilterPaginationRequest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AuthorControllerTest {

    @Mock
    private AuthorService authorService;

    private AuthorController controller;

    @BeforeEach
    void setUp() {
        controller = new AuthorController(authorService);
    }

    @Test
    void testGetService() {
        assertSame(authorService, controller.getService());
    }

    @Test
    void testFindAuthorByAuthorId() {
        AuthorDto authorDto = new AuthorDto();
        authorDto.setId(123L);
        authorDto.setName("Author Name");
        when(authorService.findById(123L)).thenReturn(authorDto);

        ApiResponse response = controller.findAuthorByAuthorId(123L);

        assertTrue(response.getSuccess());
        assertEquals("Author fetched successfully.", response.getMessage());
        assertSame(authorDto, response.getBody());
        assertNotNull(response.getTimestamp());
        verify(authorService).findById(123L);
    }

    @Test
    void testFindAllAuthorsPaginatedAndFiltered() {
        FilterPaginationRequest<AuthorFilterPaginationRequest> request = new FilterPaginationRequest<>();
        PaginationResponse<AuthorDto> paginationResponse = PaginationResponse.<AuthorDto>builder()
                .pageNumber(1)
                .pageSize(10)
                .totalNumberOfPages(1)
                .totalNumberOfElements(1)
                .result(List.of(new AuthorDto()))
                .isFirst(true)
                .isLast(true)
                .build();
        when(authorService.findAllAuthorsPaginatedAndFiltered(request)).thenReturn(paginationResponse);

        ApiResponse response = controller.findAllAuthorsPaginatedAndFiltered(request);

        assertTrue(response.getSuccess());
        assertEquals("Authors paginated filtered fetched successfully.", response.getMessage());
        assertSame(paginationResponse, response.getBody());
        assertNotNull(response.getTimestamp());
        verify(authorService).findAllAuthorsPaginatedAndFiltered(request);
    }

    @Test
    void testCreateAuthor() {
        AuthorDto authorDto = new AuthorDto();
        authorDto.setId(1L);
        when(authorService.create(authorDto)).thenReturn(authorDto);

        ApiResponse response = controller.createAuthor(authorDto);

        assertTrue(response.getSuccess());
        assertEquals("Author created successfully.", response.getMessage());
        assertSame(authorDto, response.getBody());
        assertNotNull(response.getTimestamp());
        verify(authorService).create(authorDto);
    }

    @Test
    void testCreateAuthors() {
        List<AuthorDto> authors = List.of(new AuthorDto(), new AuthorDto());
        when(authorService.create(authors)).thenReturn(authors);

        ApiResponse response = controller.createAuthors(authors);

        assertTrue(response.getSuccess());
        assertEquals("Authors created successfully.", response.getMessage());
        assertSame(authors, response.getBody());
        assertNotNull(response.getTimestamp());
        verify(authorService).create(authors);
    }

    @Test
    void testUpdateAuthor() {
        AuthorDto authorDto = new AuthorDto();
        authorDto.setId(99L);
        when(authorService.update(authorDto, 99L)).thenReturn(authorDto);

        ApiResponse response = controller.updateAuthor(authorDto);

        assertTrue(response.getSuccess());
        assertEquals("Author updated successfully.", response.getMessage());
        assertSame(authorDto, response.getBody());
        assertNotNull(response.getTimestamp());
        verify(authorService).update(authorDto, 99L);
    }

    @Test
    void testDeleteAuthor() {
        ApiResponse response = controller.deleteAuthor(88L);

        assertTrue(response.getSuccess());
        assertEquals("Author deleted successfully.", response.getMessage());
        assertEquals(true, response.getBody());
        assertNotNull(response.getTimestamp());
        verify(authorService).deleteById(88L);
    }
}
