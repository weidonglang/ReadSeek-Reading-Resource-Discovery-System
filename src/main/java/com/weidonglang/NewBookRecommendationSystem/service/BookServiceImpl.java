package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.dao.BookDao;
import com.weidonglang.NewBookRecommendationSystem.dao.BookLoanDao;
import com.weidonglang.NewBookRecommendationSystem.dao.UserBookRateDao;
import com.weidonglang.NewBookRecommendationSystem.dto.BookDto;
import com.weidonglang.NewBookRecommendationSystem.dto.BookFilterPaginationRequest;
import com.weidonglang.NewBookRecommendationSystem.dto.BookRecommendationOverviewDto;
import com.weidonglang.NewBookRecommendationSystem.dto.BookRecommendationShelfDto;
import com.weidonglang.NewBookRecommendationSystem.dto.TagDto;
import com.weidonglang.NewBookRecommendationSystem.dto.base.pagination.FilterPaginationRequest;
import com.weidonglang.NewBookRecommendationSystem.dto.base.response.PaginationResponse;
import com.weidonglang.NewBookRecommendationSystem.entity.Book;
import com.weidonglang.NewBookRecommendationSystem.entity.BookLoan;
import com.weidonglang.NewBookRecommendationSystem.entity.UserBookRate;
import com.weidonglang.NewBookRecommendationSystem.recommender.CollaborativeFilteringRecommender;
import com.weidonglang.NewBookRecommendationSystem.transformer.BookTransformer;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import jakarta.persistence.EntityExistsException;
import jakarta.persistence.EntityNotFoundException;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

@Slf4j
@Service
public class BookServiceImpl implements BookService {
    private static final int MIN_OF_RECOMMENDED_BOOKS = 14;
    private static final int DEFAULT_RECOMMENDATION_LIMIT = 8;
    private static final int DETAIL_RECOMMENDATION_LIMIT = 6;
    private static final int DEFAULT_POPULAR_RECENT_DAYS = 30;
    private static final int CANDIDATE_POOL_MULTIPLIER = 6;
    private static final Map<String, String> CATEGORY_NAME_MAP = Map.of(
            "Science Fiction", "Sci-Fi",
            "Horror", "Horror",
            "Classic", "Classic",
            "Action and Adventure", "Action & Adventure",
            "Romantic", "Romance",
            "Kids", "Children",
            "History", "History",
            "Sport", "Sports"
    );
    private final BookTransformer bookTransformer;
    private final BookDao bookDao;
    private final AuthorService authorService;
    private final BookCategoryService bookCategoryService;
    private final PublisherService publisherService;
    private final TagService tagService;
    private final UserReadingInfoService userReadingInfoService;
    private final BookLoanDao bookLoanDao;
    private final UserService userService;
    private final UserBookRateDao userBookRateDao;
    private final CollaborativeFilteringRecommender collaborativeFilteringRecommender;
    private final BehaviorAnalyticsService behaviorAnalyticsService;
    private final BookSearchIndexService bookSearchIndexService;

    @Autowired
    public BookServiceImpl(BookTransformer bookTransformer,
                           BookDao bookDao,
                           AuthorService authorService,
                           BookCategoryService bookCategoryService,
                           PublisherService publisherService,
                           TagService tagService,
                           UserReadingInfoService userReadingInfoService,
                           BookLoanDao bookLoanDao,
                           UserService userService,
                           UserBookRateDao userBookRateDao,
                           CollaborativeFilteringRecommender collaborativeFilteringRecommender,
                           BehaviorAnalyticsService behaviorAnalyticsService,
                           BookSearchIndexService bookSearchIndexService) {
        this.bookTransformer = bookTransformer;
        this.bookDao = bookDao;
        this.bookCategoryService = bookCategoryService;
        this.publisherService = publisherService;
        this.tagService = tagService;
        this.userReadingInfoService = userReadingInfoService;
        this.authorService = authorService;
        this.bookLoanDao = bookLoanDao;
        this.userService = userService;
        this.userBookRateDao = userBookRateDao;
        this.collaborativeFilteringRecommender = collaborativeFilteringRecommender;
        this.behaviorAnalyticsService = behaviorAnalyticsService;
        this.bookSearchIndexService = bookSearchIndexService;
    }

