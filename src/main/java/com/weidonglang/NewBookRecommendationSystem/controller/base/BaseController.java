package com.weidonglang.NewBookRecommendationSystem.controller.base;

import com.weidonglang.NewBookRecommendationSystem.service.base.BaseService;
public interface BaseController<Service extends BaseService> {
    Service getService();
}
/*
weidonglang
2026.3-2027.9
*/
