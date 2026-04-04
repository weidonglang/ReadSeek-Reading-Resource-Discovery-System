package com.henry.bookrecommendationsystem.dao;

import com.henry.bookrecommendationsystem.dao.base.BaseDao;
import com.henry.bookrecommendationsystem.entity.Tag;
import com.henry.bookrecommendationsystem.repository.TagRepository;

import java.util.List;
public interface TagDao extends BaseDao<Tag, TagRepository> {
    List<Tag> findAllActive();
}