    public BookServiceImpl(BookTransformer bookTransformer,
                           BookDao bookDao,
                           AuthorService authorService,
                           BookCategoryService bookCategoryService,
                           PublisherService publisherService,
                           TagService tagService,
                           UserReadingInfoService userReadingInfoService,
                           BookLoanDao bookLoanDao,
                           UserService userService,
                           UserBookRateDao userBookRateDao) {
        this(bookTransformer, bookDao, authorService, bookCategoryService, publisherService, tagService,
                userReadingInfoService, bookLoanDao, userService, userBookRateDao, null, null, null);
    }

    public BookServiceImpl(BookTransformer bookTransformer, BookDao bookDao, AuthorService authorService, BookCategoryService bookCategoryService, PublisherService publisherService, TagService tagService, UserReadingInfoService userReadingInfoService, BookLoanDao bookLoanDao) {
        this(bookTransformer, bookDao, authorService, bookCategoryService, publisherService, tagService, userReadingInfoService, bookLoanDao, null, null, null, null, null);
    }

    public BookServiceImpl(BookTransformer bookTransformer, BookDao bookDao, AuthorService authorService, UserReadingInfoService userReadingInfoService) {
        this(bookTransformer, bookDao, authorService, null, null, null, userReadingInfoService, null, null, null, null, null, null);
    }

    @Override
    public BookDao getDao() {
        return bookDao;
    }

    @Override
    public BookTransformer getTransformer() {
        return bookTransformer;
    }

    @Override
    public BookDto create(BookDto dto) {
        log.info("BookService: create() called");
        normalizeBookRelations(dto);
        normalizeInventoryForCreate(dto);
        BookDto createdBook = getTransformer().transformEntityToDto(getDao().create(getTransformer().transformDtoToEntity(dto)));
        syncBookSearchIndex(createdBook.getId());
        return createdBook;
    }

    @Override
    public BookDto update(BookDto dto, Long id) {
        log.info("BookService: update() called");
        Optional<Book> book = getDao().findById(id);
        if (book.isEmpty())
            throw new EntityNotFoundException("Book not found for id: " + id);

        normalizeBookRelations(dto);
        normalizeInventoryForUpdate(dto, book.get());
        getTransformer().updateEntity(dto, book.get());
        BookDto updatedBook = getTransformer().transformEntityToDto(getDao().update(book.get()));
        syncBookSearchIndex(updatedBook.getId());
        return updatedBook;
    }

    @Override
    public void deleteById(Long id) {
        log.info("BookService: deleteById() called");
        Optional<Book> optionalBook = getDao().findById(id);
        if (optionalBook.isEmpty())
            throw new EntityNotFoundException("Book not found for id: " + id);

        Book book = optionalBook.get();
        book.setMarkedAsDeleted(true);
        getDao().update(book);
        syncBookSearchIndex(id);
    }

    private void syncBookSearchIndex(Long bookId) {
        if (bookSearchIndexService == null || bookId == null) {
            return;
        }
        try {
            bookSearchIndexService.indexBook(bookId);
        } catch (Exception exception) {
            log.warn("BookService: skip search index sync for bookId={} because {}",
                    bookId, exception.getMessage());
        }
    }

    private void normalizeBookRelations(BookDto dto) {
        dto.setAuthor(authorService.findById(dto.getAuthor().getId()));
        if (bookCategoryService != null && dto.getCategory() != null) {
            dto.setCategory(bookCategoryService.findById(dto.getCategory().getId()));
        }
        if (publisherService != null) {
            dto.setPublisher(dto.getPublisher() == null || dto.getPublisher().getId() == null
                    ? null
                    : publisherService.findById(dto.getPublisher().getId()));
        }
        if (tagService != null) {
            Set<TagDto> normalizedTags = dto.getTags() == null
                    ? new LinkedHashSet<>()
                    : dto.getTags().stream()
                    .filter(tagDto -> tagDto.getId() != null)
                    .map(tagDto -> tagService.findById(tagDto.getId()))
                    .collect(Collectors.toCollection(LinkedHashSet::new));
            dto.setTags(normalizedTags);
        }
    }

