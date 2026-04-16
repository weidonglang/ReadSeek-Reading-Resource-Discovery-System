package com.weidonglang.readseek.transformer;

import com.weidonglang.readseek.dto.UserDto;
import com.weidonglang.readseek.entity.User;
import com.weidonglang.readseek.transformer.base.BaseTransformer;
import com.weidonglang.readseek.transformer.mapper.UserMapper;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;
@Component
@AllArgsConstructor
public class UserTransformer implements BaseTransformer<User, UserDto, UserMapper> {
    private final UserMapper userMapper;

    @Override
    public UserMapper getMapper() {
        return userMapper;
    }
}
