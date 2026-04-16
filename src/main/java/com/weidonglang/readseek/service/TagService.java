package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dao.TagDao;
import com.weidonglang.readseek.dto.TagDto;
import com.weidonglang.readseek.entity.Tag;
import com.weidonglang.readseek.service.base.BaseService;
import com.weidonglang.readseek.transformer.TagTransformer;

import java.util.List;
public interface TagService extends BaseService<Tag, TagDto, TagDao, TagTransformer> {
    List<TagDto> findAllActive();
}
/*
weidonglang
2026.3-2027.9
*/
