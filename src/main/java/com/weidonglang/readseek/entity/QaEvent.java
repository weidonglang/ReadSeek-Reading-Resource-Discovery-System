package com.weidonglang.readseek.entity;

import com.weidonglang.readseek.entity.base.BaseEntity;
import com.weidonglang.readseek.enums.QaEventType;
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
@Table(name = "qa_event", schema = "public")
public class QaEvent extends BaseEntity {
    @Id
    @SequenceGenerator(name = "qa_event_id_sequence", sequenceName = "qa_event_id_sequence", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "qa_event_id_sequence")
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(name = "event_type", nullable = false)
    private QaEventType eventType;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "book_id")
    private Book book;

    @Column(name = "question", length = 1000)
    private String question;

    @Column(name = "answer_mode", length = 80)
    private String answerMode;

    @Column(name = "rag_mode", length = 40)
    private String ragMode;

    @Column(name = "provider", length = 80)
    private String provider;

    @Column(name = "model", length = 160)
    private String model;

    @Column(name = "answerable")
    private Boolean answerable;

    @Column(name = "evidence_count")
    private Integer evidenceCount;

    @Column(name = "citation_count")
    private Integer citationCount;

    @Column(name = "retrieval_strategy", length = 160)
    private String retrievalStrategy;

    @Column(name = "fallback_applied")
    private Boolean fallbackApplied;

    @Column(name = "fallback_reason", length = 1000)
    private String fallbackReason;

    @Column(name = "confidence")
    private Double confidence;

    @Column(name = "retrieval_latency_ms")
    private Long retrievalLatencyMs;

    @Column(name = "generation_latency_ms")
    private Long generationLatencyMs;

    @Column(name = "total_latency_ms")
    private Long totalLatencyMs;

    @Column(name = "referenced_book_ids", length = 1000)
    private String referencedBookIds;

    @Column(name = "citation", length = 80)
    private String citation;
}
