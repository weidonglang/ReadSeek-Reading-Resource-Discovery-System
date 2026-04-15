package com.weidonglang.NewBookRecommendationSystem.search;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(indexName = "#{@searchProperties.bookIndexName}", createIndex = false)
public class BookSearchDocument {

    @Id
    private Long id;

    @Field(type = FieldType.Keyword)
    private String isbn;

    @Field(type = FieldType.Text)
    private String name;

    @Field(type = FieldType.Text)
    private String description;

    @Field(type = FieldType.Text)
    private String authorName;

    @Field(type = FieldType.Text)
    private String categoryName;

    @Field(type = FieldType.Text)
    private String publisherName;

    @Field(type = FieldType.Text)
    private List<String> tagNames;

    @Field(type = FieldType.Text)
    private String searchableText;

    @Field(type = FieldType.Dense_Vector, dims = 384)
    private List<Float> embedding;

    @Field(type = FieldType.Double)
    private Double rate;

    @Field(type = FieldType.Long)
    private Long usersRateCount;

    @Field(type = FieldType.Integer)
    private Integer availableCopies;
}