    private void normalizeInventoryForCreate(BookDto dto) {
        Integer totalCopies = dto.getTotalCopies() == null ? 1 : dto.getTotalCopies();
        if (totalCopies < 1) {
            throw new EntityExistsException("Total copies must be at least 1.");
        }
        dto.setTotalCopies(totalCopies);
        dto.setAvailableCopies(totalCopies);
    }

    private void normalizeInventoryForUpdate(BookDto dto, Book existingBook) {
        Integer totalCopies = dto.getTotalCopies() == null ? existingBook.getTotalCopies() : dto.getTotalCopies();
        if (totalCopies < 1) {
            throw new EntityExistsException("Total copies must be at least 1.");
        }
        long activeLoans = bookLoanDao == null
                ? Math.max(0, existingBook.getTotalCopies() - existingBook.getAvailableCopies())
                : bookLoanDao.countActiveLoansByBookId(existingBook.getId());
        if (totalCopies < activeLoans) {
            throw new EntityExistsException("Total copies cannot be lower than active borrowed copies.");
        }
        dto.setTotalCopies(totalCopies);
        dto.setAvailableCopies((int) (totalCopies - activeLoans));
    }

    @Override
    public List<BookDto> findAllBooksByAuthorId(Long authorId) {
        log.info("BookService: findAllBooksByAuthorId() called");
        return getTransformer().transformEntityToDto(getDao().findAllBooksByAuthorId(authorId));
    }

    @Override
    public PaginationResponse<BookDto> findAllBooksPaginatedAndFiltered(FilterPaginationRequest<BookFilterPaginationRequest> bookFilterPaginationRequest) {
        log.info("BookService: findAllBooksPaginatedAndFiltered() called");
        return buildPaginationResponse(getDao().findAllBooksPaginatedAndFiltered(bookFilterPaginationRequest));
    }

    @Override
    public List<BookDto> findAllRecommendedBooks() {
        log.info("BookService: findAllRecommendedBooks() called");
        List<Book> recommendedBooks = recommendByPreferredCategories(Collections.emptySet(), MIN_OF_RECOMMENDED_BOOKS);
        if (recommendedBooks.isEmpty()) {
            recommendedBooks = findPopularBookEntities(MIN_OF_RECOMMENDED_BOOKS, Collections.emptySet());
        }
        return getTransformer().transformEntityToDto(recommendedBooks);
    }

    @Override
    public List<BookDto> findPopularBooks(Integer limit) {
        return findPopularBooks(limit, DEFAULT_POPULAR_RECENT_DAYS);
    }

    @Override
    public List<BookDto> findPopularBooks(Integer limit, Integer recentDays) {
        log.info("BookService: findPopularBooks() called");
        int normalizedLimit = sanitizeLimit(limit, DEFAULT_RECOMMENDATION_LIMIT);
        int normalizedRecentDays = recentDays == null || recentDays < 1 ? DEFAULT_POPULAR_RECENT_DAYS : recentDays;
        if (behaviorAnalyticsService != null) {
            List<BookDto> popularBooks = behaviorAnalyticsService.findPopularBooks(normalizedLimit, normalizedRecentDays);
            if (!popularBooks.isEmpty()) {
                return popularBooks;
            }
        }
        return getTransformer().transformEntityToDto(findPopularBookEntities(normalizedLimit, Collections.emptySet()));
    }

    @Override
    public BookRecommendationOverviewDto findRecommendationOverview() {
        return findRecommendationOverview(DEFAULT_POPULAR_RECENT_DAYS);
    }

