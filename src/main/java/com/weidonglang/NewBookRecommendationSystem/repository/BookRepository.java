package com.weidonglang.NewBookRecommendationSystem.repository;

import com.weidonglang.NewBookRecommendationSystem.entity.Book;
import jakarta.persistence.LockModeType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Set;
@Repository
public interface BookRepository extends JpaRepository<Book, Long> {
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("SELECT b FROM Book b WHERE b.id = :id")
    java.util.Optional<Book> findByIdForUpdate(@Param("id") Long id);

    List<Book> findByMarkedAsDeletedFalseOrderByCreatedDateDesc(Pageable pageable);

    List<Book> findAllByAuthorIdAndMarkedAsDeletedFalse(Long authorId);

    Boolean existsByAuthorIdAndMarkedAsDeletedFalse(Long authorId);

    Boolean existsByPublisherIdAndMarkedAsDeletedFalse(Long publisherId);

    Boolean existsByTagsIdAndMarkedAsDeletedFalse(Long tagId);

    Boolean existsByCategoryIdAndMarkedAsDeletedFalse(Long categoryId);

    @Query("SELECT b FROM Book b WHERE b.markedAsDeleted = :deletedRecords ")
    Page<Book> findAll(Pageable pageable, Boolean deletedRecords);

    List<Book> findAllByCategoryNameInAndMarkedAsDeletedFalse(List<String> categories);

    @Query(
            value = "SELECT DISTINCT b FROM Book b LEFT JOIN b.tags t WHERE b.markedAsDeleted = :deletedRecords " +
                    "AND ((:name) IS NULL OR lower(b.name) like %:name% OR lower(coalesce(b.isbn, '')) like %:name% OR lower(b.author.name) like %:name% " +
                    "OR lower(b.category.name) like %:name% OR lower(coalesce(b.publisher.name, '')) like %:name% " +
                    "OR lower(coalesce(t.name, '')) like %:name%) " +
                    "AND ((:fromPrice) IS NULL OR b.price >= :fromPrice) " +
                    "AND ((:toPrice) IS NULL OR b.price <= :toPrice) " +
                    "AND ((:fromPagesNumber) IS NULL OR b.pagesNumber >= :fromPagesNumber) " +
                    "AND ((:toPagesNumber) IS NULL OR b.pagesNumber <= :toPagesNumber) " +
                    "AND ((:fromReadingDuration) IS NULL OR b.readingDuration >= :fromReadingDuration) " +
                    "AND ((:toReadingDuration) IS NULL OR b.readingDuration <= :toReadingDuration) " +
                    "AND ((:categories) IS NULL OR b.category.id IN (:categories)) " +
                    "AND ((:authors) IS NULL OR b.author.id IN (:authors)) " +
                    "AND ((:publishers) IS NULL OR b.publisher.id IN (:publishers)) " +
                    "AND ((:tags) IS NULL OR t.id IN (:tags)) ",
            countQuery = "SELECT COUNT(DISTINCT b.id) FROM Book b LEFT JOIN b.tags t WHERE b.markedAsDeleted = :deletedRecords " +
                    "AND ((:name) IS NULL OR lower(b.name) like %:name% OR lower(coalesce(b.isbn, '')) like %:name% OR lower(b.author.name) like %:name% " +
                    "OR lower(b.category.name) like %:name% OR lower(coalesce(b.publisher.name, '')) like %:name% " +
                    "OR lower(coalesce(t.name, '')) like %:name%) " +
                    "AND ((:fromPrice) IS NULL OR b.price >= :fromPrice) " +
                    "AND ((:toPrice) IS NULL OR b.price <= :toPrice) " +
                    "AND ((:fromPagesNumber) IS NULL OR b.pagesNumber >= :fromPagesNumber) " +
                    "AND ((:toPagesNumber) IS NULL OR b.pagesNumber <= :toPagesNumber) " +
                    "AND ((:fromReadingDuration) IS NULL OR b.readingDuration >= :fromReadingDuration) " +
                    "AND ((:toReadingDuration) IS NULL OR b.readingDuration <= :toReadingDuration) " +
                    "AND ((:categories) IS NULL OR b.category.id IN (:categories)) " +
                    "AND ((:authors) IS NULL OR b.author.id IN (:authors)) " +
                    "AND ((:publishers) IS NULL OR b.publisher.id IN (:publishers)) " +
                    "AND ((:tags) IS NULL OR t.id IN (:tags)) "
    )
    Page<Book> findAllBooksPaginatedAndFiltered(@Param("name") String name,
                                                @Param("categories") Set<Long> categories,
                                                @Param("authors") Set<Long> authors,
                                                @Param("publishers") Set<Long> publishers,
                                                @Param("tags") Set<Long> tags,
                                                @Param("fromPrice") Double fromPrice,
                                                @Param("toPrice") Double toPrice,
                                                @Param("fromPagesNumber") Integer fromPagesNumber,
                                                @Param("toPagesNumber") Integer toPagesNumber,
                                                @Param("fromReadingDuration") Integer fromReadingDuration,
                                                @Param("toReadingDuration") Integer toReadingDuration,
                                                @Param("deletedRecords") Boolean deletedRecords,
                                                Pageable pageable);

