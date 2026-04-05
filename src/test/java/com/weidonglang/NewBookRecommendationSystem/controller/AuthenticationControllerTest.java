package com.weidonglang.NewBookRecommendationSystem.controller;

import com.weidonglang.NewBookRecommendationSystem.dto.UserDto;
import com.weidonglang.NewBookRecommendationSystem.dto.base.request.AuthRequest;
import com.weidonglang.NewBookRecommendationSystem.dto.base.request.RefreshTokenRequest;
import com.weidonglang.NewBookRecommendationSystem.dto.base.response.ApiResponse;
import com.weidonglang.NewBookRecommendationSystem.dto.base.response.AuthResponse;
import com.weidonglang.NewBookRecommendationSystem.manager.JWTAuthenticationManager;
import com.weidonglang.NewBookRecommendationSystem.service.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AuthenticationControllerTest {

    @Mock
    private JWTAuthenticationManager jwtAuthenticationManager;

    @Mock
    private UserService userService;

    private AuthenticationController controller;

    @BeforeEach
    void setUp() {
        controller = new AuthenticationController(jwtAuthenticationManager, userService);
    }

    @Test
    void testLogin() {
        AuthRequest authRequest = new AuthRequest();
        authRequest.setEmail("user@example.com");
        authRequest.setPassword("secret");
        AuthResponse authResponse = new AuthResponse("access", 3600L, "refresh", 86400L);
        when(jwtAuthenticationManager.login(authRequest)).thenReturn(authResponse);

        ApiResponse response = controller.login(authRequest);

        assertTrue(response.getSuccess());
        assertEquals("User logged in successfully.", response.getMessage());
        assertSame(authResponse, response.getBody());
        assertNotNull(response.getTimestamp());
        verify(jwtAuthenticationManager).login(authRequest);
    }

    @Test
    void testCurrentLoggedUser() {
        UserDto currentUser = new UserDto();
        currentUser.setId(7L);
        currentUser.setEmail("user@example.com");
        when(userService.getCurrentUser()).thenReturn(currentUser);

        ApiResponse response = controller.currentLoggedUser();

        assertTrue(response.getSuccess());
        assertEquals("Current logged user fetched successfully.", response.getMessage());
        assertSame(currentUser, response.getBody());
        assertNotNull(response.getTimestamp());
        verify(userService).getCurrentUser();
    }

    @Test
    void testRefreshToken() {
        RefreshTokenRequest refreshTokenRequest = new RefreshTokenRequest();
        refreshTokenRequest.setEmail("user@example.com");
        refreshTokenRequest.setRefreshToken("refresh-token");
        AuthResponse authResponse = new AuthResponse("new-access", 3600L, "new-refresh", 86400L);
        when(jwtAuthenticationManager.refreshToken(refreshTokenRequest)).thenReturn(authResponse);

        ApiResponse response = controller.refreshToken(refreshTokenRequest);

        assertTrue(response.getSuccess());
        assertEquals("Token Refreshed successfully.", response.getMessage());
        assertSame(authResponse, response.getBody());
        assertNotNull(response.getTimestamp());
        verify(jwtAuthenticationManager).refreshToken(refreshTokenRequest);
    }

    @Test
    void testLogout() {
        when(jwtAuthenticationManager.logout()).thenReturn(true);

        ApiResponse response = controller.logout();

        assertTrue(response.getSuccess());
        assertEquals("User logged out successfully.", response.getMessage());
        assertEquals(true, response.getBody());
        assertNotNull(response.getTimestamp());
        verify(jwtAuthenticationManager).logout();
    }
}
