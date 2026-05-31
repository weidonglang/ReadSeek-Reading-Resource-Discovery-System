package com.weidonglang.readseek.repository;

import com.weidonglang.readseek.entity.QaEvent;
import com.weidonglang.readseek.enums.QaEventType;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface QaEventRepository extends JpaRepository<QaEvent, Long> {
    @EntityGraph(attributePaths = {"user", "book"})
    List<QaEvent> findByMarkedAsDeletedFalseOrderByCreatedDateDesc(Pageable pageable);

    @EntityGraph(attributePaths = {"user", "book"})
    List<QaEvent> findByEventTypeAndMarkedAsDeletedFalseOrderByCreatedDateDesc(QaEventType eventType, Pageable pageable);

    long countByEventTypeAndMarkedAsDeletedFalse(QaEventType eventType);

    long countByEventTypeAndAnswerableAndMarkedAsDeletedFalse(QaEventType eventType, Boolean answerable);

    long countByEventTypeAndCreatedDateGreaterThanEqualAndMarkedAsDeletedFalse(QaEventType eventType, LocalDateTime fromDate);

    long countByEventTypeAndAnswerableAndCreatedDateGreaterThanEqualAndMarkedAsDeletedFalse(QaEventType eventType,
                                                                                            Boolean answerable,
                                                                                            LocalDateTime fromDate);

    @Query("select avg(e.totalLatencyMs) from QaEvent e where e.eventType = :eventType and e.markedAsDeleted = false and e.totalLatencyMs is not null")
    Double averageLatency(@Param("eventType") QaEventType eventType);

    @Query("select avg(e.totalLatencyMs) from QaEvent e where e.eventType = :eventType and e.markedAsDeleted = false and e.createdDate >= :fromDate and e.totalLatencyMs is not null")
    Double averageLatencySince(@Param("eventType") QaEventType eventType, @Param("fromDate") LocalDateTime fromDate);
}
