package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dao.BookDao;
import com.weidonglang.readseek.dao.BookLoanDao;
import com.weidonglang.readseek.dao.BookReservationDao;
import com.weidonglang.readseek.dto.BookDto;
import com.weidonglang.readseek.dto.BookLoanDto;
import com.weidonglang.readseek.dto.UserDto;
import com.weidonglang.readseek.entity.Book;
import com.weidonglang.readseek.entity.BookLoan;
import com.weidonglang.readseek.transformer.BookLoanTransformer;
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
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class BookLoanServiceImplTest {

    @Mock
    private BookLoanDao bookLoanDao;

    @Mock
    private BookLoanTransformer bookLoanTransformer;

    @Mock
    private UserService userService;

    @Mock
    private BookService bookService;

    @Mock
    private BookDao bookDao;

    @Mock
    private BookReservationDao bookReservationDao;

    @Mock
    private UserBehaviorLogService userBehaviorLogService;

    private BookLoanServiceImpl service;

    @BeforeEach
    void setUp() {
        service = new BookLoanServiceImpl(
                bookLoanDao,
                bookLoanTransformer,
                userService,
                bookService,
                bookDao,
                bookReservationDao,
                userBehaviorLogService
        );
    }

    @Test
    void borrowBookShouldLockBookBeforeUpdatingInventory() {
        UserDto currentUser = new UserDto();
        currentUser.setId(21L);

        BookDto bookDto = new BookDto();
        bookDto.setId(301L);
        bookDto.setMarkedAsDeleted(false);

        Book bookEntity = new Book();
        bookEntity.setId(301L);
        bookEntity.setTotalCopies(1);
        bookEntity.setAvailableCopies(1);
        bookEntity.setMarkedAsDeleted(false);

        BookLoan loanEntity = new BookLoan();
        BookLoanDto resultDto = new BookLoanDto();

        when(userService.getCurrentUser()).thenReturn(currentUser);
        when(bookService.findById(301L)).thenReturn(bookDto);
        when(bookDao.findByIdForUpdate(301L)).thenReturn(Optional.of(bookEntity));
        when(bookReservationDao.findActiveReservationByUserIdAndBookId(21L, 301L)).thenReturn(Optional.empty());
        when(bookReservationDao.findFirstActiveReservationByBookId(301L)).thenReturn(Optional.empty());
        when(bookLoanDao.findActiveLoanByUserIdAndBookId(21L, 301L)).thenReturn(Optional.empty());
        when(bookLoanDao.countActiveLoansByUserId(21L)).thenReturn(0L);
        when(bookLoanTransformer.transformDtoToEntity(any(BookLoanDto.class))).thenReturn(loanEntity);
        when(bookLoanDao.create(loanEntity)).thenReturn(loanEntity);
        when(bookLoanTransformer.transformEntityToDto(loanEntity)).thenReturn(resultDto);

        BookLoanDto actual = service.borrowBook(301L);

        verify(bookDao).findByIdForUpdate(301L);
        ArgumentCaptor<Book> bookCaptor = ArgumentCaptor.forClass(Book.class);
        verify(bookDao).update(bookCaptor.capture());
        assertEquals(0, bookCaptor.getValue().getAvailableCopies());
        assertSame(resultDto, actual);
    }
}
