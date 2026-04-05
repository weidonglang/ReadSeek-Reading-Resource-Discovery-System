package com.weidonglang.NewBookRecommendationSystem.entity;

import com.weidonglang.NewBookRecommendationSystem.entity.base.BaseEntity;
import com.weidonglang.NewBookRecommendationSystem.enums.BookReservationStatus;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDateTime;
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "book_reservation", schema = "public")
public class BookReservation extends BaseEntity {

    @Id
    @SequenceGenerator(name = "book_reservation_id_sequence", sequenceName = "book_reservation_id_sequence", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "book_reservation_id_sequence")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "book_id", nullable = false)
    private Book book;

    @Column(name = "requested_at", nullable = false)
    private LocalDateTime requestedAt;

    @Column(name = "fulfilled_at")
    private LocalDateTime fulfilledAt;

    @Column(name = "cancelled_at")
    private LocalDateTime cancelledAt;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private BookReservationStatus status;
}
/*
weidonglang
2026.3-2027.9
*/
