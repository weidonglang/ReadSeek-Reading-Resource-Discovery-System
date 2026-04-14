package com.weidonglang.NewBookRecommendationSystem.exception;

import com.auth0.jwt.exceptions.JWTVerificationException;
import com.weidonglang.NewBookRecommendationSystem.dto.base.response.ApiResponse;
import jakarta.persistence.EntityExistsException;
import jakarta.persistence.EntityNotFoundException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

import java.time.LocalDateTime;

@Slf4j
@ControllerAdvice
public class GlobalExceptionHandlerController extends ResponseEntityExceptionHandler {
    private static final String UNAUTHORIZED_MESSAGE = "Authentication failed.";
    private static final String ACCESS_DENIED_MESSAGE = "You do not have permission to perform this action.";
    private static final String CONFLICT_MESSAGE = "The request conflicts with the current state of the resource.";
    private static final String INTERNAL_ERROR_MESSAGE = "An unexpected internal error occurred.";

    @ExceptionHandler(JWTVerificationException.class)
    public ResponseEntity<ApiResponse> handleJWTVerificationException(JWTVerificationException exception) {
        log.warn("GlobalExceptionHandlerController: JWT verification failed", exception);
        return buildErrorResponse(HttpStatus.UNAUTHORIZED, "Authentication token is invalid or expired.");
    }

    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<ApiResponse> handleAuthenticationException(AuthenticationException exception) {
        log.warn("GlobalExceptionHandlerController: authentication failed", exception);
        String message = "Invalid email or password".equals(exception.getMessage())
                ? exception.getMessage()
                : UNAUTHORIZED_MESSAGE;
        return buildErrorResponse(HttpStatus.UNAUTHORIZED, message);
    }

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ApiResponse> handleAccessDeniedException(AccessDeniedException exception) {
        log.warn("GlobalExceptionHandlerController: access denied", exception);
        return buildErrorResponse(HttpStatus.FORBIDDEN, ACCESS_DENIED_MESSAGE);
    }

    @ExceptionHandler(EntityNotFoundException.class)
    public ResponseEntity<ApiResponse> handleEntityNotFoundException(EntityNotFoundException exception) {
        log.warn("GlobalExceptionHandlerController: entity not found", exception);
        return buildErrorResponse(HttpStatus.NOT_FOUND, resolveClientMessage(exception.getMessage(), "Resource not found."));
    }

    @ExceptionHandler(EntityExistsException.class)
    public ResponseEntity<ApiResponse> handleEntityExistsException(EntityExistsException exception) {
        log.warn("GlobalExceptionHandlerController: business conflict", exception);
        return buildErrorResponse(HttpStatus.CONFLICT, resolveClientMessage(exception.getMessage(), CONFLICT_MESSAGE));
    }

    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<ApiResponse> handleDataIntegrityViolationException(DataIntegrityViolationException exception) {
        log.warn("GlobalExceptionHandlerController: data integrity violation", exception);
        return buildErrorResponse(HttpStatus.CONFLICT, CONFLICT_MESSAGE);
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ApiResponse> handleIllegalArgumentException(IllegalArgumentException exception) {
        log.warn("GlobalExceptionHandlerController: invalid request", exception);
        return buildErrorResponse(HttpStatus.BAD_REQUEST, resolveClientMessage(exception.getMessage(), "Invalid request."));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse> handleException(Exception exception) {
        log.error("GlobalExceptionHandlerController: unhandled exception", exception);
        return buildErrorResponse(HttpStatus.INTERNAL_SERVER_ERROR, INTERNAL_ERROR_MESSAGE);
    }

    @Override
    protected ResponseEntity<Object> handleMethodArgumentNotValid(MethodArgumentNotValidException exception,
                                                                  HttpHeaders headers,
                                                                  HttpStatusCode status,
                                                                  WebRequest request) {
        String message = exception.getBindingResult().getFieldErrors().stream()
                .findFirst()
                .map(fieldError -> fieldError.getField() + " " + fieldError.getDefaultMessage())
                .orElse("Invalid request payload.");
        return buildFrameworkErrorResponse(HttpStatus.BAD_REQUEST, message);
    }

    @Override
    protected ResponseEntity<Object> handleHttpMessageNotReadable(HttpMessageNotReadableException exception,
                                                                  HttpHeaders headers,
                                                                  HttpStatusCode status,
                                                                  WebRequest request) {
        log.warn("GlobalExceptionHandlerController: malformed request body", exception);
        return buildFrameworkErrorResponse(HttpStatus.BAD_REQUEST, "Malformed request body.");
    }

    private ResponseEntity<ApiResponse> buildErrorResponse(HttpStatus status, String message) {
        return ResponseEntity.status(status)
                .body(new ApiResponse(false, LocalDateTime.now().toString(), message, null));
    }

    private ResponseEntity<Object> buildFrameworkErrorResponse(HttpStatus status, String message) {
        return ResponseEntity.status(status)
                .body(new ApiResponse(false, LocalDateTime.now().toString(), message, null));
    }

    private String resolveClientMessage(String message, String fallback) {
        if (message == null || message.isBlank()) {
            return fallback;
        }
        return message;
    }
}
