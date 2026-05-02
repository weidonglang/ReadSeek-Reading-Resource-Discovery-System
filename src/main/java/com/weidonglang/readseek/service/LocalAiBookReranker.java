package com.weidonglang.readseek.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.weidonglang.readseek.config.SearchProperties;
import com.weidonglang.readseek.dto.BookDto;
import com.weidonglang.readseek.dto.BookSearchHitDto;
import com.weidonglang.readseek.dto.RerankCandidateDto;
import com.weidonglang.readseek.dto.RerankRequestDto;
import com.weidonglang.readseek.dto.RerankResponseDto;
import com.weidonglang.readseek.dto.TagDto;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

@Slf4j
@Service
public class LocalAiBookReranker implements BookReranker {
    private final SearchProperties searchProperties;
    private final ObjectMapper objectMapper;
    private final HttpClient httpClient;

    public LocalAiBookReranker(SearchProperties searchProperties,
                               ObjectMapper objectMapper) {
        this.searchProperties = searchProperties;
        this.objectMapper = objectMapper;
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofMillis(searchProperties.getReranker().getTimeoutMs()))
                .build();
    }

    @Override
    public Optional<List<BookSearchHitDto>> rerank(String query, List<BookSearchHitDto> candidates, int topN) {
        if (!isEnabled() || query == null || query.isBlank() || candidates == null || candidates.isEmpty() || topN < 1) {
            return Optional.empty();
        }

        List<BookSearchHitDto> normalizedCandidates = candidates.stream()
                .filter(hit -> hit != null && hit.getBook() != null && hit.getBook().getId() != null)
                .limit(searchProperties.getReranker().getCandidateLimit())
                .toList();
        if (normalizedCandidates.isEmpty()) {
            return Optional.empty();
        }

        try {
            RerankRequestDto requestDto = RerankRequestDto.builder()
                    .query(query.trim())
                    .model(searchProperties.getReranker().getModel())
                    .topN(Math.min(topN, normalizedCandidates.size()))
                    .candidates(normalizedCandidates.stream()
                            .map(this::toCandidateDto)
                            .toList())
                    .build();

            String payload = objectMapper.writeValueAsString(requestDto);
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(resolveRerankUri())
                    .timeout(Duration.ofMillis(searchProperties.getReranker().getTimeoutMs()))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(payload))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() < 200 || response.statusCode() >= 300) {
                log.warn("LocalAiBookReranker: rerank request failed with status={}", response.statusCode());
                return Optional.empty();
            }

            RerankResponseDto responseDto = objectMapper.readValue(response.body(), RerankResponseDto.class);
            List<RerankResponseDto.RerankResultDto> results = responseDto.getResults();
            if (results == null || results.isEmpty()) {
                return Optional.empty();
            }

            Map<Long, BookSearchHitDto> candidatesById = normalizedCandidates.stream()
                    .collect(Collectors.toMap(hit -> hit.getBook().getId(), Function.identity(), (left, right) -> left, LinkedHashMap::new));
            Map<Long, Double> scoresById = results.stream()
                    .filter(result -> result.getId() != null && result.getScore() != null)
                    .collect(Collectors.toMap(RerankResponseDto.RerankResultDto::getId, RerankResponseDto.RerankResultDto::getScore, (left, right) -> left, LinkedHashMap::new));

            List<BookSearchHitDto> reranked = new ArrayList<>();
            for (RerankResponseDto.RerankResultDto result : results.stream()
                    .filter(result -> result.getId() != null)
                    .sorted(Comparator.comparing(result -> Optional.ofNullable(result.getRank()).orElse(Integer.MAX_VALUE)))
                    .toList()) {
                BookSearchHitDto hit = candidatesById.remove(result.getId());
                if (hit != null) {
                    applyRerankScore(hit, scoresById.get(result.getId()));
                    reranked.add(hit);
                }
            }

            if (reranked.isEmpty()) {
                return Optional.empty();
            }
            return Optional.of(reranked);
        } catch (Exception exception) {
            log.debug("LocalAiBookReranker: rerank request skipped because {}", exception.getMessage());
            return Optional.empty();
        }
    }

    @Override
    public boolean isEnabled() {
        return searchProperties.getReranker().isEnabled()
                && "local-ai".equalsIgnoreCase(searchProperties.getReranker().getProvider());
    }

    private RerankCandidateDto toCandidateDto(BookSearchHitDto hit) {
        BookDto book = hit.getBook();
        return RerankCandidateDto.builder()
                .id(book.getId())
                .title(book.getName())
                .passage(buildPassage(book))
                .build();
    }

    private String buildPassage(BookDto book) {
        List<String> parts = new ArrayList<>();
        append(parts, "Title", book.getName());
        append(parts, "ISBN", book.getIsbn());
        append(parts, "Author", book.getAuthor() == null ? null : book.getAuthor().getName());
        append(parts, "Category", book.getCategory() == null ? null : book.getCategory().getName());
        append(parts, "Publisher", book.getPublisher() == null ? null : book.getPublisher().getName());
        Set<TagDto> tags = book.getTags();
        if (tags != null && !tags.isEmpty()) {
            append(parts, "Tags", tags.stream()
                    .map(TagDto::getName)
                    .filter(name -> name != null && !name.isBlank())
                    .collect(Collectors.joining(", ")));
        }
        append(parts, "Description", book.getDescription());
        return String.join("\n", parts);
    }

    private void append(List<String> parts, String label, String value) {
        if (value != null && !value.isBlank()) {
            parts.add(label + ": " + value.trim());
        }
    }

    private void applyRerankScore(BookSearchHitDto hit, Double score) {
        if (score != null) {
            hit.setScore(score);
        }
        if (hit.getMatchType() == null || hit.getMatchType().isBlank()) {
            hit.setMatchType("RERANK");
        } else if (!hit.getMatchType().contains("RERANK")) {
            hit.setMatchType(hit.getMatchType() + "+RERANK");
        }
        hit.setReason("Reranked by BGE reranker based on query-passage relevance.");
    }

    private URI resolveRerankUri() {
        String baseUrl = searchProperties.getReranker().getBaseUrl();
        String normalizedBaseUrl = baseUrl == null ? "" : baseUrl.trim();
        if (normalizedBaseUrl.endsWith("/")) {
            normalizedBaseUrl = normalizedBaseUrl.substring(0, normalizedBaseUrl.length() - 1);
        }
        return URI.create(normalizedBaseUrl + "/rerank");
    }
}
