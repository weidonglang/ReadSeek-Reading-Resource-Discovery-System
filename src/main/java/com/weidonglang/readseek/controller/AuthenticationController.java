package com.weidonglang.readseek.controller;

import com.weidonglang.readseek.dto.base.request.AuthRequest;
import com.weidonglang.readseek.dto.base.request.RefreshTokenRequest;
import com.weidonglang.readseek.dto.base.response.ApiResponse;
import com.weidonglang.readseek.manager.JWTAuthenticationManager;
import com.weidonglang.readseek.service.UserService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.time.LocalDateTime;
@Slf4j
@CrossOrigin
@RestController
@AllArgsConstructor
@RequestMapping("/api/auth")
public class AuthenticationController {
    private final JWTAuthenticationManager jwtAuthenticationManager;
    private final UserService userService;

    @PostMapping("/log-in")
    public ApiResponse login(@Valid @RequestBody AuthRequest authRequest) {
        log.info("AuthenticationController: login() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "User logged in successfully.", jwtAuthenticationManager.login(authRequest));
    }

    @GetMapping("/current")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse currentLoggedUser() {
        log.info("AuthenticationController: currentLoggedUser() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Current logged user fetched successfully.", userService.getCurrentUser());
    }

    @PostMapping("/refresh-token")
//    @PreAuthorize("isAuthenticated()")
    public ApiResponse refreshToken(@Valid @RequestBody RefreshTokenRequest refreshTokenRequest) {
        log.info("AuthenticationController: refreshToken() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Token Refreshed successfully.", jwtAuthenticationManager.refreshToken(refreshTokenRequest));
    }

    @GetMapping("/log-out")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse logout() {
        log.info("AuthenticationController: logout() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "User logged out successfully.", jwtAuthenticationManager.logout());
    }
}
/*
weidonglang
2026.3-2027.9
*/
