package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.enums.SearchQueryIntent;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class SearchQueryExpanderTest {

    private SearchQueryExpander expander;

    @BeforeEach
    void setUp() {
        expander = new SearchQueryExpander();
    }

    @Test
    void expandKeepsEnglishQueryUntouched() {
        assertEquals("pride and prejudice",
                expander.expand("pride and prejudice", SearchQueryIntent.KEYWORD));
    }

    @Test
    void expandAddsEnglishAliasesForChineseKeywordQuery() {
        String expanded = expander.expand("\u7231\u60c5\u5c0f\u8bf4", SearchQueryIntent.KEYWORD);

        assertTrue(expanded.contains("romantic romance love"));
    }

    @Test
    void expandAddsGeneralBookHintsForChineseNaturalLanguageQuery() {
        String expanded = expander.expand(
                "\u60f3\u627e\u4e00\u672c\u9002\u5408\u5165\u95e8\u7684\u5fc3\u7406\u5b66\u4e66",
                SearchQueryIntent.NATURAL_LANGUAGE
        );

        assertTrue(expanded.contains("psychology"));
        assertTrue(expanded.contains("beginner introduction introductory"));
        assertTrue(expanded.contains("book"));
        assertTrue(expanded.contains("novel"));
    }

    @Test
    void expandAddsAuthorAndMasterpieceAliasesForChineseAuthorQuery() {
        String expanded = expander.expand(
                "\u60f3\u770b\u7b80\u5965\u65af\u6c40\u7684\u4ee3\u8868\u4f5c",
                SearchQueryIntent.NATURAL_LANGUAGE
        );

        assertTrue(expanded.contains("jane austen austen"));
        assertTrue(expanded.contains("masterpiece classic signature work"));
    }

    @Test
    void resolveExactCandidateQueriesShouldExtractEnglishAuthorAlias() {
        assertTrue(expander.resolveExactCandidateQueries("\u60f3\u770b\u7b80\u5965\u65af\u6c40\u7684\u4ee3\u8868\u4f5c")
                .contains("Jane Austen"));
    }
}
