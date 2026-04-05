package com.weidonglang.NewBookRecommendationSystem.entity;

import com.weidonglang.NewBookRecommendationSystem.entity.base.BaseEntity;
import com.weidonglang.NewBookRecommendationSystem.enums.UserBehaviorActionType;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

/**
 * Minimal behavior log for search, detail clicks, recommendations, rating, and borrowing.
 */
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "user_behavior_log", schema = "public")
public class UserBehaviorLog extends BaseEntity {

    @Id
    @SequenceGenerator(name = "user_behavior_log_id_sequence", sequenceName = "user_behavior_log_id_sequence", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "user_behavior_log_id_sequence")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "book_id")
    private Book book;

    @Enumerated(EnumType.STRING)
    @Column(name = "action_type", nullable = false)
    private UserBehaviorActionType actionType;

    @Column(name = "keyword")
    private String keyword;

    @Column(name = "source")
    private String source;

    @Column(name = "reason")
    private String reason;
}
/*
weidonglang
2026.3-2027.9
*/