    @Override
    public BookRecommendationOverviewDto findRecommendationOverview(Integer recentDays) {
        log.info("BookService: findRecommendationOverview() called");
        int normalizedRecentDays = recentDays == null || recentDays < 1 ? DEFAULT_POPULAR_RECENT_DAYS : recentDays;
        List<BookRecommendationShelfDto> shelves = new ArrayList<>();

        List<Book> popularBooks = findPopularBookEntities(DEFAULT_RECOMMENDATION_LIMIT, Collections.emptySet());
        if (behaviorAnalyticsService != null) {
            List<BookDto> behaviorPopularBooks = behaviorAnalyticsService.findPopularBooks(DEFAULT_RECOMMENDATION_LIMIT, normalizedRecentDays);
            if (!behaviorPopularBooks.isEmpty()) {
                popularBooks = fetchBooksByIdsPreservingOrder(behaviorPopularBooks.stream()
                        .map(BookDto::getId)
                        .collect(Collectors.toList()));
            }
        }
        if (!popularBooks.isEmpty()) {
            shelves.add(buildShelf("popular", "Popular Books",
                    String.format("Combined popularity over the last %d days using borrow, click, and rating signals.", normalizedRecentDays),
                    popularBooks,
                    book -> String.format("Recently popular: %d ratings, average %.1f, available %d/%d copies.",
                            safeLong(book.getUsersRateCount()),
                            safeDouble(book.getRate()),
                            safeInt(book.getAvailableCopies()),
                            safeInt(book.getTotalCopies()))));
        }

        Set<Long> usedBookIds = popularBooks.stream().map(Book::getId).collect(Collectors.toSet());
        List<Book> collaborativeBooks = recommendByCollaborativeFiltering(usedBookIds, DEFAULT_RECOMMENDATION_LIMIT);
        if (!collaborativeBooks.isEmpty()) {
            shelves.add(buildShelf("collaborative", "Readers Like You",
                    "Recommendations inferred from users with similar rating patterns.",
                    collaborativeBooks,
                    book -> String.format("Users with similar tastes also liked %s. Current rating %.1f.",
                            safeString(book.getName()),
                            safeDouble(book.getRate()))));
            usedBookIds.addAll(collaborativeBooks.stream().map(Book::getId).collect(Collectors.toSet()));
        }

        List<Book> preferenceBooks = recommendByPreferredCategories(usedBookIds, DEFAULT_RECOMMENDATION_LIMIT);
        if (!preferenceBooks.isEmpty()) {
            shelves.add(buildShelf("preferences", "Preferred Categories",
                    "Recommendations aligned with the categories selected in your profile.",
                    preferenceBooks,
                    book -> String.format("Matches your preferred category: %s.",
                            localizeCategoryName(book.getCategory() == null ? null : book.getCategory().getName()))));
            usedBookIds.addAll(preferenceBooks.stream().map(Book::getId).collect(Collectors.toSet()));
        }

        List<Book> activityBooks = recommendByUserActivity(usedBookIds, DEFAULT_RECOMMENDATION_LIMIT);
        if (!activityBooks.isEmpty()) {
            shelves.add(buildShelf("activity", "Based On Your Activity",
                    "Built from the categories and tags of books you rated or borrowed.",
                    activityBooks,
                    book -> String.format("Close to books you already engaged with in category %s.",
                            localizeCategoryName(book.getCategory() == null ? null : book.getCategory().getName()))));
        }

        return new BookRecommendationOverviewDto(String.format("Recommendation Shelves (%d-day window)", normalizedRecentDays), shelves);
    }

