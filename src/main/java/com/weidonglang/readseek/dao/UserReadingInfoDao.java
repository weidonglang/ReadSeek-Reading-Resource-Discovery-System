package com.weidonglang.readseek.dao;

import com.weidonglang.readseek.dao.base.BaseDao;
import com.weidonglang.readseek.entity.UserReadingInfo;
import com.weidonglang.readseek.repository.UserReadingInfoRepository;

import java.util.Optional;
public interface UserReadingInfoDao extends BaseDao<UserReadingInfo, UserReadingInfoRepository> {
    Optional<UserReadingInfo> findByUserId(Long userId);
}
/*
weidonglang
2026.3-2027.9
*/
