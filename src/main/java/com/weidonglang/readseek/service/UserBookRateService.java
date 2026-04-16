package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dao.UserBookRateDao;
import com.weidonglang.readseek.dto.UserBookRateDto;
import com.weidonglang.readseek.entity.UserBookRate;
import com.weidonglang.readseek.service.base.BaseService;
import com.weidonglang.readseek.transformer.UserBookRateTransformer;
public interface UserBookRateService extends BaseService<UserBookRate, UserBookRateDto, UserBookRateDao, UserBookRateTransformer> {
    UserBookRateDto rateBook(UserBookRateDto userBookRateDto);
}
