package com.henry.bookrecommendationsystem.transformer.mapper;

import com.henry.bookrecommendationsystem.dto.PublisherDto;
import com.henry.bookrecommendationsystem.entity.Publisher;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-04-04T22:46:52+0800",
    comments = "version: 1.5.3.Final, compiler: javac, environment: Java 11.0.16 (JetBrains s.r.o.)"
)
@Component
public class PublisherMapperImpl implements PublisherMapper {

    @Override
    public Publisher dtoToEntity(PublisherDto dto) {
        if ( dto == null ) {
            return null;
        }

        Publisher publisher = new Publisher();

        publisher.setMarkedAsDeleted( dto.getMarkedAsDeleted() );
        publisher.setId( dto.getId() );
        publisher.setName( dto.getName() );
        publisher.setDescription( dto.getDescription() );
        publisher.setCountry( dto.getCountry() );
        publisher.setWebsiteUrl( dto.getWebsiteUrl() );

        return publisher;
    }

    @Override
    public PublisherDto entityToDto(Publisher entity) {
        if ( entity == null ) {
            return null;
        }

        PublisherDto publisherDto = new PublisherDto();

        publisherDto.setCreationDate( entity.getCreatedDate() );
        publisherDto.setLastModificationDate( entity.getModifiedDate() );
        publisherDto.setMarkedAsDeleted( entity.getMarkedAsDeleted() );
        publisherDto.setId( entity.getId() );
        publisherDto.setName( entity.getName() );
        publisherDto.setDescription( entity.getDescription() );
        publisherDto.setCountry( entity.getCountry() );
        publisherDto.setWebsiteUrl( entity.getWebsiteUrl() );

        return publisherDto;
    }

    @Override
    public void updateEntity(PublisherDto dto, Publisher entity) {
        if ( dto == null ) {
            return;
        }

        entity.setMarkedAsDeleted( dto.getMarkedAsDeleted() );
        entity.setId( dto.getId() );
        entity.setName( dto.getName() );
        entity.setDescription( dto.getDescription() );
        entity.setCountry( dto.getCountry() );
        entity.setWebsiteUrl( dto.getWebsiteUrl() );
    }
}
