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
import org.springframework.stereotype.Service;

import javax.persistence.EntityExistsException;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
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
    private static final Map<String, String> CATEGORY_NAME_MAP = Map.of(
            "Science Fiction", "科幻",
            "Horror", "恐怖",
            "Classic", "经典",
            "Action and Adventure", "动作冒险",
            "Romantic", "爱情",
            "Kids", "儿童",
            "History", "历史",
            "Sport", "体育"
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
                           CollaborativeFilteringRecommender collaborativeFilteringRecommender) {
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
                userReadingInfoService, bookLoanDao, userService, userBookRateDao, null);
    }

    public BookServiceImpl(BookTransformer bookTransformer, BookDao bookDao, AuthorService authorService, BookCategoryService bookCategoryService, PublisherService publisherService, TagService tagService, UserReadingInfoService userReadingInfoService, BookLoanDao bookLoanDao) {
        this(bookTransformer, bookDao, authorService, bookCategoryService, publisherService, tagService, userReadingInfoService, bookLoanDao, null, null, null);
    }

    public BookServiceImpl(BookTransformer bookTransformer, BookDao bookDao, AuthorService authorService, UserReadingInfoService userReadingInfoService) {
        this(bookTransformer, bookDao, authorService, null, null, null, userReadingInfoService, null, null, null, null);
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
        return getTransformer().transformEntityToDto(getDao().create(getTransformer().transformDtoToEntity(dto)));
    }

    @Override
    public BookDto update(BookDto dto, Long id) {
        log.info("BookService: update() called");
        Optional<Book> book = getDao().findById(id);
        if (book.isEmpty())
            throw new EntityExistsException("Book not found for id: " + id);

        normalizeBookRelations(dto);
        normalizeInventoryForUpdate(dto, book.get());
        getTransformer().updateEntity(dto, book.get());
        return getTransformer().transformEntityToDto(getDao().update(book.get()));
    }

    @Override
    public void deleteById(Long id) {
        log.info("BookService: deleteById() called");
        Optional<Book> optionalBook = getDao().findById(id);
        if (optionalBook.isEmpty())
            throw new EntityExistsException("Book not found for id: " + id);

        Book book = optionalBook.get();
        book.setMarkedAsDeleted(true);
        getDao().update(book);
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
        List<Book> recommendedBooks = recommendByPreferredCategories(findActiveBooks(), Collections.emptySet(), MIN_OF_RECOMMENDED_BOOKS);
        if (recommendedBooks.isEmpty()) {
            recommendedBooks = findPopularBookEntities(MIN_OF_RECOMMENDED_BOOKS, Collections.emptySet());
        }
        return getTransformer().transformEntityToDto(recommendedBooks);
    }

    @Override
    public List<BookDto> findPopularBooks(Integer limit) {
        log.info("BookService: findPopularBooks() called");
        return getTransformer().transformEntityToDto(findPopularBookEntities(sanitizeLimit(limit, DEFAULT_RECOMMENDATION_LIMIT), Collections.emptySet()));
    }

    @Override
    public BookRecommendationOverviewDto findRecommendationOverview() {
        log.info("BookService: findRecommendationOverview() called");
        List<Book> activeBooks = findActiveBooks();
        List<BookRecommendationShelfDto> shelves = new ArrayList<>();

        List<Book> popularBooks = findPopularBookEntities(DEFAULT_RECOMMENDATION_LIMIT, Collections.emptySet());
        if (!popularBooks.isEmpty()) {
            shelves.add(buildShelf("popular", "近期热门",
                    "综合评分人数、平均分和可借库存生成的热门图书榜单。",
                    popularBooks,
                    book -> String.format("近期热门：%d 位读者评分，平均分 %.1f，当前可借 %d/%d 本。",
                            safeLong(book.getUsersRateCount()),
                            safeDouble(book.getRate()),
                            safeInt(book.getAvailableCopies()),
                            safeInt(book.getTotalCopies()))));
        }

        Set<Long> usedBookIds = popularBooks.stream().map(Book::getId).collect(Collectors.toSet());
        List<Book> collaborativeBooks = recommendByCollaborativeFiltering(usedBookIds, DEFAULT_RECOMMENDATION_LIMIT);
        if (!collaborativeBooks.isEmpty()) {
            shelves.add(buildShelf("collaborative", "同类读者也喜欢",
                    "根据与你评分模式相近的用户生成的协同过滤推荐。",
                    collaborativeBooks,
                    book -> String.format("同类读者偏好：协同过滤认为你可能喜欢《%s》，当前评分 %.1f。",
                            safeString(book.getName()),
                            safeDouble(book.getRate()))));
            usedBookIds.addAll(collaborativeBooks.stream().map(Book::getId).collect(Collectors.toSet()));
        }

        List<Book> preferenceBooks = recommendByPreferredCategories(activeBooks, usedBookIds, DEFAULT_RECOMMENDATION_LIMIT);
        if (!preferenceBooks.isEmpty()) {
            shelves.add(buildShelf("preferences", "符合你的阅读偏好",
                    "匹配你在个人中心选择的偏好分类。",
                    preferenceBooks,
                    book -> String.format("与你偏好的“%s”分类一致。",
                            localizeCategoryName(book.getCategory() == null ? null : book.getCategory().getName()))));
            usedBookIds.addAll(preferenceBooks.stream().map(Book::getId).collect(Collectors.toSet()));
        }

        List<Book> activityBooks = recommendByUserActivity(activeBooks, usedBookIds, DEFAULT_RECOMMENDATION_LIMIT);
        if (!activityBooks.isEmpty()) {
            shelves.add(buildShelf("activity", "基于你的评分和借阅行为",
                    "根据你评分或借阅过图书的分类与标签生成推荐。",
                    activityBooks,
                    book -> String.format("与你高分或借阅过的图书在“%s”分类或相近标签上更接近。",
                            localizeCategoryName(book.getCategory() == null ? null : book.getCategory().getName()))));
        }

        return new BookRecommendationOverviewDto("推荐书架", shelves);
    }

    @Override
    public BookRecommendationOverviewDto findBookSimilarityRecommendations(Long bookId) {
        log.info("BookService: findBookSimilarityRecommendations() called");
        Book sourceBook = getDao().findById(bookId)
                .filter(book -> !Boolean.TRUE.equals(book.getMarkedAsDeleted()))
                .orElseThrow(() -> new EntityExistsException("Book not found for id: " + bookId));

        List<Book> activeBooks = findActiveBooks().stream()
                .filter(book -> !bookId.equals(book.getId()))
                .collect(Collectors.toList());
        List<BookRecommendationShelfDto> shelves = new ArrayList<>();
        Set<Long> excludedIds = new HashSet<>();
        excludedIds.add(bookId);

        List<Book> sameCategoryBooks = activeBooks.stream()
                .filter(book -> book.getCategory() != null
                        && sourceBook.getCategory() != null
                        && sourceBook.getCategory().getId().equals(book.getCategory().getId()))
                .sorted(Comparator
                        .comparingInt((Book book) -> sharedTagCount(sourceBook, book)).reversed()
                        .thenComparing(popularityComparator()))
                .limit(DETAIL_RECOMMENDATION_LIMIT)
                .collect(Collectors.toList());
        if (!sameCategoryBooks.isEmpty()) {
            shelves.add(buildShelf("same-category", "同分类推荐",
                    "优先推荐同分类图书，并结合共享标签数量和热度排序。",
                    sameCategoryBooks,
                    book -> String.format("与《%s》同属“%s”分类，并共享 %d 个标签。",
                            safeString(sourceBook.getName()),
                            localizeCategoryName(book.getCategory() == null ? null : book.getCategory().getName()),
                            sharedTagCount(sourceBook, book))));
            excludedIds.addAll(sameCategoryBooks.stream().map(Book::getId).collect(Collectors.toSet()));
        }

        Set<Long> sourceTagIds = extractTagIds(sourceBook);
        List<Book> tagSimilarBooks = sourceTagIds.isEmpty()
                ? Collections.emptyList()
                : activeBooks.stream()
                .filter(book -> !excludedIds.contains(book.getId()))
                .filter(book -> sharedTagCount(sourceBook, book) > 0)
                .sorted(Comparator
                        .comparingInt((Book book) -> sharedTagCount(sourceBook, book)).reversed()
                        .thenComparing(popularityComparator()))
                .limit(DETAIL_RECOMMENDATION_LIMIT)
                .collect(Collectors.toList());
        if (!tagSimilarBooks.isEmpty()) {
            shelves.add(buildShelf("shared-tags", "相似标签推荐",
                    "推荐与当前图书共享一个或多个标签的相似图书。",
                    tagSimilarBooks,
                    book -> String.format("与《%s》共享 %d 个标签：%s。",
                            safeString(sourceBook.getName()),
                            sharedTagCount(sourceBook, book),
                            describeSharedTags(sourceBook, book))));
            excludedIds.addAll(tagSimilarBooks.stream().map(Book::getId).collect(Collectors.toSet()));
        }

        if (shelves.isEmpty()) {
            List<Book> fallbackBooks = findPopularBookEntities(DETAIL_RECOMMENDATION_LIMIT, excludedIds);
            if (!fallbackBooks.isEmpty()) {
                shelves.add(buildShelf("fallback", "读者还在看",
                        "当当前图书相似邻居较少时，补充展示更热门的可浏览图书。",
                        fallbackBooks,
                        book -> String.format("当前书籍邻近样本较少，补充展示近期更热门的《%s》。", safeString(book.getName()))));
            }
        }

        return new BookRecommendationOverviewDto("相关图书", shelves);
    }

    private List<Book> findActiveBooks() {
        return getDao().findAll().stream()
                .filter(book -> !Boolean.TRUE.equals(book.getMarkedAsDeleted()))
                .collect(Collectors.toList());
    }

    private List<Book> findPopularBookEntities(int limit, Set<Long> excludedIds) {
        return findActiveBooks().stream()
                .filter(book -> !excludedIds.contains(book.getId()))
                .sorted(popularityComparator())
                .limit(limit)
                .collect(Collectors.toList());
    }

    private List<Book> recommendByPreferredCategories(List<Book> activeBooks, Set<Long> excludedIds, int limit) {
        try {
            Set<Long> preferredCategoryIds = userReadingInfoService.findUserReadingInfo().getUserBookCategories().stream()
                    .map(userBookCategoryDto -> userBookCategoryDto.getCategory())
                    .filter(categoryDto -> categoryDto != null && categoryDto.getId() != null)
                    .map(categoryDto -> categoryDto.getId())
                    .collect(Collectors.toSet());
            if (preferredCategoryIds.isEmpty()) {
                return Collections.emptyList();
            }

            return activeBooks.stream()
                    .filter(book -> !excludedIds.contains(book.getId()))
                    .filter(book -> book.getCategory() != null && preferredCategoryIds.contains(book.getCategory().getId()))
                    .sorted(popularityComparator())
                    .limit(limit)
                    .collect(Collectors.toList());
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

    private List<Book> recommendByUserActivity(List<Book> activeBooks, Set<Long> excludedIds, int limit) {
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

            return activeBooks.stream()
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
            return "暂无标签交集";
        }
        String sharedTags = candidateBook.getTags().stream()
                .filter(tag -> tag != null && tag.getId() != null && sourceTagIds.contains(tag.getId()))
                .map(tag -> safeString(tag.getName()))
                .filter(name -> !name.isBlank())
                .sorted()
                .collect(Collectors.joining(", "));
        return sharedTags.isBlank() ? "暂无标签交集" : sharedTags;
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
            return "未分类";
        }
        return CATEGORY_NAME_MAP.getOrDefault(normalizedValue, normalizedValue);
    }

    private int sanitizeLimit(Integer limit, int fallback) {
        if (limit == null || limit < 1) {
            return fallback;
        }
        return Math.min(limit, 24);
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
