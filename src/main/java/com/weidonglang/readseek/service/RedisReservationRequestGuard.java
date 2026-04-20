package com.weidonglang.readseek.service;

import jakarta.persistence.EntityExistsException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.UUID;

@Slf4j
@Service
public class RedisReservationRequestGuard implements ReservationRequestGuard {
    private static final String DUPLICATE_RESERVATION_MESSAGE =
            "A reservation request for this book is already being processed.";

    private final StringRedisTemplate redisTemplate;
    private final String keyPrefix;
    private final Duration dedupeTtl;

    public RedisReservationRequestGuard(StringRedisTemplate redisTemplate,
                                        @Value("${readseek.redis.key-prefix:readseek}") String keyPrefix,
                                        @Value("${readseek.reservation.dedupe-ttl:PT30S}") Duration dedupeTtl) {
        this.redisTemplate = redisTemplate;
        this.keyPrefix = normalizePrefix(keyPrefix);
        this.dedupeTtl = normalizeTtl(dedupeTtl);
    }

    @Override
    public GuardToken acquire(Long userId, Long bookId) {
        String key = reservationKey(userId, bookId);
        String value = UUID.randomUUID().toString();
        try {
            Boolean acquired = redisTemplate.opsForValue().setIfAbsent(key, value, dedupeTtl);
            if (Boolean.TRUE.equals(acquired)) {
                return GuardToken.redis(key, value);
            }
            if (Boolean.FALSE.equals(acquired)) {
                throw new EntityExistsException(DUPLICATE_RESERVATION_MESSAGE);
            }
            log.warn("Redis reservation guard returned no result for key={}; continuing with database checks", key);
        } catch (EntityExistsException exception) {
            throw exception;
        } catch (RuntimeException exception) {
            log.warn("Redis reservation guard unavailable for key={}; continuing with database checks", key, exception);
        }
        return GuardToken.bypassed();
    }

    @Override
    public void release(GuardToken token) {
        if (token == null || !token.isRedisBacked()) {
            return;
        }
        try {
            String currentValue = redisTemplate.opsForValue().get(token.getKey());
            if (token.getValue().equals(currentValue)) {
                redisTemplate.delete(token.getKey());
            }
        } catch (RuntimeException exception) {
            log.warn("Failed to release Redis reservation guard for key={}", token.getKey(), exception);
        }
    }

    private String reservationKey(Long userId, Long bookId) {
        return keyPrefix + ":reservation:dedupe:user:" + userId + ":book:" + bookId;
    }

    private String normalizePrefix(String rawPrefix) {
        if (rawPrefix == null || rawPrefix.isBlank()) {
            return "readseek";
        }
        return rawPrefix.trim();
    }

    private Duration normalizeTtl(Duration rawTtl) {
        if (rawTtl == null || rawTtl.isZero() || rawTtl.isNegative()) {
            return Duration.ofSeconds(30);
        }
        return rawTtl;
    }
}
