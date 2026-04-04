package com.henry.bookrecommendationsystem.dao;

import com.henry.bookrecommendationsystem.entity.BookCategory;
import com.henry.bookrecommendationsystem.repository.BookCategoryRepository;
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
