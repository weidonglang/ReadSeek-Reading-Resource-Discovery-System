package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.dao.UserBookRateDao;
import com.weidonglang.NewBookRecommendationSystem.dto.UserBookRateDto;
import com.weidonglang.NewBookRecommendationSystem.entity.UserBookRate;
import com.weidonglang.NewBookRecommendationSystem.service.base.BaseService;
import com.weidonglang.NewBookRecommendationSystem.transformer.UserBookRateTransformer;
public interface UserBookRateService extends BaseService<UserBookRate, UserBookRateDto, UserBookRateDao, UserBookRateTransformer> {
    UserBookRateDto rateBook(UserBookRateDto userBookRateDto);
}
