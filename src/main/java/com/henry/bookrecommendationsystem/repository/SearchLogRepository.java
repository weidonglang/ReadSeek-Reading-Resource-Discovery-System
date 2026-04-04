package com.henry.bookrecommendationsystem.repository;

import com.henry.bookrecommendationsystem.entity.SearchLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface SearchLogRepository extends JpaRepository<SearchLog, Long> {
}
