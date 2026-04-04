package com.henry.bookrecommendationsystem.service;

import com.henry.bookrecommendationsystem.dao.PublisherDao;
import com.henry.bookrecommendationsystem.dto.PublisherDto;
import com.henry.bookrecommendationsystem.entity.Publisher;
import com.henry.bookrecommendationsystem.service.base.BaseService;
import com.henry.bookrecommendationsystem.transformer.PublisherTransformer;

import java.util.List;
public interface PublisherService extends BaseService<Publisher, PublisherDto, PublisherDao, PublisherTransformer> {
    List<PublisherDto> findAllActive();
}
