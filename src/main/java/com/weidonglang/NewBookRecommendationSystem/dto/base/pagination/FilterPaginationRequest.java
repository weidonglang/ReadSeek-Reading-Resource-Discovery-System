package com.weidonglang.NewBookRecommendationSystem.dto.base.pagination;

import com.weidonglang.NewBookRecommendationSystem.dto.base.request.PaginationRequest;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
@Data
@AllArgsConstructor
@NoArgsConstructor
public class FilterPaginationRequest<Filtration> extends PaginationRequest {
    private Filtration criteria;
    private Boolean deletedRecords;
}
/*
weidonglang
2026.3-2027.9
*/
