package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.dao.BookDao;
import com.weidonglang.NewBookRecommendationSystem.dao.BookLoanDao;
import com.weidonglang.NewBookRecommendationSystem.dao.BookReservationDao;
import com.weidonglang.NewBookRecommendationSystem.dao.UserDao;
import com.weidonglang.NewBookRecommendationSystem.dto.BookReservationDto;
import com.weidonglang.NewBookRecommendationSystem.dto.UserDto;
import com.weidonglang.NewBookRecommendationSystem.entity.Book;
import com.weidonglang.NewBookRecommendationSystem.entity.BookReservation;
import com.weidonglang.NewBookRecommendationSystem.entity.User;
import com.weidonglang.NewBookRecommendationSystem.transformer.BookReservationTransformer;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertSame;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class BookReservationServiceImplTest {

    @Mock
    private BookReservationDao bookReservationDao;

    @Mock
    private BookReservationTransformer bookReservationTransformer;

    @Mock
    private BookDao bookDao;

    @Mock
    private BookLoanDao bookLoanDao;

    @Mock
    private UserService userService;

    @Mock
    private UserDao userDao;

    private BookReservationServiceImpl service;

    @BeforeEach
    void setUp() {
        service = new BookReservationServiceImpl(
                bookReservationDao,
                bookReservationTransformer,
                bookDao,
                bookLoanDao,
                userService
        );
    }

    @Test
    void reserveBookShouldLockBookBeforeCreatingReservation() {
        UserDto currentUser = new UserDto();
        currentUser.setId(31L);

        User userEntity = new User();
        userEntity.setId(31L);

        Book bookEntity = new Book();
        bookEntity.setId(401L);
        bookEntity.setAvailableCopies(0);
        bookEntity.setMarkedAsDeleted(false);

        BookReservation reservationEntity = new BookReservation();
        BookReservationDto resultDto = new BookReservationDto();

        when(userService.getCurrentUser()).thenReturn(currentUser);
        when(userService.getDao()).thenReturn(userDao);
        when(userDao.findById(31L)).thenReturn(Optional.of(userEntity));
        when(bookDao.findByIdForUpdate(401L)).thenReturn(Optional.of(bookEntity));
        when(bookLoanDao.findActiveLoanByUserIdAndBookId(31L, 401L)).thenReturn(Optional.empty());
        when(bookReservationDao.findActiveReservationByUserIdAndBookId(31L, 401L)).thenReturn(Optional.empty());
        when(bookReservationDao.create(any(BookReservation.class))).thenReturn(reservationEntity);
        when(bookReservationTransformer.transformEntityToDto(reservationEntity)).thenReturn(resultDto);

        BookReservationDto actual = service.reserveBook(401L);

        verify(bookDao).findByIdForUpdate(401L);
        verify(bookReservationDao).create(any(BookReservation.class));
        assertSame(resultDto, actual);
    }
}
