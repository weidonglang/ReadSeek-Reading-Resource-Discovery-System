package com.weidonglang.readseek.dto.base.pagination;
public enum SortingDirection {
    ASC("ASC"),
    DESC("DESC");

    private final String value;

    SortingDirection(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
/*
weidonglang
2026.3-2027.9
*/
