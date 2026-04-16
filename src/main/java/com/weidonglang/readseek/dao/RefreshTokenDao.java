package com.weidonglang.readseek.dao;

import com.weidonglang.readseek.entity.RefreshToken;

import java.util.Optional;
public interface RefreshTokenDao {
    Optional<RefreshToken> findRefreshTokenByEmail(String email);

    Optional<RefreshToken> findRefreshTokenByRefreshToken(String refreshToken);

    RefreshToken createRefreshToken(RefreshToken refreshToken);

    RefreshToken updateRefreshToken(RefreshToken refreshToken);

    Boolean deleteRefreshTokenByEmail(String email);
}
/*
weidonglang
2026.3-2027.9
*/
