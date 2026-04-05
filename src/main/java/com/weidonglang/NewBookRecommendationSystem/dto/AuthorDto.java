package com.weidonglang.NewBookRecommendationSystem.dto;

import com.weidonglang.NewBookRecommendationSystem.dto.base.BaseDto;
import com.weidonglang.NewBookRecommendationSystem.enums.UserGender;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AuthorDto extends BaseDto {
    private Long id;
    private String name;
    private String description;
    private Date birthdate;
    private Date deathdate;
    private String country;
    private Integer age;
    private UserGender gender;
    private String imageUrl;
}
/*
weidonglang
2026.3-2027.9
*/
