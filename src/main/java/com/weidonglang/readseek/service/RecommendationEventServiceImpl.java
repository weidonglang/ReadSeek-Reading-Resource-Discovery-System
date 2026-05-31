package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dto.BookDto;
import com.weidonglang.readseek.dto.BookRecommendationOverviewDto;
import com.weidonglang.readseek.dto.BookRecommendationShelfDto;
import com.weidonglang.readseek.dto.RecommendationAnalyticsDto;
import com.weidonglang.readseek.dto.RecommendationClickRequestDto;
import com.weidonglang.readseek.dto.RecommendationEventDto;
import com.weidonglang.readseek.dto.RecommendationFeedbackRequestDto;
import com.weidonglang.readseek.entity.Book;
import com.weidonglang.readseek.entity.RecommendationEvent;
import com.weidonglang.readseek.entity.User;
import com.weidonglang.readseek.enums.RecommendationEventType;
import com.weidonglang.readseek.repository.BookRepository;
import com.weidonglang.readseek.repository.RecommendationEventRepository;
import com.weidonglang.readseek.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Slf4j
@Service
public class RecommendationEventServiceImpl implements RecommendationEventService {
    private static final int MAX_RECENT_LIMIT = 100;

    private final RecommendationEventRepository recommendationEventRepository;
    private final BookRepository bookRepository;
    private final UserRepository userRepository;
    private final UserService userService;

    public RecommendationEventServiceImpl(RecommendationEventRepository recommendationEventRepository,
                                          BookRepository bookRepository,
                                          UserRepository userRepository,
                                          UserService userService) {
        this.recommendationEventRepository = recommendationEventRepository;
        this.bookRepository = bookRepository;
        this.userRepository = userRepository;
        this.userService = userService;
    }

    @Override
    public void recordOverviewExposure(BookRecommendationOverviewDto overview, String requestContext) {
        if (overview == null || overview.getShelves() == null || overview.getShelves().isEmpty()) {
            return;
        }

        try {
            Optional<User> optionalUser = resolveCurrentUser();
            List<RecommendationEvent> events = new ArrayList<>();
            for (BookRecommendationShelfDto shelf : overview.getShelves()) {
                List<BookDto> books = shelf.getBooks();
                if (books == null || books.isEmpty()) {
                    continue;
                }
                for (int index = 0; index < books.size(); index++) {
                    BookDto bookDto = books.get(index);
                    if (bookDto == null || bookDto.getId() == null) {
                        continue;
                    }
                    RecommendationEvent event = new RecommendationEvent();
                    event.setEventType(RecommendationEventType.EXPOSURE);
                    event.setMarkedAsDeleted(false);
                    optionalUser.ifPresent(event::setUser);
                    bookRepository.findById(bookDto.getId()).ifPresent(event::setBook);
                    event.setOverviewTitle(normalizeText(overview.getTitle(), 255));
                    event.setShelfKey(normalizeText(shelf.getKey(), 80));
                    event.setShelfTitle(normalizeText(shelf.getTitle(), 160));
                    event.setSource(normalizeText(bookDto.getRecommendationSource(), 120));
                    event.setReason(normalizeText(bookDto.getRecommendationReason(), 1000));
                    event.setReasonType(normalizeText(bookDto.getRecommendationReasonType(), 80));
                    event.setRankPosition(bookDto.getRecommendationRank() == null ? index + 1 : bookDto.getRecommendationRank());
                    event.setRequestContext(normalizeText(requestContext, 255));
                    events.add(event);
                }
            }
            if (!events.isEmpty()) {
                recommendationEventRepository.saveAll(events);
            }
        } catch (Exception e) {
            log.warn("RecommendationEventService: skip recommendation exposure log because {}", e.getMessage());
        }
    }

    @Override
    public RecommendationEventDto recordFeedback(RecommendationFeedbackRequestDto requestDto) {
        if (requestDto == null || requestDto.getBookId() == null || requestDto.getFeedbackType() == null) {
            throw new IllegalArgumentException("bookId and feedbackType are required.");
        }

        Book book = bookRepository.findById(requestDto.getBookId())
                .orElseThrow(() -> new IllegalArgumentException("Book not found for feedback."));

        RecommendationEvent event = new RecommendationEvent();
        event.setEventType(RecommendationEventType.FEEDBACK);
        event.setFeedbackType(requestDto.getFeedbackType());
        event.setBook(book);
        resolveCurrentUser().ifPresent(event::setUser);
        event.setSource(normalizeText(requestDto.getSource(), 120));
        event.setReason(normalizeText(requestDto.getReason(), 1000));
        event.setReasonType(normalizeText(requestDto.getReasonType(), 80));
        event.setRankPosition(requestDto.getRankPosition());
        event.setRequestContext(normalizeText(requestDto.getRequestContext(), 255));
        event.setComment(normalizeText(requestDto.getComment(), 500));
        event.setMarkedAsDeleted(false);
        return toDto(recommendationEventRepository.save(event));
    }

