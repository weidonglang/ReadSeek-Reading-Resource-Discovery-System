package com.weidonglang.NewBookRecommendationSystem.dao;

import com.weidonglang.NewBookRecommendationSystem.dao.base.BaseDao;
import com.weidonglang.NewBookRecommendationSystem.entity.User;
import com.weidonglang.NewBookRecommendationSystem.repository.UserRepository;

import java.util.Optional;
public interface UserDao extends BaseDao<User, UserRepository> {
    Optional<User> findUserByEmail(String email);

    Boolean isUserExistsByEmail(String email);
}
/*
weidonglang
2026.3-2027.9
*/
