package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.dao.BookDao;
import com.weidonglang.NewBookRecommendationSystem.dto.AuthorDto;
import com.weidonglang.NewBookRecommendationSystem.dto.BookDto;
import com.weidonglang.NewBookRecommendationSystem.entity.Book;
import com.weidonglang.NewBookRecommendationSystem.transformer.BookTransformer;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.mockito.Mockito.any;
import static org.mockito.Mockito.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class BookServiceImplTest {

    @Mock
    private BookTransformer bookTransformer;

    @Mock
    private BookDao bookDao;

    @Mock
    private AuthorService authorService;

    @Mock
    private BookSearchIndexService bookSearchIndexService;

    private BookServiceImpl service;

    @BeforeEach
    void setUp() {
        service = new BookServiceImpl(
                bookTransformer,
                bookDao,
                authorService,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                bookSearchIndexService
        );
    }

    @Test
    void createShouldSyncSearchIndexAfterPersistingBook() {
        BookDto request = buildBookDto(10L, 3);
        Book createdEntity = new Book();
        createdEntity.setId(10L);
        BookDto createdDto = buildBookDto(10L, 3);

        when(authorService.findById(1L)).thenReturn(request.getAuthor());
        when(bookTransformer.transformDtoToEntity(any(BookDto.class))).thenReturn(createdEntity);
        when(bookDao.create(createdEntity)).thenReturn(createdEntity);
        when(bookTransformer.transformEntityToDto(createdEntity)).thenReturn(createdDto);

        BookDto actual = service.create(request);

        ArgumentCaptor<BookDto> dtoCaptor = ArgumentCaptor.forClass(BookDto.class);
        verify(bookTransformer).transformDtoToEntity(dtoCaptor.capture());
        assertEquals(3, dtoCaptor.getValue().getTotalCopies());
        assertEquals(3, dtoCaptor.getValue().getAvailableCopies());
        verify(bookSearchIndexService).indexBook(10L);
        assertSame(createdDto, actual);
    }

    @Test
    void updateShouldSyncSearchIndexAfterPersistingBook() {
        BookDto request = buildBookDto(20L, 4);
        Book existingBook = new Book();
        existingBook.setId(20L);
        existingBook.setTotalCopies(4);
        existingBook.setAvailableCopies(4);
        BookDto updatedDto = buildBookDto(20L, 4);

        when(bookDao.findById(20L)).thenReturn(Optional.of(existingBook));
        when(authorService.findById(1L)).thenReturn(request.getAuthor());
        when(bookDao.update(existingBook)).thenReturn(existingBook);
        when(bookTransformer.transformEntityToDto(existingBook)).thenReturn(updatedDto);

        BookDto actual = service.update(request, 20L);

        verify(bookTransformer).updateEntity(request, existingBook);
        verify(bookSearchIndexService).indexBook(20L);
        assertSame(updatedDto, actual);
    }

    @Test
    void deleteByIdShouldMarkBookDeletedAndSyncIndex() {
        Book existingBook = new Book();
        existingBook.setId(30L);
        existingBook.setMarkedAsDeleted(false);

        when(bookDao.findById(30L)).thenReturn(Optional.of(existingBook));
        when(bookDao.update(existingBook)).thenReturn(existingBook);

        service.deleteById(30L);

        assertEquals(Boolean.TRUE, existingBook.getMarkedAsDeleted());
        verify(bookDao).update(existingBook);
        verify(bookSearchIndexService).indexBook(30L);
        verify(bookTransformer, never()).transformEntityToDto(any(Book.class));
    }

    private BookDto buildBookDto(Long id, Integer totalCopies) {
        AuthorDto authorDto = new AuthorDto();
        authorDto.setId(1L);
        authorDto.setName("Jane Austen");

        BookDto bookDto = new BookDto();
        bookDto.setId(id);
        bookDto.setAuthor(authorDto);
        bookDto.setName("Pride and Prejudice");
        bookDto.setTotalCopies(totalCopies);
        return bookDto;
    }
}
