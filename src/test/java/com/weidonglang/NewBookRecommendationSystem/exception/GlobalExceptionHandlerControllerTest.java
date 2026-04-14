package com.weidonglang.NewBookRecommendationSystem.exception;

import com.auth0.jwt.exceptions.JWTVerificationException;
import com.weidonglang.NewBookRecommendationSystem.dto.base.response.ApiResponse;
import jakarta.persistence.EntityExistsException;
import jakarta.persistence.EntityNotFoundException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

class GlobalExceptionHandlerControllerTest {

    private GlobalExceptionHandlerController handler;

    @BeforeEach
    void setUp() {
        handler = new GlobalExceptionHandlerController();
    }

    @Test
    void handleJwtVerificationExceptionReturnsUnauthorized() {
        ResponseEntity<ApiResponse> response = handler.handleJWTVerificationException(new JWTVerificationException("Expired token"));

        assertEquals(HttpStatus.UNAUTHORIZED, response.getStatusCode());
        assertEquals("Authentication token is invalid or expired.", response.getBody().getMessage());
        assertNull(response.getBody().getBody());
    }

    @Test
    void handleAuthenticationExceptionKeepsSafeLoginMessage() {
        ResponseEntity<ApiResponse> response = handler.handleAuthenticationException(new BadCredentialsException("Invalid email or password"));

        assertEquals(HttpStatus.UNAUTHORIZED, response.getStatusCode());
        assertEquals("Invalid email or password", response.getBody().getMessage());
    }

    @Test
    void handleEntityNotFoundReturnsNotFound() {
        ResponseEntity<ApiResponse> response = handler.handleEntityNotFoundException(new EntityNotFoundException("Book not found for id: 99"));

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
        assertEquals("Book not found for id: 99", response.getBody().getMessage());
    }

    @Test
    void handleEntityExistsReturnsConflict() {
        ResponseEntity<ApiResponse> response = handler.handleEntityExistsException(new EntityExistsException("User email already exists"));

        assertEquals(HttpStatus.CONFLICT, response.getStatusCode());
        assertEquals("User email already exists", response.getBody().getMessage());
    }

    @Test
    void handleDataIntegrityViolationDoesNotExposeDatabaseDetails() {
        ResponseEntity<ApiResponse> response = handler.handleDataIntegrityViolationException(
                new DataIntegrityViolationException("duplicate key value violates unique constraint book_name_key")
        );

        assertEquals(HttpStatus.CONFLICT, response.getStatusCode());
        assertEquals("The request conflicts with the current state of the resource.", response.getBody().getMessage());
        assertNull(response.getBody().getBody());
    }

    @Test
    void handleExceptionReturnsInternalServerError() {
        ResponseEntity<ApiResponse> response = handler.handleException(new RuntimeException("database stacktrace"));

        assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.getStatusCode());
        assertEquals("An unexpected internal error occurred.", response.getBody().getMessage());
    }
}
