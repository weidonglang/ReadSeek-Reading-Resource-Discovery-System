package com.weidonglang.readseek.transformer.mapper.base;

import com.weidonglang.readseek.dto.base.BaseDto;
import com.weidonglang.readseek.entity.base.BaseEntity;
import org.mapstruct.MappingTarget;
public interface BaseMapper<Entity extends BaseEntity, Dto extends BaseDto> {

    Entity dtoToEntity(Dto dto);

    Dto entityToDto(Entity entity);

    void updateEntity(Dto dto, @MappingTarget Entity entity);
}