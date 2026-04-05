package com.weidonglang.NewBookRecommendationSystem.entity;

import com.weidonglang.NewBookRecommendationSystem.entity.base.BaseEntity;
import com.weidonglang.NewBookRecommendationSystem.enums.UserGender;
import com.weidonglang.NewBookRecommendationSystem.enums.UserMartialStatus;
import com.weidonglang.NewBookRecommendationSystem.enums.UserRole;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.util.Date;
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "user", schema = "public")
public class User extends BaseEntity {

    @Id
    @SequenceGenerator(name = "user_id_sequence", sequenceName = "user_id_sequence", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "user_id_sequence")
    private Long id;

    @Column(name = "first_name", nullable = false)
    private String firstName;

    @Column(name = "last_name", nullable = false)
    private String lastName;

    @Column(name = "email", unique = true, updatable = false, nullable = false)
    private String email;

    @Column(name = "password", nullable = false)
    private String password;

    @Column(name = "phone_number")
    private String phoneNumber;

    @Column(name = "birthdate")
    private Date birthdate;

    @Column(name = "country")
    private String country;

    @Column(name = "age")
    private Integer age;

    @Column(name = "gender")
    private UserGender gender;

    @Column(name = "marital_status")
    private UserMartialStatus maritalStatus;

    @Enumerated(EnumType.STRING)
    @Column(name = "role", nullable = false)
    private UserRole role = UserRole.USER;

    @Column(name = "image_url")
    private String imageUrl;
}
/*
weidonglang
2026.3-2027.9
*/
