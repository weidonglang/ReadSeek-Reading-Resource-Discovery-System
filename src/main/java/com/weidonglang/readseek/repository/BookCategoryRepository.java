package com.weidonglang.readseek.repository;

import com.weidonglang.readseek.entity.BookCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
@Repository
public interface BookCategoryRepository extends JpaRepository<BookCategory, Long> {
    List<BookCategory> findAllByMarkedAsDeletedFalse();
}
/*
weidonglang
2026.3-2027.9
*/
