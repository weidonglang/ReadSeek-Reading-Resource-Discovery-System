package com.henry.bookrecommendationsystem.transformer.mapper;

import com.henry.bookrecommendationsystem.dto.BookCategoryDto;
import com.henry.bookrecommendationsystem.dto.UserBookCategoryDto;
import com.henry.bookrecommendationsystem.dto.UserDto;
import com.henry.bookrecommendationsystem.dto.UserReadingInfoDto;
import com.henry.bookrecommendationsystem.entity.BookCategory;
import com.henry.bookrecommendationsystem.entity.User;
import com.henry.bookrecommendationsystem.entity.UserBookCategory;
import com.henry.bookrecommendationsystem.entity.UserReadingInfo;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-04-04T22:46:52+0800",
    comments = "version: 1.5.3.Final, compiler: javac, environment: Java 11.0.16 (JetBrains s.r.o.)"
)
@Component
public class UserReadingInfoMapperImpl implements UserReadingInfoMapper {

    @Override
    public UserReadingInfo dtoToEntity(UserReadingInfoDto dto) {
        if ( dto == null ) {
            return null;
        }

        UserReadingInfo userReadingInfo = new UserReadingInfo();

        userReadingInfo.setMarkedAsDeleted( dto.getMarkedAsDeleted() );
        userReadingInfo.setId( dto.getId() );
        userReadingInfo.setUser( userDtoToUser( dto.getUser() ) );
        userReadingInfo.setReadingLevel( dto.getReadingLevel() );
        userReadingInfo.setUserBookCategories( userBookCategoryDtoListToUserBookCategoryList( dto.getUserBookCategories() ) );

        return userReadingInfo;
    }

    @Override
    public UserReadingInfoDto entityToDto(UserReadingInfo entity) {
        if ( entity == null ) {
            return null;
        }

        UserReadingInfoDto userReadingInfoDto = new UserReadingInfoDto();

        userReadingInfoDto.setCreationDate( entity.getCreatedDate() );
        userReadingInfoDto.setLastModificationDate( entity.getModifiedDate() );
        userReadingInfoDto.setMarkedAsDeleted( entity.getMarkedAsDeleted() );
        userReadingInfoDto.setId( entity.getId() );
        userReadingInfoDto.setUser( userToUserDto( entity.getUser() ) );
        userReadingInfoDto.setReadingLevel( entity.getReadingLevel() );
        userReadingInfoDto.setUserBookCategories( userBookCategoryListToUserBookCategoryDtoList( entity.getUserBookCategories() ) );

        return userReadingInfoDto;
    }

    @Override
    public void updateEntity(UserReadingInfoDto dto, UserReadingInfo entity) {
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
        entity.setReadingLevel( dto.getReadingLevel() );
        if ( entity.getUserBookCategories() != null ) {
            List<UserBookCategory> list = userBookCategoryDtoListToUserBookCategoryList( dto.getUserBookCategories() );
            if ( list != null ) {
                entity.getUserBookCategories().clear();
                entity.getUserBookCategories().addAll( list );
            }
            else {
                entity.setUserBookCategories( null );
            }
        }
        else {
            List<UserBookCategory> list = userBookCategoryDtoListToUserBookCategoryList( dto.getUserBookCategories() );
            if ( list != null ) {
                entity.setUserBookCategories( list );
            }
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

    protected UserBookCategory userBookCategoryDtoToUserBookCategory(UserBookCategoryDto userBookCategoryDto) {
        if ( userBookCategoryDto == null ) {
            return null;
        }

        UserBookCategory userBookCategory = new UserBookCategory();

        userBookCategory.setMarkedAsDeleted( userBookCategoryDto.getMarkedAsDeleted() );
        userBookCategory.setId( userBookCategoryDto.getId() );
        userBookCategory.setUser( userDtoToUser( userBookCategoryDto.getUser() ) );
        userBookCategory.setCategory( bookCategoryDtoToBookCategory( userBookCategoryDto.getCategory() ) );

        return userBookCategory;
    }

    protected List<UserBookCategory> userBookCategoryDtoListToUserBookCategoryList(List<UserBookCategoryDto> list) {
        if ( list == null ) {
            return null;
        }

        List<UserBookCategory> list1 = new ArrayList<UserBookCategory>( list.size() );
        for ( UserBookCategoryDto userBookCategoryDto : list ) {
            list1.add( userBookCategoryDtoToUserBookCategory( userBookCategoryDto ) );
        }

        return list1;
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

    protected UserBookCategoryDto userBookCategoryToUserBookCategoryDto(UserBookCategory userBookCategory) {
        if ( userBookCategory == null ) {
            return null;
        }

        UserBookCategoryDto userBookCategoryDto = new UserBookCategoryDto();

        userBookCategoryDto.setMarkedAsDeleted( userBookCategory.getMarkedAsDeleted() );
        userBookCategoryDto.setId( userBookCategory.getId() );
        userBookCategoryDto.setUser( userToUserDto( userBookCategory.getUser() ) );
        userBookCategoryDto.setCategory( bookCategoryToBookCategoryDto( userBookCategory.getCategory() ) );

        return userBookCategoryDto;
    }

    protected List<UserBookCategoryDto> userBookCategoryListToUserBookCategoryDtoList(List<UserBookCategory> list) {
        if ( list == null ) {
            return null;
        }

        List<UserBookCategoryDto> list1 = new ArrayList<UserBookCategoryDto>( list.size() );
        for ( UserBookCategory userBookCategory : list ) {
            list1.add( userBookCategoryToUserBookCategoryDto( userBookCategory ) );
        }

        return list1;
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
}
