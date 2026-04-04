package com.henry.bookrecommendationsystem.transformer.mapper;

import com.henry.bookrecommendationsystem.dto.AuthorDto;
import com.henry.bookrecommendationsystem.dto.BookCategoryDto;
import com.henry.bookrecommendationsystem.dto.BookDto;
import com.henry.bookrecommendationsystem.dto.PublisherDto;
import com.henry.bookrecommendationsystem.dto.TagDto;
import com.henry.bookrecommendationsystem.dto.UserBookRateDto;
import com.henry.bookrecommendationsystem.dto.UserDto;
import com.henry.bookrecommendationsystem.entity.Author;
import com.henry.bookrecommendationsystem.entity.Book;
import com.henry.bookrecommendationsystem.entity.BookCategory;
import com.henry.bookrecommendationsystem.entity.Publisher;
import com.henry.bookrecommendationsystem.entity.Tag;
import com.henry.bookrecommendationsystem.entity.User;
import com.henry.bookrecommendationsystem.entity.UserBookRate;
import java.util.LinkedHashSet;
import java.util.Set;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-04-04T22:46:52+0800",
    comments = "version: 1.5.3.Final, compiler: javac, environment: Java 11.0.16 (JetBrains s.r.o.)"
)
@Component
public class UserBookRateMapperImpl implements UserBookRateMapper {

    @Override
    public UserBookRate dtoToEntity(UserBookRateDto dto) {
        if ( dto == null ) {
            return null;
        }

        UserBookRate userBookRate = new UserBookRate();

        userBookRate.setMarkedAsDeleted( dto.getMarkedAsDeleted() );
        userBookRate.setId( dto.getId() );
        userBookRate.setUser( userDtoToUser( dto.getUser() ) );
        userBookRate.setBook( bookDtoToBook( dto.getBook() ) );
        userBookRate.setRate( dto.getRate() );
        userBookRate.setComment( dto.getComment() );

        return userBookRate;
    }

    @Override
    public UserBookRateDto entityToDto(UserBookRate entity) {
        if ( entity == null ) {
            return null;
        }

        UserBookRateDto userBookRateDto = new UserBookRateDto();

        userBookRateDto.setCreationDate( entity.getCreatedDate() );
        userBookRateDto.setLastModificationDate( entity.getModifiedDate() );
        userBookRateDto.setMarkedAsDeleted( entity.getMarkedAsDeleted() );
        userBookRateDto.setId( entity.getId() );
        userBookRateDto.setUser( userToUserDto( entity.getUser() ) );
        userBookRateDto.setBook( bookToBookDto( entity.getBook() ) );
        userBookRateDto.setRate( entity.getRate() );
        userBookRateDto.setComment( entity.getComment() );

        return userBookRateDto;
    }

