package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.enums.SearchQueryIntent;
import org.springframework.stereotype.Component;

import java.util.Locale;
import java.util.Set;
import java.util.regex.Pattern;

@Component
public class SearchQueryIntentClassifier {
    private static final Pattern ISBN_PATTERN = Pattern.compile("^(97(8|9))?[\\d-]{9,18}[\\dxX]$");
    private static final Set<String> NATURAL_LANGUAGE_HINTS = Set.of(
            "想找", "推荐", "有没有", "适合", "类似", "比较", "介绍", "阅读路径", "主题",
            "looking for", "recommend", "similar", "compare", "suggest", "what should", "which book"
    );

    public SearchQueryIntent classify(String rawQuery) {
        String query = normalize(rawQuery);
        if (query.isBlank()) {
            return SearchQueryIntent.KEYWORD;
        }

        if (ISBN_PATTERN.matcher(query).matches()
                || query.startsWith("\"")
                || query.endsWith("\"")
                || query.toLowerCase(Locale.ROOT).startsWith("isbn:")
                || query.toLowerCase(Locale.ROOT).startsWith("title:")
                || query.toLowerCase(Locale.ROOT).startsWith("author:")) {
            return SearchQueryIntent.EXACT_LOOKUP;
        }

        String loweredQuery = query.toLowerCase(Locale.ROOT);
        long tokenCount = loweredQuery.split("\\s+").length;
        if (query.contains("?") || query.contains("？") || tokenCount >= 8) {
            return SearchQueryIntent.NATURAL_LANGUAGE;
        }

        for (String hint : NATURAL_LANGUAGE_HINTS) {
            if (loweredQuery.contains(hint)) {
                return SearchQueryIntent.NATURAL_LANGUAGE;
            }
        }

        return SearchQueryIntent.KEYWORD;
    }

    private String normalize(String rawQuery) {
        return rawQuery == null ? "" : rawQuery.trim();
    }
}
