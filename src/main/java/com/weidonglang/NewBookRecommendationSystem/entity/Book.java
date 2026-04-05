package com.weidonglang.NewBookRecommendationSystem.entity;

import com.weidonglang.NewBookRecommendationSystem.entity.base.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.util.Date;
import java.util.Set;
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "book", schema = "public")
public class Book extends BaseEntity {

    @Id
    @SequenceGenerator(name = "book_id_sequence", sequenceName = "book_id_sequence", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "book_id_sequence")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "author_id", nullable = false)
    private Author author;

    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "isbn")
    private String isbn;

    @ManyToOne
    @JoinColumn(name = "category_id", nullable = false)
    private BookCategory category;

    @ManyToOne
    @JoinColumn(name = "publisher_id")
    private Publisher publisher;

    @Column(name = "rate", nullable = false)
    private Double rate;

    @Column(name = "users_rate_count", nullable = false)
    private Long usersRateCount;

    @Column(name = "price", nullable = false)
    private Double price;

    @Column(name = "pages_number", nullable = false)
    private Integer pagesNumber;

    @Column(name = "reading_duration", nullable = false)
    private Integer readingDuration;

    @Column(name = "publish_date", nullable = false)
    private Date publishDate;

    @Column(name = "description", nullable = false)
    private String description;

    @Column(name = "image_url", nullable = false)
    private String imageUrl;

    @Column(name = "total_copies", nullable = false)
    private Integer totalCopies;

    @Column(name = "available_copies", nullable = false)
    private Integer availableCopies;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "book_tag", schema = "public",
            joinColumns = @JoinColumn(name = "book_id"),
            inverseJoinColumns = @JoinColumn(name = "tag_id"))
    private Set<Tag> tags;
}
/*
weidonglang
2026.3-2027.9
*/
