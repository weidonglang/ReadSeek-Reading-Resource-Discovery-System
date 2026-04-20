package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dto.BookDto;
import com.weidonglang.readseek.dto.BookRecommendationOverviewDto;
import com.weidonglang.readseek.dto.BookRecommendationShelfDto;
import com.weidonglang.readseek.dto.RecommendationEventDto;
import com.weidonglang.readseek.dto.RecommendationFeedbackRequestDto;
import com.weidonglang.readseek.dto.UserDto;
import com.weidonglang.readseek.entity.Book;
import com.weidonglang.readseek.entity.RecommendationEvent;
import com.weidonglang.readseek.entity.User;
import com.weidonglang.readseek.enums.RecommendationEventType;
import com.weidonglang.readseek.enums.RecommendationFeedbackType;
import com.weidonglang.readseek.repository.BookRepository;
import com.weidonglang.readseek.repository.RecommendationEventRepository;
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
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class RecommendationEventServiceImplTest {

    @Mock
    private RecommendationEventRepository recommendationEventRepository;

    @Mock
    private BookRepository bookRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private UserService userService;

    private RecommendationEventServiceImpl service;

    @BeforeEach
    void setUp() {
        service = new RecommendationEventServiceImpl(
                recommendationEventRepository,
                bookRepository,
                userRepository,
                userService
        );
    }

    @Test
    void recordFeedbackShouldPersistStructuredFeedback() {
        RecommendationFeedbackRequestDto request = new RecommendationFeedbackRequestDto();
        request.setBookId(12L);
        request.setFeedbackType(RecommendationFeedbackType.NOT_INTERESTED);
        request.setSource("recommendation:popular");
        request.setReason("Recently popular.");
        request.setReasonType("POPULARITY");
        request.setRankPosition(2);

        Book book = new Book();
        book.setId(12L);
        book.setName("Pride and Prejudice");
        UserDto currentUserDto = new UserDto();
        currentUserDto.setId(7L);
        User user = new User();
        user.setId(7L);
        user.setEmail("reader@example.org");

        when(bookRepository.findById(12L)).thenReturn(Optional.of(book));
        when(userService.getCurrentUser()).thenReturn(currentUserDto);
        when(userRepository.findById(7L)).thenReturn(Optional.of(user));
        when(recommendationEventRepository.save(any(RecommendationEvent.class))).thenAnswer(invocation -> {
            RecommendationEvent event = invocation.getArgument(0);
            event.setId(44L);
            return event;
        });

        RecommendationEventDto saved = service.recordFeedback(request);

        ArgumentCaptor<RecommendationEvent> captor = ArgumentCaptor.forClass(RecommendationEvent.class);
        verify(recommendationEventRepository).save(captor.capture());
        RecommendationEvent event = captor.getValue();
        assertEquals(RecommendationEventType.FEEDBACK, event.getEventType());
        assertEquals(RecommendationFeedbackType.NOT_INTERESTED, event.getFeedbackType());
        assertSame(book, event.getBook());
        assertSame(user, event.getUser());
        assertEquals("POPULARITY", event.getReasonType());
        assertEquals(2, event.getRankPosition());
        assertEquals(44L, saved.getId());
        assertEquals("Pride and Prejudice", saved.getBookName());
    }

    @Test
    void recordOverviewExposureShouldPersistEachRecommendedBook() {
        BookDto first = new BookDto();
        first.setId(1L);
        first.setRecommendationSource("popular");
        first.setRecommendationReason("Popular reason");
        first.setRecommendationReasonType("POPULARITY");
        first.setRecommendationRank(1);
        BookDto second = new BookDto();
        second.setId(2L);

        BookRecommendationShelfDto shelf = new BookRecommendationShelfDto(
                "popular",
                "Popular Books",
                "Popular shelf",
                List.of(first, second)
        );
        BookRecommendationOverviewDto overview = new BookRecommendationOverviewDto(
                "Recommendation Shelves",
                List.of(shelf)
        );

        Book bookOne = new Book();
        bookOne.setId(1L);
        Book bookTwo = new Book();
        bookTwo.setId(2L);
        when(bookRepository.findById(1L)).thenReturn(Optional.of(bookOne));
        when(bookRepository.findById(2L)).thenReturn(Optional.of(bookTwo));

        service.recordOverviewExposure(overview, "overview:30");

        ArgumentCaptor<List<RecommendationEvent>> captor = ArgumentCaptor.forClass(List.class);
        verify(recommendationEventRepository).saveAll(captor.capture());
        List<RecommendationEvent> events = captor.getValue();
        assertEquals(2, events.size());
        assertEquals(RecommendationEventType.EXPOSURE, events.get(0).getEventType());
        assertEquals("popular", events.get(0).getShelfKey());
        assertEquals("POPULARITY", events.get(0).getReasonType());
        assertEquals(1, events.get(0).getRankPosition());
        assertEquals(2, events.get(1).getRankPosition());
        assertEquals("overview:30", events.get(1).getRequestContext());
    }
}
