package com.henry.bookrecommendationsystem.transformer.mapper;

import com.henry.bookrecommendationsystem.dto.TagDto;
import com.henry.bookrecommendationsystem.entity.Tag;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-04-04T21:54:48+0800",
    comments = "version: 1.5.3.Final, compiler: javac, environment: Java 11.0.16 (JetBrains s.r.o.)"
)
@Component
public class TagMapperImpl implements TagMapper {

    @Override
    public Tag dtoToEntity(TagDto dto) {
        if ( dto == null ) {
            return null;
        }

        Tag tag = new Tag();

        tag.setMarkedAsDeleted( dto.getMarkedAsDeleted() );
        tag.setId( dto.getId() );
        tag.setName( dto.getName() );
        tag.setDescription( dto.getDescription() );

        return tag;
    }

    @Override
    public TagDto entityToDto(Tag entity) {
        if ( entity == null ) {
            return null;
        }

        TagDto tagDto = new TagDto();

        tagDto.setCreationDate( entity.getCreatedDate() );
        tagDto.setLastModificationDate( entity.getModifiedDate() );
        tagDto.setMarkedAsDeleted( entity.getMarkedAsDeleted() );
        tagDto.setId( entity.getId() );
        tagDto.setName( entity.getName() );
        tagDto.setDescription( entity.getDescription() );

        return tagDto;
    }

    @Override
    public void updateEntity(TagDto dto, Tag entity) {
        if ( dto == null ) {
            return;
        }

        entity.setMarkedAsDeleted( dto.getMarkedAsDeleted() );
        entity.setId( dto.getId() );
        entity.setName( dto.getName() );
        entity.setDescription( dto.getDescription() );
    }
}
