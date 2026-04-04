package com.henry.bookrecommendationsystem.transformer.mapper;

import com.henry.bookrecommendationsystem.dto.BookCategoryDto;
import com.henry.bookrecommendationsystem.dto.UserBookCategoryDto;
import com.henry.bookrecommendationsystem.dto.UserDto;
import com.henry.bookrecommendationsystem.entity.BookCategory;
import com.henry.bookrecommendationsystem.entity.User;
import com.henry.bookrecommendationsystem.entity.UserBookCategory;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-04-04T21:54:48+0800",
    comments = "version: 1.5.3.Final, compiler: javac, environment: Java 11.0.16 (JetBrains s.r.o.)"
)
@Component
public class UserBookCategoryMapperImpl implements UserBookCategoryMapper {

    @Override
    public UserBookCategory dtoToEntity(UserBookCategoryDto dto) {
        if ( dto == null ) {
            return null;
        }

        UserBookCategory userBookCategory = new UserBookCategory();

        userBookCategory.setMarkedAsDeleted( dto.getMarkedAsDeleted() );
        userBookCategory.setId( dto.getId() );
        userBookCategory.setUser( userDtoToUser( dto.getUser() ) );
        userBookCategory.setCategory( bookCategoryDtoToBookCategory( dto.getCategory() ) );

        return userBookCategory;
    }

    @Override
    public UserBookCategoryDto entityToDto(UserBookCategory entity) {
        if ( entity == null ) {
            return null;
        }

        UserBookCategoryDto userBookCategoryDto = new UserBookCategoryDto();

        userBookCategoryDto.setCreationDate( entity.getCreatedDate() );
        userBookCategoryDto.setLastModificationDate( entity.getModifiedDate() );
        userBookCategoryDto.setMarkedAsDeleted( entity.getMarkedAsDeleted() );
        userBookCategoryDto.setId( entity.getId() );
        userBookCategoryDto.setUser( userToUserDto( entity.getUser() ) );
        userBookCategoryDto.setCategory( bookCategoryToBookCategoryDto( entity.getCategory() ) );

        return userBookCategoryDto;
    }

    @Override
    public void updateEntity(UserBookCategoryDto dto, UserBookCategory entity) {
        if ( dto == null ) {
            return;
        }

        entity.setMarkedAsDeleted( dto.getMarkedAsDeleted() );
        entity.setId( dto.getId() );
        if ( dto.getUser() != null ) {
            if ( entity.getUser() == null ) {
                entity.setUser( new User() );
            }
            userDtoToUser1( dto.getUser(), entity.getUser() );
        }
        else {
            entity.setUser( null );
        }
        if ( dto.getCategory() != null ) {
            if ( entity.getCategory() == null ) {
                entity.setCategory( new BookCategory() );
            }
            bookCategoryDtoToBookCategory1( dto.getCategory(), entity.getCategory() );
        }
        else {
            entity.setCategory( null );
        }
    }

    protected User userDtoToUser(UserDto userDto) {
        if ( userDto == null ) {
            return null;
        }

        User user = new User();

        user.setMarkedAsDeleted( userDto.getMarkedAsDeleted() );
        user.setId( userDto.getId() );
        user.setFirstName( userDto.getFirstName() );
        user.setLastName( userDto.getLastName() );
        user.setEmail( userDto.getEmail() );
        user.setPassword( userDto.getPassword() );
        user.setPhoneNumber( userDto.getPhoneNumber() );
        user.setBirthdate( userDto.getBirthdate() );
        user.setCountry( userDto.getCountry() );
        user.setAge( userDto.getAge() );
        user.setGender( userDto.getGender() );
        user.setMaritalStatus( userDto.getMaritalStatus() );
        user.setRole( userDto.getRole() );
        user.setImageUrl( userDto.getImageUrl() );

        return user;
    }

    protected BookCategory bookCategoryDtoToBookCategory(BookCategoryDto bookCategoryDto) {
        if ( bookCategoryDto == null ) {
            return null;
        }

        BookCategory bookCategory = new BookCategory();

        bookCategory.setMarkedAsDeleted( bookCategoryDto.getMarkedAsDeleted() );
        bookCategory.setId( bookCategoryDto.getId() );
        bookCategory.setName( bookCategoryDto.getName() );
        bookCategory.setDescription( bookCategoryDto.getDescription() );

        return bookCategory;
    }

    protected UserDto userToUserDto(User user) {
        if ( user == null ) {
            return null;
        }

        UserDto userDto = new UserDto();

        userDto.setMarkedAsDeleted( user.getMarkedAsDeleted() );
        userDto.setId( user.getId() );
        userDto.setFirstName( user.getFirstName() );
        userDto.setLastName( user.getLastName() );
        userDto.setEmail( user.getEmail() );
        userDto.setPassword( user.getPassword() );
        userDto.setPhoneNumber( user.getPhoneNumber() );
        userDto.setBirthdate( user.getBirthdate() );
        userDto.setCountry( user.getCountry() );
        userDto.setAge( user.getAge() );
        userDto.setGender( user.getGender() );
        userDto.setMaritalStatus( user.getMaritalStatus() );
        userDto.setRole( user.getRole() );
        userDto.setImageUrl( user.getImageUrl() );

        return userDto;
    }

    protected BookCategoryDto bookCategoryToBookCategoryDto(BookCategory bookCategory) {
        if ( bookCategory == null ) {
            return null;
        }

        BookCategoryDto bookCategoryDto = new BookCategoryDto();

        bookCategoryDto.setMarkedAsDeleted( bookCategory.getMarkedAsDeleted() );
        bookCategoryDto.setId( bookCategory.getId() );
        bookCategoryDto.setName( bookCategory.getName() );
        bookCategoryDto.setDescription( bookCategory.getDescription() );

        return bookCategoryDto;
    }

    protected void userDtoToUser1(UserDto userDto, User mappingTarget) {
        if ( userDto == null ) {
            return;
        }

        mappingTarget.setMarkedAsDeleted( userDto.getMarkedAsDeleted() );
        mappingTarget.setId( userDto.getId() );
        mappingTarget.setFirstName( userDto.getFirstName() );
        mappingTarget.setLastName( userDto.getLastName() );
        mappingTarget.setEmail( userDto.getEmail() );
        mappingTarget.setPassword( userDto.getPassword() );
        mappingTarget.setPhoneNumber( userDto.getPhoneNumber() );
        mappingTarget.setBirthdate( userDto.getBirthdate() );
        mappingTarget.setCountry( userDto.getCountry() );
        mappingTarget.setAge( userDto.getAge() );
        mappingTarget.setGender( userDto.getGender() );
        mappingTarget.setMaritalStatus( userDto.getMaritalStatus() );
        mappingTarget.setRole( userDto.getRole() );
        mappingTarget.setImageUrl( userDto.getImageUrl() );
    }

    protected void bookCategoryDtoToBookCategory1(BookCategoryDto bookCategoryDto, BookCategory mappingTarget) {
        if ( bookCategoryDto == null ) {
            return;
        }

        mappingTarget.setMarkedAsDeleted( bookCategoryDto.getMarkedAsDeleted() );
        mappingTarget.setId( bookCategoryDto.getId() );
        mappingTarget.setName( bookCategoryDto.getName() );
        mappingTarget.setDescription( bookCategoryDto.getDescription() );
    }
}
