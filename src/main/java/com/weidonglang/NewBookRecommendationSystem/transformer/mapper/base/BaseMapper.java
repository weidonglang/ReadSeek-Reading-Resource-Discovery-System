package com.weidonglang.NewBookRecommendationSystem.transformer.mapper.base;

import com.weidonglang.NewBookRecommendationSystem.dto.base.BaseDto;
import com.weidonglang.NewBookRecommendationSystem.entity.base.BaseEntity;
import org.mapstruct.MappingTarget;
public interface BaseMapper<Entity extends BaseEntity, Dto extends BaseDto> {

    Entity dtoToEntity(Dto dto);

    Dto entityToDto(Entity entity);

    void updateEntity(Dto dto, @MappingTarget Entity entity);
}