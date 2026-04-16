package com.weidonglang.readseek.service;


import com.weidonglang.readseek.dao.UserDao;
import com.weidonglang.readseek.dto.UserDto;
import com.weidonglang.readseek.entity.User;
import com.weidonglang.readseek.enums.UserGender;
import com.weidonglang.readseek.enums.UserMartialStatus;
import com.weidonglang.readseek.service.base.BaseService;
import com.weidonglang.readseek.transformer.UserTransformer;

import java.util.List;
public interface UserService extends BaseService<User, UserDto, UserDao, UserTransformer> {
    UserDto findUserByEmail(String email);

    List<UserGender> getUserGenders();

    List<UserMartialStatus> getUserMartialStatuses();

    UserDto getCurrentUser();

    Boolean isUserExistsByEmail(String email);
}
