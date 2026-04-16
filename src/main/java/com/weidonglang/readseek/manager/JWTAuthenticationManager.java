package com.weidonglang.readseek.manager;

import com.weidonglang.readseek.dto.base.request.AuthRequest;
import com.weidonglang.readseek.dto.base.request.RefreshTokenRequest;
import com.weidonglang.readseek.dto.base.response.AuthResponse;
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
