package com.weidonglang.NewBookRecommendationSystem.repository;

import com.weidonglang.NewBookRecommendationSystem.entity.Author;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
@Repository
public interface AuthorRepository extends JpaRepository<Author, Long> {

    @Query("SELECT a FROM Author a WHERE a.markedAsDeleted = :deletedRecords ")
    Page<Author> findAll(Pageable pageable, Boolean deletedRecords);

    @Query("SELECT a FROM Author a WHERE a.markedAsDeleted = :deletedRecords " +
            "AND ((:name) IS NULL OR lower(a.name) like %:name%) ")
    Page<Author> findAllAuthorsPaginatedAndFiltered(String name, Boolean deletedRecords, Pageable pageable);
}
/*
weidonglang
2026.3-2027.9
*/
