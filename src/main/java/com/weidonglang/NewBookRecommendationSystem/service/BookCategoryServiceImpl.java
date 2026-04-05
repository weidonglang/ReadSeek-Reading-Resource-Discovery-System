package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.dao.BookCategoryDao;
import com.weidonglang.NewBookRecommendationSystem.entity.BookCategory;
import com.weidonglang.NewBookRecommendationSystem.repository.BookRepository;
import com.weidonglang.NewBookRecommendationSystem.transformer.BookCategoryTransformer;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityExistsException;
import java.util.Optional;
@Slf4j
@Service
public class BookCategoryServiceImpl implements BookCategoryService {
    private final BookCategoryDao bookCategoryDao;
    private final BookCategoryTransformer bookCategoryTransformer;
    private final BookRepository bookRepository;

    @Autowired
    public BookCategoryServiceImpl(BookCategoryDao bookCategoryDao,
                                   BookCategoryTransformer bookCategoryTransformer,
                                   BookRepository bookRepository) {
        this.bookCategoryDao = bookCategoryDao;
        this.bookCategoryTransformer = bookCategoryTransformer;
        this.bookRepository = bookRepository;
    }

    public BookCategoryServiceImpl(BookCategoryDao bookCategoryDao,
                                   BookCategoryTransformer bookCategoryTransformer) {
        this(bookCategoryDao, bookCategoryTransformer, null);
    }

    @Override
    public BookCategoryDao getDao() {
        return bookCategoryDao;
    }

    @Override
    public BookCategoryTransformer getTransformer() {
        return bookCategoryTransformer;
    }

    @Override
    public void deleteById(Long id) {
        log.info("BookCategoryService: deleteById() called");
        Optional<BookCategory> optionalCategory = getDao().findById(id);
        if (optionalCategory.isEmpty()) {
            throw new EntityExistsException("Book category not found for id: " + id);
        }
        if (bookRepository != null && Boolean.TRUE.equals(bookRepository.existsByCategoryIdAndMarkedAsDeletedFalse(id))) {
            throw new EntityExistsException("Book category has active books and cannot be deleted");
        }

        BookCategory bookCategory = optionalCategory.get();
        bookCategory.setMarkedAsDeleted(true);
        getDao().update(bookCategory);
    }
}
/*
weidonglang
2026.3-2027.9
*/
