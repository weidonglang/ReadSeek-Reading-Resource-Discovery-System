package com.weidonglang.readseek.transformer;

import com.weidonglang.readseek.dto.UserReadingInfoDto;
import com.weidonglang.readseek.entity.UserReadingInfo;
import com.weidonglang.readseek.transformer.base.BaseTransformer;
import com.weidonglang.readseek.transformer.mapper.UserReadingInfoMapper;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;
@Component
@AllArgsConstructor
public class UserReadingInfoTransformer implements BaseTransformer<UserReadingInfo, UserReadingInfoDto, UserReadingInfoMapper> {
    private final UserReadingInfoMapper userReadingInfoMapper;

    @Override
    public UserReadingInfoMapper getMapper() {
        return userReadingInfoMapper;
    }
}
