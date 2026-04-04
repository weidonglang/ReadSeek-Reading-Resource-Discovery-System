package com.henry.bookrecommendationsystem.service;

import com.henry.bookrecommendationsystem.dao.AuthorDao;
import com.henry.bookrecommendationsystem.dto.AuthorDto;
import com.henry.bookrecommendationsystem.dto.AuthorFilterPaginationRequest;
import com.henry.bookrecommendationsystem.dto.base.pagination.FilterPaginationRequest;
import com.henry.bookrecommendationsystem.dto.base.response.PaginationResponse;
import com.henry.bookrecommendationsystem.entity.Author;
import com.henry.bookrecommendationsystem.repository.BookRepository;
import com.henry.bookrecommendationsystem.transformer.AuthorTransformer;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityExistsException;
import java.util.Optional;
@Slf4j
@Service
public class AuthorServiceImpl implements AuthorService {
    private final AuthorTransformer authorTransformer;
    private final AuthorDao authorDao;
    private final BookRepository bookRepository;

    @Autowired
    public AuthorServiceImpl(AuthorTransformer authorTransformer, AuthorDao authorDao, BookRepository bookRepository) {
        this.authorTransformer = authorTransformer;
        this.authorDao = authorDao;
        this.bookRepository = bookRepository;
    }

    public AuthorServiceImpl(AuthorTransformer authorTransformer, AuthorDao authorDao) {
        this(authorTransformer, authorDao, null);
    }

    @Override
    public AuthorDao getDao() {
        return authorDao;
    }

    @Override
    public AuthorTransformer getTransformer() {
        return authorTransformer;
    }

    @Override
    public PaginationResponse<AuthorDto> findAllAuthorsPaginatedAndFiltered(FilterPaginationRequest<AuthorFilterPaginationRequest> authorFilterPaginationRequest) {
        log.info("AuthorService: findAllAuthorsPaginatedAndFiltered() called");
        return buildPaginationResponse(getDao().findAllAuthorsPaginatedAndFiltered(authorFilterPaginationRequest));
    }

    @Override
    public void deleteById(Long id) {
        log.info("AuthorService: deleteById() called");
        Optional<Author> optionalAuthor = getDao().findById(id);
        if (optionalAuthor.isEmpty())
            throw new EntityExistsException("Author not found for id: " + id);
        if (bookRepository != null && Boolean.TRUE.equals(bookRepository.existsByAuthorIdAndMarkedAsDeletedFalse(id))) {
            throw new EntityExistsException("Author has active books and cannot be deleted");
        }

        Author author = optionalAuthor.get();
        author.setMarkedAsDeleted(true);
        getDao().update(author);
    }
}
