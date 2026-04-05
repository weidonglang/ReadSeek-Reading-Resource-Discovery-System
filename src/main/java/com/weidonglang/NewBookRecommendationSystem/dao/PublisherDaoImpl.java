package com.weidonglang.NewBookRecommendationSystem.dao;

import com.weidonglang.NewBookRecommendationSystem.entity.Publisher;
import com.weidonglang.NewBookRecommendationSystem.repository.PublisherRepository;
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
/*
weidonglang
2026.3-2027.9
*/
