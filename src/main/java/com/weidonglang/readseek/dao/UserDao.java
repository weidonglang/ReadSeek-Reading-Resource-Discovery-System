package com.weidonglang.readseek.dao;

import com.weidonglang.readseek.dao.base.BaseDao;
import com.weidonglang.readseek.entity.User;
import com.weidonglang.readseek.repository.UserRepository;

import java.util.Optional;
public interface UserDao extends BaseDao<User, UserRepository> {
    Optional<User> findUserByEmail(String email);

    Boolean isUserExistsByEmail(String email);
}
/*
weidonglang
2026.3-2027.9
*/
