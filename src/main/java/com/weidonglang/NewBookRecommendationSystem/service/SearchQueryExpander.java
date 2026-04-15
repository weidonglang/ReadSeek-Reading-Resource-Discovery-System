package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.enums.SearchQueryIntent;
import org.springframework.stereotype.Component;

import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

@Component
public class SearchQueryExpander {
    private static final Map<String, String> TERM_ALIASES = createAliases();

    public String expand(String rawQuery, SearchQueryIntent intent) {
        String query = rawQuery == null ? "" : rawQuery.trim();
        if (query.isBlank()) {
            return query;
        }

        if (!containsCjk(query)) {
            return query;
        }

        Set<String> terms = new LinkedHashSet<>();
        terms.add(query);

        String loweredQuery = query.toLowerCase(Locale.ROOT);
        for (Map.Entry<String, String> entry : TERM_ALIASES.entrySet()) {
            if (loweredQuery.contains(entry.getKey())) {
                terms.add(entry.getValue());
            }
        }

        if (intent == SearchQueryIntent.NATURAL_LANGUAGE) {
            terms.add("book");
            terms.add("novel");
        }

        return String.join(" ", terms);
    }

    private boolean containsCjk(String value) {
        return value.codePoints().anyMatch(codePoint ->
                Character.UnicodeScript.of(codePoint) == Character.UnicodeScript.HAN);
    }

    private static Map<String, String> createAliases() {
        Map<String, String> aliases = new LinkedHashMap<>();
        aliases.put("\u7231\u60c5", "romantic romance love");
        aliases.put("\u79d1\u5e7b", "science fiction sci-fi");
        aliases.put("\u5386\u53f2", "history historical");
        aliases.put("\u6050\u6016", "horror thriller");
        aliases.put("\u7ecf\u5178", "classic classics");
        aliases.put("\u513f\u7ae5", "kids children");
        aliases.put("\u7ae5\u4e66", "kids children");
        aliases.put("\u5c11\u513f", "kids children");
        aliases.put("\u5192\u9669", "adventure action");
        aliases.put("\u52a8\u4f5c", "action adventure");
        aliases.put("\u5fc3\u7406", "psychology");
        aliases.put("\u5fc3\u7406\u5b66", "psychology");
        aliases.put("\u5165\u95e8", "beginner introduction introductory");
        aliases.put("\u521d\u5b66", "beginner introduction introductory");
        aliases.put("\u57fa\u7840", "basic introduction introductory");
        aliases.put("\u6587\u5b66", "literature novel");
        aliases.put("\u54f2\u5b66", "philosophy");
        aliases.put("\u4fa6\u63a2", "detective mystery");
        aliases.put("\u63a8\u7406", "mystery detective");
        aliases.put("\u60ac\u7591", "mystery suspense thriller");
        aliases.put("\u4f20\u8bb0", "biography memoir");
        aliases.put("\u6210\u957f", "coming of age growth");
        return aliases;
    }
}
