package com.weidonglang.readseek.transformer;

import com.weidonglang.readseek.dto.PublisherDto;
import com.weidonglang.readseek.entity.Publisher;
import com.weidonglang.readseek.transformer.base.BaseTransformer;
import com.weidonglang.readseek.transformer.mapper.PublisherMapper;
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
