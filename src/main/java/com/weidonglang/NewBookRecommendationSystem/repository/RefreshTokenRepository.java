package com.weidonglang.NewBookRecommendationSystem.repository;

import com.weidonglang.NewBookRecommendationSystem.entity.RefreshToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;
@Repository
public interface RefreshTokenRepository extends JpaRepository<RefreshToken, Long> {
    Optional<RefreshToken> findByEmailAndMarkedAsDeletedFalse(String email);

    Optional<RefreshToken> findByTokenAndMarkedAsDeletedFalse(String refreshToken);

    @Modifying
    @Query("UPDATE RefreshToken SET markedAsDeleted = true WHERE email = :email")
    Integer deleteRefreshTokenByEmail(String email);
}
/*
weidonglang
2026.3-2027.9
*/
