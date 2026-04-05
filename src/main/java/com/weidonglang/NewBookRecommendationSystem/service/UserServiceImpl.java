package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.dao.UserDao;
import com.weidonglang.NewBookRecommendationSystem.dto.UserDto;
import com.weidonglang.NewBookRecommendationSystem.entity.User;
import com.weidonglang.NewBookRecommendationSystem.enums.UserGender;
import com.weidonglang.NewBookRecommendationSystem.enums.UserMartialStatus;
import com.weidonglang.NewBookRecommendationSystem.enums.UserRole;
import com.weidonglang.NewBookRecommendationSystem.manager.JWTAuthenticationManager;
import com.weidonglang.NewBookRecommendationSystem.transformer.UserTransformer;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import javax.persistence.EntityExistsException;
import java.util.ArrayList;
import java.util.EnumSet;
import java.util.List;
import java.util.Optional;
@Slf4j
@Service
public class UserServiceImpl implements UserService {
    private final UserTransformer userTransformer;
    private final UserDao userDao;
    private final JWTAuthenticationManager jwtAuthenticationManager;
    private final PasswordEncoder passwordEncoder;

    public UserServiceImpl(UserTransformer userTransformer, UserDao userDao, JWTAuthenticationManager jwtAuthenticationManager, @Lazy PasswordEncoder passwordEncoder) {
        this.userTransformer = userTransformer;
        this.userDao = userDao;
        this.jwtAuthenticationManager = jwtAuthenticationManager;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public UserDao getDao() {
        return userDao;
    }

    @Override
    public UserTransformer getTransformer() {
        return userTransformer;
    }

    @Override
    public UserDto create(UserDto dto) {
        log.info("UserService: create() called");
        // check if email already exists
        if (getDao().isUserExistsByEmail(dto.getEmail()))
            throw new EntityExistsException("User email already exists - " + dto.getEmail());

        dto.setRole(UserRole.USER);
        dto.setPassword(passwordEncoder.encode(dto.getPassword()));
        User transformedDtoToEntity = getTransformer().transformDtoToEntity(dto);
        return getTransformer().transformEntityToDto(getDao().create(transformedDtoToEntity));
    }

    @Override
    public UserDto update(UserDto dto, Long id) {
        log.info("UserService: update() called");
        Optional<User> optionalUser = getDao().findById(id);
        if (optionalUser.isEmpty())
            throw new EntityExistsException("User not found for id: " + id);

        User existingUser = optionalUser.get();
        UserDto currentUser = getCurrentUser();
        if (currentUser.getRole() != UserRole.ADMIN && !currentUser.getId().equals(id)) {
            throw new AccessDeniedException("You can only update your own profile");
        }

        dto.setRole(existingUser.getRole());
        if (dto.getPassword() == null || dto.getPassword().isBlank()) {
            dto.setPassword(existingUser.getPassword());
        } else {
            dto.setPassword(passwordEncoder.encode(dto.getPassword()));
        }

        getTransformer().updateEntity(dto, existingUser);
        return getTransformer().transformEntityToDto(getDao().update(existingUser));
    }

    @Override
    public UserDto findUserByEmail(String email) {
        log.info("UserService: findUserByEmail() called");
        Optional<User> optionalUser = getDao().findUserByEmail(email);
        if (optionalUser.isEmpty())
            throw new EntityExistsException("User not exists for email: " + email);
        return getTransformer().transformEntityToDto(optionalUser.get());
    }

    @Override
    public List<UserGender> getUserGenders() {
        log.info("UserService: getUserGenders() called");
        return new ArrayList<>(EnumSet.allOf(UserGender.class));
    }

    @Override
    public List<UserMartialStatus> getUserMartialStatuses() {
        log.info("UserService: getUserMartialStatuses() called");
        return new ArrayList<>(EnumSet.allOf(UserMartialStatus.class));
    }

    @Override
    public UserDto getCurrentUser() {
        log.info("UserService: getCurrentUser() called");
        return findUserByEmail(jwtAuthenticationManager.getCurrentUserEmail());
    }

    @Override
    public Boolean isUserExistsByEmail(String email) {
        log.info("UserService: isUserExistsByEmail() called");
        return getDao().isUserExistsByEmail(email);
    }
}
