package com.henry.bookrecommendationsystem.transformer.mapper;

import com.henry.bookrecommendationsystem.dto.UserDto;
import com.henry.bookrecommendationsystem.entity.User;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-04-04T21:54:48+0800",
    comments = "version: 1.5.3.Final, compiler: javac, environment: Java 11.0.16 (JetBrains s.r.o.)"
)
@Component
public class UserMapperImpl implements UserMapper {

    @Override
    public User dtoToEntity(UserDto dto) {
        if ( dto == null ) {
            return null;
        }

        User user = new User();

        user.setMarkedAsDeleted( dto.getMarkedAsDeleted() );
        user.setId( dto.getId() );
        user.setFirstName( dto.getFirstName() );
        user.setLastName( dto.getLastName() );
        user.setEmail( dto.getEmail() );
        user.setPassword( dto.getPassword() );
        user.setPhoneNumber( dto.getPhoneNumber() );
        user.setBirthdate( dto.getBirthdate() );
        user.setCountry( dto.getCountry() );
        user.setAge( dto.getAge() );
        user.setGender( dto.getGender() );
        user.setMaritalStatus( dto.getMaritalStatus() );
        user.setRole( dto.getRole() );
        user.setImageUrl( dto.getImageUrl() );

        return user;
    }

    @Override
    public UserDto entityToDto(User entity) {
        if ( entity == null ) {
            return null;
        }

        UserDto userDto = new UserDto();

        userDto.setCreationDate( entity.getCreatedDate() );
        userDto.setLastModificationDate( entity.getModifiedDate() );
        userDto.setMarkedAsDeleted( entity.getMarkedAsDeleted() );
        userDto.setId( entity.getId() );
        userDto.setFirstName( entity.getFirstName() );
        userDto.setLastName( entity.getLastName() );
        userDto.setEmail( entity.getEmail() );
        userDto.setPassword( entity.getPassword() );
        userDto.setPhoneNumber( entity.getPhoneNumber() );
        userDto.setBirthdate( entity.getBirthdate() );
        userDto.setCountry( entity.getCountry() );
        userDto.setAge( entity.getAge() );
        userDto.setGender( entity.getGender() );
        userDto.setMaritalStatus( entity.getMaritalStatus() );
        userDto.setRole( entity.getRole() );
        userDto.setImageUrl( entity.getImageUrl() );

        return userDto;
    }

    @Override
    public void updateEntity(UserDto dto, User entity) {
        if ( dto == null ) {
            return;
        }

        entity.setMarkedAsDeleted( dto.getMarkedAsDeleted() );
        entity.setId( dto.getId() );
        entity.setFirstName( dto.getFirstName() );
        entity.setLastName( dto.getLastName() );
        entity.setEmail( dto.getEmail() );
        entity.setPassword( dto.getPassword() );
        entity.setPhoneNumber( dto.getPhoneNumber() );
        entity.setBirthdate( dto.getBirthdate() );
        entity.setCountry( dto.getCountry() );
        entity.setAge( dto.getAge() );
        entity.setGender( dto.getGender() );
        entity.setMaritalStatus( dto.getMaritalStatus() );
        entity.setRole( dto.getRole() );
        entity.setImageUrl( dto.getImageUrl() );
    }
}
