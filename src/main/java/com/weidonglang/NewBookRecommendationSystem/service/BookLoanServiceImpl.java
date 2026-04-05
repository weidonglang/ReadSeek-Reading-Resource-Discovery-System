package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.dao.BookDao;
import com.weidonglang.NewBookRecommendationSystem.dao.BookLoanDao;
import com.weidonglang.NewBookRecommendationSystem.dao.BookReservationDao;
import com.weidonglang.NewBookRecommendationSystem.dto.BookDto;
import com.weidonglang.NewBookRecommendationSystem.dto.BookLoanDto;
import com.weidonglang.NewBookRecommendationSystem.dto.UserDto;
import com.weidonglang.NewBookRecommendationSystem.entity.Book;
import com.weidonglang.NewBookRecommendationSystem.entity.BookLoan;
import com.weidonglang.NewBookRecommendationSystem.entity.BookReservation;
import com.weidonglang.NewBookRecommendationSystem.enums.BookLoanStatus;
import com.weidonglang.NewBookRecommendationSystem.enums.BookReservationStatus;
import com.weidonglang.NewBookRecommendationSystem.transformer.BookLoanTransformer;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityExistsException;
import javax.persistence.EntityNotFoundException;
import javax.transaction.Transactional;
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
        Book bookEntity = bookDao.findById(bookId).orElseThrow(() -> new EntityNotFoundException("Book not found for id: " + bookId));
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
        BookLoanDto loanDto = new BookLoanDto();
        loanDto.setUser(currentUser);
        loanDto.setBook(book);
        loanDto.setBorrowedAt(now);
        loanDto.setDueDate(now.plusDays(DEFAULT_LOAN_DAYS));
        loanDto.setRenewCount(0);
        loanDto.setStatus(BookLoanStatus.BORROWED);

        BookLoanDto createdLoan = getTransformer().transformEntityToDto(getDao().create(getTransformer().transformDtoToEntity(loanDto)));
        if (userBehaviorLogService != null) {
            userBehaviorLogService.recordBookBorrow(bookId, "用户成功借阅图书");
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

        Book borrowedBook = loan.getBook();
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
}
