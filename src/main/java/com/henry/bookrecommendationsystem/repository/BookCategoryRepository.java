package com.henry.bookrecommendationsystem.repository;

import com.henry.bookrecommendationsystem.entity.BookCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
@Repository
public interface BookCategoryRepository extends JpaRepository<BookCategory, Long> {
    List<BookCategory> findAllByMarkedAsDeletedFalse();
}