package com.weidonglang.NewBookRecommendationSystem.service;

import com.weidonglang.NewBookRecommendationSystem.enums.SearchQueryIntent;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class SearchQueryIntentClassifierTest {

    private SearchQueryIntentClassifier classifier;

    @BeforeEach
    void setUp() {
        classifier = new SearchQueryIntentClassifier();
    }

    @Test
    void classifyRecognizesExactLookupForIsbn() {
        assertEquals(SearchQueryIntent.EXACT_LOOKUP, classifier.classify("978-0134685991"));
    }

    @Test
    void classifyRecognizesNaturalLanguageQuestion() {
        assertEquals(SearchQueryIntent.NATURAL_LANGUAGE,
                classifier.classify("想找一本适合入门的心理学书，不要太学术"));
    }

    @Test
    void classifyDefaultsToKeywordForShortSearch() {
        assertEquals(SearchQueryIntent.KEYWORD, classifier.classify("harry potter"));
    }
}
