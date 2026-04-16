package com.weidonglang.readseek.repository;

import com.weidonglang.readseek.entity.SearchLog;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
@Repository
public interface SearchLogRepository extends JpaRepository<SearchLog, Long> {
    List<SearchLog> findByMarkedAsDeletedFalse();

    List<SearchLog> findByMarkedAsDeletedFalseOrderByCreatedDateDesc(Pageable pageable);

    List<SearchLog> findByMarkedAsDeletedFalseAndCreatedDateGreaterThanEqual(LocalDateTime fromDate);

    List<SearchLog> findByMarkedAsDeletedFalseAndCreatedDateGreaterThanEqualOrderByCreatedDateDesc(LocalDateTime fromDate, Pageable pageable);

    Long countByMarkedAsDeletedFalse();

    @Query("SELECT COUNT(sl.id) FROM SearchLog sl WHERE sl.markedAsDeleted = false AND sl.createdDate >= :fromDate")
    Long countRecentSearches(@Param("fromDate") LocalDateTime fromDate);

    @Query("SELECT sl.keyword, COUNT(sl.id) FROM SearchLog sl " +
            "WHERE sl.markedAsDeleted = false " +
            "AND sl.keyword IS NOT NULL AND sl.keyword <> '' " +
            "GROUP BY sl.keyword ORDER BY COUNT(sl.id) DESC")
    List<Object[]> aggregateTopKeywords(Pageable pageable);

    @Query("SELECT sl.keyword, COUNT(sl.id) FROM SearchLog sl " +
            "WHERE sl.markedAsDeleted = false " +
            "AND sl.keyword IS NOT NULL AND sl.keyword <> '' " +
            "AND sl.createdDate >= :fromDate " +
            "GROUP BY sl.keyword ORDER BY COUNT(sl.id) DESC")
    List<Object[]> aggregateTopKeywordsSince(@Param("fromDate") LocalDateTime fromDate, Pageable pageable);
}
/*
weidonglang
2026.3-2027.9
*/
