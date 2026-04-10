package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.dao.UserBookRateDao;
import com.weidonglang.NewBookRecommendationSystem.dto.BookDto;
import com.weidonglang.NewBookRecommendationSystem.dto.UserBookRateDto;
import com.weidonglang.NewBookRecommendationSystem.dto.UserDto;
import com.weidonglang.NewBookRecommendationSystem.entity.UserBookRate;
import com.weidonglang.NewBookRecommendationSystem.transformer.UserBookRateTransformer;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class UserBookRateServiceImplTest {

    @Mock
    private UserBookRateTransformer userBookRateTransformer;

    @Mock
    private UserBookRateDao userBookRateDao;

    @Mock
    private UserService userService;

    @Mock
    private BookService bookService;

    @Mock
    private UserBehaviorLogService userBehaviorLogService;

    private UserBookRateServiceImpl service;

    @BeforeEach
    void setUp() {
        service = new UserBookRateServiceImpl(
                userBookRateTransformer,
                userBookRateDao,
                userService,
                bookService,
                userBehaviorLogService
        );
    }

    @Test
    void rateBookShouldSetAverageForFirstRating() {
        UserDto currentUser = buildUser(11L);
        UserBookRateDto request = buildRateRequest(100L, 5);
        BookDto bookDto = buildBook(100L, 0D, 0L);
        UserBookRate createdEntity = new UserBookRate();
        UserBookRateDto resultDto = new UserBookRateDto();

        when(userService.getCurrentUser()).thenReturn(currentUser);
        when(userService.findById(11L)).thenReturn(currentUser);
        when(userBookRateDao.findUserBookRateByUserIdAndBookId(11L, 100L)).thenReturn(Optional.empty());
        when(bookService.findById(100L)).thenReturn(bookDto);
        when(bookService.update(any(BookDto.class), eq(100L))).thenAnswer(invocation -> invocation.getArgument(0));
        when(userBookRateTransformer.transformDtoToEntity(any(UserBookRateDto.class))).thenReturn(createdEntity);
        when(userBookRateDao.create(createdEntity)).thenReturn(createdEntity);
        when(userBookRateTransformer.transformEntityToDto(createdEntity)).thenReturn(resultDto);

        UserBookRateDto actual = service.rateBook(request);

        ArgumentCaptor<BookDto> bookCaptor = ArgumentCaptor.forClass(BookDto.class);
        verify(bookService).update(bookCaptor.capture(), eq(100L));
        BookDto updatedBook = bookCaptor.getValue();
        assertEquals(1L, updatedBook.getUsersRateCount());
        assertEquals(5D, updatedBook.getRate());
        verify(userBookRateDao).create(createdEntity);
        verify(userBehaviorLogService).recordBookRate(100L, "Book rating recorded: 5");
        assertSame(resultDto, actual);
    }

    @Test
    void rateBookShouldRecalculateAverageWhenAnotherUserRates() {
        UserDto currentUser = buildUser(12L);
        UserBookRateDto request = buildRateRequest(101L, 2);
        BookDto bookDto = buildBook(101L, 4D, 1L);
        UserBookRate createdEntity = new UserBookRate();
        UserBookRateDto resultDto = new UserBookRateDto();

        when(userService.getCurrentUser()).thenReturn(currentUser);
        when(userService.findById(12L)).thenReturn(currentUser);
        when(userBookRateDao.findUserBookRateByUserIdAndBookId(12L, 101L)).thenReturn(Optional.empty());
        when(bookService.findById(101L)).thenReturn(bookDto);
        when(bookService.update(any(BookDto.class), eq(101L))).thenAnswer(invocation -> invocation.getArgument(0));
        when(userBookRateTransformer.transformDtoToEntity(any(UserBookRateDto.class))).thenReturn(createdEntity);
        when(userBookRateDao.create(createdEntity)).thenReturn(createdEntity);
        when(userBookRateTransformer.transformEntityToDto(createdEntity)).thenReturn(resultDto);

        service.rateBook(request);

        ArgumentCaptor<BookDto> bookCaptor = ArgumentCaptor.forClass(BookDto.class);
        verify(bookService).update(bookCaptor.capture(), eq(101L));
        BookDto updatedBook = bookCaptor.getValue();
        assertEquals(2L, updatedBook.getUsersRateCount());
        assertEquals(3D, updatedBook.getRate());
    }

    @Test
    void rateBookShouldKeepCountAndAdjustAverageWhenUserUpdatesRating() {
        UserDto currentUser = buildUser(13L);
        UserBookRateDto request = buildRateRequest(102L, 4);
        BookDto bookDto = buildBook(102L, 3.5D, 2L);
        UserBookRate existingRate = new UserBookRate();
        existingRate.setId(88L);
        existingRate.setRate(2);
        UserBookRateDto resultDto = new UserBookRateDto();

        when(userService.getCurrentUser()).thenReturn(currentUser);
        when(userBookRateDao.findUserBookRateByUserIdAndBookId(13L, 102L)).thenReturn(Optional.of(existingRate));
        when(userBookRateDao.findById(88L)).thenReturn(Optional.of(existingRate));
        when(bookService.findById(102L)).thenReturn(bookDto);
        when(bookService.update(any(BookDto.class), eq(102L))).thenAnswer(invocation -> invocation.getArgument(0));
        when(userBookRateDao.update(existingRate)).thenReturn(existingRate);
        when(userBookRateTransformer.transformEntityToDto(existingRate)).thenReturn(resultDto);

        UserBookRateDto actual = service.rateBook(request);

        ArgumentCaptor<BookDto> bookCaptor = ArgumentCaptor.forClass(BookDto.class);
        verify(bookService).update(bookCaptor.capture(), eq(102L));
        BookDto updatedBook = bookCaptor.getValue();
        assertEquals(2L, updatedBook.getUsersRateCount());
        assertEquals(4.5D, updatedBook.getRate());
        verify(userBookRateDao, never()).create(any(UserBookRate.class));
        verify(userBehaviorLogService).recordBookRate(102L, "Book rating recorded: 4");
        assertSame(resultDto, actual);
    }

    private UserDto buildUser(Long userId) {
        UserDto userDto = new UserDto();
        userDto.setId(userId);
        userDto.setEmail("user" + userId + "@example.com");
        return userDto;
    }

    private UserBookRateDto buildRateRequest(Long bookId, Integer rate) {
        BookDto bookDto = new BookDto();
        bookDto.setId(bookId);

        UserBookRateDto userBookRateDto = new UserBookRateDto();
        userBookRateDto.setBook(bookDto);
        userBookRateDto.setRate(rate);
        return userBookRateDto;
    }

    private BookDto buildBook(Long bookId, Double averageRate, Long usersRateCount) {
        BookDto bookDto = new BookDto();
        bookDto.setId(bookId);
        bookDto.setRate(averageRate);
        bookDto.setUsersRateCount(usersRateCount);
        return bookDto;
    }
}