    @Override
    public void updateEntity(UserBookRateDto dto, UserBookRate entity) {
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
        if ( dto.getBook() != null ) {
            if ( entity.getBook() == null ) {
                entity.setBook( new Book() );
            }
            bookDtoToBook1( dto.getBook(), entity.getBook() );
        }
        else {
            entity.setBook( null );
        }
        entity.setRate( dto.getRate() );
        entity.setComment( dto.getComment() );
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

    protected Author authorDtoToAuthor(AuthorDto authorDto) {
        if ( authorDto == null ) {
            return null;
        }

        Author author = new Author();

        author.setMarkedAsDeleted( authorDto.getMarkedAsDeleted() );
        author.setId( authorDto.getId() );
        author.setName( authorDto.getName() );
        author.setDescription( authorDto.getDescription() );
        author.setBirthdate( authorDto.getBirthdate() );
        author.setDeathdate( authorDto.getDeathdate() );
        author.setCountry( authorDto.getCountry() );
        author.setAge( authorDto.getAge() );
        author.setGender( authorDto.getGender() );
        author.setImageUrl( authorDto.getImageUrl() );

        return author;
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

    protected Publisher publisherDtoToPublisher(PublisherDto publisherDto) {
        if ( publisherDto == null ) {
            return null;
        }

        Publisher publisher = new Publisher();

        publisher.setMarkedAsDeleted( publisherDto.getMarkedAsDeleted() );
        publisher.setId( publisherDto.getId() );
        publisher.setName( publisherDto.getName() );
        publisher.setDescription( publisherDto.getDescription() );
        publisher.setCountry( publisherDto.getCountry() );
        publisher.setWebsiteUrl( publisherDto.getWebsiteUrl() );

        return publisher;
    }

    protected Tag tagDtoToTag(TagDto tagDto) {
        if ( tagDto == null ) {
            return null;
        }

        Tag tag = new Tag();

        tag.setMarkedAsDeleted( tagDto.getMarkedAsDeleted() );
        tag.setId( tagDto.getId() );
        tag.setName( tagDto.getName() );
        tag.setDescription( tagDto.getDescription() );

        return tag;
    }

    protected Set<Tag> tagDtoSetToTagSet(Set<TagDto> set) {
        if ( set == null ) {
            return null;
        }

        Set<Tag> set1 = new LinkedHashSet<Tag>( Math.max( (int) ( set.size() / .75f ) + 1, 16 ) );
        for ( TagDto tagDto : set ) {
            set1.add( tagDtoToTag( tagDto ) );
        }

        return set1;
    }

    protected Book bookDtoToBook(BookDto bookDto) {
        if ( bookDto == null ) {
            return null;
        }

        Book book = new Book();

        book.setMarkedAsDeleted( bookDto.getMarkedAsDeleted() );
        book.setId( bookDto.getId() );
        book.setAuthor( authorDtoToAuthor( bookDto.getAuthor() ) );
        book.setName( bookDto.getName() );
        book.setIsbn( bookDto.getIsbn() );
        book.setCategory( bookCategoryDtoToBookCategory( bookDto.getCategory() ) );
        book.setPublisher( publisherDtoToPublisher( bookDto.getPublisher() ) );
        book.setRate( bookDto.getRate() );
        book.setUsersRateCount( bookDto.getUsersRateCount() );
        book.setPrice( bookDto.getPrice() );
        book.setPagesNumber( bookDto.getPagesNumber() );
        book.setReadingDuration( bookDto.getReadingDuration() );
        book.setPublishDate( bookDto.getPublishDate() );
        book.setDescription( bookDto.getDescription() );
        book.setImageUrl( bookDto.getImageUrl() );
        book.setTotalCopies( bookDto.getTotalCopies() );
        book.setAvailableCopies( bookDto.getAvailableCopies() );
        book.setTags( tagDtoSetToTagSet( bookDto.getTags() ) );

        return book;
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

    protected AuthorDto authorToAuthorDto(Author author) {
        if ( author == null ) {
            return null;
        }

        AuthorDto authorDto = new AuthorDto();

        authorDto.setMarkedAsDeleted( author.getMarkedAsDeleted() );
        authorDto.setId( author.getId() );
        authorDto.setName( author.getName() );
        authorDto.setDescription( author.getDescription() );
        authorDto.setBirthdate( author.getBirthdate() );
        authorDto.setDeathdate( author.getDeathdate() );
        authorDto.setCountry( author.getCountry() );
        authorDto.setAge( author.getAge() );
        authorDto.setGender( author.getGender() );
        authorDto.setImageUrl( author.getImageUrl() );

        return authorDto;
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

    protected PublisherDto publisherToPublisherDto(Publisher publisher) {
        if ( publisher == null ) {
            return null;
        }

        PublisherDto publisherDto = new PublisherDto();

        publisherDto.setMarkedAsDeleted( publisher.getMarkedAsDeleted() );
        publisherDto.setId( publisher.getId() );
        publisherDto.setName( publisher.getName() );
        publisherDto.setDescription( publisher.getDescription() );
        publisherDto.setCountry( publisher.getCountry() );
        publisherDto.setWebsiteUrl( publisher.getWebsiteUrl() );

        return publisherDto;
    }

    protected TagDto tagToTagDto(Tag tag) {
        if ( tag == null ) {
            return null;
        }

        TagDto tagDto = new TagDto();

        tagDto.setMarkedAsDeleted( tag.getMarkedAsDeleted() );
        tagDto.setId( tag.getId() );
        tagDto.setName( tag.getName() );
        tagDto.setDescription( tag.getDescription() );

        return tagDto;
    }

    protected Set<TagDto> tagSetToTagDtoSet(Set<Tag> set) {
        if ( set == null ) {
            return null;
        }

        Set<TagDto> set1 = new LinkedHashSet<TagDto>( Math.max( (int) ( set.size() / .75f ) + 1, 16 ) );
        for ( Tag tag : set ) {
            set1.add( tagToTagDto( tag ) );
        }

        return set1;
    }

    protected BookDto bookToBookDto(Book book) {
        if ( book == null ) {
            return null;
        }

        BookDto bookDto = new BookDto();

        bookDto.setMarkedAsDeleted( book.getMarkedAsDeleted() );
        bookDto.setId( book.getId() );
        bookDto.setAuthor( authorToAuthorDto( book.getAuthor() ) );
        bookDto.setName( book.getName() );
        bookDto.setIsbn( book.getIsbn() );
        bookDto.setRate( book.getRate() );
        bookDto.setUsersRateCount( book.getUsersRateCount() );
        bookDto.setCategory( bookCategoryToBookCategoryDto( book.getCategory() ) );
        bookDto.setPublisher( publisherToPublisherDto( book.getPublisher() ) );
        bookDto.setPrice( book.getPrice() );
        bookDto.setPagesNumber( book.getPagesNumber() );
        bookDto.setReadingDuration( book.getReadingDuration() );
        bookDto.setPublishDate( book.getPublishDate() );
        bookDto.setDescription( book.getDescription() );
        bookDto.setImageUrl( book.getImageUrl() );
        bookDto.setTotalCopies( book.getTotalCopies() );
        bookDto.setAvailableCopies( book.getAvailableCopies() );
        bookDto.setTags( tagSetToTagDtoSet( book.getTags() ) );

        return bookDto;
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

    protected void authorDtoToAuthor1(AuthorDto authorDto, Author mappingTarget) {
        if ( authorDto == null ) {
            return;
        }

        mappingTarget.setMarkedAsDeleted( authorDto.getMarkedAsDeleted() );
        mappingTarget.setId( authorDto.getId() );
        mappingTarget.setName( authorDto.getName() );
        mappingTarget.setDescription( authorDto.getDescription() );
        mappingTarget.setBirthdate( authorDto.getBirthdate() );
        mappingTarget.setDeathdate( authorDto.getDeathdate() );
        mappingTarget.setCountry( authorDto.getCountry() );
        mappingTarget.setAge( authorDto.getAge() );
        mappingTarget.setGender( authorDto.getGender() );
        mappingTarget.setImageUrl( authorDto.getImageUrl() );
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

    protected void publisherDtoToPublisher1(PublisherDto publisherDto, Publisher mappingTarget) {
        if ( publisherDto == null ) {
            return;
        }

        mappingTarget.setMarkedAsDeleted( publisherDto.getMarkedAsDeleted() );
        mappingTarget.setId( publisherDto.getId() );
        mappingTarget.setName( publisherDto.getName() );
        mappingTarget.setDescription( publisherDto.getDescription() );
        mappingTarget.setCountry( publisherDto.getCountry() );
        mappingTarget.setWebsiteUrl( publisherDto.getWebsiteUrl() );
    }

    protected void bookDtoToBook1(BookDto bookDto, Book mappingTarget) {
        if ( bookDto == null ) {
            return;
        }

        mappingTarget.setMarkedAsDeleted( bookDto.getMarkedAsDeleted() );
        mappingTarget.setId( bookDto.getId() );
        if ( bookDto.getAuthor() != null ) {
            if ( mappingTarget.getAuthor() == null ) {
                mappingTarget.setAuthor( new Author() );
            }
            authorDtoToAuthor1( bookDto.getAuthor(), mappingTarget.getAuthor() );
        }
        else {
            mappingTarget.setAuthor( null );
        }
        mappingTarget.setName( bookDto.getName() );
        mappingTarget.setIsbn( bookDto.getIsbn() );
        if ( bookDto.getCategory() != null ) {
            if ( mappingTarget.getCategory() == null ) {
                mappingTarget.setCategory( new BookCategory() );
            }
            bookCategoryDtoToBookCategory1( bookDto.getCategory(), mappingTarget.getCategory() );
        }
        else {
            mappingTarget.setCategory( null );
        }
        if ( bookDto.getPublisher() != null ) {
            if ( mappingTarget.getPublisher() == null ) {
                mappingTarget.setPublisher( new Publisher() );
            }
            publisherDtoToPublisher1( bookDto.getPublisher(), mappingTarget.getPublisher() );
        }
        else {
            mappingTarget.setPublisher( null );
        }
        mappingTarget.setRate( bookDto.getRate() );
        mappingTarget.setUsersRateCount( bookDto.getUsersRateCount() );
        mappingTarget.setPrice( bookDto.getPrice() );
        mappingTarget.setPagesNumber( bookDto.getPagesNumber() );
        mappingTarget.setReadingDuration( bookDto.getReadingDuration() );
        mappingTarget.setPublishDate( bookDto.getPublishDate() );
        mappingTarget.setDescription( bookDto.getDescription() );
        mappingTarget.setImageUrl( bookDto.getImageUrl() );
        mappingTarget.setTotalCopies( bookDto.getTotalCopies() );
        mappingTarget.setAvailableCopies( bookDto.getAvailableCopies() );
        if ( mappingTarget.getTags() != null ) {
            Set<Tag> set = tagDtoSetToTagSet( bookDto.getTags() );
            if ( set != null ) {
                mappingTarget.getTags().clear();
                mappingTarget.getTags().addAll( set );
            }
            else {
                mappingTarget.setTags( null );
            }
        }
        else {
            Set<Tag> set = tagDtoSetToTagSet( bookDto.getTags() );
            if ( set != null ) {
                mappingTarget.setTags( set );
            }
        }
    }
}
