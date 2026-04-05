package com.weidonglang.NewBookRecommendationSystem.security.jwt;

import com.weidonglang.NewBookRecommendationSystem.dto.UserDto;
import com.weidonglang.NewBookRecommendationSystem.enums.UserRole;
import com.weidonglang.NewBookRecommendationSystem.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Collections;
@Slf4j
@Service
public class JWTUserDetailsService implements UserDetailsService {
    private final UserService userService;

    public JWTUserDetailsService(UserService userService) {
        this.userService = userService;
    }

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        log.info("UserDetailsService: loadUserByUsername() called");
        UserDto userDto = userService.findUserByEmail(email);
        UserRole userRole = userDto.getRole() == null ? UserRole.USER : userDto.getRole();
        return new org.springframework.security.core.userdetails.User(userDto.getEmail(),
                userDto.getPassword(), Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + userRole.name())));
    }
}
/*
weidonglang
2026.3-2027.9
*/
