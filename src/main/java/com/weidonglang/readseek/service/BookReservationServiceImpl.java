package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dao.BookDao;
import com.weidonglang.readseek.dao.BookLoanDao;
import com.weidonglang.readseek.dao.BookReservationDao;
import com.weidonglang.readseek.dto.BookReservationDto;
import com.weidonglang.readseek.dto.BookReservationSummaryDto;
import com.weidonglang.readseek.entity.Book;
import com.weidonglang.readseek.entity.BookReservation;
import com.weidonglang.readseek.enums.BookReservationStatus;
import com.weidonglang.readseek.transformer.BookReservationTransformer;
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
public class BookReservationServiceImpl implements BookReservationService {
    private final BookReservationDao bookReservationDao;
    private final BookReservationTransformer bookReservationTransformer;
    private final BookDao bookDao;
    private final BookLoanDao bookLoanDao;
    private final UserService userService;
    private final ReservationRequestGuard reservationRequestGuard;

    public BookReservationServiceImpl(BookReservationDao bookReservationDao, BookReservationTransformer bookReservationTransformer, BookDao bookDao, BookLoanDao bookLoanDao, UserService userService) {
        this(bookReservationDao, bookReservationTransformer, bookDao, bookLoanDao, userService, ReservationRequestGuard.noOp());
    }

    @Autowired
    public BookReservationServiceImpl(BookReservationDao bookReservationDao,
                                      BookReservationTransformer bookReservationTransformer,
                                      BookDao bookDao,
                                      BookLoanDao bookLoanDao,
                                      UserService userService,
                                      ReservationRequestGuard reservationRequestGuard) {
        this.bookReservationDao = bookReservationDao;
        this.bookReservationTransformer = bookReservationTransformer;
        this.bookDao = bookDao;
        this.bookLoanDao = bookLoanDao;
        this.userService = userService;
        this.reservationRequestGuard = reservationRequestGuard;
    }

    @Override
    public BookReservationDao getDao() {
        return bookReservationDao;
    }

    @Override
    public BookReservationTransformer getTransformer() {
        return bookReservationTransformer;
    }

    @Override
    @Transactional
    public BookReservationDto reserveBook(Long bookId) {
        log.info("BookReservationService: reserveBook() called");
        Long currentUserId = userService.getCurrentUser().getId();
        ReservationRequestGuard.GuardToken guardToken = reservationRequestGuard.acquire(currentUserId, bookId);
        try {
            Book book = findBookEntityForUpdate(bookId);

            if (Boolean.TRUE.equals(book.getMarkedAsDeleted())) {
                throw new EntityExistsException("Book is not available for reservation.");
            }
            if (book.getAvailableCopies() > 0) {
                throw new EntityExistsException("Book is available now. Borrow it directly instead of reserving.");
            }
            if (bookLoanDao.findActiveLoanByUserIdAndBookId(currentUserId, bookId).isPresent()) {
                throw new EntityExistsException("You already borrowed this book.");
            }
            if (getDao().findActiveReservationByUserIdAndBookId(currentUserId, bookId).isPresent()) {
                throw new EntityExistsException("You already have an active reservation for this book.");
            }

            BookReservation reservation = new BookReservation();
            reservation.setUser(userService.getDao().findById(currentUserId).orElseThrow(EntityNotFoundException::new));
            reservation.setBook(book);
            reservation.setRequestedAt(LocalDateTime.now());
            reservation.setStatus(BookReservationStatus.ACTIVE);

            return getTransformer().transformEntityToDto(getDao().create(reservation));
        } catch (RuntimeException exception) {
            reservationRequestGuard.release(guardToken);
            throw exception;
        }
    }

    @Override
    @Transactional
    public BookReservationDto cancelReservation(Long reservationId) {
        log.info("BookReservationService: cancelReservation() called");
        BookReservation reservation = findCurrentUserReservationEntity(reservationId);
        if (reservation.getStatus() != BookReservationStatus.ACTIVE) {
            throw new EntityExistsException("Only active reservations can be cancelled.");
        }

        reservation.setStatus(BookReservationStatus.CANCELLED);
        reservation.setCancelledAt(LocalDateTime.now());
        return getTransformer().transformEntityToDto(getDao().update(reservation));
    }

    @Override
    public List<BookReservationDto> findCurrentUserActiveReservations() {
        log.info("BookReservationService: findCurrentUserActiveReservations() called");
        return getTransformer().transformEntityToDto(getDao().findCurrentUserActiveReservations(userService.getCurrentUser().getId()));
    }

    @Override
    public List<BookReservationDto> findCurrentUserReservationHistory() {
        log.info("BookReservationService: findCurrentUserReservationHistory() called");
        return getTransformer().transformEntityToDto(getDao().findCurrentUserReservationHistory(userService.getCurrentUser().getId()));
    }

    @Override
    public BookReservationSummaryDto findBookReservationSummary(Long bookId) {
        log.info("BookReservationService: findBookReservationSummary() called");
        Long currentUserId = userService.getCurrentUser().getId();
        List<BookReservation> activeReservations = getDao().findActiveReservationsByBookId(bookId);
        Optional<BookReservation> currentUserReservation = getDao().findActiveReservationByUserIdAndBookId(currentUserId, bookId);

        Integer queuePosition = null;
        Boolean isFirst = false;
        Long reservationId = null;
        if (currentUserReservation.isPresent()) {
            reservationId = currentUserReservation.get().getId();
            for (int i = 0; i < activeReservations.size(); i++) {
                if (activeReservations.get(i).getId().equals(reservationId)) {
                    queuePosition = i + 1;
                    isFirst = i == 0;
                    break;
                }
            }
        }

        return new BookReservationSummaryDto(
                bookId,
                (long) activeReservations.size(),
                currentUserReservation.isPresent(),
                isFirst,
                queuePosition,
                reservationId
        );
    }

    @Override
    public List<BookReservationDto> findAllActiveReservations() {
        log.info("BookReservationService: findAllActiveReservations() called");
        return getTransformer().transformEntityToDto(getDao().findAllActiveReservations());
    }

    @Override
    public List<BookReservationDto> findAllReservationHistory() {
        log.info("BookReservationService: findAllReservationHistory() called");
        return getTransformer().transformEntityToDto(getDao().findAllReservationHistory());
    }

    private Book findBookEntityForUpdate(Long bookId) {
        return bookDao.findByIdForUpdate(bookId).orElseThrow(() -> new EntityNotFoundException("Book not found for id: " + bookId));
    }

    private BookReservation findCurrentUserReservationEntity(Long reservationId) {
        return getDao().findByIdAndUserId(reservationId, userService.getCurrentUser().getId())
                .orElseThrow(() -> new EntityNotFoundException("Reservation not found for id: " + reservationId));
    }
}
/*
weidonglang
2026.3-2027.9
*/
