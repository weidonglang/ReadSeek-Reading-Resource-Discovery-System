package com.weidonglang.readseek.controller;

import com.weidonglang.readseek.controller.base.BaseController;
import com.weidonglang.readseek.dto.UserDto;
import com.weidonglang.readseek.dto.UserReadingInfoDto;
import com.weidonglang.readseek.dto.base.response.ApiResponse;
import com.weidonglang.readseek.service.HomeDashboardService;
import com.weidonglang.readseek.service.UserReadingInfoService;
import com.weidonglang.readseek.service.UserService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
@Slf4j
@CrossOrigin
@RestController
@AllArgsConstructor
@RequestMapping("/api/user")
public class UserController implements BaseController<UserService> {
    private final UserService userService;
    private final UserReadingInfoService userReadingInfoService;
    private final HomeDashboardService homeDashboardService;

    @Override
    public UserService getService() {
        return userService;
    }

    @GetMapping("/find-all-genders")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse getUserGenders() {
        log.info("UserController: getUserGenders() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "User genders fetched successfully.", getService().getUserGenders());
    }

    @GetMapping("/find-all-martial-statuses")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse getUserMartialStatuses() {
        log.info("UserController: getUserMartialStatuses() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "User martial status fetched successfully.", getService().getUserMartialStatuses());
    }

    @GetMapping("/find-reading-info")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse findUserReadingInfo() {
        log.info("UserController: createUserReadingInfo() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "User reading info fetched successfully.", userReadingInfoService.findUserReadingInfo());
    }

    @GetMapping("/reading-info/status")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse findUserReadingPreferenceStatus() {
        log.info("UserController: findUserReadingPreferenceStatus() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "User reading preference status fetched successfully.",
                userReadingInfoService.findCurrentUserReadingPreferenceStatus());
    }

    @GetMapping("/home-dashboard")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse findCurrentUserHomeDashboard() {
        log.info("UserController: findCurrentUserHomeDashboard() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Current user home dashboard fetched successfully.", homeDashboardService.buildCurrentUserDashboard());
    }

    @GetMapping("/find-is-email-exists/{email}")
    public ApiResponse checkIsEmailAlreadyExists(@PathVariable String email) {
        log.info("UserController: checkIsEmailAlreadyExists() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "Email existence checked successfully.", getService().isUserExistsByEmail(email));
    }

    @PostMapping
    public ApiResponse createUser(@RequestBody UserDto userDto) {
        log.info("UserController: createUser() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "User created successfully.", getService().create(userDto));
    }

    @PostMapping("/reading-info")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse createUserReadingInfo(@RequestBody UserReadingInfoDto userReadingInfoDto) {
        log.info("UserController: createUserReadingInfo() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "User reading info created successfully.", userReadingInfoService.create(userReadingInfoDto));
    }

    @PutMapping
    @PreAuthorize("isAuthenticated()")
    public ApiResponse updateUser(@RequestBody UserDto userDto) {
        log.info("UserController: updateUser() called");
        return new ApiResponse(true, LocalDateTime.now().toString(),
                "User updated successfully.", getService().update(userDto, userDto.getId()));
    }
}
/*
weidonglang
2026.3-2027.9
*/
