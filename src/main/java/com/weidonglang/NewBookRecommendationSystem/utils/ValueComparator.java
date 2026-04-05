package com.weidonglang.NewBookRecommendationSystem.utils;

import java.util.Comparator;
import java.util.Map;
public class ValueComparator implements Comparator<Long> {
    private final Map<Long, Double> base;

    public ValueComparator(Map<Long, Double> base) {
        this.base = base;
    }

    public int compare(Long a, Long b) {
        if (base.get(a) >= base.get(b)) {
            return -1;
        } else {
            return 1;
        }
    }
}
