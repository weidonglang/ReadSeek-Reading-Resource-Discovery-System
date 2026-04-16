package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dao.PublisherDao;
import com.weidonglang.readseek.dto.PublisherDto;
import com.weidonglang.readseek.entity.Publisher;
import com.weidonglang.readseek.service.base.BaseService;
import com.weidonglang.readseek.transformer.PublisherTransformer;

import java.util.List;
public interface PublisherService extends BaseService<Publisher, PublisherDto, PublisherDao, PublisherTransformer> {
    List<PublisherDto> findAllActive();
}
/*
weidonglang
2026.3-2027.9
*/
