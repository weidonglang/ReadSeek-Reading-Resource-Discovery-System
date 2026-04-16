package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dto.BehaviorDashboardDto;
import com.weidonglang.readseek.dto.BehaviorLogEntryDto;
import com.weidonglang.readseek.dto.BookActivityStatDto;
import com.weidonglang.readseek.dto.BookDto;
import com.weidonglang.readseek.dto.NamedCountStatDto;
import com.weidonglang.readseek.dto.RecommendationStrategyDto;
import com.weidonglang.readseek.dto.SearchKeywordStatDto;
import com.weidonglang.readseek.dto.SearchLogEntryDto;
import com.weidonglang.readseek.entity.Author;
import com.weidonglang.readseek.entity.Book;
import com.weidonglang.readseek.entity.BookCategory;
import com.weidonglang.readseek.entity.Publisher;
import com.weidonglang.readseek.entity.SearchLog;
import com.weidonglang.readseek.entity.Tag;
import com.weidonglang.readseek.entity.UserBehaviorLog;
import com.weidonglang.readseek.enums.UserBehaviorActionType;
import com.weidonglang.readseek.repository.AuthorRepository;
import com.weidonglang.readseek.repository.BookCategoryRepository;
import com.weidonglang.readseek.repository.BookLoanRepository;
import com.weidonglang.readseek.repository.BookRepository;
import com.weidonglang.readseek.repository.PublisherRepository;
import com.weidonglang.readseek.repository.SearchLogRepository;
import com.weidonglang.readseek.repository.TagRepository;
import com.weidonglang.readseek.repository.UserBehaviorLogRepository;
import com.weidonglang.readseek.transformer.BookTransformer;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class BehaviorAnalyticsServiceImpl implements BehaviorAnalyticsService {
    private static final int DEFAULT_LIMIT = 10;
    private static final int DEFAULT_RECOMMENDATION_WINDOW_DAYS = 30;
    private static final int BORROW_WEIGHT = 5;
    private static final int DETAIL_CLICK_WEIGHT = 3;
    private static final int RATING_WEIGHT = 2;

    private final UserBehaviorLogRepository userBehaviorLogRepository;
    private final SearchLogRepository searchLogRepository;
    private final BookLoanRepository bookLoanRepository;
    private final BookRepository bookRepository;
    private final AuthorRepository authorRepository;
    private final BookCategoryRepository bookCategoryRepository;
    private final PublisherRepository publisherRepository;
    private final TagRepository tagRepository;
    private final BookTransformer bookTransformer;

    public BehaviorAnalyticsServiceImpl(UserBehaviorLogRepository userBehaviorLogRepository,
                                        SearchLogRepository searchLogRepository,
                                        BookLoanRepository bookLoanRepository,
                                        BookRepository bookRepository,
                                        AuthorRepository authorRepository,
                                        BookCategoryRepository bookCategoryRepository,
                                        PublisherRepository publisherRepository,
                                        TagRepository tagRepository,
                                        BookTransformer bookTransformer) {
        this.userBehaviorLogRepository = userBehaviorLogRepository;
        this.searchLogRepository = searchLogRepository;
        this.bookLoanRepository = bookLoanRepository;
        this.bookRepository = bookRepository;
        this.authorRepository = authorRepository;
        this.bookCategoryRepository = bookCategoryRepository;
        this.publisherRepository = publisherRepository;
        this.tagRepository = tagRepository;
        this.bookTransformer = bookTransformer;
    }

    @Override
    public BehaviorDashboardDto buildDashboard(Integer limit, Integer recentDays) {
        int normalizedLimit = normalizeLimit(limit);
        LocalDateTime fromDate = resolveFromDate(recentDays);
        List<SearchLog> recentSearchLogs = findRecentSearchLogEntities(normalizedLimit, fromDate);
        List<UserBehaviorLog> recentBehaviorLogs = findRecentBehaviorLogEntities(normalizedLimit, fromDate);

        return new BehaviorDashboardDto(
                normalizeRecentDays(recentDays),
                defaultLong(userBehaviorLogRepository.countByMarkedAsDeletedFalse()),
                countRecentSearches(fromDate),
                countRecentDetailClicks(fromDate),
                countRecentBorrows(fromDate),
                getRecommendationStrategy(recentDays),
                recentBehaviorLogs.stream().map(this::toBehaviorLogEntry).collect(Collectors.toList()),
                recentSearchLogs.stream().map(this::toSearchLogEntry).collect(Collectors.toList()),
                findTopKeywords(normalizedLimit, recentDays),
                findTopCategories(normalizedLimit, recentDays),
                findTopAuthors(normalizedLimit, recentDays),
                findTopTags(normalizedLimit, recentDays),
                findTopPublishers(normalizedLimit, recentDays),
                findTopClickedBooks(normalizedLimit, recentDays),
                findTopBorrowedBooks(normalizedLimit, recentDays)
        );
    }

    @Override
    public List<BehaviorLogEntryDto> findRecentBehaviorLogs(Integer limit) {
        return findRecentBehaviorLogEntities(normalizeLimit(limit), null).stream()
                .map(this::toBehaviorLogEntry)
                .collect(Collectors.toList());
    }

    @Override
    public List<SearchLogEntryDto> findRecentSearchLogs(Integer limit) {
        return findRecentSearchLogEntities(normalizeLimit(limit), null).stream()
                .map(this::toSearchLogEntry)
                .collect(Collectors.toList());
    }

    @Override
    public List<BehaviorLogEntryDto> findRecentBehaviorByUser(Long userId, Integer limit) {
        return userBehaviorLogRepository.findByUserIdAndMarkedAsDeletedFalseOrderByCreatedDateDesc(userId, PageRequest.of(0, normalizeLimit(limit))).stream()
                .map(this::toBehaviorLogEntry)
                .collect(Collectors.toList());
    }

    @Override
    public List<BehaviorLogEntryDto> findRecentBehaviorByBook(Long bookId, Integer limit) {
        return userBehaviorLogRepository.findByBookIdAndMarkedAsDeletedFalseOrderByCreatedDateDesc(bookId, PageRequest.of(0, normalizeLimit(limit))).stream()
                .map(this::toBehaviorLogEntry)
                .collect(Collectors.toList());
    }

    @Override
    public List<SearchKeywordStatDto> findTopKeywords(Integer limit, Integer recentDays) {
        LocalDateTime fromDate = resolveFromDate(recentDays);
        List<Object[]> rows = fromDate == null
                ? searchLogRepository.aggregateTopKeywords(PageRequest.of(0, normalizeLimit(limit)))
                : searchLogRepository.aggregateTopKeywordsSince(fromDate, PageRequest.of(0, normalizeLimit(limit)));
        return rows.stream()
                .map(row -> new SearchKeywordStatDto(String.valueOf(row[0]), toLong(row[1])))
                .collect(Collectors.toList());
    }

    @Override
    public List<BookActivityStatDto> findTopClickedBooks(Integer limit, Integer recentDays) {
        List<Object[]> rows = aggregateBookActions(
                Set.of(UserBehaviorActionType.BOOK_DETAIL_CLICK, UserBehaviorActionType.RECOMMENDATION_CLICK),
                recentDays,
                normalizeLimit(limit)
        );
        return mapBookStatRows(rows, "clicks");
    }

    @Override
    public List<BookActivityStatDto> findTopBorrowedBooks(Integer limit, Integer recentDays) {
        return mapBookStatRows(aggregateBorrowedBooks(recentDays, normalizeLimit(limit)), "borrows");
    }

    @Override
    public List<NamedCountStatDto> findTopCategories(Integer limit, Integer recentDays) {
        return aggregateStructuredSearchStats(
                recentDays,
                normalizeLimit(limit),
                SearchLog::getCategoryIds,
                ids -> bookCategoryRepository.findAllById(ids).stream()
                        .filter(entity -> !Boolean.TRUE.equals(entity.getMarkedAsDeleted()))
                        .collect(Collectors.toMap(BookCategory::getId, BookCategory::getName)),
                "category"
        );
    }

    @Override
    public List<NamedCountStatDto> findTopAuthors(Integer limit, Integer recentDays) {
        return aggregateStructuredSearchStats(
                recentDays,
                normalizeLimit(limit),
                SearchLog::getAuthorIds,
                ids -> authorRepository.findAllById(ids).stream()
                        .filter(entity -> !Boolean.TRUE.equals(entity.getMarkedAsDeleted()))
                        .collect(Collectors.toMap(Author::getId, Author::getName)),
                "author"
        );
    }

    @Override
    public List<NamedCountStatDto> findTopTags(Integer limit, Integer recentDays) {
        return aggregateStructuredSearchStats(
                recentDays,
                normalizeLimit(limit),
                SearchLog::getTagIds,
                ids -> tagRepository.findAllById(ids).stream()
                        .filter(entity -> !Boolean.TRUE.equals(entity.getMarkedAsDeleted()))
                        .collect(Collectors.toMap(Tag::getId, Tag::getName)),
                "tag"
        );
    }

    @Override
    public List<NamedCountStatDto> findTopPublishers(Integer limit, Integer recentDays) {
        return aggregateStructuredSearchStats(
                recentDays,
                normalizeLimit(limit),
                SearchLog::getPublisherIds,
                ids -> publisherRepository.findAllById(ids).stream()
                        .filter(entity -> !Boolean.TRUE.equals(entity.getMarkedAsDeleted()))
                        .collect(Collectors.toMap(Publisher::getId, Publisher::getName)),
                "publisher"
        );
    }

    @Override
    public RecommendationStrategyDto getRecommendationStrategy(Integer recentDays) {
        Integer appliedWindow = normalizeRecentDays(recentDays);
        return new RecommendationStrategyDto(
                appliedWindow,
                BORROW_WEIGHT,
                DETAIL_CLICK_WEIGHT,
                RATING_WEIGHT,
                String.format("score = borrows x %d + detail clicks x %d + rating count x %d", BORROW_WEIGHT, DETAIL_CLICK_WEIGHT, RATING_WEIGHT),
                appliedWindow == null
                        ? "Uses all recorded activity. Falls back to rating count, average rating, and available inventory when behavior data is too thin."
                        : String.format("Uses the last %d days of recorded activity. Falls back to rating count, average rating, and available inventory when behavior data is too thin.", appliedWindow)
        );
    }

    @Override
    public List<BookDto> findPopularBooks(Integer limit, Integer recentDays) {
        int normalizedLimit = normalizeLimit(limit);
        Map<Long, Integer> scores = new LinkedHashMap<>();
        mergeScores(scores, aggregateBookActions(
                Set.of(UserBehaviorActionType.BOOK_DETAIL_CLICK, UserBehaviorActionType.RECOMMENDATION_CLICK),
                recentDays,
                normalizedLimit * 4
        ), DETAIL_CLICK_WEIGHT);
        mergeScores(scores, aggregateBorrowedBooks(recentDays, normalizedLimit * 4), BORROW_WEIGHT);
        mergeScores(scores, bookRepository.aggregateRatedBooks(PageRequest.of(0, normalizedLimit * 4)), RATING_WEIGHT);

        if (scores.isEmpty()) {
            return Collections.emptyList();
        }

        List<Long> orderedIds = scores.entrySet().stream()
                .sorted(Map.Entry.<Long, Integer>comparingByValue().reversed())
                .limit(normalizedLimit)
                .map(Map.Entry::getKey)
                .collect(Collectors.toList());

        Map<Long, Book> booksById = bookRepository.findAllById(orderedIds).stream()
                .filter(book -> !Boolean.TRUE.equals(book.getMarkedAsDeleted()))
                .collect(Collectors.toMap(Book::getId, Function.identity()));

        List<Book> orderedBooks = new ArrayList<>();
        for (Long bookId : orderedIds) {
            Book book = booksById.get(bookId);
            if (book != null) {
                orderedBooks.add(book);
            }
        }
        return bookTransformer.transformEntityToDto(orderedBooks);
    }

    private void mergeScores(Map<Long, Integer> scores, Collection<Object[]> rows, int weight) {
        for (Object[] row : rows) {
            Long bookId = toLong(row[0]);
            Long count = toLong(row[1]);
            if (bookId != null && count != null) {
                scores.merge(bookId, Math.toIntExact(count * weight), Integer::sum);
            }
        }
    }

    private List<BookActivityStatDto> mapBookStatRows(List<Object[]> rows, String metric) {
        if (rows.isEmpty()) {
            return Collections.emptyList();
        }
        List<Long> ids = rows.stream()
                .map(row -> toLong(row[0]))
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
        Map<Long, Book> booksById = bookRepository.findAllById(ids).stream()
                .filter(book -> !Boolean.TRUE.equals(book.getMarkedAsDeleted()))
                .collect(Collectors.toMap(Book::getId, Function.identity()));

        List<BookActivityStatDto> result = new ArrayList<>();
        for (Object[] row : rows) {
            Long bookId = toLong(row[0]);
            Long count = toLong(row[1]);
            Book book = booksById.get(bookId);
            if (bookId != null && count != null && book != null) {
                result.add(new BookActivityStatDto(bookId, book.getName(), book.getImageUrl(), count, metric));
            }
        }
        return result;
    }

    private BehaviorLogEntryDto toBehaviorLogEntry(UserBehaviorLog log) {
        return new BehaviorLogEntryDto(
                log.getId(),
                log.getActionType(),
                log.getUser() == null ? null : log.getUser().getId(),
                log.getUser() == null ? null : log.getUser().getEmail(),
                log.getBook() == null ? null : log.getBook().getId(),
                log.getBook() == null ? null : log.getBook().getName(),
                log.getKeyword(),
                log.getSource(),
                log.getReason(),
                log.getCreatedDate()
        );
    }

    private SearchLogEntryDto toSearchLogEntry(SearchLog log) {
        return new SearchLogEntryDto(
                log.getId(),
                log.getUser() == null ? null : log.getUser().getId(),
                log.getUser() == null ? null : log.getUser().getEmail(),
                log.getKeyword(),
                log.getSource(),
                log.getReason(),
                log.getCategoryIds(),
                log.getAuthorIds(),
                log.getPublisherIds(),
                log.getTagIds(),
                log.getFromPrice(),
                log.getToPrice(),
                log.getFromPagesNumber(),
                log.getToPagesNumber(),
                log.getFromReadingDuration(),
                log.getToReadingDuration(),
                log.getSortBy(),
                log.getPageNumber(),
                log.getPageSize(),
                log.getDeletedRecords(),
                log.getResultCount(),
                log.getCreatedDate()
        );
    }

    private List<UserBehaviorLog> findRecentBehaviorLogEntities(int limit, LocalDateTime fromDate) {
        PageRequest pageable = PageRequest.of(0, limit);
        if (fromDate == null) {
            return userBehaviorLogRepository.findByMarkedAsDeletedFalseOrderByCreatedDateDesc(pageable);
        }
        return userBehaviorLogRepository.findByMarkedAsDeletedFalseAndCreatedDateGreaterThanEqualOrderByCreatedDateDesc(fromDate, pageable);
    }

    private List<SearchLog> findRecentSearchLogEntities(int limit, LocalDateTime fromDate) {
        PageRequest pageable = PageRequest.of(0, limit);
        if (fromDate == null) {
            return searchLogRepository.findByMarkedAsDeletedFalseOrderByCreatedDateDesc(pageable);
        }
        return searchLogRepository.findByMarkedAsDeletedFalseAndCreatedDateGreaterThanEqualOrderByCreatedDateDesc(fromDate, pageable);
    }

    private List<NamedCountStatDto> aggregateStructuredSearchStats(Integer recentDays,
                                                                   int limit,
                                                                   Function<SearchLog, String> idExtractor,
                                                                   Function<Set<Long>, Map<Long, String>> nameResolver,
                                                                   String type) {
        List<SearchLog> searchLogs = fetchSearchLogsForAggregation(resolveFromDate(recentDays));
        if (searchLogs.isEmpty()) {
            return Collections.emptyList();
        }

        Map<Long, Long> counts = new HashMap<>();
        for (SearchLog searchLog : searchLogs) {
            for (Long id : parseIds(idExtractor.apply(searchLog))) {
                counts.merge(id, 1L, Long::sum);
            }
        }
        if (counts.isEmpty()) {
            return Collections.emptyList();
        }

        Map<Long, String> names = nameResolver.apply(counts.keySet());
        return counts.entrySet().stream()
                .map(entry -> new NamedCountStatDto(
                        entry.getKey(),
                        names.getOrDefault(entry.getKey(), String.valueOf(entry.getKey())),
                        entry.getValue(),
                        type
                ))
                .sorted(Comparator
                        .comparingLong(NamedCountStatDto::getCount).reversed()
                        .thenComparing(NamedCountStatDto::getName))
                .limit(limit)
                .collect(Collectors.toList());
    }

    private List<SearchLog> fetchSearchLogsForAggregation(LocalDateTime fromDate) {
        if (fromDate == null) {
            return searchLogRepository.findByMarkedAsDeletedFalse();
        }
        return searchLogRepository.findByMarkedAsDeletedFalseAndCreatedDateGreaterThanEqual(fromDate);
    }

    private Set<Long> parseIds(String rawIds) {
        if (rawIds == null || rawIds.isBlank()) {
            return Collections.emptySet();
        }
        return java.util.Arrays.stream(rawIds.split(","))
                .map(String::trim)
                .filter(value -> !value.isBlank())
                .map(value -> {
                    try {
                        return Long.valueOf(value);
                    } catch (NumberFormatException exception) {
                        return null;
                    }
                })
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
    }

    private LocalDateTime resolveFromDate(Integer recentDays) {
        if (recentDays == null || recentDays < 1) {
            return null;
        }
        return LocalDateTime.now().minusDays(recentDays);
    }

    private Integer normalizeRecentDays(Integer recentDays) {
        if (recentDays == null || recentDays < 1) {
            return null;
        }
        return recentDays;
    }

    private int normalizeLimit(Integer limit) {
        if (limit == null || limit < 1) {
            return DEFAULT_LIMIT;
        }
        return Math.min(limit, 50);
    }

    private Long toLong(Object value) {
        if (value == null) {
            return null;
        }
        if (value instanceof Long) {
            return (Long) value;
        }
        if (value instanceof Integer) {
            return ((Integer) value).longValue();
        }
        if (value instanceof Number) {
            return ((Number) value).longValue();
        }
        return Long.parseLong(String.valueOf(value));
    }

    private Long countRecentSearches(LocalDateTime fromDate) {
        if (fromDate == null) {
            return defaultLong(searchLogRepository.countByMarkedAsDeletedFalse());
        }
        return defaultLong(searchLogRepository.countRecentSearches(fromDate));
    }

    private Long countRecentDetailClicks(LocalDateTime fromDate) {
        if (fromDate == null) {
            return defaultLong(userBehaviorLogRepository.countActions(
                    Set.of(UserBehaviorActionType.BOOK_DETAIL_CLICK, UserBehaviorActionType.RECOMMENDATION_CLICK)
            ));
        }
        return defaultLong(userBehaviorLogRepository.countActionsSince(
                Set.of(UserBehaviorActionType.BOOK_DETAIL_CLICK, UserBehaviorActionType.RECOMMENDATION_CLICK),
                fromDate
        ));
    }

    private Long countRecentBorrows(LocalDateTime fromDate) {
        if (fromDate == null) {
            return defaultLong(bookLoanRepository.countByMarkedAsDeletedFalse());
        }
        return defaultLong(bookLoanRepository.countBorrowedBooksSince(fromDate));
    }

    private Long defaultLong(Long value) {
        return value == null ? 0L : value;
    }

    private List<Object[]> aggregateBookActions(Collection<UserBehaviorActionType> actionTypes, Integer recentDays, int limit) {
        LocalDateTime fromDate = resolveFromDate(recentDays);
        PageRequest pageable = PageRequest.of(0, limit);
        if (fromDate == null) {
            return userBehaviorLogRepository.aggregateBookActions(actionTypes, pageable);
        }
        return userBehaviorLogRepository.aggregateBookActionsSince(actionTypes, fromDate, pageable);
    }

    private List<Object[]> aggregateBorrowedBooks(Integer recentDays, int limit) {
        LocalDateTime fromDate = resolveFromDate(recentDays);
        PageRequest pageable = PageRequest.of(0, limit);
        if (fromDate == null) {
            return bookLoanRepository.aggregateBorrowedBooks(pageable);
        }
        return bookLoanRepository.aggregateBorrowedBooksSince(fromDate, pageable);
    }
}