    @Override
    public BookRecommendationOverviewDto findBookSimilarityRecommendations(Long bookId) {
        log.info("BookService: findBookSimilarityRecommendations() called");
        Book sourceBook = getDao().findById(bookId)
                .filter(book -> !Boolean.TRUE.equals(book.getMarkedAsDeleted()))
                .orElseThrow(() -> new EntityNotFoundException("Book not found for id: " + bookId));

        List<BookRecommendationShelfDto> shelves = new ArrayList<>();
        Set<Long> excludedIds = new HashSet<>();
        excludedIds.add(bookId);

        List<Book> sameCategoryBooks = sourceBook.getCategory() == null || sourceBook.getCategory().getId() == null
                ? Collections.emptyList()
                : getDao().getRepository().findSimilarBooksByCategory(
                        bookId,
                        sourceBook.getCategory().getId(),
                        topNRequest(resolveCandidatePoolLimit(DETAIL_RECOMMENDATION_LIMIT))
                ).stream()
                .sorted(Comparator
                        .comparingInt((Book book) -> sharedTagCount(sourceBook, book)).reversed()
                        .thenComparing(popularityComparator()))
                .limit(DETAIL_RECOMMENDATION_LIMIT)
                .collect(Collectors.toList());
        if (!sameCategoryBooks.isEmpty()) {
            shelves.add(buildShelf("same-category", "Same Category",
                    "Books from the same category, ranked by shared tags and popularity.",
                    sameCategoryBooks,
                    book -> String.format("%s is in the same category %s and shares %d tags.",
                            safeString(sourceBook.getName()),
                            localizeCategoryName(book.getCategory() == null ? null : book.getCategory().getName()),
                            sharedTagCount(sourceBook, book))));
            excludedIds.addAll(sameCategoryBooks.stream().map(Book::getId).collect(Collectors.toSet()));
        }

        Set<Long> sourceTagIds = extractTagIds(sourceBook);
        List<Book> tagSimilarBooks = sourceTagIds.isEmpty()
                ? Collections.emptyList()
                : getDao().getRepository().findBooksByTagIdsExcluding(
                        sourceTagIds,
                        excludedIds,
                        topNRequest(resolveCandidatePoolLimit(DETAIL_RECOMMENDATION_LIMIT))
                ).stream()
                .filter(book -> sharedTagCount(sourceBook, book) > 0)
                .sorted(Comparator
                        .comparingInt((Book book) -> sharedTagCount(sourceBook, book)).reversed()
                        .thenComparing(popularityComparator()))
                .limit(DETAIL_RECOMMENDATION_LIMIT)
                .collect(Collectors.toList());
        if (!tagSimilarBooks.isEmpty()) {
            shelves.add(buildShelf("shared-tags", "Shared Tags",
                    "Books that overlap with the current title on one or more tags.",
                    tagSimilarBooks,
                    book -> String.format("%s shares %d tags: %s.",
                            safeString(sourceBook.getName()),
                            sharedTagCount(sourceBook, book),
                            describeSharedTags(sourceBook, book))));
            excludedIds.addAll(tagSimilarBooks.stream().map(Book::getId).collect(Collectors.toSet()));
        }

        if (shelves.isEmpty()) {
            List<Book> fallbackBooks = findPopularBookEntities(DETAIL_RECOMMENDATION_LIMIT, excludedIds);
            if (!fallbackBooks.isEmpty()) {
                shelves.add(buildShelf("fallback", "Fallback Picks",
                        "Used when the current book has too few close neighbors.",
                        fallbackBooks,
                        book -> String.format("Fallback popular recommendation: %s.", safeString(book.getName()))));
            }
        }

        return new BookRecommendationOverviewDto("Similar Book Recommendations", shelves);
    }

    private List<Book> findPopularBookEntities(int limit, Set<Long> excludedIds) {
        if (excludedIds == null || excludedIds.isEmpty()) {
            return getDao().getRepository().findPopularBooks(topNRequest(limit));
        }
        return getDao().getRepository().findPopularBooksExcluding(excludedIds, topNRequest(limit));
    }

