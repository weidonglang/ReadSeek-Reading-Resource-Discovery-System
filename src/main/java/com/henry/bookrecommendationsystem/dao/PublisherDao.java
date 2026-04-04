package com.henry.bookrecommendationsystem.dao;

import com.henry.bookrecommendationsystem.dao.base.BaseDao;
import com.henry.bookrecommendationsystem.entity.Publisher;
import com.henry.bookrecommendationsystem.repository.PublisherRepository;

import java.util.List;
public interface PublisherDao extends BaseDao<Publisher, PublisherRepository> {
    List<Publisher> findAllActive();
}
