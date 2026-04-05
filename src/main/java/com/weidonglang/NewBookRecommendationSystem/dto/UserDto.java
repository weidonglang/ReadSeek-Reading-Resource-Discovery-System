package com.weidonglang.NewBookRecommendationSystem.dto;

import com.weidonglang.NewBookRecommendationSystem.dto.base.BaseDto;
import com.weidonglang.NewBookRecommendationSystem.enums.UserGender;
import com.weidonglang.NewBookRecommendationSystem.enums.UserMartialStatus;
import com.weidonglang.NewBookRecommendationSystem.enums.UserRole;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserDto extends BaseDto {
    private Long id;
    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private String phoneNumber;
    private Date birthdate;
    private String country;
    private Integer age;
    private UserGender gender;
    private UserMartialStatus maritalStatus;
    private UserRole role;
    private String imageUrl;
}
/*
weidonglang
2026.3-2027.9
*/