    private List<Book> recommendByPreferredCategories(Set<Long> excludedIds, int limit) {
        try {
            Set<Long> preferredCategoryIds = userReadingInfoService.findUserReadingInfo().getUserBookCategories().stream()
                    .map(userBookCategoryDto -> userBookCategoryDto.getCategory())
                    .filter(categoryDto -> categoryDto != null && categoryDto.getId() != null)
                    .map(categoryDto -> categoryDto.getId())
                    .collect(Collectors.toSet());
            if (preferredCategoryIds.isEmpty()) {
                return Collections.emptyList();
            }

            if (excludedIds == null || excludedIds.isEmpty()) {
                return getDao().getRepository().findRecommendedByCategoryIds(preferredCategoryIds, topNRequest(limit));
            }
            return getDao().getRepository().findRecommendedByCategoryIdsExcluding(preferredCategoryIds, excludedIds, topNRequest(limit));
        } catch (Exception e) {
            return Collections.emptyList();
        }
    }

    private List<Book> recommendByCollaborativeFiltering(Set<Long> excludedIds, int limit) {
        if (userService == null || collaborativeFilteringRecommender == null) {
            return Collections.emptyList();
        }

        try {
            Long userId = userService.getCurrentUser().getId();
            return collaborativeFilteringRecommender.recommendedBooks(userId).stream()
                    .filter(book -> book != null && book.getId() != null)
                    .filter(book -> !Boolean.TRUE.equals(book.getMarkedAsDeleted()))
                    .filter(book -> !excludedIds.contains(book.getId()))
                    .limit(limit)
                    .collect(Collectors.toList());
        } catch (Exception e) {
            log.warn("BookService: collaborative filtering unavailable, fallback to other shelves - {}", e.getMessage());
            return Collections.emptyList();
        }
    }

    private List<Book> recommendByUserActivity(Set<Long> excludedIds, int limit) {
        if (userService == null || userBookRateDao == null || bookLoanDao == null) {
            return Collections.emptyList();
        }

        try {
            Long userId = userService.getCurrentUser().getId();
            Map<Long, Integer> categoryWeights = new HashMap<>();
            Map<Long, Integer> tagWeights = new HashMap<>();
            Set<Long> interactedBookIds = new HashSet<>(excludedIds);

            for (UserBookRate rate : userBookRateDao.findAllByUserId(userId)) {
                collectInteractionWeights(rate.getBook(), Math.max(1, rate.getRate() == null ? 2 : rate.getRate()), categoryWeights, tagWeights, interactedBookIds);
            }
            for (BookLoan activeLoan : bookLoanDao.findCurrentUserActiveLoans(userId)) {
                collectInteractionWeights(activeLoan.getBook(), 2, categoryWeights, tagWeights, interactedBookIds);
            }
            for (BookLoan historyLoan : bookLoanDao.findCurrentUserLoanHistory(userId)) {
                collectInteractionWeights(historyLoan.getBook(), 1, categoryWeights, tagWeights, interactedBookIds);
            }

            if (categoryWeights.isEmpty() && tagWeights.isEmpty()) {
                return Collections.emptyList();
            }

            List<Book> candidateBooks = findActivityCandidateBooks(categoryWeights.keySet(), tagWeights.keySet(), interactedBookIds, limit);
            return candidateBooks.stream()
                    .filter(book -> !interactedBookIds.contains(book.getId()))
                    .map(book -> new AbstractMap.SimpleEntry<>(book, calculateActivityScore(book, categoryWeights, tagWeights)))
                    .filter(entry -> entry.getValue() > 0)
                    .sorted(Comparator
                            .comparingInt((AbstractMap.SimpleEntry<Book, Integer> entry) -> entry.getValue()).reversed()
                            .thenComparing(entry -> safeLong(entry.getKey().getUsersRateCount()), Comparator.reverseOrder())
                            .thenComparing(entry -> safeDouble(entry.getKey().getRate()), Comparator.reverseOrder())
                            .thenComparing(entry -> safeInt(entry.getKey().getAvailableCopies()), Comparator.reverseOrder())
                            .thenComparing(entry -> safeString(entry.getKey().getName())))
                    .map(AbstractMap.SimpleEntry::getKey)
                    .limit(limit)
                    .collect(Collectors.toList());
        } catch (Exception e) {
            return Collections.emptyList();
        }
    }

