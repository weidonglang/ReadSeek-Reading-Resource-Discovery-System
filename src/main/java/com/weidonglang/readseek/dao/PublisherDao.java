package com.weidonglang.readseek.dao;

import com.weidonglang.readseek.dao.base.BaseDao;
import com.weidonglang.readseek.entity.Publisher;
import com.weidonglang.readseek.repository.PublisherRepository;

import java.util.List;
public interface PublisherDao extends BaseDao<Publisher, PublisherRepository> {
    List<Publisher> findAllActive();
}
/*
weidonglang
2026.3-2027.9
*/
