package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dao.BookDao;
import com.weidonglang.readseek.dao.BookLoanDao;
import com.weidonglang.readseek.dao.BookReservationDao;
import com.weidonglang.readseek.dto.BookDto;
import com.weidonglang.readseek.dto.BookLoanDto;
import com.weidonglang.readseek.dto.UserDto;
import com.weidonglang.readseek.entity.Book;
import com.weidonglang.readseek.entity.BookLoan;
import com.weidonglang.readseek.entity.BookReservation;
import com.weidonglang.readseek.entity.User;
import com.weidonglang.readseek.enums.BookLoanStatus;
import com.weidonglang.readseek.enums.BookReservationStatus;
import com.weidonglang.readseek.transformer.BookLoanTransformer;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jakarta.persistence.EntityExistsException;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Slf4j
@Service
public class BookLoanServiceImpl implements BookLoanService {
    private static final int DEFAULT_LOAN_DAYS = 14;
    private static final int RENEW_LOAN_DAYS = 7;
    private static final int MAX_RENEW_COUNT = 1;
    private static final int MAX_ACTIVE_LOANS_PER_USER = 5;

    private final BookLoanDao bookLoanDao;
    private final BookLoanTransformer bookLoanTransformer;
    private final UserService userService;
    private final BookService bookService;
    private final BookDao bookDao;
    private final BookReservationDao bookReservationDao;
    private final UserBehaviorLogService userBehaviorLogService;

    public BookLoanServiceImpl(BookLoanDao bookLoanDao, BookLoanTransformer bookLoanTransformer, UserService userService, BookService bookService, BookDao bookDao, BookReservationDao bookReservationDao) {
        this(bookLoanDao, bookLoanTransformer, userService, bookService, bookDao, bookReservationDao, null);
    }

    @Autowired
    public BookLoanServiceImpl(BookLoanDao bookLoanDao,
                               BookLoanTransformer bookLoanTransformer,
                               UserService userService,
                               BookService bookService,
                               BookDao bookDao,
                               BookReservationDao bookReservationDao,
                               UserBehaviorLogService userBehaviorLogService) {
        this.bookLoanDao = bookLoanDao;
        this.bookLoanTransformer = bookLoanTransformer;
        this.userService = userService;
        this.bookService = bookService;
        this.bookDao = bookDao;
        this.bookReservationDao = bookReservationDao;
        this.userBehaviorLogService = userBehaviorLogService;
    }

    @Override
    public BookLoanDao getDao() {
        return bookLoanDao;
    }

    @Override
    public BookLoanTransformer getTransformer() {
        return bookLoanTransformer;
    }

    @Override
    @Transactional
    public BookLoanDto borrowBook(Long bookId) {
        log.info("BookLoanService: borrowBook() called");
        UserDto currentUser = userService.getCurrentUser();
        BookDto book = bookService.findById(bookId);
        Book bookEntity = findBookEntityForUpdate(bookId);
        Optional<BookReservation> activeReservation = bookReservationDao.findActiveReservationByUserIdAndBookId(currentUser.getId(), bookId);
        Optional<BookReservation> firstReservation = bookReservationDao.findFirstActiveReservationByBookId(bookId);

        if (Boolean.TRUE.equals(book.getMarkedAsDeleted())) {
            throw new EntityExistsException("Book is not available for borrowing.");
        }
        if (getDao().findActiveLoanByUserIdAndBookId(currentUser.getId(), bookId).isPresent()) {
            throw new EntityExistsException("This book is already borrowed by the current user.");
        }
        if (getDao().countActiveLoansByUserId(currentUser.getId()) >= MAX_ACTIVE_LOANS_PER_USER) {
            throw new EntityExistsException("You reached the active loan limit.");
        }
        if (firstReservation.isPresent()) {
            boolean currentUserIsFirst = activeReservation.isPresent()
                    && activeReservation.get().getId().equals(firstReservation.get().getId());
            if (!currentUserIsFirst) {
                throw new EntityExistsException(bookEntity.getAvailableCopies() > 0
                        ? "This book has an active reservation queue. Wait for your turn or place a reservation."
                        : "No copies available. You can place a reservation for this book.");
            }
        }
        if (bookEntity.getAvailableCopies() <= 0) {
            throw new EntityExistsException(activeReservation.isPresent()
                    ? "No copies available yet. Your reservation is still active."
                    : "No copies available. You can place a reservation for this book.");
        }

        LocalDateTime now = LocalDateTime.now();
        bookEntity.setAvailableCopies(bookEntity.getAvailableCopies() - 1);
        bookDao.update(bookEntity);
        if (activeReservation.isPresent()) {
            BookReservation reservation = activeReservation.get();
            reservation.setStatus(BookReservationStatus.FULFILLED);
            reservation.setFulfilledAt(now);
            bookReservationDao.update(reservation);
        }
        User userEntity = userService.getDao().findById(currentUser.getId())
                .orElseThrow(() -> new EntityNotFoundException("User not found for id: " + currentUser.getId()));
        BookLoan loan = new BookLoan();
        loan.setUser(userEntity);
        loan.setBook(bookEntity);
        loan.setBorrowedAt(now);
        loan.setDueDate(now.plusDays(DEFAULT_LOAN_DAYS));
        loan.setRenewCount(0);
        loan.setStatus(BookLoanStatus.BORROWED);

        BookLoanDto createdLoan = getTransformer().transformEntityToDto(getDao().create(loan));
        if (userBehaviorLogService != null) {
            userBehaviorLogService.recordBookBorrow(bookId, "鐢ㄦ埛鎴愬姛鍊熼槄鍥句功");
        }
        return createdLoan;
    }

