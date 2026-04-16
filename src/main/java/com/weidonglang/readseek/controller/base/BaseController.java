package com.weidonglang.readseek.controller.base;

import com.weidonglang.readseek.service.base.BaseService;
public interface BaseController<Service extends BaseService> {
    Service getService();
}
/*
weidonglang
2026.3-2027.9
*/
