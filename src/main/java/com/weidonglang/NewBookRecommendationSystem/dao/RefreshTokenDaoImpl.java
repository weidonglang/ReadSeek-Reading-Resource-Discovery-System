package com.weidonglang.NewBookRecommendationSystem.dao;

import com.weidonglang.NewBookRecommendationSystem.entity.RefreshToken;
import com.weidonglang.NewBookRecommendationSystem.repository.RefreshTokenRepository;
import org.springframework.stereotype.Component;

import java.util.Optional;
@Component
public class RefreshTokenDaoImpl implements RefreshTokenDao {
    private final RefreshTokenRepository refreshTokenRepository;

    public RefreshTokenDaoImpl(RefreshTokenRepository refreshTokenRepository) {
        this.refreshTokenRepository = refreshTokenRepository;
    }

    @Override
    public Optional<RefreshToken> findRefreshTokenByEmail(String email) {
        return refreshTokenRepository.findByEmailAndMarkedAsDeletedFalse(email);
    }

    @Override
    public Optional<RefreshToken> findRefreshTokenByRefreshToken(String refreshToken) {
        return refreshTokenRepository.findByTokenAndMarkedAsDeletedFalse(refreshToken);
    }

    @Override
    public RefreshToken createRefreshToken(RefreshToken refreshToken) {
        return refreshTokenRepository.save(refreshToken);
    }

    @Override
    public RefreshToken updateRefreshToken(RefreshToken refreshToken) {
        return refreshTokenRepository.saveAndFlush(refreshToken);
    }

    @Override
    public Boolean deleteRefreshTokenByEmail(String email) {
        return refreshTokenRepository.deleteRefreshTokenByEmail(email) == 1;
    }
}
/*
weidonglang
2026.3-2027.9
*/
