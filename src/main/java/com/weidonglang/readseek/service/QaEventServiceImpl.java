package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dto.EvidenceQaResponseDto;
import com.weidonglang.readseek.dto.EvidenceSnippetDto;
import com.weidonglang.readseek.dto.QaAnalyticsDto;
import com.weidonglang.readseek.dto.QaCitationClickRequestDto;
import com.weidonglang.readseek.dto.QaEventDto;
import com.weidonglang.readseek.entity.Book;
import com.weidonglang.readseek.entity.QaEvent;
import com.weidonglang.readseek.entity.User;
import com.weidonglang.readseek.enums.QaEventType;
import com.weidonglang.readseek.repository.BookRepository;
import com.weidonglang.readseek.repository.QaEventRepository;
import com.weidonglang.readseek.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Slf4j
@Service
public class QaEventServiceImpl implements QaEventService {
    private static final int MAX_LIMIT = 100;

    private final QaEventRepository qaEventRepository;
    private final BookRepository bookRepository;
    private final UserRepository userRepository;
    private final UserService userService;

    public QaEventServiceImpl(QaEventRepository qaEventRepository,
                              BookRepository bookRepository,
                              UserRepository userRepository,
                              UserService userService) {
        this.qaEventRepository = qaEventRepository;
        this.bookRepository = bookRepository;
        this.userRepository = userRepository;
        this.userService = userService;
    }

    @Override
    public QaEventDto recordQuestion(EvidenceQaResponseDto responseDto) {
        if (responseDto == null) {
            throw new IllegalArgumentException("QA response is required.");
        }
        try {
            QaEvent event = new QaEvent();
            event.setEventType(QaEventType.QUESTION);
            resolveCurrentUser().ifPresent(event::setUser);
            event.setQuestion(normalizeText(responseDto.getQuestion(), 1000));
            event.setAnswerMode(normalizeText(responseDto.getAnswerMode(), 80));
            event.setRagMode(normalizeText(responseDto.getRagMode(), 40));
            event.setProvider(normalizeText(responseDto.getLlmProvider(), 80));
            event.setModel(normalizeText(responseDto.getModel(), 160));
            event.setAnswerable(responseDto.getAnswerable());
            event.setEvidenceCount(responseDto.getEvidenceCount());
            event.setCitationCount(responseDto.getCitations() == null ? 0 : responseDto.getCitations().size());
            event.setRetrievalStrategy(normalizeText(responseDto.getStrategy(), 160));
            event.setFallbackApplied(Boolean.TRUE.equals(responseDto.getFallbackApplied())
                    || Boolean.TRUE.equals(responseDto.getLlmFallbackApplied()));
            event.setFallbackReason(normalizeText(responseDto.getLlmFallbackReason(), 1000));
            event.setConfidence(responseDto.getConfidence());
            event.setRetrievalLatencyMs(responseDto.getRetrievalLatencyMs());
            event.setGenerationLatencyMs(responseDto.getGenerationLatencyMs());
            event.setTotalLatencyMs(responseDto.getTotalLatencyMs());
            event.setReferencedBookIds(collectReferencedBookIds(responseDto.getEvidence()));
            event.setMarkedAsDeleted(false);
            QaEvent saved = qaEventRepository.save(event);
            responseDto.setQaEventId(saved.getId());
            return toDto(saved);
        } catch (Exception exception) {
            log.warn("QaEventService: failed to record QA question event because {}", exception.getMessage());
            return null;
        }
    }

    @Override
    public QaEventDto recordCitationClick(QaCitationClickRequestDto requestDto) {
        if (requestDto == null || requestDto.getBookId() == null) {
            throw new IllegalArgumentException("bookId is required for QA citation click.");
        }
        Book book = bookRepository.findById(requestDto.getBookId())
                .orElseThrow(() -> new IllegalArgumentException("Book not found for QA citation click."));
        QaEvent event = new QaEvent();
        event.setEventType(QaEventType.CITATION_CLICK);
        resolveCurrentUser().ifPresent(event::setUser);
        event.setBook(book);
        event.setQuestion(normalizeText(requestDto.getQuestion(), 1000));
        event.setAnswerMode(normalizeText(requestDto.getAnswerMode(), 80));
        event.setRagMode(normalizeText(requestDto.getRagMode(), 40));
        event.setCitation(normalizeText(requestDto.getCitation(), 80));
        event.setMarkedAsDeleted(false);
        return toDto(qaEventRepository.save(event));
    }

