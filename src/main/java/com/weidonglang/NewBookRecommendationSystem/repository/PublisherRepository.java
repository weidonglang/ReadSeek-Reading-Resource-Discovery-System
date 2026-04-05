package com.weidonglang.NewBookRecommendationSystem.repository;

import com.weidonglang.NewBookRecommendationSystem.entity.Publisher;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
@Repository
public interface PublisherRepository extends JpaRepository<Publisher, Long> {
    List<Publisher> findAllByMarkedAsDeletedFalseOrderByNameAsc();
}
/*
weidonglang
2026.3-2027.9
*/
