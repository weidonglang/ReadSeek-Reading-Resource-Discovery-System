package com.henry.bookrecommendationsystem.transformer.mapper;

import com.henry.bookrecommendationsystem.dto.BookCategoryDto;
import com.henry.bookrecommendationsystem.entity.BookCategory;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-04-04T22:46:52+0800",
    comments = "version: 1.5.3.Final, compiler: javac, environment: Java 11.0.16 (JetBrains s.r.o.)"
)
@Component
public class BookCategoryMapperImpl implements BookCategoryMapper {

    @Override
    public BookCategory dtoToEntity(BookCategoryDto dto) {
        if ( dto == null ) {
            return null;
        }

        BookCategory bookCategory = new BookCategory();

        bookCategory.setMarkedAsDeleted( dto.getMarkedAsDeleted() );
        bookCategory.setId( dto.getId() );
        bookCategory.setName( dto.getName() );
        bookCategory.setDescription( dto.getDescription() );

        return bookCategory;
    }

    @Override
    public BookCategoryDto entityToDto(BookCategory entity) {
        if ( entity == null ) {
            return null;
        }

        BookCategoryDto bookCategoryDto = new BookCategoryDto();

        bookCategoryDto.setCreationDate( entity.getCreatedDate() );
        bookCategoryDto.setLastModificationDate( entity.getModifiedDate() );
        bookCategoryDto.setMarkedAsDeleted( entity.getMarkedAsDeleted() );
        bookCategoryDto.setId( entity.getId() );
        bookCategoryDto.setName( entity.getName() );
        bookCategoryDto.setDescription( entity.getDescription() );

        return bookCategoryDto;
    }

    @Override
    public void updateEntity(BookCategoryDto dto, BookCategory entity) {
        if ( dto == null ) {
            return;
        }

        entity.setMarkedAsDeleted( dto.getMarkedAsDeleted() );
        entity.setId( dto.getId() );
        entity.setName( dto.getName() );
        entity.setDescription( dto.getDescription() );
    }
}
