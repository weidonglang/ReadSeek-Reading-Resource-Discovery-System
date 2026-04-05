package com.weidonglang.NewBookRecommendationSystem.controller;

import com.weidonglang.NewBookRecommendationSystem.dto.UserDto;
import com.weidonglang.NewBookRecommendationSystem.dto.UserReadingInfoDto;
import com.weidonglang.NewBookRecommendationSystem.dto.base.response.ApiResponse;
import com.weidonglang.NewBookRecommendationSystem.enums.UserGender;
import com.weidonglang.NewBookRecommendationSystem.enums.UserMartialStatus;
import com.weidonglang.NewBookRecommendationSystem.service.UserReadingInfoService;
import com.weidonglang.NewBookRecommendationSystem.service.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class UserControllerTest {

    @Mock
    private UserService userService;

    @Mock
    private UserReadingInfoService userReadingInfoService;

    private UserController controller;

    @BeforeEach
    void setUp() {
        controller = new UserController(userService, userReadingInfoService);
    }

    @Test
    void testGetService() {
        assertSame(userService, controller.getService());
    }

    @Test
    void testGetUserGenders() {
        List<UserGender> genders = List.of(UserGender.MALE, UserGender.FEMALE);
        when(userService.getUserGenders()).thenReturn(genders);

        ApiResponse response = controller.getUserGenders();

        assertTrue(response.getSuccess());
        assertEquals("User genders fetched successfully.", response.getMessage());
        assertSame(genders, response.getBody());
        assertNotNull(response.getTimestamp());
        verify(userService).getUserGenders();
    }

    @Test
    void testGetUserMartialStatuses() {
        List<UserMartialStatus> statuses = List.of(UserMartialStatus.SINGLE, UserMartialStatus.MARRIED);
        when(userService.getUserMartialStatuses()).thenReturn(statuses);

        ApiResponse response = controller.getUserMartialStatuses();

        assertTrue(response.getSuccess());
        assertEquals("User martial status fetched successfully.", response.getMessage());
        assertSame(statuses, response.getBody());
        assertNotNull(response.getTimestamp());
        verify(userService).getUserMartialStatuses();
    }

    @Test
    void testFindUserReadingInfo() {
        UserReadingInfoDto readingInfo = new UserReadingInfoDto();
        readingInfo.setId(11L);
        when(userReadingInfoService.findUserReadingInfo()).thenReturn(readingInfo);

        ApiResponse response = controller.findUserReadingInfo();

        assertTrue(response.getSuccess());
        assertEquals("User reading info fetched successfully.", response.getMessage());
        assertSame(readingInfo, response.getBody());
        assertNotNull(response.getTimestamp());
        verify(userReadingInfoService).findUserReadingInfo();
    }

    @Test
    void testCheckIsEmailAlreadyExists() {
        when(userService.isUserExistsByEmail("jane.doe@example.org")).thenReturn(true);

        ApiResponse response = controller.checkIsEmailAlreadyExists("jane.doe@example.org");

        assertTrue(response.getSuccess());
        assertEquals("Email existence checked successfully.", response.getMessage());
        assertEquals(true, response.getBody());
        assertNotNull(response.getTimestamp());
        verify(userService).isUserExistsByEmail("jane.doe@example.org");
    }

    @Test
    void testCreateUser() {
        UserDto userDto = new UserDto();
        userDto.setId(1L);
        userDto.setEmail("new@example.org");
        when(userService.create(userDto)).thenReturn(userDto);

        ApiResponse response = controller.createUser(userDto);

        assertTrue(response.getSuccess());
        assertEquals("User created successfully.", response.getMessage());
        assertSame(userDto, response.getBody());
        assertNotNull(response.getTimestamp());
        verify(userService).create(userDto);
    }

    @Test
    void testCreateUserReadingInfo() {
        UserReadingInfoDto readingInfo = new UserReadingInfoDto();
        readingInfo.setId(22L);
        when(userReadingInfoService.create(readingInfo)).thenReturn(readingInfo);

        ApiResponse response = controller.createUserReadingInfo(readingInfo);

        assertTrue(response.getSuccess());
        assertEquals("User reading info created successfully.", response.getMessage());
        assertSame(readingInfo, response.getBody());
        assertNotNull(response.getTimestamp());
        verify(userReadingInfoService).create(readingInfo);
    }

    @Test
    void testUpdateUser() {
        UserDto userDto = new UserDto();
        userDto.setId(3L);
        when(userService.update(userDto, 3L)).thenReturn(userDto);

        ApiResponse response = controller.updateUser(userDto);

        assertTrue(response.getSuccess());
        assertEquals("User updated successfully.", response.getMessage());
        assertSame(userDto, response.getBody());
        assertNotNull(response.getTimestamp());
        verify(userService).update(userDto, 3L);
    }
}
