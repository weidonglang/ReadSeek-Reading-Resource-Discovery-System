package com.weidonglang.readseek.transformer;

import com.weidonglang.readseek.dto.TagDto;
import com.weidonglang.readseek.entity.Tag;
import com.weidonglang.readseek.transformer.base.BaseTransformer;
import com.weidonglang.readseek.transformer.mapper.TagMapper;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;
@Component
@AllArgsConstructor
public class TagTransformer implements BaseTransformer<Tag, TagDto, TagMapper> {
    private final TagMapper tagMapper;

    @Override
    public TagMapper getMapper() {
        return tagMapper;
    }
}
