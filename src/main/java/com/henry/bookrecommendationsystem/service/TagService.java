package com.henry.bookrecommendationsystem.service;

import com.henry.bookrecommendationsystem.dao.TagDao;
import com.henry.bookrecommendationsystem.dto.TagDto;
import com.henry.bookrecommendationsystem.entity.Tag;
import com.henry.bookrecommendationsystem.service.base.BaseService;
import com.henry.bookrecommendationsystem.transformer.TagTransformer;

import java.util.List;
public interface TagService extends BaseService<Tag, TagDto, TagDao, TagTransformer> {
    List<TagDto> findAllActive();
}
