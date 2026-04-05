package com.weidonglang.NewBookRecommendationSystem.dao;

import com.weidonglang.NewBookRecommendationSystem.entity.User;
import com.weidonglang.NewBookRecommendationSystem.repository.UserRepository;
import org.springframework.stereotype.Component;

import java.util.Optional;
@Component
public class UserDaoImpl implements UserDao {
    private final UserRepository userRepository;

    public UserDaoImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public UserRepository getRepository() {
        return userRepository;
    }

    @Override
    public Optional<User> findUserByEmail(String email) {
        return getRepository().findByEmail(email);
    }

    @Override
    public Boolean isUserExistsByEmail(String email) {
        return getRepository().existsByEmail(email);
    }
}
/*
weidonglang
2026.3-2027.9
*/
