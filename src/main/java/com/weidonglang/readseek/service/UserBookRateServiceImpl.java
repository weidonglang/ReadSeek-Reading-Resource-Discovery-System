package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dao.UserBookRateDao;
import com.weidonglang.readseek.dto.BookDto;
import com.weidonglang.readseek.dto.UserBookRateDto;
import com.weidonglang.readseek.entity.UserBookRate;
import com.weidonglang.readseek.transformer.UserBookRateTransformer;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import java.util.Optional;

@Slf4j
@Service
public class UserBookRateServiceImpl implements UserBookRateService {
    private final UserBookRateTransformer userBookRateTransformer;
    private final UserBookRateDao userBookRateDao;
    private final UserService userService;
    private final BookService bookService;
    private final UserBehaviorLogService userBehaviorLogService;

    public UserBookRateServiceImpl(UserBookRateTransformer userBookRateTransformer, UserBookRateDao userBookRateDao, UserService userService, BookService bookService) {
        this(userBookRateTransformer, userBookRateDao, userService, bookService, null);
    }

    @Autowired
    public UserBookRateServiceImpl(UserBookRateTransformer userBookRateTransformer,
                                   UserBookRateDao userBookRateDao,
                                   UserService userService,
                                   BookService bookService,
                                   UserBehaviorLogService userBehaviorLogService) {
        this.userBookRateTransformer = userBookRateTransformer;
        this.userBookRateDao = userBookRateDao;
        this.userService = userService;
        this.bookService = bookService;
        this.userBehaviorLogService = userBehaviorLogService;
    }

    @Override
    public UserBookRateDao getDao() {
        return userBookRateDao;
    }

    @Override
    public UserBookRateTransformer getTransformer() {
        return userBookRateTransformer;
    }

    @Override
    @Transactional
    public UserBookRateDto create(UserBookRateDto dto) {
        log.info("UserBookRateService: create() called");
        dto.setUser(userService.findById(userService.getCurrentUser().getId()));
        BookDto bookDto = bookService.findById(dto.getBook().getId());
        BookDto updateBook = updateBookRatingSummary(bookDto, dto.getRate(), null);
        dto.setBook(updateBook);
        return getTransformer().transformEntityToDto(getDao().create(getTransformer().transformDtoToEntity(dto)));
    }

    @Override
    @Transactional
    public UserBookRateDto update(UserBookRateDto dto, Long id) {
        log.info("UserBookRateService: update() called");
        Optional<UserBookRate> entity = getDao().findById(id);
        if (entity.isEmpty()) throw new EntityNotFoundException("User doesn't rate this book!");
        Integer previousRate = entity.get().getRate();
        getTransformer().updateEntity(dto, entity.get());
        BookDto bookDto = bookService.findById(dto.getBook().getId());
        BookDto updateBook = updateBookRatingSummary(bookDto, dto.getRate(), previousRate);
        dto.setBook(updateBook);
        return getTransformer().transformEntityToDto(getDao().update(entity.get()));
    }

    @Override
    public UserBookRateDto rateBook(UserBookRateDto userBookRateDto) {
        log.info("UserBookRateService: rateBook() called");
        Optional<UserBookRate> userBookRate = getDao().findUserBookRateByUserIdAndBookId(userService.getCurrentUser().getId(), userBookRateDto.getBook().getId());
        UserBookRateDto result;
        if (userBookRate.isPresent()) {
            userBookRateDto.setId(userBookRate.get().getId());
            result = update(userBookRateDto, userBookRateDto.getId());
        } else {
            result = create(userBookRateDto);
        }
        if (userBehaviorLogService != null) {
            userBehaviorLogService.recordBookRate(userBookRateDto.getBook().getId(),
                    "Book rating recorded: " + userBookRateDto.getRate());
        }
        return result;
    }

    private BookDto updateBookRatingSummary(BookDto bookDto, Integer newRate, Integer previousRate) {
        int normalizedNewRate = normalizeRate(newRate);
        long currentCount = normalizeRatingCount(bookDto.getUsersRateCount());
        double currentAverage = normalizeAverageRate(bookDto.getRate());

        long updatedCount = previousRate == null ? currentCount + 1 : Math.max(currentCount, 1L);
        double totalRating = currentAverage * currentCount;

        if (previousRate == null) {
            totalRating += normalizedNewRate;
        } else {
            totalRating = (currentAverage * updatedCount) - normalizeRate(previousRate) + normalizedNewRate;
        }

        bookDto.setUsersRateCount(updatedCount);
        bookDto.setRate(updatedCount == 0 ? 0D : totalRating / updatedCount);
        return bookService.update(bookDto, bookDto.getId());
    }

    private long normalizeRatingCount(Long usersRateCount) {
        return usersRateCount == null || usersRateCount < 0 ? 0L : usersRateCount;
    }

    private double normalizeAverageRate(Double averageRate) {
        return averageRate == null || averageRate < 0 ? 0D : averageRate;
    }

    private int normalizeRate(Integer rate) {
        if (rate == null) {
            throw new IllegalArgumentException("Book rate is required");
        }
        return rate;
    }
}