    @Override
    public List<QaEventDto> findRecentEvents(Integer limit) {
        return qaEventRepository.findByMarkedAsDeletedFalseOrderByCreatedDateDesc(PageRequest.of(0, sanitizeLimit(limit)))
                .stream()
                .map(this::toDto)
                .toList();
    }

    @Override
    public QaAnalyticsDto buildAnalytics(Integer recentDays, Integer limit) {
        LocalDateTime fromDate = resolveFromDate(recentDays);
        long requestCount = count(QaEventType.QUESTION, fromDate);
        long answerableCount = countAnswerable(true, fromDate);
        long refusalCount = countAnswerable(false, fromDate);
        long citationClickCount = count(QaEventType.CITATION_CLICK, fromDate);
        Double averageLatency = fromDate == null
                ? qaEventRepository.averageLatency(QaEventType.QUESTION)
                : qaEventRepository.averageLatencySince(QaEventType.QUESTION, fromDate);
        double clickRate = requestCount == 0 ? 0.0D : (double) citationClickCount / requestCount;
        return new QaAnalyticsDto(
                normalizeRecentDays(recentDays),
                requestCount,
                answerableCount,
                refusalCount,
                citationClickCount,
                round(clickRate),
                averageLatency == null ? 0.0D : round(averageLatency),
                findRecentEvents(limit)
        );
    }

    private QaEventDto toDto(QaEvent event) {
        User user = event.getUser();
        Book book = event.getBook();
        return new QaEventDto(
                event.getId(),
                event.getEventType(),
                user == null ? null : user.getId(),
                user == null ? null : user.getEmail(),
                book == null ? null : book.getId(),
                book == null ? null : book.getName(),
                event.getQuestion(),
                event.getAnswerMode(),
                event.getRagMode(),
                event.getProvider(),
                event.getModel(),
                event.getAnswerable(),
                event.getEvidenceCount(),
                event.getCitationCount(),
                event.getRetrievalStrategy(),
                event.getFallbackApplied(),
                event.getFallbackReason(),
                event.getConfidence(),
                event.getTotalLatencyMs(),
                event.getCitation(),
                event.getCreatedDate()
        );
    }

    private String collectReferencedBookIds(List<EvidenceSnippetDto> evidence) {
        if (evidence == null || evidence.isEmpty()) {
            return null;
        }
        String ids = evidence.stream()
                .map(EvidenceSnippetDto::getResourceId)
                .filter(id -> id != null && id > 0)
                .distinct()
                .map(String::valueOf)
                .collect(Collectors.joining(","));
        return ids.isBlank() ? null : ids;
    }

    private long count(QaEventType eventType, LocalDateTime fromDate) {
        return fromDate == null
                ? qaEventRepository.countByEventTypeAndMarkedAsDeletedFalse(eventType)
                : qaEventRepository.countByEventTypeAndCreatedDateGreaterThanEqualAndMarkedAsDeletedFalse(eventType, fromDate);
    }

    private long countAnswerable(boolean answerable, LocalDateTime fromDate) {
        return fromDate == null
                ? qaEventRepository.countByEventTypeAndAnswerableAndMarkedAsDeletedFalse(QaEventType.QUESTION, answerable)
                : qaEventRepository.countByEventTypeAndAnswerableAndCreatedDateGreaterThanEqualAndMarkedAsDeletedFalse(
                QaEventType.QUESTION, answerable, fromDate);
    }

    private Optional<User> resolveCurrentUser() {
        try {
            Long currentUserId = userService.getCurrentUser().getId();
            return userRepository.findById(currentUserId);
        } catch (Exception exception) {
            log.debug("QaEventService: current user unavailable - {}", exception.getMessage());
            return Optional.empty();
        }
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

    private int sanitizeLimit(Integer limit) {
        if (limit == null || limit < 1) {
            return 20;
        }
        return Math.min(limit, MAX_LIMIT);
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

    private double round(double value) {
        return Math.round(value * 100.0D) / 100.0D;
    }
}
