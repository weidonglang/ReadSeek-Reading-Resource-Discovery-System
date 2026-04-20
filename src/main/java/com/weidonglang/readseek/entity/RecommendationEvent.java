package com.weidonglang.readseek.entity;

import com.weidonglang.readseek.entity.base.BaseEntity;
import com.weidonglang.readseek.enums.RecommendationEventType;
import com.weidonglang.readseek.enums.RecommendationFeedbackType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "recommendation_event", schema = "public")
public class RecommendationEvent extends BaseEntity {

    @Id
    @SequenceGenerator(name = "recommendation_event_id_sequence", sequenceName = "recommendation_event_id_sequence", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "recommendation_event_id_sequence")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "book_id")
    private Book book;

    @Enumerated(EnumType.STRING)
    @Column(name = "event_type", nullable = false)
    private RecommendationEventType eventType;

    @Enumerated(EnumType.STRING)
    @Column(name = "feedback_type")
    private RecommendationFeedbackType feedbackType;

    @Column(name = "overview_title")
    private String overviewTitle;

    @Column(name = "shelf_key")
    private String shelfKey;

    @Column(name = "shelf_title")
    private String shelfTitle;

    @Column(name = "source")
    private String source;

    @Column(name = "reason")
    private String reason;

    @Column(name = "reason_type")
    private String reasonType;

    @Column(name = "rank_position")
    private Integer rankPosition;

    @Column(name = "request_context")
    private String requestContext;

    @Column(name = "comment")
    private String comment;
}
