package com.weidonglang.NewBookRecommendationSystem.security;

import org.springframework.context.annotation.Configuration;

import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;

@Configuration
@EnableMethodSecurity(prePostEnabled = true, securedEnabled = true, jsr250Enabled = true)
public class MethodSecurityConfigurations {
}
/*
weidonglang
2026.3-2027.9
*/
