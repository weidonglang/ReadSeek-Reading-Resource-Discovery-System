package com.weidonglang.NewBookRecommendationSystem.service;


import com.weidonglang.NewBookRecommendationSystem.dao.UserDao;
import com.weidonglang.NewBookRecommendationSystem.dto.UserDto;
import com.weidonglang.NewBookRecommendationSystem.entity.User;
import com.weidonglang.NewBookRecommendationSystem.enums.UserGender;
import com.weidonglang.NewBookRecommendationSystem.enums.UserMartialStatus;
import com.weidonglang.NewBookRecommendationSystem.service.base.BaseService;
import com.weidonglang.NewBookRecommendationSystem.transformer.UserTransformer;

import java.util.List;
public interface UserService extends BaseService<User, UserDto, UserDao, UserTransformer> {
    UserDto findUserByEmail(String email);

    List<UserGender> getUserGenders();

    List<UserMartialStatus> getUserMartialStatuses();

    UserDto getCurrentUser();

    Boolean isUserExistsByEmail(String email);
}
