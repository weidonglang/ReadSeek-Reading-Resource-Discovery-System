package com.weidonglang.NewBookRecommendationSystem.dao;

import com.weidonglang.NewBookRecommendationSystem.dto.BookFilterPaginationRequest;
import com.weidonglang.NewBookRecommendationSystem.dto.base.pagination.FilterPaginationRequest;
import com.weidonglang.NewBookRecommendationSystem.entity.Author;
import com.weidonglang.NewBookRecommendationSystem.entity.Book;
import com.weidonglang.NewBookRecommendationSystem.entity.BookCategory;
import com.weidonglang.NewBookRecommendationSystem.entity.Publisher;
import com.weidonglang.NewBookRecommendationSystem.entity.Tag;
import com.weidonglang.NewBookRecommendationSystem.repository.BookRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Component;

import javax.persistence.EntityManager;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Join;
import javax.persistence.criteria.JoinType;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.util.ArrayList;
import java.util.List;
@Component
public class BookDaoImpl implements BookDao {
    private final BookRepository bookRepository;
    private final EntityManager entityManager;

    public BookDaoImpl(BookRepository bookRepository, EntityManager entityManager) {
        this.bookRepository = bookRepository;
        this.entityManager = entityManager;
    }

    @Override
    public BookRepository getRepository() {
        return bookRepository;
    }

    @Override
    public List<Book> findAllBooksByAuthorId(Long authorId) {
        return getRepository().findAllByAuthorIdAndMarkedAsDeletedFalse(authorId);
    }

    @Override
    public List<Book> findAllBooksByCategoriesAndLimit(List<String> categories, Integer limit) {
        List<Book> books = getRepository().findAllByCategoryNameInAndMarkedAsDeletedFalse(categories);
        if (books.size() <= limit) return books;
        return books.subList(0, limit);
    }

    @Override
    public Page<Book> findAllBooksPaginatedAndFiltered(FilterPaginationRequest<BookFilterPaginationRequest> bookFilterPaginationRequest) {
        PageRequest pageRequest = getPageRequest(bookFilterPaginationRequest);
        BookFilterPaginationRequest criteria = normalizeCriteria(bookFilterPaginationRequest.getCriteria());
        if (criteria == null || isCriteriaEmpty(criteria))
            return getRepository().findAll(pageRequest, bookFilterPaginationRequest.getDeletedRecords());

        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();

        CriteriaQuery<Book> query = criteriaBuilder.createQuery(Book.class);
        Root<Book> root = query.from(Book.class);
        Join<Book, Author> authorJoin = root.join("author", JoinType.LEFT);
        Join<Book, BookCategory> categoryJoin = root.join("category", JoinType.LEFT);
        Join<Book, Publisher> publisherJoin = root.join("publisher", JoinType.LEFT);
        Join<Book, Tag> tagJoin = root.join("tags", JoinType.LEFT);

        List<Predicate> predicates = buildPredicates(criteriaBuilder, root, authorJoin, categoryJoin, publisherJoin, tagJoin,
                criteria, bookFilterPaginationRequest.getDeletedRecords());

        query.select(root).distinct(true).where(predicates.toArray(new Predicate[0]));

        List<Book> result = entityManager.createQuery(query)
                .setFirstResult((int) pageRequest.getOffset())
                .setMaxResults(pageRequest.getPageSize())
                .getResultList();

        CriteriaQuery<Long> countQuery = criteriaBuilder.createQuery(Long.class);
        Root<Book> countRoot = countQuery.from(Book.class);
        Join<Book, Author> countAuthorJoin = countRoot.join("author", JoinType.LEFT);
        Join<Book, BookCategory> countCategoryJoin = countRoot.join("category", JoinType.LEFT);
        Join<Book, Publisher> countPublisherJoin = countRoot.join("publisher", JoinType.LEFT);
        Join<Book, Tag> countTagJoin = countRoot.join("tags", JoinType.LEFT);

        List<Predicate> countPredicates = buildPredicates(criteriaBuilder, countRoot, countAuthorJoin, countCategoryJoin, countPublisherJoin, countTagJoin,
                criteria, bookFilterPaginationRequest.getDeletedRecords());

        countQuery.select(criteriaBuilder.countDistinct(countRoot)).where(countPredicates.toArray(new Predicate[0]));
        Long total = entityManager.createQuery(countQuery).getSingleResult();

        return new PageImpl<>(result, pageRequest, total);
    }

