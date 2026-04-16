package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dto.BookDto;
import com.weidonglang.readseek.dto.BookLoanDto;
import com.weidonglang.readseek.dto.BookReservationDto;
import com.weidonglang.readseek.dto.HomeDashboardDto;
import com.weidonglang.readseek.dto.UserBookCategoryDto;
import com.weidonglang.readseek.dto.UserReadingInfoDto;
import com.weidonglang.readseek.entity.Book;
import com.weidonglang.readseek.entity.BookLoan;
import com.weidonglang.readseek.entity.BookReservation;
import com.weidonglang.readseek.entity.UserBehaviorLog;
import com.weidonglang.readseek.enums.BookLoanStatus;
import com.weidonglang.readseek.enums.BookReservationStatus;
import com.weidonglang.readseek.enums.UserBehaviorActionType;
import com.weidonglang.readseek.repository.BookLoanRepository;
import com.weidonglang.readseek.repository.BookRepository;
import com.weidonglang.readseek.repository.BookReservationRepository;
import com.weidonglang.readseek.repository.UserBehaviorLogRepository;
import com.weidonglang.readseek.repository.UserBookRatingRepository;
import com.weidonglang.readseek.transformer.BookLoanTransformer;
import com.weidonglang.readseek.transformer.BookReservationTransformer;
import com.weidonglang.readseek.transformer.BookTransformer;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class HomeDashboardServiceImpl implements HomeDashboardService {
    private static final int DUE_SOON_DAYS = 3;
    private static final int RECENT_VIEWED_LIMIT = 6;
    private static final int TREND_LIMIT = 6;
    private static final int NEW_ARRIVAL_LIMIT = 6;
    private static final int POPULAR_LIMIT = 6;

    private final UserService userService;
    private final UserReadingInfoService userReadingInfoService;
    private final BookLoanRepository bookLoanRepository;
    private final BookReservationRepository bookReservationRepository;
    private final UserBehaviorLogRepository userBehaviorLogRepository;
    private final UserBookRatingRepository userBookRatingRepository;
    private final BookRepository bookRepository;
    private final BehaviorAnalyticsService behaviorAnalyticsService;
    private final BookTransformer bookTransformer;
    private final BookLoanTransformer bookLoanTransformer;
    private final BookReservationTransformer bookReservationTransformer;

    public HomeDashboardServiceImpl(UserService userService,
                                    UserReadingInfoService userReadingInfoService,
                                    BookLoanRepository bookLoanRepository,
                                    BookReservationRepository bookReservationRepository,
                                    UserBehaviorLogRepository userBehaviorLogRepository,
                                    UserBookRatingRepository userBookRatingRepository,
                                    BookRepository bookRepository,
                                    BehaviorAnalyticsService behaviorAnalyticsService,
                                    BookTransformer bookTransformer,
                                    BookLoanTransformer bookLoanTransformer,
                                    BookReservationTransformer bookReservationTransformer) {
        this.userService = userService;
        this.userReadingInfoService = userReadingInfoService;
        this.bookLoanRepository = bookLoanRepository;
        this.bookReservationRepository = bookReservationRepository;
        this.userBehaviorLogRepository = userBehaviorLogRepository;
        this.userBookRatingRepository = userBookRatingRepository;
        this.bookRepository = bookRepository;
        this.behaviorAnalyticsService = behaviorAnalyticsService;
        this.bookTransformer = bookTransformer;
        this.bookLoanTransformer = bookLoanTransformer;
        this.bookReservationTransformer = bookReservationTransformer;
    }

    @Override
    public HomeDashboardDto buildCurrentUserDashboard() {
        Long userId = userService.getCurrentUser().getId();
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime monthStart = LocalDate.now().withDayOfMonth(1).atStartOfDay();

        List<BookLoan> activeLoans = bookLoanRepository.findCurrentUserLoansByStatus(userId, BookLoanStatus.BORROWED);
        List<BookReservation> activeReservations = bookReservationRepository
                .findAllByUserIdAndStatusAndMarkedAsDeletedFalseOrderByRequestedAtAsc(userId, BookReservationStatus.ACTIVE);

        List<BookLoan> urgentLoans = activeLoans.stream()
                .filter(loan -> loan.getDueDate() != null && !loan.getDueDate().isAfter(now.plusDays(DUE_SOON_DAYS)))
                .sorted(Comparator.comparing(BookLoan::getDueDate, Comparator.nullsLast(Comparator.naturalOrder())))
                .collect(Collectors.toList());

        long overdueCount = activeLoans.stream()
                .filter(loan -> loan.getDueDate() != null && loan.getDueDate().isBefore(now))
                .count();
        long dueSoonCount = activeLoans.stream()
                .filter(loan -> loan.getDueDate() != null
                        && !loan.getDueDate().isBefore(now)
                        && !loan.getDueDate().isAfter(now.plusDays(DUE_SOON_DAYS)))
                .count();

        UserReadingInfoDto readingInfo = findReadingInfoSafely();

        return new HomeDashboardDto(
                calculateReadingStreakDays(userId),
                (long) activeLoans.size(),
                (long) activeReservations.size(),
                dueSoonCount,
                overdueCount,
                defaultLong(bookLoanRepository.countBorrowedBooksByUserSince(userId, monthStart)),
                defaultLong(userBookRatingRepository.countByUserIdAndCreatedDateGreaterThanEqualAndMarkedAsDeletedFalse(userId, monthStart)),
                readingInfo == null || readingInfo.getReadingLevel() == null ? null : readingInfo.getReadingLevel().name(),
                extractPreferredCategories(readingInfo),
                bookLoanTransformer.transformEntityToDto(urgentLoans),
                bookReservationTransformer.transformEntityToDto(activeReservations),
                buildRecentViewedBooks(userId),
                behaviorAnalyticsService.findTopKeywords(TREND_LIMIT, 30),
                behaviorAnalyticsService.findTopCategories(TREND_LIMIT, 30),
                bookTransformer.transformEntityToDto(bookRepository.findByMarkedAsDeletedFalseOrderByCreatedDateDesc(PageRequest.of(0, NEW_ARRIVAL_LIMIT))),
                behaviorAnalyticsService.findPopularBooks(POPULAR_LIMIT, 30)
        );
    }

    private UserReadingInfoDto findReadingInfoSafely() {
        try {
            return userReadingInfoService.findUserReadingInfo();
        } catch (Exception exception) {
            return null;
        }
    }

    private List<String> extractPreferredCategories(UserReadingInfoDto readingInfo) {
        if (readingInfo == null || readingInfo.getUserBookCategories() == null) {
            return new ArrayList<>();
        }
        return readingInfo.getUserBookCategories().stream()
                .map(UserBookCategoryDto::getCategory)
                .filter(Objects::nonNull)
                .map(category -> category.getName())
                .filter(Objects::nonNull)
                .distinct()
                .collect(Collectors.toList());
    }

    private List<BookDto> buildRecentViewedBooks(Long userId) {
        List<UserBehaviorLog> logs = userBehaviorLogRepository
                .findByUserIdAndMarkedAsDeletedFalseAndActionTypeInOrderByCreatedDateDesc(
                        userId,
                        Set.of(UserBehaviorActionType.BOOK_DETAIL_CLICK, UserBehaviorActionType.RECOMMENDATION_CLICK),
                        PageRequest.of(0, RECENT_VIEWED_LIMIT * 4)
                );

        Map<Long, Book> booksById = new LinkedHashMap<>();
        for (UserBehaviorLog log : logs) {
            Book book = log.getBook();
            if (book == null || Boolean.TRUE.equals(book.getMarkedAsDeleted())) {
                continue;
            }
            booksById.putIfAbsent(book.getId(), book);
            if (booksById.size() >= RECENT_VIEWED_LIMIT) {
                break;
            }
        }
        return bookTransformer.transformEntityToDto(new ArrayList<>(booksById.values()));
    }

    private Integer calculateReadingStreakDays(Long userId) {
        List<UserBehaviorLog> logs = userBehaviorLogRepository.findByUserIdAndMarkedAsDeletedFalseOrderByCreatedDateDesc(userId);
        if (logs.isEmpty()) {
            return 0;
        }

        Set<LocalDate> activeDates = logs.stream()
                .map(UserBehaviorLog::getCreatedDate)
                .filter(Objects::nonNull)
                .map(LocalDateTime::toLocalDate)
                .collect(Collectors.toSet());
        if (activeDates.isEmpty()) {
            return 0;
        }

        LocalDate today = LocalDate.now();
        LocalDate cursor;
        if (activeDates.contains(today)) {
            cursor = today;
        } else if (activeDates.contains(today.minusDays(1))) {
            cursor = today.minusDays(1);
        } else {
            return 0;
        }

        int streak = 0;
        while (activeDates.contains(cursor)) {
            streak++;
            cursor = cursor.minusDays(1);
        }
        return streak;
    }

    private Long defaultLong(Long value) {
        return value == null ? 0L : value;
    }
}
