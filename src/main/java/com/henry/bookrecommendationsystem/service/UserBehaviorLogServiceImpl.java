package com.henry.bookrecommendationsystem.service;

import com.henry.bookrecommendationsystem.entity.Book;
import com.henry.bookrecommendationsystem.entity.SearchLog;
import com.henry.bookrecommendationsystem.entity.User;
import com.henry.bookrecommendationsystem.entity.UserBehaviorLog;
import com.henry.bookrecommendationsystem.enums.UserBehaviorActionType;
import com.henry.bookrecommendationsystem.repository.BookRepository;
import com.henry.bookrecommendationsystem.repository.SearchLogRepository;
import com.henry.bookrecommendationsystem.repository.UserBehaviorLogRepository;
import com.henry.bookrecommendationsystem.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Optional;
@Slf4j
@Service
public class UserBehaviorLogServiceImpl implements UserBehaviorLogService {
    private final UserBehaviorLogRepository userBehaviorLogRepository;
    private final SearchLogRepository searchLogRepository;
    private final UserRepository userRepository;
    private final BookRepository bookRepository;
    private final UserService userService;

    public UserBehaviorLogServiceImpl(UserBehaviorLogRepository userBehaviorLogRepository,
                                      SearchLogRepository searchLogRepository,
                                      UserRepository userRepository,
                                      BookRepository bookRepository,
                                      UserService userService) {
        this.userBehaviorLogRepository = userBehaviorLogRepository;
        this.searchLogRepository = searchLogRepository;
        this.userRepository = userRepository;
        this.bookRepository = bookRepository;
        this.userService = userService;
    }

    @Override
    public void record(UserBehaviorActionType actionType, Long bookId, String keyword, String source, String reason) {
        try {
            UserBehaviorLog behaviorLog = new UserBehaviorLog();
            behaviorLog.setActionType(actionType);
            behaviorLog.setKeyword(normalizeText(keyword, 255));
            behaviorLog.setSource(normalizeText(source, 120));
            behaviorLog.setReason(normalizeText(reason, 1000));
            behaviorLog.setMarkedAsDeleted(false);

            Optional<User> optionalUser = resolveCurrentUser();
            optionalUser.ifPresent(behaviorLog::setUser);

            if (bookId != null) {
                Optional<Book> optionalBook = bookRepository.findById(bookId);
                optionalBook.ifPresent(behaviorLog::setBook);
            }

            userBehaviorLogRepository.save(behaviorLog);
            if (actionType == UserBehaviorActionType.SEARCH) {
                SearchLog searchLog = new SearchLog();
                optionalUser.ifPresent(searchLog::setUser);
                searchLog.setKeyword(behaviorLog.getKeyword());
                searchLog.setSource(behaviorLog.getSource());
                searchLog.setReason(behaviorLog.getReason());
                searchLog.setMarkedAsDeleted(false);
                searchLogRepository.save(searchLog);
            }
        } catch (Exception e) {
            log.warn("UserBehaviorLogService: skip behavior log action={} bookId={} source={} reason={} because {}",
                    actionType, bookId, source, reason, e.getMessage());
        }
    }

    private String normalizeText(String value, int maxLength) {
        if (value == null) {
            return null;
        }
        String normalized = value.trim();
        if (normalized.isEmpty()) {
            return null;
        }
        if (normalized.length() <= maxLength) {
            return normalized;
        }
        return normalized.substring(0, maxLength);
    }

    private Optional<User> resolveCurrentUser() {
        try {
            Long currentUserId = userService.getCurrentUser().getId();
            return userRepository.findById(currentUserId);
        } catch (Exception e) {
            log.debug("UserBehaviorLogService: current user unavailable, write anonymous behavior log - {}", e.getMessage());
            return Optional.empty();
        }
    }
}
