package com.weidonglang.NewBookRecommendationSystem.transformer.mapper.base;

import com.weidonglang.NewBookRecommendationSystem.dto.base.BaseDto;
import com.weidonglang.NewBookRecommendationSystem.entity.base.BaseEntity;
import org.mapstruct.*;
@MapperConfig(unmappedTargetPolicy = ReportingPolicy.IGNORE,
        mappingInheritanceStrategy = MappingInheritanceStrategy.AUTO_INHERIT_FROM_CONFIG)
public interface GenericMapperConfiguration {

    @Mappings({
            @Mapping(target = "creationDate", source = "createdDate"),
            @Mapping(target = "lastModificationDate", source = "modifiedDate")
    })
    BaseDto anyEntityToDto(BaseEntity entity);

    @Mappings({
            @Mapping(target = "createdDate", ignore = true),
            @Mapping(target = "modifiedDate", ignore = true),
    })
    BaseEntity anyDtoToEntity(BaseDto dto);
}