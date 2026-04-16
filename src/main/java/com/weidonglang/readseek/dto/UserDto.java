package com.weidonglang.readseek.dto;

import com.weidonglang.readseek.dto.base.BaseDto;
import com.weidonglang.readseek.enums.UserGender;
import com.weidonglang.readseek.enums.UserMartialStatus;
import com.weidonglang.readseek.enums.UserRole;
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
