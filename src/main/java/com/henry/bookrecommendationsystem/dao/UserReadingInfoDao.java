package com.henry.bookrecommendationsystem.dao;

import com.henry.bookrecommendationsystem.dao.base.BaseDao;
import com.henry.bookrecommendationsystem.entity.UserReadingInfo;
import com.henry.bookrecommendationsystem.repository.UserReadingInfoRepository;

import java.util.Optional;
public interface UserReadingInfoDao extends BaseDao<UserReadingInfo, UserReadingInfoRepository> {
    Optional<UserReadingInfo> findByUserId(Long userId);
}
