package com.henry.bookrecommendationsystem.dao;

import com.henry.bookrecommendationsystem.entity.Publisher;
import com.henry.bookrecommendationsystem.repository.PublisherRepository;
import org.springframework.stereotype.Component;

import java.util.List;
@Component
public class PublisherDaoImpl implements PublisherDao {
    private final PublisherRepository publisherRepository;

    public PublisherDaoImpl(PublisherRepository publisherRepository) {
        this.publisherRepository = publisherRepository;
    }

    @Override
    public PublisherRepository getRepository() {
        return publisherRepository;
    }

    @Override
    public List<Publisher> findAllActive() {
        return getRepository().findAllByMarkedAsDeletedFalseOrderByNameAsc();
    }
}