    @Override
    @Transactional
    public BookLoanDto returnBook(Long loanId) {
        log.info("BookLoanService: returnBook() called");
        BookLoan loan = findCurrentUserLoanEntity(loanId);
        if (loan.getStatus() != BookLoanStatus.BORROWED) {
            throw new EntityExistsException("This loan is already closed.");
        }

        Book borrowedBook = findBookEntityForUpdate(loan.getBook().getId());
        borrowedBook.setAvailableCopies(Math.min(borrowedBook.getTotalCopies(), borrowedBook.getAvailableCopies() + 1));
        bookDao.update(borrowedBook);
        loan.setStatus(BookLoanStatus.RETURNED);
        loan.setReturnedAt(LocalDateTime.now());
        return getTransformer().transformEntityToDto(getDao().update(loan));
    }

    @Override
    @Transactional
    public BookLoanDto renewBook(Long loanId) {
        log.info("BookLoanService: renewBook() called");
        BookLoan loan = findCurrentUserLoanEntity(loanId);
        if (loan.getStatus() != BookLoanStatus.BORROWED) {
            throw new EntityExistsException("Only active loans can be renewed.");
        }
        if (loan.getRenewCount() >= MAX_RENEW_COUNT) {
            throw new EntityExistsException("This loan has already reached the renewal limit.");
        }

        loan.setRenewCount(loan.getRenewCount() + 1);
        loan.setDueDate(loan.getDueDate().plusDays(RENEW_LOAN_DAYS));
        return getTransformer().transformEntityToDto(getDao().update(loan));
    }

    @Override
    public List<BookLoanDto> findCurrentUserActiveLoans() {
        log.info("BookLoanService: findCurrentUserActiveLoans() called");
        return getTransformer().transformEntityToDto(getDao().findCurrentUserActiveLoans(userService.getCurrentUser().getId()));
    }

    @Override
    public List<BookLoanDto> findCurrentUserLoanHistory() {
        log.info("BookLoanService: findCurrentUserLoanHistory() called");
        return getTransformer().transformEntityToDto(getDao().findCurrentUserLoanHistory(userService.getCurrentUser().getId()));
    }

    @Override
    public List<BookLoanDto> findAllActiveLoans() {
        log.info("BookLoanService: findAllActiveLoans() called");
        return getTransformer().transformEntityToDto(getDao().findAllActiveLoans());
    }

    @Override
    public List<BookLoanDto> findAllLoanHistory() {
        log.info("BookLoanService: findAllLoanHistory() called");
        return getTransformer().transformEntityToDto(getDao().findAllLoanHistory());
    }

    private BookLoan findCurrentUserLoanEntity(Long loanId) {
        Optional<BookLoan> loan = getDao().findByIdAndUserId(loanId, userService.getCurrentUser().getId());
        if (loan.isEmpty()) {
            throw new EntityNotFoundException("Loan not found for id: " + loanId);
        }
        return loan.get();
    }

    private Book findBookEntityForUpdate(Long bookId) {
        return bookDao.findByIdForUpdate(bookId)
                .orElseThrow(() -> new EntityNotFoundException("Book not found for id: " + bookId));
    }
}
