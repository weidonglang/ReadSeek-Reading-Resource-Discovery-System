package com.weidonglang.NewBookRecommendationSystem.service;


import com.weidonglang.NewBookRecommendationSystem.dto.base.request.RefreshTokenRequest;
import com.weidonglang.NewBookRecommendationSystem.entity.RefreshToken;
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