    private PageRequest getPageRequest(FilterPaginationRequest<BookFilterPaginationRequest> bookFilterPaginationRequest) {
        if (bookFilterPaginationRequest.getPageSize() == -1) bookFilterPaginationRequest.setPageSize(Integer.MAX_VALUE);
        return PageRequest.of(bookFilterPaginationRequest.getPageNumber() - 1, bookFilterPaginationRequest.getPageSize(), buildSort(bookFilterPaginationRequest, Book.class));
    }

    private boolean isCriteriaEmpty(BookFilterPaginationRequest criteria) {
        return criteria.getName() == null
                && criteria.getCategories() == null
                && criteria.getAuthors() == null
                && criteria.getPublishers() == null
                && criteria.getTags() == null
                && criteria.getFromPrice() == null
                && criteria.getToPrice() == null
                && criteria.getFromPagesNumber() == null
                && criteria.getToPagesNumber() == null
                && criteria.getFromReadingDuration() == null
                && criteria.getToReadingDuration() == null;
    }

    private BookFilterPaginationRequest normalizeCriteria(BookFilterPaginationRequest criteria) {
        if (criteria == null) {
            return null;
        }
        criteria.setName(criteria.getName());
        criteria.setCategories(criteria.getCategories());
        criteria.setAuthors(criteria.getAuthors());
        criteria.setPublishers(criteria.getPublishers());
        criteria.setTags(criteria.getTags());
        return criteria;
    }

    private List<Predicate> buildPredicates(CriteriaBuilder cb,
                                            Root<Book> root,
                                            Join<Book, Author> authorJoin,
                                            Join<Book, BookCategory> categoryJoin,
                                            Join<Book, Publisher> publisherJoin,
                                            Join<Book, Tag> tagJoin,
                                            BookFilterPaginationRequest criteria,
                                            Boolean deletedRecords) {
        List<Predicate> predicates = new ArrayList<>();
        predicates.add(cb.equal(root.get("markedAsDeleted"), deletedRecords));

        if (criteria.getName() != null) {
            String keyword = "%" + criteria.getName() + "%";
            predicates.add(cb.or(
                    cb.like(cb.lower(root.get("name").as(String.class)), keyword),
                    cb.like(cb.lower(cb.coalesce(root.get("isbn").as(String.class), "")), keyword),
                    cb.like(cb.lower(authorJoin.get("name").as(String.class)), keyword),
                    cb.like(cb.lower(categoryJoin.get("name").as(String.class)), keyword),
                    cb.like(cb.lower(cb.coalesce(publisherJoin.get("name").as(String.class), "")), keyword),
                    cb.like(cb.lower(cb.coalesce(tagJoin.get("name").as(String.class), "")), keyword)
            ));
        }
        if (criteria.getCategories() != null) {
            predicates.add(categoryJoin.get("id").in(criteria.getCategories()));
        }
        if (criteria.getAuthors() != null) {
            predicates.add(authorJoin.get("id").in(criteria.getAuthors()));
        }
        if (criteria.getPublishers() != null) {
            predicates.add(publisherJoin.get("id").in(criteria.getPublishers()));
        }
        if (criteria.getTags() != null) {
            predicates.add(tagJoin.get("id").in(criteria.getTags()));
        }
        if (criteria.getFromPrice() != null) {
            predicates.add(cb.greaterThanOrEqualTo(root.get("price").as(Double.class), criteria.getFromPrice()));
        }
        if (criteria.getToPrice() != null) {
            predicates.add(cb.lessThanOrEqualTo(root.get("price").as(Double.class), criteria.getToPrice()));
        }
        if (criteria.getFromPagesNumber() != null) {
            predicates.add(cb.greaterThanOrEqualTo(root.get("pagesNumber").as(Integer.class), criteria.getFromPagesNumber()));
        }
        if (criteria.getToPagesNumber() != null) {
            predicates.add(cb.lessThanOrEqualTo(root.get("pagesNumber").as(Integer.class), criteria.getToPagesNumber()));
        }
        if (criteria.getFromReadingDuration() != null) {
            predicates.add(cb.greaterThanOrEqualTo(root.get("readingDuration").as(Integer.class), criteria.getFromReadingDuration()));
        }
        if (criteria.getToReadingDuration() != null) {
            predicates.add(cb.lessThanOrEqualTo(root.get("readingDuration").as(Integer.class), criteria.getToReadingDuration()));
        }
        return predicates;
    }
}
/*
weidonglang
2026.3-2027.9
*/
