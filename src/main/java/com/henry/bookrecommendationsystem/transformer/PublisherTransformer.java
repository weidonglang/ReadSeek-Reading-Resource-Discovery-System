package com.henry.bookrecommendationsystem.transformer;

import com.henry.bookrecommendationsystem.dto.PublisherDto;
import com.henry.bookrecommendationsystem.entity.Publisher;
import com.henry.bookrecommendationsystem.transformer.base.BaseTransformer;
import com.henry.bookrecommendationsystem.transformer.mapper.PublisherMapper;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;
@Component
@AllArgsConstructor
public class PublisherTransformer implements BaseTransformer<Publisher, PublisherDto, PublisherMapper> {
    private final PublisherMapper publisherMapper;

    @Override
    public PublisherMapper getMapper() {
        return publisherMapper;
    }
}
