package com.henry.bookrecommendationsystem.transformer.mapper;

import com.henry.bookrecommendationsystem.dto.AuthorDto;
import com.henry.bookrecommendationsystem.dto.BookCategoryDto;
import com.henry.bookrecommendationsystem.dto.BookDto;
import com.henry.bookrecommendationsystem.dto.PublisherDto;
import com.henry.bookrecommendationsystem.dto.TagDto;
import com.henry.bookrecommendationsystem.entity.Author;
import com.henry.bookrecommendationsystem.entity.Book;
import com.henry.bookrecommendationsystem.entity.BookCategory;
import com.henry.bookrecommendationsystem.entity.Publisher;
import com.henry.bookrecommendationsystem.entity.Tag;
import java.util.LinkedHashSet;
import java.util.Set;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-04-04T21:54:48+0800",
    comments = "version: 1.5.3.Final, compiler: javac, environment: Java 11.0.16 (JetBrains s.r.o.)"
)
@Component
public class BookMapperImpl implements BookMapper {

    @Override
    public Book dtoToEntity(BookDto dto) {
        if ( dto == null ) {
            return null;
        }

        Book book = new Book();

        book.setMarkedAsDeleted( dto.getMarkedAsDeleted() );
        book.setId( dto.getId() );
        book.setAuthor( authorDtoToAuthor( dto.getAuthor() ) );
        book.setName( dto.getName() );
        book.setIsbn( dto.getIsbn() );
        book.setCategory( bookCategoryDtoToBookCategory( dto.getCategory() ) );
        book.setPublisher( publisherDtoToPublisher( dto.getPublisher() ) );
        book.setRate( dto.getRate() );
        book.setUsersRateCount( dto.getUsersRateCount() );
        book.setPrice( dto.getPrice() );
        book.setPagesNumber( dto.getPagesNumber() );
        book.setReadingDuration( dto.getReadingDuration() );
        book.setPublishDate( dto.getPublishDate() );
        book.setDescription( dto.getDescription() );
        book.setImageUrl( dto.getImageUrl() );
        book.setTotalCopies( dto.getTotalCopies() );
        book.setAvailableCopies( dto.getAvailableCopies() );
        book.setTags( tagDtoSetToTagSet( dto.getTags() ) );

        return book;
    }

    @Override
    public BookDto entityToDto(Book entity) {
        if ( entity == null ) {
            return null;
        }

        BookDto bookDto = new BookDto();

        bookDto.setCreationDate( entity.getCreatedDate() );
        bookDto.setLastModificationDate( entity.getModifiedDate() );
        bookDto.setMarkedAsDeleted( entity.getMarkedAsDeleted() );
        bookDto.setId( entity.getId() );
        bookDto.setAuthor( authorToAuthorDto( entity.getAuthor() ) );
        bookDto.setName( entity.getName() );
        bookDto.setIsbn( entity.getIsbn() );
        bookDto.setRate( entity.getRate() );
        bookDto.setUsersRateCount( entity.getUsersRateCount() );
        bookDto.setCategory( bookCategoryToBookCategoryDto( entity.getCategory() ) );
        bookDto.setPublisher( publisherToPublisherDto( entity.getPublisher() ) );
        bookDto.setPrice( entity.getPrice() );
        bookDto.setPagesNumber( entity.getPagesNumber() );
        bookDto.setReadingDuration( entity.getReadingDuration() );
        bookDto.setPublishDate( entity.getPublishDate() );
        bookDto.setDescription( entity.getDescription() );
        bookDto.setImageUrl( entity.getImageUrl() );
        bookDto.setTotalCopies( entity.getTotalCopies() );
        bookDto.setAvailableCopies( entity.getAvailableCopies() );
        bookDto.setTags( tagSetToTagDtoSet( entity.getTags() ) );

        return bookDto;
    }

    @Override
    public void updateEntity(BookDto dto, Book entity) {
        if ( dto == null ) {
            return;
        }

        entity.setMarkedAsDeleted( dto.getMarkedAsDeleted() );
        entity.setId( dto.getId() );
        if ( dto.getAuthor() != null ) {
            if ( entity.getAuthor() == null ) {
                entity.setAuthor( new Author() );
            }
            authorDtoToAuthor1( dto.getAuthor(), entity.getAuthor() );
        }
        else {
            entity.setAuthor( null );
        }
        entity.setName( dto.getName() );
        entity.setIsbn( dto.getIsbn() );
        if ( dto.getCategory() != null ) {
            if ( entity.getCategory() == null ) {
                entity.setCategory( new BookCategory() );
            }
            bookCategoryDtoToBookCategory1( dto.getCategory(), entity.getCategory() );
        }
        else {
            entity.setCategory( null );
        }
        if ( dto.getPublisher() != null ) {
            if ( entity.getPublisher() == null ) {
                entity.setPublisher( new Publisher() );
            }
            publisherDtoToPublisher1( dto.getPublisher(), entity.getPublisher() );
        }
        else {
            entity.setPublisher( null );
        }
        entity.setRate( dto.getRate() );
        entity.setUsersRateCount( dto.getUsersRateCount() );
        entity.setPrice( dto.getPrice() );
        entity.setPagesNumber( dto.getPagesNumber() );
        entity.setReadingDuration( dto.getReadingDuration() );
        entity.setPublishDate( dto.getPublishDate() );
        entity.setDescription( dto.getDescription() );
        entity.setImageUrl( dto.getImageUrl() );
        entity.setTotalCopies( dto.getTotalCopies() );
        entity.setAvailableCopies( dto.getAvailableCopies() );
        if ( entity.getTags() != null ) {
            Set<Tag> set = tagDtoSetToTagSet( dto.getTags() );
            if ( set != null ) {
                entity.getTags().clear();
                entity.getTags().addAll( set );
            }
            else {
                entity.setTags( null );
            }
        }
        else {
            Set<Tag> set = tagDtoSetToTagSet( dto.getTags() );
            if ( set != null ) {
                entity.setTags( set );
            }
        }
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
}
