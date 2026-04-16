package com.weidonglang.readseek.service;


import com.weidonglang.readseek.dto.base.request.RefreshTokenRequest;
import com.weidonglang.readseek.entity.RefreshToken;
public interface RefreshTokenService {
    RefreshToken findRefreshTokenByRefreshToken(String refreshToken);

    RefreshToken createRefreshToken(String email);

    RefreshToken refreshToken(RefreshTokenRequest refreshTokenRequest);

    Boolean deleteRefreshToken(String email);
}
/*
weidonglang
2026.3-2027.9
*/
