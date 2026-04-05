package com.weidonglang.NewBookRecommendationSystem.dao;

import com.weidonglang.NewBookRecommendationSystem.entity.Tag;
import com.weidonglang.NewBookRecommendationSystem.repository.TagRepository;
import org.springframework.stereotype.Component;

import java.util.List;
@Component
public class TagDaoImpl implements TagDao {
    private final TagRepository tagRepository;

    public TagDaoImpl(TagRepository tagRepository) {
        this.tagRepository = tagRepository;
    }

    @Override
    public TagRepository getRepository() {
        return tagRepository;
    }

    @Override
    public List<Tag> findAllActive() {
        return getRepository().findAllByMarkedAsDeletedFalseOrderByNameAsc();
    }
}
/*
weidonglang
2026.3-2027.9
*/
