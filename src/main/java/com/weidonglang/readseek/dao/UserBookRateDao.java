package com.weidonglang.readseek.dao;

import com.weidonglang.readseek.dao.base.BaseDao;
import com.weidonglang.readseek.entity.UserBookRate;
import com.weidonglang.readseek.repository.UserBookRatingRepository;

import java.util.List;
import java.util.Optional;
public interface UserBookRateDao extends BaseDao<UserBookRate, UserBookRatingRepository> {
    Optional<UserBookRate> findUserBookRateByUserIdAndBookId(Long userId, Long bookId);

    List<UserBookRate> findAllByUserId(Long userId);
}
/*
weidonglang
2026.3-2027.9
*/
