package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dto.BookDto;
import com.weidonglang.readseek.dto.BookSearchHitDto;
import com.weidonglang.readseek.dto.BookSearchResponseDto;
import com.weidonglang.readseek.dto.EvidenceSnippetDto;
import com.weidonglang.readseek.dto.ReadingPathRequestDto;
import com.weidonglang.readseek.dto.ReadingPathResponseDto;
import com.weidonglang.readseek.dto.ReadingPathStepDto;
import com.weidonglang.readseek.dto.ResourceComparisonItemDto;
import com.weidonglang.readseek.dto.ResourceComparisonRequestDto;
import com.weidonglang.readseek.dto.ResourceComparisonResponseDto;
import com.weidonglang.readseek.dto.TagDto;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class ReadingPlanningServiceImpl implements ReadingPlanningService {
    private static final int MAX_COMPARE_SIZE = 4;
    private static final int DEFAULT_PATH_LIMIT = 9;
    private static final int MAX_PATH_LIMIT = 12;

    private final BookService bookService;
    private final BookSearchService bookSearchService;

    public ReadingPlanningServiceImpl(BookService bookService, BookSearchService bookSearchService) {
        this.bookService = bookService;
        this.bookSearchService = bookSearchService;
    }

    @Override
    public ResourceComparisonResponseDto compareResources(ResourceComparisonRequestDto requestDto) {
        List<Long> resourceIds = normalizeResourceIds(requestDto == null ? null : requestDto.getResourceIds());
        List<BookDto> resources = resourceIds.stream()
                .map(bookService::findById)
                .toList();
        List<ResourceComparisonItemDto> items = resources.stream()
                .map(this::toComparisonItem)
                .toList();

        List<String> sharedCategories = sharedValues(resources, resource -> resource.getCategory() == null ? null : resource.getCategory().getName());
        List<String> sharedAuthors = sharedValues(resources, resource -> resource.getAuthor() == null ? null : resource.getAuthor().getName());
        List<String> sharedTags = sharedTagNames(resources);

        return new ResourceComparisonResponseDto(
                items,
                buildComparisonSummary(items, sharedCategories, sharedAuthors, sharedTags),
                sharedCategories,
                sharedAuthors,
                sharedTags,
                buildDimensionNotes(items),
                buildDecisionSuggestions(items, sharedCategories, sharedTags)
        );
    }

    @Override
    public ReadingPathResponseDto suggestReadingPath(ReadingPathRequestDto requestDto) {
        String topic = normalizeTopic(requestDto == null ? null : requestDto.getTopic());
        String readingLevel = normalizeReadingLevel(requestDto == null ? null : requestDto.getReadingLevel());
        int limit = sanitizePathLimit(requestDto == null ? null : requestDto.getLimit());
        BookSearchResponseDto searchResponse = searchWithPlanningFallback(topic, limit);
        List<BookSearchHitDto> hits = searchResponse == null || searchResponse.getHits() == null
                ? List.of()
                : searchResponse.getHits();
        List<EvidenceSnippetDto> evidence = new ArrayList<>();
        for (int index = 0; index < hits.size(); index++) {
            evidence.add(toEvidenceSnippet(hits.get(index), index + 1));
        }

        List<ReadingPathStepDto> steps = buildPathSteps(evidence, readingLevel);
        return new ReadingPathResponseDto(
                topic,
                readingLevel,
                searchResponse == null ? null : searchResponse.getStrategy(),
                searchResponse == null ? null : searchResponse.getQueryIntent(),
                evidence.size(),
                steps,
                buildPathRationale(topic, readingLevel, evidence),
                buildPathLimitations(evidence, searchResponse == null ? false : searchResponse.isFallbackApplied())
        );
    }

    private List<Long> normalizeResourceIds(List<Long> resourceIds) {
        if (resourceIds == null) {
            throw new IllegalArgumentException("At least two resource ids are required.");
        }
        List<Long> normalized = resourceIds.stream()
                .filter(Objects::nonNull)
                .filter(id -> id > 0)
                .distinct()
                .limit(MAX_COMPARE_SIZE)
                .toList();
        if (normalized.size() < 2) {
            throw new IllegalArgumentException("At least two distinct resource ids are required.");
        }
        return normalized;
    }

    private BookSearchResponseDto searchWithPlanningFallback(String topic, int limit) {
        BookSearchResponseDto initialResponse = bookSearchService.searchBooks(topic, limit);
        if (hasSearchHits(initialResponse)) {
            return initialResponse;
        }

        for (String fallbackQuery : buildPlanningFallbackQueries(topic)) {
            BookSearchResponseDto fallbackResponse = bookSearchService.searchBooks(fallbackQuery, limit);
            if (hasSearchHits(fallbackResponse)) {
                fallbackResponse.setQuery(topic);
                fallbackResponse.setFallbackApplied(true);
                String strategy = fallbackResponse.getStrategy() == null ? "planning-query-expansion" : fallbackResponse.getStrategy();
                fallbackResponse.setStrategy(strategy + "+planning-query-expansion");
                return fallbackResponse;
            }
        }
        return initialResponse;
    }

    private boolean hasSearchHits(BookSearchResponseDto response) {
        return response != null && response.getHits() != null && !response.getHits().isEmpty();
    }

    private List<String> buildPlanningFallbackQueries(String topic) {
        String normalized = topic == null ? "" : topic.trim();
        List<String> queries = new ArrayList<>();
        if (!normalized.isBlank()) {
            queries.add("想找一本" + normalized);
        }

        String lowerTopic = normalized.toLowerCase(Locale.ROOT);
        if (normalized.contains("简奥斯汀") || normalized.contains("奥斯汀") || lowerTopic.contains("austen")) {
            queries.add("Jane Austen Pride and Prejudice Sense and Sensibility");
        }
        if (normalized.contains("爱情") || normalized.contains("恋爱") || lowerTopic.contains("romance")) {
            queries.add("classic romance love story Jane Austen Pride and Prejudice");
        }
        if (normalized.contains("心理") || lowerTopic.contains("psychology")) {
            queries.add("introductory psychology self help behavior Nudge");
        }
        if (normalized.contains("科幻") || lowerTopic.contains("science fiction")) {
            queries.add("science fiction classic adventure");
        }
        if (normalized.contains("哲学") || lowerTopic.contains("philosophy")) {
            queries.add("philosophy introduction classic");
        }
        if (normalized.contains("历史") || lowerTopic.contains("history")) {
            queries.add("history classic biography");
        }

        return queries.stream()
                .filter(query -> !query.equalsIgnoreCase(normalized))
                .distinct()
                .toList();
    }

    private ResourceComparisonItemDto toComparisonItem(BookDto resource) {
        return new ResourceComparisonItemDto(
                resource.getId(),
                resource.getName(),
                resource.getAuthor() == null ? null : resource.getAuthor().getName(),
                resource.getCategory() == null ? null : resource.getCategory().getName(),
                resource.getRate(),
                resource.getUsersRateCount(),
                resource.getPagesNumber(),
                resource.getReadingDuration(),
                resource.getAvailableCopies(),
                resource.getTotalCopies(),
                tagNames(resource),
                truncate(resource.getDescription(), 220)
        );
    }

    private List<String> sharedValues(List<BookDto> resources, Function<BookDto, String> extractor) {
        Map<String, Long> counts = resources.stream()
                .map(extractor)
                .filter(value -> value != null && !value.isBlank())
                .collect(Collectors.groupingBy(Function.identity(), Collectors.counting()));
        return counts.entrySet().stream()
                .filter(entry -> entry.getValue() > 1)
                .map(Map.Entry::getKey)
                .sorted()
                .toList();
    }

    private List<String> sharedTagNames(List<BookDto> resources) {
        Map<String, Long> counts = resources.stream()
                .map(this::tagNames)
                .flatMap(Collection::stream)
                .collect(Collectors.groupingBy(Function.identity(), Collectors.counting()));
        return counts.entrySet().stream()
                .filter(entry -> entry.getValue() > 1)
                .map(Map.Entry::getKey)
                .sorted()
                .toList();
    }

    private List<String> tagNames(BookDto resource) {
        if (resource.getTags() == null) {
            return List.of();
        }
        return resource.getTags().stream()
                .map(TagDto::getName)
                .filter(name -> name != null && !name.isBlank())
                .sorted()
                .toList();
    }

    private String buildComparisonSummary(List<ResourceComparisonItemDto> items,
                                          List<String> sharedCategories,
                                          List<String> sharedAuthors,
                                          List<String> sharedTags) {
        String titles = items.stream().map(ResourceComparisonItemDto::getTitle).collect(Collectors.joining("、"));
        if (!sharedAuthors.isEmpty()) {
            return String.format("这组资源都与作者 %s 相关，适合按作品主题、篇幅和可借状态继续比较：%s。", String.join("、", sharedAuthors), titles);
        }
        if (!sharedCategories.isEmpty()) {
            return String.format("这组资源存在共同分类 %s，适合同主题横向比较：%s。", String.join("、", sharedCategories), titles);
        }
        if (!sharedTags.isEmpty()) {
            return String.format("这组资源共享标签 %s，可从相近主题切入比较：%s。", String.join("、", sharedTags), titles);
        }
        return String.format("这组资源差异较大，建议按作者、分类、评分、篇幅和库存分别判断：%s。", titles);
    }

    private List<String> buildDimensionNotes(List<ResourceComparisonItemDto> items) {
        List<String> notes = new ArrayList<>();
        items.stream()
                .filter(item -> item.getRating() != null)
                .max(Comparator.comparing(ResourceComparisonItemDto::getRating))
                .ifPresent(item -> notes.add(String.format("评分维度：%s 当前评分最高，为 %.1f。", item.getTitle(), item.getRating())));
        items.stream()
                .filter(item -> item.getPagesNumber() != null)
                .min(Comparator.comparing(ResourceComparisonItemDto::getPagesNumber))
                .ifPresent(item -> notes.add(String.format("篇幅维度：%s 页数最少，更适合作为快速入口。", item.getTitle())));
        items.stream()
                .filter(item -> item.getAvailableCopies() != null && item.getAvailableCopies() > 0)
                .findFirst()
                .ifPresentOrElse(
                        item -> notes.add(String.format("流通维度：%s 当前有可借库存。", item.getTitle())),
                        () -> notes.add("流通维度：当前对比资源都没有明确可借库存，可能需要预约或稍后再看。")
                );
        return notes;
    }

    private List<String> buildDecisionSuggestions(List<ResourceComparisonItemDto> items,
                                                  List<String> sharedCategories,
                                                  List<String> sharedTags) {
        List<String> suggestions = new ArrayList<>();
        suggestions.add("如果目标是快速开始，优先选择页数少、可借库存充足的资源。");
        suggestions.add("如果目标是深入理解，优先选择评分和评分人数更高、简介更完整的资源。");
        if (!sharedCategories.isEmpty() || !sharedTags.isEmpty()) {
            suggestions.add("这些资源存在主题重合，可以先读评分更高的一本，再用另一本补充视角。");
        } else {
            suggestions.add("这些资源主题跨度较大，建议先明确是想看作者、题材、知识点还是难度。");
        }
        return suggestions;
    }

    private List<ReadingPathStepDto> buildPathSteps(List<EvidenceSnippetDto> evidence, String readingLevel) {
        if (evidence.isEmpty()) {
            return List.of();
        }
        List<EvidenceSnippetDto> ordered = reorderEvidenceForLevel(evidence, readingLevel);
        return List.of(
                new ReadingPathStepDto(1, "入门理解", "先用较容易进入的资源建立主题印象。", slice(ordered, 0, 3)),
                new ReadingPathStepDto(2, "核心阅读", "阅读相关性更高或评价更稳定的资源，形成主干理解。", slice(ordered, 3, 6)),
                new ReadingPathStepDto(3, "拓展对照", "用剩余证据补充不同作者、分类或主题角度。", slice(ordered, 6, ordered.size()))
        ).stream().filter(step -> !step.getResources().isEmpty()).toList();
    }

    private List<EvidenceSnippetDto> reorderEvidenceForLevel(List<EvidenceSnippetDto> evidence, String readingLevel) {
        if ("BEGINNER".equals(readingLevel)) {
            return evidence.stream()
                    .sorted(Comparator.comparingInt(item -> estimateDifficulty(item.getDescription())))
                    .toList();
        }
        if ("EXPERT".equals(readingLevel)) {
            return evidence.stream()
                    .sorted(Comparator.comparing((EvidenceSnippetDto item) -> item.getScore() == null ? 0D : item.getScore()).reversed())
                    .toList();
        }
        return evidence;
    }

    private int estimateDifficulty(String description) {
        if (description == null) {
            return 1000;
        }
        return description.length();
    }

    private List<EvidenceSnippetDto> slice(List<EvidenceSnippetDto> items, int from, int to) {
        if (from >= items.size()) {
            return List.of();
        }
        return items.subList(from, Math.min(to, items.size()));
    }

    private EvidenceSnippetDto toEvidenceSnippet(BookSearchHitDto hit, int rank) {
        BookDto book = hit == null ? null : hit.getBook();
        return new EvidenceSnippetDto(
                book == null ? null : book.getId(),
                book == null ? null : book.getName(),
                book == null || book.getAuthor() == null ? null : book.getAuthor().getName(),
                book == null || book.getCategory() == null ? null : book.getCategory().getName(),
                truncate(book == null ? null : book.getDescription(), 220),
                hit == null ? null : hit.getMatchType(),
                hit == null ? null : hit.getScore(),
                hit == null ? null : hit.getReason(),
                rank
        );
    }

    private List<String> buildPathRationale(String topic, String readingLevel, List<EvidenceSnippetDto> evidence) {
        List<String> rationale = new ArrayList<>();
        rationale.add(String.format("围绕“%s”调用混合检索，按相关性、难度估计和阶段目标组织阅读顺序。", topic));
        rationale.add(String.format("当前阅读等级为 %s，因此路径会在入门、核心和拓展之间分层。", readingLevel));
        rationale.add(String.format("本次共使用 %d 条检索证据生成路径。", evidence.size()));
        return rationale;
    }

    private List<String> buildPathLimitations(List<EvidenceSnippetDto> evidence, boolean fallbackApplied) {
        List<String> limitations = new ArrayList<>();
        limitations.add("当前路径由规则模板生成，尚未接入本地模型进行个性化重排。");
        limitations.add("难度估计主要依据简介长度和检索排名，后续可引入真实阅读难度模型。");
        if (fallbackApplied) {
            limitations.add("本次检索触发回退，说明高置信证据不足。");
        }
        if (evidence.size() < 6) {
            limitations.add("证据数量偏少，路径阶段可能不完整。");
        }
        return limitations;
    }

    private String normalizeTopic(String topic) {
        String normalized = topic == null ? "" : topic.trim();
        if (normalized.isBlank()) {
            throw new IllegalArgumentException("Topic must not be blank.");
        }
        return normalized.length() <= 300 ? normalized : normalized.substring(0, 300);
    }

    private String normalizeReadingLevel(String readingLevel) {
        String normalized = readingLevel == null ? "INTERMEDIATE" : readingLevel.trim().toUpperCase(Locale.ROOT);
        Set<String> allowed = Set.of("BEGINNER", "INTERMEDIATE", "EXPERT");
        return allowed.contains(normalized) ? normalized : "INTERMEDIATE";
    }

    private int sanitizePathLimit(Integer limit) {
        if (limit == null || limit < 1) {
            return DEFAULT_PATH_LIMIT;
        }
        return Math.min(limit, MAX_PATH_LIMIT);
    }

    private String truncate(String value, int maxLength) {
        if (value == null || value.isBlank()) {
            return null;
        }
        String normalized = value.trim();
        return normalized.length() <= maxLength ? normalized : normalized.substring(0, maxLength) + "...";
    }
}
