package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.dao.UserReadingInfoDao;
import com.weidonglang.NewBookRecommendationSystem.dto.UserBookCategoryDto;
import com.weidonglang.NewBookRecommendationSystem.dto.UserReadingInfoDto;
import com.weidonglang.NewBookRecommendationSystem.entity.User;
import com.weidonglang.NewBookRecommendationSystem.entity.UserReadingInfo;
import com.weidonglang.NewBookRecommendationSystem.transformer.UserReadingInfoTransformer;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.persistence.EntityExistsException;
import javax.transaction.Transactional;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
@Slf4j
@Service
public class UserReadingInfoServiceImpl implements UserReadingInfoService {
    private final UserReadingInfoDao userReadingInfoDao;
    private final UserReadingInfoTransformer userReadingInfoTransformer;
    private final UserService userService;
    private final UserBookCategoryService userBookCategoryService;

    public UserReadingInfoServiceImpl(UserReadingInfoDao userReadingInfoDao, UserReadingInfoTransformer userReadingInfoTransformer, UserService userService, UserBookCategoryService userBookCategoryService) {
        this.userReadingInfoDao = userReadingInfoDao;
        this.userReadingInfoTransformer = userReadingInfoTransformer;
        this.userService = userService;
        this.userBookCategoryService = userBookCategoryService;
    }

    @Override
    public UserReadingInfoDao getDao() {
        return userReadingInfoDao;
    }

    @Override
    public UserReadingInfoTransformer getTransformer() {
        return userReadingInfoTransformer;
    }

    @Override
    @Transactional
    public UserReadingInfoDto create(UserReadingInfoDto dto) {
        log.info("UserReadingInfoService: create() called");
        User currentUser = userService.getTransformer().transformDtoToEntity(userService.getCurrentUser());
        dto.setUser(userService.getCurrentUser());

        List<UserBookCategoryDto> userBookCategories = dto.getUserBookCategories() == null
                ? new ArrayList<>()
                : new ArrayList<>(dto.getUserBookCategories());

        Optional<UserReadingInfo> optionalUserReadingInfo = getDao().findByUserId(currentUser.getId());
        UserReadingInfo userReadingInfo;

        if (optionalUserReadingInfo.isPresent()) {
            userReadingInfo = optionalUserReadingInfo.get();
            userReadingInfo.setReadingLevel(dto.getReadingLevel());
            userReadingInfo = getDao().update(userReadingInfo);
        } else {
            dto.setUserBookCategories(null);
            UserReadingInfo entity = getTransformer().transformDtoToEntity(dto);
            entity.setId(null);
            entity.setUser(currentUser);
            userReadingInfo = getDao().create(entity);
        }

        userBookCategoryService.deleteAllCurrentUserBookCategories();
        for (UserBookCategoryDto userBookCategoryDto : userBookCategories) {
            userBookCategoryDto.setId(null);
            userBookCategoryService.create(userBookCategoryDto);
        }

        UserReadingInfoDto userReadingInfoDto = getTransformer().transformEntityToDto(userReadingInfo);
        userReadingInfoDto.setUserBookCategories(userBookCategoryService.findAllUserBookCategories());
        return userReadingInfoDto;
    }

    @Override
    public UserReadingInfoDto findUserReadingInfo() {
        log.info("UserReadingInfoService: findUserReadingInfo() called");
        Optional<UserReadingInfo> userReadingInfo = getDao().findByUserId(userService.getCurrentUser().getId());
        if (userReadingInfo.isEmpty()) throw new EntityExistsException("User hasn't reading info");
        UserReadingInfoDto userReadingInfoDto = getTransformer().transformEntityToDto(userReadingInfo.get());
        userReadingInfoDto.setUserBookCategories(userBookCategoryService.findAllUserBookCategories());
        return userReadingInfoDto;
    }
}
