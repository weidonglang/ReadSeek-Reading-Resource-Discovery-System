package com.weidonglang.readseek.transformer;

import com.weidonglang.readseek.dto.BookDto;
import com.weidonglang.readseek.entity.Book;
import com.weidonglang.readseek.transformer.base.BaseTransformer;
import com.weidonglang.readseek.transformer.mapper.BookMapper;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;
@Component
@AllArgsConstructor
public class BookTransformer implements BaseTransformer<Book, BookDto, BookMapper> {
    private final BookMapper bookMapper;

    @Override
    public BookMapper getMapper() {
        return bookMapper;
    }
}
