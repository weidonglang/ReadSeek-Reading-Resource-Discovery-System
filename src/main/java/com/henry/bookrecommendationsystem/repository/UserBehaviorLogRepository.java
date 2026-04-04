package com.henry.bookrecommendationsystem.repository;

import com.henry.bookrecommendationsystem.entity.UserBehaviorLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface UserBehaviorLogRepository extends JpaRepository<UserBehaviorLog, Long> {
}
