package com.weidonglang.readseek.service;


import com.weidonglang.readseek.dao.UserReadingInfoDao;
import com.weidonglang.readseek.dto.UserReadingInfoDto;
import com.weidonglang.readseek.entity.UserReadingInfo;
import com.weidonglang.readseek.service.base.BaseService;
import com.weidonglang.readseek.transformer.UserReadingInfoTransformer;
public interface UserReadingInfoService extends BaseService<UserReadingInfo, UserReadingInfoDto, UserReadingInfoDao, UserReadingInfoTransformer> {
    UserReadingInfoDto findUserReadingInfo();
}