    @Query("SELECT b.id, b.usersRateCount FROM Book b WHERE b.markedAsDeleted = false ORDER BY b.usersRateCount DESC, b.rate DESC")
    List<Object[]> aggregateRatedBooks(Pageable pageable);

    @Query("SELECT b FROM Book b WHERE b.markedAsDeleted = false " +
            "ORDER BY b.usersRateCount DESC, b.rate DESC, b.availableCopies DESC, b.name ASC")
    List<Book> findPopularBooks(Pageable pageable);

    @Query("SELECT b FROM Book b WHERE b.markedAsDeleted = false AND b.id NOT IN :excludedIds " +
            "ORDER BY b.usersRateCount DESC, b.rate DESC, b.availableCopies DESC, b.name ASC")
    List<Book> findPopularBooksExcluding(@Param("excludedIds") Set<Long> excludedIds, Pageable pageable);

    @Query("SELECT b FROM Book b WHERE b.markedAsDeleted = false AND b.category.id IN :categoryIds " +
            "ORDER BY b.usersRateCount DESC, b.rate DESC, b.availableCopies DESC, b.name ASC")
    List<Book> findRecommendedByCategoryIds(@Param("categoryIds") Set<Long> categoryIds, Pageable pageable);

    @Query("SELECT b FROM Book b WHERE b.markedAsDeleted = false AND b.category.id IN :categoryIds AND b.id NOT IN :excludedIds " +
            "ORDER BY b.usersRateCount DESC, b.rate DESC, b.availableCopies DESC, b.name ASC")
    List<Book> findRecommendedByCategoryIdsExcluding(@Param("categoryIds") Set<Long> categoryIds,
                                                     @Param("excludedIds") Set<Long> excludedIds,
                                                     Pageable pageable);

    @Query("SELECT b FROM Book b WHERE b.markedAsDeleted = false AND b.id <> :bookId AND b.category.id = :categoryId " +
            "ORDER BY b.usersRateCount DESC, b.rate DESC, b.availableCopies DESC, b.name ASC")
    List<Book> findSimilarBooksByCategory(@Param("bookId") Long bookId,
                                          @Param("categoryId") Long categoryId,
                                          Pageable pageable);

    @Query("SELECT DISTINCT b FROM Book b JOIN b.tags t WHERE b.markedAsDeleted = false AND t.id IN :tagIds " +
            "ORDER BY b.usersRateCount DESC, b.rate DESC, b.availableCopies DESC, b.name ASC")
    List<Book> findBooksByTagIds(@Param("tagIds") Set<Long> tagIds, Pageable pageable);

    @Query("SELECT DISTINCT b FROM Book b JOIN b.tags t WHERE b.markedAsDeleted = false AND t.id IN :tagIds AND b.id NOT IN :excludedIds " +
            "ORDER BY b.usersRateCount DESC, b.rate DESC, b.availableCopies DESC, b.name ASC")
    List<Book> findBooksByTagIdsExcluding(@Param("tagIds") Set<Long> tagIds,
                                          @Param("excludedIds") Set<Long> excludedIds,
                                          Pageable pageable);

    @Query("SELECT b.id, b.name FROM Book b WHERE b.markedAsDeleted = false")
    List<Object[]> findActiveBookIdsAndNames();

    @Query("SELECT DISTINCT b FROM Book b WHERE b.markedAsDeleted = false AND (" +
            "lower(b.name) = lower(:query) OR lower(coalesce(b.isbn, '')) = lower(:query) OR lower(b.author.name) = lower(:query)" +
            ") ORDER BY b.usersRateCount DESC, b.rate DESC, b.availableCopies DESC, b.name ASC")
    List<Book> findExactMatches(@Param("query") String query, Pageable pageable);
}
/*
weidonglang
2026.3-2027.9
*/
