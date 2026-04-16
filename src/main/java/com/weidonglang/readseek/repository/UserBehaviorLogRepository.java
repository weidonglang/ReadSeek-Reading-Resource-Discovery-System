package com.weidonglang.readseek.repository;

import com.weidonglang.readseek.entity.UserBehaviorLog;
import com.weidonglang.readseek.enums.UserBehaviorActionType;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;
@Repository
public interface UserBehaviorLogRepository extends JpaRepository<UserBehaviorLog, Long> {
    List<UserBehaviorLog> findByMarkedAsDeletedFalseOrderByCreatedDateDesc(Pageable pageable);

    Long countByMarkedAsDeletedFalse();

    List<UserBehaviorLog> findByMarkedAsDeletedFalseAndCreatedDateGreaterThanEqualOrderByCreatedDateDesc(LocalDateTime fromDate, Pageable pageable);

    List<UserBehaviorLog> findByUserIdAndMarkedAsDeletedFalseOrderByCreatedDateDesc(Long userId);

    List<UserBehaviorLog> findByUserIdAndMarkedAsDeletedFalseOrderByCreatedDateDesc(Long userId, Pageable pageable);

    List<UserBehaviorLog> findByUserIdAndMarkedAsDeletedFalseAndActionTypeInOrderByCreatedDateDesc(Long userId,
                                                                                                     Collection<UserBehaviorActionType> actionTypes,
                                                                                                     Pageable pageable);

    List<UserBehaviorLog> findByBookIdAndMarkedAsDeletedFalseOrderByCreatedDateDesc(Long bookId, Pageable pageable);

    @Query("SELECT ubl.book.id, COUNT(ubl.id) FROM UserBehaviorLog ubl " +
            "WHERE ubl.markedAsDeleted = false " +
            "AND ubl.book IS NOT NULL " +
            "AND ubl.actionType IN :actionTypes " +
            "GROUP BY ubl.book.id ORDER BY COUNT(ubl.id) DESC")
    List<Object[]> aggregateBookActions(@Param("actionTypes") Collection<UserBehaviorActionType> actionTypes,
                                        Pageable pageable);

    @Query("SELECT COUNT(ubl.id) FROM UserBehaviorLog ubl " +
            "WHERE ubl.markedAsDeleted = false " +
            "AND ubl.actionType IN :actionTypes")
    Long countActions(@Param("actionTypes") Collection<UserBehaviorActionType> actionTypes);

    @Query("SELECT COUNT(ubl.id) FROM UserBehaviorLog ubl " +
            "WHERE ubl.markedAsDeleted = false " +
            "AND ubl.actionType IN :actionTypes " +
            "AND ubl.createdDate >= :fromDate")
    Long countActionsSince(@Param("actionTypes") Collection<UserBehaviorActionType> actionTypes,
                           @Param("fromDate") LocalDateTime fromDate);

    @Query("SELECT ubl.book.id, COUNT(ubl.id) FROM UserBehaviorLog ubl " +
            "WHERE ubl.markedAsDeleted = false " +
            "AND ubl.book IS NOT NULL " +
            "AND ubl.actionType IN :actionTypes " +
            "AND ubl.createdDate >= :fromDate " +
            "GROUP BY ubl.book.id ORDER BY COUNT(ubl.id) DESC")
    List<Object[]> aggregateBookActionsSince(@Param("actionTypes") Collection<UserBehaviorActionType> actionTypes,
                                             @Param("fromDate") LocalDateTime fromDate,
                                             Pageable pageable);
}
/*
weidonglang
2026.3-2027.9
*/
