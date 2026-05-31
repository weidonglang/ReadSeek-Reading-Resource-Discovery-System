package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dto.EvidenceQaResponseDto;
import com.weidonglang.readseek.dto.EvidenceSnippetDto;
import com.weidonglang.readseek.dto.QaAnalyticsDto;
import com.weidonglang.readseek.dto.QaCitationClickRequestDto;
import com.weidonglang.readseek.dto.QaEventDto;
import com.weidonglang.readseek.entity.Book;
import com.weidonglang.readseek.entity.QaEvent;
import com.weidonglang.readseek.enums.QaEventType;
import com.weidonglang.readseek.repository.BookRepository;
import com.weidonglang.readseek.repository.QaEventRepository;
import com.weidonglang.readseek.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class QaEventServiceImplTest {
    @Mock
    private QaEventRepository qaEventRepository;

    @Mock
    private BookRepository bookRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private UserService userService;

    private QaEventServiceImpl service;

    @BeforeEach
    void setUp() {
        service = new QaEventServiceImpl(qaEventRepository, bookRepository, userRepository, userService);
    }

    @Test
    void recordQuestionShouldPersistQaMetadata() {
        EvidenceSnippetDto evidence = new EvidenceSnippetDto();
        evidence.setResourceId(9L);
        EvidenceQaResponseDto response = new EvidenceQaResponseDto();
        response.setQuestion("推荐成长类书籍");
        response.setAnswerMode("RECOMMENDATION");
        response.setRagMode("standard");
        response.setLlmProvider("ollama");
        response.setModel("qwen3:8b");
        response.setAnswerable(true);
        response.setEvidenceCount(1);
        response.setCitations(List.of("[1] Atomic Habits"));
        response.setEvidence(List.of(evidence));
        response.setStrategy("hybrid-v3");
        response.setConfidence(0.8D);
        response.setTotalLatencyMs(1200L);
        when(qaEventRepository.save(any(QaEvent.class))).thenAnswer(invocation -> {
            QaEvent event = invocation.getArgument(0);
            event.setId(77L);
            return event;
        });

        QaEventDto saved = service.recordQuestion(response);

        ArgumentCaptor<QaEvent> captor = ArgumentCaptor.forClass(QaEvent.class);
        verify(qaEventRepository).save(captor.capture());
        QaEvent event = captor.getValue();
        assertEquals(QaEventType.QUESTION, event.getEventType());
        assertEquals("RECOMMENDATION", event.getAnswerMode());
        assertEquals("standard", event.getRagMode());
        assertEquals("9", event.getReferencedBookIds());
        assertEquals(77L, response.getQaEventId());
        assertEquals(77L, saved.getId());
    }

    @Test
    void recordCitationClickShouldPersistBookReference() {
        Book book = new Book();
        book.setId(5L);
        book.setName("Pride and Prejudice");
        when(bookRepository.findById(5L)).thenReturn(Optional.of(book));
        when(qaEventRepository.save(any(QaEvent.class))).thenAnswer(invocation -> {
            QaEvent event = invocation.getArgument(0);
            event.setId(31L);
            return event;
        });

        QaEventDto saved = service.recordCitationClick(new QaCitationClickRequestDto(
                77L,
                5L,
                "[1]",
                "比较两本书",
                "COMPARISON",
                "standard"
        ));

        assertEquals(QaEventType.CITATION_CLICK, saved.getEventType());
        assertEquals("Pride and Prejudice", saved.getBookName());
        assertEquals("[1]", saved.getCitation());
    }

    @Test
    void buildAnalyticsShouldCalculateQaRates() {
        when(qaEventRepository.countByEventTypeAndMarkedAsDeletedFalse(QaEventType.QUESTION)).thenReturn(10L);
        when(qaEventRepository.countByEventTypeAndAnswerableAndMarkedAsDeletedFalse(QaEventType.QUESTION, true)).thenReturn(7L);
        when(qaEventRepository.countByEventTypeAndAnswerableAndMarkedAsDeletedFalse(QaEventType.QUESTION, false)).thenReturn(3L);
        when(qaEventRepository.countByEventTypeAndMarkedAsDeletedFalse(QaEventType.CITATION_CLICK)).thenReturn(5L);
        when(qaEventRepository.averageLatency(QaEventType.QUESTION)).thenReturn(1234.4D);
        when(qaEventRepository.findByMarkedAsDeletedFalseOrderByCreatedDateDesc(any())).thenReturn(List.of());

        QaAnalyticsDto analytics = service.buildAnalytics(null, 5);

        assertEquals(10L, analytics.getRequestCount());
        assertEquals(7L, analytics.getAnswerableCount());
        assertEquals(3L, analytics.getRefusalCount());
        assertEquals(5L, analytics.getCitationClickCount());
        assertEquals(0.5D, analytics.getCitationClickRate());
        assertEquals(1234.4D, analytics.getAverageLatencyMs());
    }
}
