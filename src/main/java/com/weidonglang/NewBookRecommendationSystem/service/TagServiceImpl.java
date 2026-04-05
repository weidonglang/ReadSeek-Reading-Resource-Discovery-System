package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.dao.TagDao;
import com.weidonglang.NewBookRecommendationSystem.dto.TagDto;
import com.weidonglang.NewBookRecommendationSystem.entity.Tag;
import com.weidonglang.NewBookRecommendationSystem.repository.BookRepository;
import com.weidonglang.NewBookRecommendationSystem.transformer.TagTransformer;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.persistence.EntityExistsException;
import java.util.List;
import java.util.Optional;
@Slf4j
@Service
public class TagServiceImpl implements TagService {
    private final TagDao tagDao;
    private final TagTransformer tagTransformer;
    private final BookRepository bookRepository;

    public TagServiceImpl(TagDao tagDao, TagTransformer tagTransformer, BookRepository bookRepository) {
        this.tagDao = tagDao;
        this.tagTransformer = tagTransformer;
        this.bookRepository = bookRepository;
    }

    @Override
    public TagDao getDao() {
        return tagDao;
    }

    @Override
    public TagTransformer getTransformer() {
        return tagTransformer;
    }

    @Override
    public List<TagDto> findAllActive() {
        log.info("TagService: findAllActive() called");
        return getTransformer().transformEntityToDto(getDao().findAllActive());
    }

    @Override
    public void deleteById(Long id) {
        log.info("TagService: deleteById() called");
        Optional<Tag> optionalTag = getDao().findById(id);
        if (optionalTag.isEmpty())
            throw new EntityExistsException("Tag not found for id: " + id);
        if (Boolean.TRUE.equals(bookRepository.existsByTagsIdAndMarkedAsDeletedFalse(id))) {
            throw new EntityExistsException("Tag is still used by active books and cannot be deleted");
        }

        Tag tag = optionalTag.get();
        tag.setMarkedAsDeleted(true);
        getDao().update(tag);
    }
}
/*
weidonglang
2026.3-2027.9
*/
