package com.henry.bookrecommendationsystem.service;

import com.henry.bookrecommendationsystem.dao.PublisherDao;
import com.henry.bookrecommendationsystem.dto.PublisherDto;
import com.henry.bookrecommendationsystem.entity.Publisher;
import com.henry.bookrecommendationsystem.repository.BookRepository;
import com.henry.bookrecommendationsystem.transformer.PublisherTransformer;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.persistence.EntityExistsException;
import java.util.List;
import java.util.Optional;
@Slf4j
@Service
public class PublisherServiceImpl implements PublisherService {
    private final PublisherDao publisherDao;
    private final PublisherTransformer publisherTransformer;
    private final BookRepository bookRepository;

    public PublisherServiceImpl(PublisherDao publisherDao, PublisherTransformer publisherTransformer, BookRepository bookRepository) {
        this.publisherDao = publisherDao;
        this.publisherTransformer = publisherTransformer;
        this.bookRepository = bookRepository;
    }

    @Override
    public PublisherDao getDao() {
        return publisherDao;
    }

    @Override
    public PublisherTransformer getTransformer() {
        return publisherTransformer;
    }

    @Override
    public List<PublisherDto> findAllActive() {
        log.info("PublisherService: findAllActive() called");
        return getTransformer().transformEntityToDto(getDao().findAllActive());
    }

    @Override
    public void deleteById(Long id) {
        log.info("PublisherService: deleteById() called");
        Optional<Publisher> optionalPublisher = getDao().findById(id);
        if (optionalPublisher.isEmpty())
            throw new EntityExistsException("Publisher not found for id: " + id);
        if (Boolean.TRUE.equals(bookRepository.existsByPublisherIdAndMarkedAsDeletedFalse(id))) {
            throw new EntityExistsException("Publisher has active books and cannot be deleted");
        }

        Publisher publisher = optionalPublisher.get();
        publisher.setMarkedAsDeleted(true);
        getDao().update(publisher);
    }
}
