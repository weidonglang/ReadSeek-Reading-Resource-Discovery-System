package com.weidonglang.NewBookRecommendationSystem.manager;

import com.weidonglang.NewBookRecommendationSystem.dto.base.request.AuthRequest;
import com.weidonglang.NewBookRecommendationSystem.dto.base.request.RefreshTokenRequest;
import com.weidonglang.NewBookRecommendationSystem.dto.base.response.AuthResponse;
public interface JWTAuthenticationManager {
    AuthResponse login(AuthRequest authRequest);

    AuthResponse refreshToken(RefreshTokenRequest refreshTokenRequest);

    Boolean logout();

    String getCurrentUserEmail();
}
/*
weidonglang
2026.3-2027.9
*/
