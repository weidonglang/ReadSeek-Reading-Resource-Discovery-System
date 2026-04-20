package com.weidonglang.readseek.repository;

import com.weidonglang.readseek.entity.RecommendationEvent;
import com.weidonglang.readseek.enums.RecommendationEventType;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RecommendationEventRepository extends JpaRepository<RecommendationEvent, Long> {
    @EntityGraph(attributePaths = {"user", "book"})
    List<RecommendationEvent> findByMarkedAsDeletedFalseOrderByCreatedDateDesc(Pageable pageable);

    @EntityGraph(attributePaths = {"user", "book"})
    List<RecommendationEvent> findByEventTypeAndMarkedAsDeletedFalseOrderByCreatedDateDesc(RecommendationEventType eventType,
                                                                                           Pageable pageable);
}
