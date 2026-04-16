package com.weidonglang.readseek.dao;

import com.weidonglang.readseek.entity.BookCategory;
import com.weidonglang.readseek.repository.BookCategoryRepository;
import org.springframework.stereotype.Component;

import java.util.List;
@Component
public class BookCategoryDaoImpl implements BookCategoryDao {
    private final BookCategoryRepository bookCategoryRepository;

    public BookCategoryDaoImpl(BookCategoryRepository bookCategoryRepository) {
        this.bookCategoryRepository = bookCategoryRepository;
    }

    @Override
    public BookCategoryRepository getRepository() {
        return bookCategoryRepository;
    }

    @Override
    public List<BookCategory> findAll() {
        return getRepository().findAllByMarkedAsDeletedFalse();
    }
}
/*
weidonglang
2026.3-2027.9
*/
