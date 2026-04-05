package com.weidonglang.NewBookRecommendationSystem.entity;

import com.weidonglang.NewBookRecommendationSystem.entity.base.BaseEntity;
import com.weidonglang.NewBookRecommendationSystem.enums.BookLoanStatus;
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
@Table(name = "book_loan", schema = "public")
public class BookLoan extends BaseEntity {

    @Id
    @SequenceGenerator(name = "book_loan_id_sequence", sequenceName = "book_loan_id_sequence", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "book_loan_id_sequence")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "book_id", nullable = false)
    private Book book;

    @Column(name = "borrowed_at", nullable = false)
    private LocalDateTime borrowedAt;

    @Column(name = "due_date", nullable = false)
    private LocalDateTime dueDate;

    @Column(name = "returned_at")
    private LocalDateTime returnedAt;

    @Column(name = "renew_count", nullable = false)
    private Integer renewCount = 0;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private BookLoanStatus status;
}
/*
weidonglang
2026.3-2027.9
*/
