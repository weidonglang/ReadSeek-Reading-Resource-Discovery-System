package com.weidonglang.NewBookRecommendationSystem.entity;

import com.weidonglang.NewBookRecommendationSystem.entity.base.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "user_book_rate", schema = "public")
public class UserBookRate extends BaseEntity {

    @Id
    @SequenceGenerator(name = "user_book_rate_id_sequence", sequenceName = "user_book_rate_id_sequence", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "user_book_rate_id_sequence")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "book_id")
    private Book book;

    @Column(name = "rate")
    private Integer rate;

    @Column(name = "comment")
    private String comment;
}
/*
weidonglang
2026.3-2027.9
*/