    @Override
    public RecommendationEventDto recordClick(RecommendationClickRequestDto requestDto) {
        if (requestDto == null || requestDto.getBookId() == null) {
            throw new IllegalArgumentException("bookId is required.");
        }
        Book book = bookRepository.findById(requestDto.getBookId())
                .orElseThrow(() -> new IllegalArgumentException("Book not found for recommendation click."));

        RecommendationEvent event = new RecommendationEvent();
        event.setEventType(RecommendationEventType.CLICK);
        event.setBook(book);
        resolveCurrentUser().ifPresent(event::setUser);
        event.setSource(normalizeText(requestDto.getSource(), 120));
        event.setReason(normalizeText(requestDto.getReason(), 1000));
        event.setReasonType(normalizeText(requestDto.getReasonType(), 80));
        event.setRankPosition(requestDto.getRankPosition());
        event.setRequestContext(normalizeText(requestDto.getRequestContext(), 255));
        event.setMarkedAsDeleted(false);
        return toDto(recommendationEventRepository.save(event));
    }

    @Override
    public List<RecommendationEventDto> findRecentEvents(Integer limit) {
        return recommendationEventRepository
                .findByMarkedAsDeletedFalseOrderByCreatedDateDesc(PageRequest.of(0, sanitizeLimit(limit)))
                .stream()
                .map(this::toDto)
                .toList();
    }

    @Override
    public List<RecommendationEventDto> findRecentFeedback(Integer limit) {
        return recommendationEventRepository
                .findByEventTypeAndMarkedAsDeletedFalseOrderByCreatedDateDesc(
                        RecommendationEventType.FEEDBACK,
                        PageRequest.of(0, sanitizeLimit(limit))
                )
                .stream()
                .map(this::toDto)
                .toList();
    }

    @Override
    public RecommendationAnalyticsDto buildAnalytics(Integer recentDays, Integer limit) {
        LocalDateTime fromDate = resolveFromDate(recentDays);
        long exposures = count(RecommendationEventType.EXPOSURE, fromDate);
        long clicks = count(RecommendationEventType.CLICK, fromDate);
        long feedback = count(RecommendationEventType.FEEDBACK, fromDate);
        double ctr = exposures == 0 ? 0.0D : (double) clicks / exposures;
        double feedbackRate = exposures == 0 ? 0.0D : (double) feedback / exposures;
        return new RecommendationAnalyticsDto(
                normalizeRecentDays(recentDays),
                exposures,
                clicks,
                feedback,
                round(ctr),
                round(feedbackRate),
                findRecentEvents(limit)
        );
    }

    private RecommendationEventDto toDto(RecommendationEvent event) {
        User user = event.getUser();
        Book book = event.getBook();
        return new RecommendationEventDto(
                event.getId(),
                user == null ? null : user.getId(),
                user == null ? null : user.getEmail(),
                book == null ? null : book.getId(),
                book == null ? null : book.getName(),
                event.getEventType(),
                event.getFeedbackType(),
                event.getShelfKey(),
                event.getShelfTitle(),
                event.getSource(),
                event.getReason(),
                event.getReasonType(),
                event.getRankPosition(),
                event.getRequestContext(),
                event.getComment(),
                event.getCreatedDate()
        );
    }

    private Optional<User> resolveCurrentUser() {
        try {
            Long currentUserId = userService.getCurrentUser().getId();
            return userRepository.findById(currentUserId);
        } catch (Exception e) {
            log.debug("RecommendationEventService: current user unavailable - {}", e.getMessage());
            return Optional.empty();
        }
    }

    private long count(RecommendationEventType eventType, LocalDateTime fromDate) {
        return fromDate == null
                ? recommendationEventRepository.countByEventTypeAndMarkedAsDeletedFalse(eventType)
                : recommendationEventRepository.countByEventTypeAndCreatedDateGreaterThanEqualAndMarkedAsDeletedFalse(eventType, fromDate);
    }

    private LocalDateTime resolveFromDate(Integer recentDays) {
        if (recentDays == null || recentDays < 1) {
            return null;
        }
        return LocalDateTime.now().minusDays(recentDays);
    }

    private Integer normalizeRecentDays(Integer recentDays) {
        return recentDays == null || recentDays < 1 ? null : recentDays;
    }

    private String normalizeText(String value, int maxLength) {
        if (value == null) {
            return null;
        }
        String normalized = value.trim();
        if (normalized.isEmpty()) {
            return null;
        }
        return normalized.length() <= maxLength ? normalized : normalized.substring(0, maxLength);
    }

    private int sanitizeLimit(Integer limit) {
        if (limit == null || limit < 1) {
            return 20;
        }
        return Math.min(limit, MAX_RECENT_LIMIT);
    }

    private double round(double value) {
        return Math.round(value * 100.0D) / 100.0D;
    }
}
