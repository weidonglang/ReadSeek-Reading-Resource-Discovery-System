package com.weidonglang.NewBookRecommendationSystem.entity;

import com.weidonglang.NewBookRecommendationSystem.entity.base.BaseEntity;
import com.weidonglang.NewBookRecommendationSystem.enums.UserGender;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.*;
import java.util.Date;
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "author", schema = "public")
public class Author extends BaseEntity {

    @Id
    @SequenceGenerator(name = "author_id_sequence", sequenceName = "author_id_sequence", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "author_id_sequence")
    private Long id;

    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "description", nullable = false)
    private String description;

    @Column(name = "birthdate", nullable = false)
    private Date birthdate;

    @Column(name = "deathdate")
    private Date deathdate;

    @Column(name = "country", nullable = false)
    private String country;

    @Column(name = "age", nullable = false)
    private Integer age;

    @Enumerated(EnumType.STRING)
    @Column(name = "gender", nullable = false)
    private UserGender gender;

    @Column(name = "image_url", nullable = false)
    private String imageUrl;
}
/*
weidonglang
2026.3-2027.9
*/
