package com.henry.bookrecommendationsystem.repository;

import com.henry.bookrecommendationsystem.entity.Tag;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
@Repository
public interface TagRepository extends JpaRepository<Tag, Long> {
    List<Tag> findAllByMarkedAsDeletedFalseOrderByNameAsc();
}
