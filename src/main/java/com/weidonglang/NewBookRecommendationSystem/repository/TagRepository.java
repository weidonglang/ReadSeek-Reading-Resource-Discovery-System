package com.weidonglang.NewBookRecommendationSystem.repository;

import com.weidonglang.NewBookRecommendationSystem.entity.Tag;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
@Repository
public interface TagRepository extends JpaRepository<Tag, Long> {
    List<Tag> findAllByMarkedAsDeletedFalseOrderByNameAsc();
}
/*
weidonglang
2026.3-2027.9
*/
