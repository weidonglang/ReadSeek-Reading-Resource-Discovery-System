package com.henry.bookrecommendationsystem.enums;
public enum UserReadingLevel {
    BEGINNER("BEGINNER"),
    INTERMEDIATE("INTERMEDIATE"),
    EXPERT("EXPERT");

    private final String level;

    UserReadingLevel(String level) {
        this.level = level;
    }
}
