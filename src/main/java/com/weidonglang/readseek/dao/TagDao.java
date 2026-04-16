package com.weidonglang.readseek.dao;

import com.weidonglang.readseek.dao.base.BaseDao;
import com.weidonglang.readseek.entity.Tag;
import com.weidonglang.readseek.repository.TagRepository;

import java.util.List;
public interface TagDao extends BaseDao<Tag, TagRepository> {
    List<Tag> findAllActive();
}
/*
weidonglang
2026.3-2027.9
*/
