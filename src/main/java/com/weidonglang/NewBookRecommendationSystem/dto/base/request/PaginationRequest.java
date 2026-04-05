package com.weidonglang.NewBookRecommendationSystem.dto.base.request;

import com.weidonglang.NewBookRecommendationSystem.dto.base.pagination.Page;
import com.weidonglang.NewBookRecommendationSystem.dto.base.pagination.SortingBy;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.List;
@NoArgsConstructor
@AllArgsConstructor
@Data
@EqualsAndHashCode(callSuper = true)
public class PaginationRequest extends Page {
    private List<SortingBy> sortingByList;
}
/*
weidonglang
2026.3-2027.9
*/
