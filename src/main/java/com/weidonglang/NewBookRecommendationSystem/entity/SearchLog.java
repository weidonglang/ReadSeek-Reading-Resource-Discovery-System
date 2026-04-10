package com.weidonglang.NewBookRecommendationSystem.entity;

import com.weidonglang.NewBookRecommendationSystem.entity.base.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;

/**
 * Dedicated search log table reserved for search/retrieval evolution.
 */
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "search_log", schema = "public")
public class SearchLog extends BaseEntity {

    @Id
    @SequenceGenerator(name = "search_log_id_sequence", sequenceName = "search_log_id_sequence", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "search_log_id_sequence")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "keyword")
    private String keyword;

    @Column(name = "source")
    private String source;

    @Column(name = "reason")
    private String reason;

    @Column(name = "category_ids")
    private String categoryIds;

    @Column(name = "author_ids")
    private String authorIds;

    @Column(name = "publisher_ids")
    private String publisherIds;

    @Column(name = "tag_ids")
    private String tagIds;

    @Column(name = "from_price")
    private Double fromPrice;

    @Column(name = "to_price")
    private Double toPrice;

    @Column(name = "from_pages_number")
    private Integer fromPagesNumber;

    @Column(name = "to_pages_number")
    private Integer toPagesNumber;

    @Column(name = "from_reading_duration")
    private Integer fromReadingDuration;

    @Column(name = "to_reading_duration")
    private Integer toReadingDuration;

    @Column(name = "sort_by")
    private String sortBy;

    @Column(name = "page_number")
    private Integer pageNumber;

    @Column(name = "page_size")
    private Integer pageSize;

    @Column(name = "deleted_records")
    private Boolean deletedRecords;

    @Column(name = "result_count")
    private Long resultCount;
}
/*
weidonglang
2026.3-2027.9
*/