    private List<Book> findActivityCandidateBooks(Set<Long> categoryIds,
                                                  Set<Long> tagIds,
                                                  Set<Long> excludedIds,
                                                  int limit) {
        Map<Long, Book> candidateBooks = new LinkedHashMap<>();
        int candidatePoolLimit = resolveCandidatePoolLimit(limit);

        if (categoryIds != null && !categoryIds.isEmpty()) {
            List<Book> categoryBooks = excludedIds == null || excludedIds.isEmpty()
                    ? getDao().getRepository().findRecommendedByCategoryIds(categoryIds, topNRequest(candidatePoolLimit))
                    : getDao().getRepository().findRecommendedByCategoryIdsExcluding(categoryIds, excludedIds, topNRequest(candidatePoolLimit));
            categoryBooks.forEach(book -> candidateBooks.putIfAbsent(book.getId(), book));
        }

        if (tagIds != null && !tagIds.isEmpty()) {
            List<Book> tagBooks = excludedIds == null || excludedIds.isEmpty()
                    ? getDao().getRepository().findBooksByTagIds(tagIds, topNRequest(candidatePoolLimit))
                    : getDao().getRepository().findBooksByTagIdsExcluding(tagIds, excludedIds, topNRequest(candidatePoolLimit));
            tagBooks.forEach(book -> candidateBooks.putIfAbsent(book.getId(), book));
        }

        return new ArrayList<>(candidateBooks.values());
    }

    private List<Book> fetchBooksByIdsPreservingOrder(List<Long> bookIds) {
        if (bookIds == null || bookIds.isEmpty()) {
            return Collections.emptyList();
        }
        Map<Long, Book> booksById = getDao().getRepository().findAllById(bookIds).stream()
                .filter(book -> !Boolean.TRUE.equals(book.getMarkedAsDeleted()))
                .collect(Collectors.toMap(Book::getId, Function.identity()));

        List<Book> orderedBooks = new ArrayList<>();
        for (Long bookId : bookIds) {
            Book book = booksById.get(bookId);
            if (book != null) {
                orderedBooks.add(book);
            }
        }
        return orderedBooks;
    }

    private void collectInteractionWeights(Book book,
                                           int weight,
                                           Map<Long, Integer> categoryWeights,
                                           Map<Long, Integer> tagWeights,
                                           Set<Long> interactedBookIds) {
        if (book == null || Boolean.TRUE.equals(book.getMarkedAsDeleted()) || book.getId() == null) {
            return;
        }
        interactedBookIds.add(book.getId());
        if (book.getCategory() != null && book.getCategory().getId() != null) {
            categoryWeights.merge(book.getCategory().getId(), weight, Integer::sum);
        }
        extractTagIds(book).forEach(tagId -> tagWeights.merge(tagId, weight, Integer::sum));
    }

    private int calculateActivityScore(Book book, Map<Long, Integer> categoryWeights, Map<Long, Integer> tagWeights) {
        int score = 0;
        if (book.getCategory() != null && book.getCategory().getId() != null) {
            score += categoryWeights.getOrDefault(book.getCategory().getId(), 0) * 3;
        }
        for (Long tagId : extractTagIds(book)) {
            score += tagWeights.getOrDefault(tagId, 0) * 2;
        }
        return score;
    }

    private Set<Long> extractTagIds(Book book) {
        if (book == null || book.getTags() == null) {
            return Collections.emptySet();
        }
        return book.getTags().stream()
                .filter(tag -> tag != null && tag.getId() != null)
                .map(tag -> tag.getId())
                .collect(Collectors.toSet());
    }

    private int sharedTagCount(Book sourceBook, Book candidateBook) {
        Set<Long> sourceTagIds = extractTagIds(sourceBook);
        if (sourceTagIds.isEmpty()) {
            return 0;
        }
        int count = 0;
        for (Long candidateTagId : extractTagIds(candidateBook)) {
            if (sourceTagIds.contains(candidateTagId)) {
                count++;
            }
        }
        return count;
    }

