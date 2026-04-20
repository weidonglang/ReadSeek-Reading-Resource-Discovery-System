package com.weidonglang.readseek.dto.base.request;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import jakarta.validation.constraints.NotBlank;
@Data
@NoArgsConstructor
@AllArgsConstructor
public class RefreshTokenRequest {
    @NotBlank(message = "Refresh token email cannot be blank")
    private String email;

    @NotBlank(message = "Refresh token cannot be blank")
    private String refreshToken;
}
/*
weidonglang
2026.3-2027.9
*/
