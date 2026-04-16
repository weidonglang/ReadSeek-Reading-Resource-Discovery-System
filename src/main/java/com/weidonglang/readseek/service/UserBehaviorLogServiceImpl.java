package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dto.SearchLogRecordDto;
import com.weidonglang.readseek.entity.Book;
import com.weidonglang.readseek.entity.SearchLog;
import com.weidonglang.readseek.entity.User;
import com.weidonglang.readseek.entity.UserBehaviorLog;
import com.weidonglang.readseek.enums.UserBehaviorActionType;
import com.weidonglang.readseek.repository.BookRepository;
import com.weidonglang.readseek.repository.SearchLogRepository;
import com.weidonglang.readseek.repository.UserBehaviorLogRepository;
import com.weidonglang.readseek.repository.UserRepository;
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
        } catch (Exception e) {
            log.warn("UserBehaviorLogService: skip behavior log action={} bookId={} source={} reason={} because {}",
                    actionType, bookId, source, reason, e.getMessage());
        }
    }

    @Override
    public void recordSearch(SearchLogRecordDto searchLogRecordDto) {
        if (searchLogRecordDto == null) {
            return;
        }

        try {
            Optional<User> optionalUser = resolveCurrentUser();

            UserBehaviorLog behaviorLog = new UserBehaviorLog();
            behaviorLog.setActionType(UserBehaviorActionType.SEARCH);
            behaviorLog.setKeyword(normalizeText(searchLogRecordDto.getKeyword(), 255));
            behaviorLog.setSource(normalizeText(searchLogRecordDto.getSource(), 120));
            behaviorLog.setReason(normalizeText(searchLogRecordDto.getReason(), 1000));
            behaviorLog.setMarkedAsDeleted(false);
            optionalUser.ifPresent(behaviorLog::setUser);
            userBehaviorLogRepository.save(behaviorLog);

            SearchLog searchLog = new SearchLog();
            optionalUser.ifPresent(searchLog::setUser);
            searchLog.setKeyword(behaviorLog.getKeyword());
            searchLog.setSource(behaviorLog.getSource());
            searchLog.setReason(behaviorLog.getReason());
            searchLog.setCategoryIds(normalizeText(searchLogRecordDto.getCategoryIds(), 1000));
            searchLog.setAuthorIds(normalizeText(searchLogRecordDto.getAuthorIds(), 1000));
            searchLog.setPublisherIds(normalizeText(searchLogRecordDto.getPublisherIds(), 1000));
            searchLog.setTagIds(normalizeText(searchLogRecordDto.getTagIds(), 1000));
            searchLog.setFromPrice(searchLogRecordDto.getFromPrice());
            searchLog.setToPrice(searchLogRecordDto.getToPrice());
            searchLog.setFromPagesNumber(searchLogRecordDto.getFromPagesNumber());
            searchLog.setToPagesNumber(searchLogRecordDto.getToPagesNumber());
            searchLog.setFromReadingDuration(searchLogRecordDto.getFromReadingDuration());
            searchLog.setToReadingDuration(searchLogRecordDto.getToReadingDuration());
            searchLog.setSortBy(normalizeText(searchLogRecordDto.getSortBy(), 1000));
            searchLog.setPageNumber(searchLogRecordDto.getPageNumber());
            searchLog.setPageSize(searchLogRecordDto.getPageSize());
            searchLog.setDeletedRecords(searchLogRecordDto.getDeletedRecords());
            searchLog.setResultCount(searchLogRecordDto.getResultCount());
            searchLog.setMarkedAsDeleted(false);
            searchLogRepository.save(searchLog);
        } catch (Exception e) {
            log.warn("UserBehaviorLogService: skip structured search log source={} keyword={} because {}",
                    searchLogRecordDto.getSource(), searchLogRecordDto.getKeyword(), e.getMessage());
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
