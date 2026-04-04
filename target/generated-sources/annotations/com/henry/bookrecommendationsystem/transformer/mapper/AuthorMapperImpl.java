package com.henry.bookrecommendationsystem.transformer.mapper;

import com.henry.bookrecommendationsystem.dto.AuthorDto;
import com.henry.bookrecommendationsystem.entity.Author;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-04-04T21:54:48+0800",
    comments = "version: 1.5.3.Final, compiler: javac, environment: Java 11.0.16 (JetBrains s.r.o.)"
)
@Component
public class AuthorMapperImpl implements AuthorMapper {

    @Override
    public Author dtoToEntity(AuthorDto dto) {
        if ( dto == null ) {
            return null;
        }

        Author author = new Author();

        author.setMarkedAsDeleted( dto.getMarkedAsDeleted() );
        author.setId( dto.getId() );
        author.setName( dto.getName() );
        author.setDescription( dto.getDescription() );
        author.setBirthdate( dto.getBirthdate() );
        author.setDeathdate( dto.getDeathdate() );
        author.setCountry( dto.getCountry() );
        author.setAge( dto.getAge() );
        author.setGender( dto.getGender() );
        author.setImageUrl( dto.getImageUrl() );

        return author;
    }

    @Override
    public AuthorDto entityToDto(Author entity) {
        if ( entity == null ) {
            return null;
        }

        AuthorDto authorDto = new AuthorDto();

        authorDto.setCreationDate( entity.getCreatedDate() );
        authorDto.setLastModificationDate( entity.getModifiedDate() );
        authorDto.setMarkedAsDeleted( entity.getMarkedAsDeleted() );
        authorDto.setId( entity.getId() );
        authorDto.setName( entity.getName() );
        authorDto.setDescription( entity.getDescription() );
        authorDto.setBirthdate( entity.getBirthdate() );
        authorDto.setDeathdate( entity.getDeathdate() );
        authorDto.setCountry( entity.getCountry() );
        authorDto.setAge( entity.getAge() );
        authorDto.setGender( entity.getGender() );
        authorDto.setImageUrl( entity.getImageUrl() );

        return authorDto;
    }

    @Override
    public void updateEntity(AuthorDto dto, Author entity) {
        if ( dto == null ) {
            return;
        }

        entity.setMarkedAsDeleted( dto.getMarkedAsDeleted() );
        entity.setId( dto.getId() );
        entity.setName( dto.getName() );
        entity.setDescription( dto.getDescription() );
        entity.setBirthdate( dto.getBirthdate() );
        entity.setDeathdate( dto.getDeathdate() );
        entity.setCountry( dto.getCountry() );
        entity.setAge( dto.getAge() );
        entity.setGender( dto.getGender() );
        entity.setImageUrl( dto.getImageUrl() );
    }
}
