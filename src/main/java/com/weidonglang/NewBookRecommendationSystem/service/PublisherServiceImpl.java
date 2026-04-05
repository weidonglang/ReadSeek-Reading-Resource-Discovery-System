package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.dao.PublisherDao;
import com.weidonglang.NewBookRecommendationSystem.dto.PublisherDto;
import com.weidonglang.NewBookRecommendationSystem.entity.Publisher;
import com.weidonglang.NewBookRecommendationSystem.repository.BookRepository;
import com.weidonglang.NewBookRecommendationSystem.transformer.PublisherTransformer;
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
/*
weidonglang
2026.3-2027.9
*/
