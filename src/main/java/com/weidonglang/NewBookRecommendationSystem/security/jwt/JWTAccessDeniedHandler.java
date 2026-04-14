package com.weidonglang.NewBookRecommendationSystem.security.jwt;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.weidonglang.NewBookRecommendationSystem.dto.base.response.ApiResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDateTime;

@Component
public class JWTAccessDeniedHandler implements AccessDeniedHandler {
    private static final String ACCESS_DENIED_MESSAGE = "You do not have permission to perform this action.";

    @Override
    public void handle(HttpServletRequest request,
                       HttpServletResponse response,
                       AccessDeniedException accessDeniedException) throws IOException {
        response.setStatus(HttpStatus.FORBIDDEN.value());
        response.setContentType("application/json");
        OutputStream outputStream = response.getOutputStream();
        ObjectMapper mapper = new ObjectMapper();
        mapper.writeValue(outputStream, new ApiResponse(false, LocalDateTime.now().toString(), ACCESS_DENIED_MESSAGE, null));
        outputStream.flush();
    }
}
