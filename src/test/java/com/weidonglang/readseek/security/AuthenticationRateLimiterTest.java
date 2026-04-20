package com.weidonglang.readseek.security;

import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.web.server.ResponseStatusException;

import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.time.ZoneOffset;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

class AuthenticationRateLimiterTest {

    @Test
    void blocksLoginAfterConfiguredFailures() {
        AuthenticationRateLimiter limiter = new AuthenticationRateLimiter(
                2,
                Duration.ofMinutes(15),
                Duration.ofMinutes(15),
                30,
                Duration.ofMinutes(10),
                fixedClock()
        );
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.setRemoteAddr("127.0.0.1");

        limiter.checkLoginAllowed("user@example.com", request);
        limiter.recordLoginFailure("user@example.com", request);
        limiter.recordLoginFailure("user@example.com", request);

        ResponseStatusException exception = assertThrows(ResponseStatusException.class,
                () -> limiter.checkLoginAllowed("user@example.com", request));
        assertEquals(429, exception.getStatusCode().value());
    }

    @Test
    void clearsLoginFailuresAfterSuccess() {
        AuthenticationRateLimiter limiter = new AuthenticationRateLimiter(
                2,
                Duration.ofMinutes(15),
                Duration.ofMinutes(15),
                30,
                Duration.ofMinutes(10),
                fixedClock()
        );
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.setRemoteAddr("127.0.0.1");

        limiter.recordLoginFailure("user@example.com", request);
        limiter.recordLoginSuccess("user@example.com", request);

        assertDoesNotThrow(() -> limiter.checkLoginAllowed("user@example.com", request));
    }

    @Test
    void blocksRefreshAfterConfiguredWindowLimit() {
        AuthenticationRateLimiter limiter = new AuthenticationRateLimiter(
                5,
                Duration.ofMinutes(15),
                Duration.ofMinutes(15),
                1,
                Duration.ofMinutes(10),
                fixedClock()
        );
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.setRemoteAddr("127.0.0.1");

        limiter.checkRefreshAllowed("user@example.com", "refresh-token", request);

        ResponseStatusException exception = assertThrows(ResponseStatusException.class,
                () -> limiter.checkRefreshAllowed("user@example.com", "refresh-token", request));
        assertEquals(429, exception.getStatusCode().value());
    }

    private Clock fixedClock() {
        return Clock.fixed(Instant.parse("2026-04-16T00:00:00Z"), ZoneOffset.UTC);
    }
}
