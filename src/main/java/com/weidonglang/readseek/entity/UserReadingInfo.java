package com.weidonglang.readseek.entity;

import com.weidonglang.readseek.entity.base.BaseEntity;
import com.weidonglang.readseek.enums.UserReadingLevel;
import lombok.*;

import jakarta.persistence.*;
import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "user_reading_info", schema = "public")
public class UserReadingInfo extends BaseEntity {

    @Id
    @SequenceGenerator(name = "user_reading_info_id_sequence", sequenceName = "user_reading_info_id_sequence", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "user_reading_info_id_sequence")
    private Long id;

    @OneToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Enumerated(EnumType.STRING)
    @Column(name = "reading_level", nullable = false)
    private UserReadingLevel readingLevel;

    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @Transient
    private List<UserBookCategory> userBookCategories;
}
/*
weidonglang
2026.3-2027.9
*/
