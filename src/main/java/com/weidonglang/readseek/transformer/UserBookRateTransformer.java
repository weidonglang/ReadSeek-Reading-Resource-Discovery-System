package com.weidonglang.readseek.transformer;

import com.weidonglang.readseek.dto.UserBookRateDto;
import com.weidonglang.readseek.entity.UserBookRate;
import com.weidonglang.readseek.transformer.base.BaseTransformer;
import com.weidonglang.readseek.transformer.mapper.UserBookRateMapper;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;
@Component
@AllArgsConstructor
public class UserBookRateTransformer implements BaseTransformer<UserBookRate, UserBookRateDto, UserBookRateMapper> {
    private final UserBookRateMapper userBookRateMapper;

    @Override
    public UserBookRateMapper getMapper() {
        return userBookRateMapper;
    }
}
