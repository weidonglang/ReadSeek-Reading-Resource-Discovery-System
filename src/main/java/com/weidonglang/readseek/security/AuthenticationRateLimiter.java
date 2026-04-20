package com.weidonglang.readseek.security;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.beans.factory.annotation.Autowired;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.util.HexFormat;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class AuthenticationRateLimiter {
    private static final int MAX_BUCKETS_BEFORE_CLEANUP = 10_000;
    private static final String RATE_LIMIT_MESSAGE = "Too many authentication attempts. Please try again later.";

    private final Map<String, LoginAttemptBucket> loginAttempts = new ConcurrentHashMap<>();
    private final Map<String, RequestWindowBucket> refreshAttempts = new ConcurrentHashMap<>();
    private final Clock clock;
    private final int maxLoginFailures;
    private final Duration loginFailureWindow;
    private final Duration loginLockDuration;
    private final int maxRefreshRequests;
    private final Duration refreshWindow;

    @Autowired
    public AuthenticationRateLimiter(
            @Value("${readseek.security.rate-limit.login.max-failures:5}") int maxLoginFailures,
            @Value("${readseek.security.rate-limit.login.window:PT15M}") Duration loginFailureWindow,
            @Value("${readseek.security.rate-limit.login.lock-duration:PT15M}") Duration loginLockDuration,
            @Value("${readseek.security.rate-limit.refresh.max-requests:30}") int maxRefreshRequests,
            @Value("${readseek.security.rate-limit.refresh.window:PT10M}") Duration refreshWindow) {
        this(maxLoginFailures, loginFailureWindow, loginLockDuration, maxRefreshRequests, refreshWindow, Clock.systemUTC());
    }

    AuthenticationRateLimiter(int maxLoginFailures,
                              Duration loginFailureWindow,
                              Duration loginLockDuration,
                              int maxRefreshRequests,
                              Duration refreshWindow,
                              Clock clock) {
        this.maxLoginFailures = Math.max(1, maxLoginFailures);
        this.loginFailureWindow = positiveOrDefault(loginFailureWindow, Duration.ofMinutes(15));
        this.loginLockDuration = positiveOrDefault(loginLockDuration, Duration.ofMinutes(15));
        this.maxRefreshRequests = Math.max(1, maxRefreshRequests);
        this.refreshWindow = positiveOrDefault(refreshWindow, Duration.ofMinutes(10));
        this.clock = clock;
    }

    public void checkLoginAllowed(String email, HttpServletRequest request) {
        cleanupIfNeeded();
        LoginAttemptBucket bucket = loginAttempts.get(loginKey(email, request));
        if (bucket != null && bucket.lockedUntil != null && bucket.lockedUntil.isAfter(now())) {
            throwRateLimitExceeded();
        }
    }

    public void recordLoginFailure(String email, HttpServletRequest request) {
        Instant currentTime = now();
        String key = loginKey(email, request);
        loginAttempts.compute(key, (ignored, bucket) -> {
            LoginAttemptBucket current = bucket == null ? new LoginAttemptBucket(currentTime) : bucket;
            if (current.windowStartedAt.plus(loginFailureWindow).isBefore(currentTime)) {
                current.windowStartedAt = currentTime;
                current.failureCount = 0;
                current.lockedUntil = null;
            }
            current.failureCount++;
            if (current.failureCount >= maxLoginFailures) {
                current.lockedUntil = currentTime.plus(loginLockDuration);
            }
            return current;
        });
    }

    public void recordLoginSuccess(String email, HttpServletRequest request) {
        loginAttempts.remove(loginKey(email, request));
    }

    public void checkRefreshAllowed(String email, String refreshToken, HttpServletRequest request) {
        cleanupIfNeeded();
        Instant currentTime = now();
        String key = refreshKey(email, refreshToken, request);
        RequestWindowBucket bucket = refreshAttempts.compute(key, (ignored, existing) -> {
            RequestWindowBucket current = existing == null ? new RequestWindowBucket(currentTime) : existing;
            if (current.windowStartedAt.plus(refreshWindow).isBefore(currentTime)) {
                current.windowStartedAt = currentTime;
                current.requestCount = 0;
            }
            current.requestCount++;
            return current;
        });
        if (bucket.requestCount > maxRefreshRequests) {
            throwRateLimitExceeded();
        }
    }

    private void cleanupIfNeeded() {
        if (loginAttempts.size() > MAX_BUCKETS_BEFORE_CLEANUP) {
            Instant currentTime = now();
            loginAttempts.entrySet().removeIf(entry -> {
                LoginAttemptBucket bucket = entry.getValue();
                boolean lockExpired = bucket.lockedUntil == null || bucket.lockedUntil.isBefore(currentTime);
                boolean windowExpired = bucket.windowStartedAt.plus(loginFailureWindow).isBefore(currentTime);
                return lockExpired && windowExpired;
            });
        }
        if (refreshAttempts.size() > MAX_BUCKETS_BEFORE_CLEANUP) {
            Instant currentTime = now();
            refreshAttempts.entrySet().removeIf(entry ->
                    entry.getValue().windowStartedAt.plus(refreshWindow).isBefore(currentTime));
        }
    }

    private String loginKey(String email, HttpServletRequest request) {
        return normalize(email) + "|" + clientIp(request);
    }

    private String refreshKey(String email, String refreshToken, HttpServletRequest request) {
        return normalize(email) + "|" + clientIp(request) + "|" + sha256(refreshToken);
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim().toLowerCase(Locale.ROOT);
    }

    private String clientIp(HttpServletRequest request) {
        if (request == null) {
            return "unknown";
        }
        String forwardedFor = request.getHeader("X-Forwarded-For");
        if (forwardedFor != null && !forwardedFor.isBlank()) {
            return forwardedFor.split(",")[0].trim();
        }
        String realIp = request.getHeader("X-Real-IP");
        if (realIp != null && !realIp.isBlank()) {
            return realIp.trim();
        }
        return request.getRemoteAddr() == null ? "unknown" : request.getRemoteAddr();
    }

    private String sha256(String value) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest((value == null ? "" : value).getBytes(StandardCharsets.UTF_8));
            return HexFormat.of().formatHex(hash);
        } catch (NoSuchAlgorithmException exception) {
            throw new IllegalStateException("SHA-256 is not available", exception);
        }
    }

    private Instant now() {
        return Instant.now(clock);
    }

    private Duration positiveOrDefault(Duration value, Duration fallback) {
        return value == null || value.isZero() || value.isNegative() ? fallback : value;
    }

    private void throwRateLimitExceeded() {
        throw new ResponseStatusException(HttpStatus.TOO_MANY_REQUESTS, RATE_LIMIT_MESSAGE);
    }

    private static final class LoginAttemptBucket {
        private Instant windowStartedAt;
        private int failureCount;
        private Instant lockedUntil;

        private LoginAttemptBucket(Instant windowStartedAt) {
            this.windowStartedAt = windowStartedAt;
        }
    }

    private static final class RequestWindowBucket {
        private Instant windowStartedAt;
        private int requestCount;

        private RequestWindowBucket(Instant windowStartedAt) {
            this.windowStartedAt = windowStartedAt;
        }
    }
}
