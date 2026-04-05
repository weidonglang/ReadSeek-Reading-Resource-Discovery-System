package com.weidonglang.NewBookRecommendationSystem.config;

import com.weidonglang.NewBookRecommendationSystem.entity.User;
import com.weidonglang.NewBookRecommendationSystem.enums.UserRole;
import com.weidonglang.NewBookRecommendationSystem.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.Optional;

/**
 * Creates or upgrades the bootstrap admin account after startup.
 */
@Slf4j
@Component
public class AdminBootstrapRunner implements ApplicationRunner {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Value("${library.bootstrap.admin.enabled:true}")
    private boolean bootstrapAdminEnabled;

    @Value("${library.bootstrap.admin.email:admin@booknook.local}")
    private String adminEmail;

    @Value("${library.bootstrap.admin.password:Admin123!}")
    private String adminPassword;

    @Value("${library.bootstrap.admin.first-name:System}")
    private String adminFirstName;

    @Value("${library.bootstrap.admin.last-name:Admin}")
    private String adminLastName;

    public AdminBootstrapRunner(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(ApplicationArguments args) {
        if (!bootstrapAdminEnabled) {
            log.info("AdminBootstrapRunner: bootstrap admin disabled");
            return;
        }

        Optional<User> optionalAdmin = userRepository.findByEmail(adminEmail);
        if (optionalAdmin.isPresent()) {
            User existingAdmin = optionalAdmin.get();
            if (existingAdmin.getRole() != UserRole.ADMIN) {
                existingAdmin.setRole(UserRole.ADMIN);
                userRepository.save(existingAdmin);
                log.info("AdminBootstrapRunner: upgraded existing user to admin - {}", adminEmail);
            }
            return;
        }

        User admin = new User();
        admin.setFirstName(adminFirstName);
        admin.setLastName(adminLastName);
        admin.setEmail(adminEmail);
        admin.setPassword(passwordEncoder.encode(adminPassword));
        admin.setRole(UserRole.ADMIN);
        admin.setMarkedAsDeleted(false);
        userRepository.save(admin);
        log.info("AdminBootstrapRunner: bootstrap admin created - {}", adminEmail);
    }
}
/*
weidonglang
2026.3-2027.9
*/