    private String describeSharedTags(Book sourceBook, Book candidateBook) {
        Set<Long> sourceTagIds = extractTagIds(sourceBook);
        if (sourceTagIds.isEmpty() || candidateBook == null || candidateBook.getTags() == null) {
            return "No shared tags available";
        }
        String sharedTags = candidateBook.getTags().stream()
                .filter(tag -> tag != null && tag.getId() != null && sourceTagIds.contains(tag.getId()))
                .map(tag -> safeString(tag.getName()))
                .filter(name -> !name.isBlank())
                .sorted()
                .collect(Collectors.joining(", "));
        return sharedTags.isBlank() ? "No shared tags" : sharedTags;
    }

    private Comparator<Book> popularityComparator() {
        return Comparator
                .comparingLong((Book book) -> safeLong(book.getUsersRateCount())).reversed()
                .thenComparing((Book book) -> safeDouble(book.getRate()), Comparator.reverseOrder())
                .thenComparing((Book book) -> safeInt(book.getAvailableCopies()), Comparator.reverseOrder())
                .thenComparing(book -> safeString(book.getName()));
    }

    private long safeLong(Long value) {
        return value == null ? 0L : value;
    }

    private double safeDouble(Double value) {
        return value == null ? 0D : value;
    }

    private int safeInt(Integer value) {
        return value == null ? 0 : value;
    }

    private String safeString(String value) {
        return value == null ? "" : value;
    }

    private String localizeCategoryName(String value) {
        String normalizedValue = safeString(value).trim();
        if (normalizedValue.isEmpty()) {
            return "Uncategorized";
        }
        return CATEGORY_NAME_MAP.getOrDefault(normalizedValue, normalizedValue);
    }

    private int sanitizeLimit(Integer limit, int fallback) {
        if (limit == null || limit < 1) {
            return fallback;
        }
        return Math.min(limit, 24);
    }

    private int resolveCandidatePoolLimit(int limit) {
        return Math.min(Math.max(limit * CANDIDATE_POOL_MULTIPLIER, 24), 120);
    }

    private PageRequest topNRequest(int limit) {
        return PageRequest.of(0, Math.max(limit, 1));
    }

    private BookRecommendationShelfDto buildShelf(String key, String title, String description, List<Book> books) {
        return buildShelf(key, title, description, books, book -> description);
    }

    private BookRecommendationShelfDto buildShelf(String key,
                                                  String title,
                                                  String description,
                                                  List<Book> books,
                                                  Function<Book, String> reasonBuilder) {
        List<BookDto> bookDtos = getTransformer().transformEntityToDto(books);
        for (BookDto bookDto : bookDtos) {
            bookDto.setRecommendationSource(key);
            books.stream()
                    .filter(book -> book.getId() != null && book.getId().equals(bookDto.getId()))
                    .findFirst()
                    .ifPresent(book -> bookDto.setRecommendationReason(reasonBuilder.apply(book)));
        }
        return new BookRecommendationShelfDto(key, title, description, bookDtos);
    }

    // free hosting cause leak algo speed for fetching
//    @Override
//    public List<BookDto> findAllRecommendedBooks() {
//        log.info("BookService: findAllRecommendedBooks() called");
//        UserDto currentUser = userService.getCurrentUser();
//        List<Book> books = collaborativeFilteringRecommender.recommendedBooks(currentUser.getId());
//        if (books.size() < MIN_OF_RECOMMENDED_BOOKS) {
//            books.addAll(getDao().findAllBooksByCategoriesAndLimit(
//                    userReadingInfoService.findUserReadingInfo().getUserBookCategories().stream().map(
//                    userBookCategoryDto -> userBookCategoryDto.getCategory().getName()
//            ).collect(Collectors.toList()), MIN_OF_RECOMMENDED_BOOKS - books.size()));
//        }
//        return getTransformer().transformEntityToDto(books);
//    }
}
