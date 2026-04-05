package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.dao.UserBookCategoryDao;
import com.weidonglang.NewBookRecommendationSystem.dto.UserBookCategoryDto;
import com.weidonglang.NewBookRecommendationSystem.transformer.UserBookCategoryTransformer;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
@Slf4j
@Service
public class UserBookCategoryServiceImpl implements UserBookCategoryService {
    private final UserBookCategoryDao userBookCategoryDao;
    private final UserBookCategoryTransformer userBookCategoryTransformer;
    private final UserService userService;
    private final BookCategoryService bookCategoryService;

    public UserBookCategoryServiceImpl(UserBookCategoryDao userBookCategoryDao, UserBookCategoryTransformer userBookCategoryTransformer, UserService userService, BookCategoryService bookCategoryService) {
        this.userBookCategoryDao = userBookCategoryDao;
        this.userBookCategoryTransformer = userBookCategoryTransformer;
        this.userService = userService;
        this.bookCategoryService = bookCategoryService;
    }

    @Override
    public UserBookCategoryDao getDao() {
        return userBookCategoryDao;
    }

    @Override
    public UserBookCategoryTransformer getTransformer() {
        return userBookCategoryTransformer;
    }

    @Override
    public UserBookCategoryDto create(UserBookCategoryDto dto) {
        log.info("UserBookCategoryService: create() called");
        dto.setId(null);
        dto.setUser(userService.getCurrentUser());
        dto.setCategory(bookCategoryService.findById(dto.getCategory().getId()));
        return getTransformer().transformEntityToDto(getDao().create(getTransformer().transformDtoToEntity(dto)));
    }

    @Override
    public List<UserBookCategoryDto> findAllUserBookCategories() {
        log.info("UserBookCategoryService: findAllUserBookCategories() called");
        return getTransformer().transformEntityToDto(getDao().findAllByUserId(userService.getCurrentUser().getId()));
    }

    @Override
    public void deleteAllCurrentUserBookCategories() {
        log.info("UserBookCategoryService: deleteAllCurrentUserBookCategories() called");
        getDao().deleteAllByUserId(userService.getCurrentUser().getId());
    }
}
