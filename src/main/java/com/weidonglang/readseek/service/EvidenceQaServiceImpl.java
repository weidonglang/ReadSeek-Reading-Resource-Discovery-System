package com.weidonglang.readseek.service;

import com.weidonglang.readseek.dto.BookDto;
import com.weidonglang.readseek.dto.BookSearchHitDto;
import com.weidonglang.readseek.dto.BookSearchResponseDto;
import com.weidonglang.readseek.dto.EvidenceQaRequestDto;
import com.weidonglang.readseek.dto.EvidenceQaResponseDto;
import com.weidonglang.readseek.dto.EvidenceSnippetDto;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

@Slf4j
@Service
public class EvidenceQaServiceImpl implements EvidenceQaService {
    private static final int DEFAULT_EVIDENCE_LIMIT = 5;
    private static final int MAX_EVIDENCE_LIMIT = 8;

    private final BookSearchService bookSearchService;

    public EvidenceQaServiceImpl(BookSearchService bookSearchService) {
        this.bookSearchService = bookSearchService;
    }

    @Override
    public EvidenceQaResponseDto answer(EvidenceQaRequestDto requestDto) {
        String question = normalizeQuestion(requestDto == null ? null : requestDto.getQuestion());
        int limit = sanitizeLimit(requestDto == null ? null : requestDto.getLimit());
        BookSearchResponseDto searchResponse = bookSearchService.searchBooks(question, limit);
        List<BookSearchHitDto> hits = searchResponse == null || searchResponse.getHits() == null
                ? List.of()
                : searchResponse.getHits();

        List<EvidenceSnippetDto> evidence = new ArrayList<>();
        for (int index = 0; index < hits.size(); index++) {
            evidence.add(toEvidenceSnippet(hits.get(index), index + 1));
        }

        String answerMode = inferAnswerMode(question);
        String answer = buildTemplateAnswer(question, answerMode, evidence);
        List<String> limitations = buildLimitations(searchResponse, evidence);
        List<String> followUps = buildFollowUpSuggestions(question, evidence);

        return new EvidenceQaResponseDto(
                question,
                answer,
                answerMode,
                searchResponse == null ? null : searchResponse.getStrategy(),
                searchResponse == null ? null : searchResponse.getQueryIntent(),
                searchResponse != null && searchResponse.isFallbackApplied(),
                evidence.size(),
                evidence,
                limitations,
                followUps
        );
    }

    private EvidenceSnippetDto toEvidenceSnippet(BookSearchHitDto hit, int rank) {
        BookDto book = hit == null ? null : hit.getBook();
        return new EvidenceSnippetDto(
                book == null ? null : book.getId(),
                book == null ? null : book.getName(),
                book == null || book.getAuthor() == null ? null : book.getAuthor().getName(),
                book == null || book.getCategory() == null ? null : book.getCategory().getName(),
                truncate(book == null ? null : book.getDescription(), 260),
                hit == null ? null : hit.getMatchType(),
                hit == null ? null : hit.getScore(),
                hit == null ? null : hit.getReason(),
                rank
        );
    }

    private String buildTemplateAnswer(String question, String answerMode, List<EvidenceSnippetDto> evidence) {
        if (evidence.isEmpty()) {
            return "暂时没有找到足够可靠的馆藏证据回答这个问题。建议换一个更具体的关键词，例如作者、主题、体裁或目标读者。";
        }

        EvidenceSnippetDto top = evidence.get(0);
        String titles = evidence.stream()
                .limit(3)
                .map(EvidenceSnippetDto::getTitle)
                .filter(title -> title != null && !title.isBlank())
                .collect(Collectors.joining("、"));

        if ("RECOMMENDATION".equals(answerMode)) {
            return String.format("基于当前检索证据，优先建议从《%s》开始；同时可以对比 %s。这个回答主要依据资源标题、作者、分类、简介和混合检索命中原因生成。", safe(top.getTitle()), titles);
        }
        if ("COMPARISON".equals(answerMode)) {
            return String.format("从证据来看，可以先比较 %s。建议重点看分类、作者背景、简介主题和命中原因，再决定哪一本更符合你的阅读目标。", titles);
        }
        if ("AUTHOR_OR_WORK".equals(answerMode)) {
            return String.format("检索结果中最相关的是《%s》，作者为 %s，分类为 %s。其余证据资源可以作为同作者、同主题或相近阅读方向的补充。", safe(top.getTitle()), safe(top.getAuthor()), safe(top.getCategory()));
        }
        return String.format("系统从馆藏检索到 %d 条相关证据。最相关的是《%s》，可以结合后续证据资源判断它是否满足“%s”这个需求。", evidence.size(), safe(top.getTitle()), question);
    }

    private List<String> buildLimitations(BookSearchResponseDto searchResponse, List<EvidenceSnippetDto> evidence) {
        List<String> limitations = new ArrayList<>();
        limitations.add("当前回答由检索结果模板生成，尚未接入本地大模型推理。");
        limitations.add("证据范围仅限当前系统已入库并已建立索引的阅读资源。");
        if (searchResponse != null && searchResponse.isFallbackApplied()) {
            limitations.add("本次检索触发了回退策略，说明高相关证据不足。");
        }
        if (evidence.size() < 3) {
            limitations.add("可用证据数量较少，建议补充更明确的问题条件。");
        }
        return limitations;
    }

    private List<String> buildFollowUpSuggestions(String question, List<EvidenceSnippetDto> evidence) {
        List<String> suggestions = new ArrayList<>();
        suggestions.add("只看可借资源，应该选哪一本？");
        suggestions.add("按入门难度重新排序这些证据。");
        if (!evidence.isEmpty() && evidence.get(0).getAuthor() != null) {
            suggestions.add("继续找 " + evidence.get(0).getAuthor() + " 的相关作品。");
        } else {
            suggestions.add("换成更具体的作者、主题或分类重新提问。");
        }
        return suggestions;
    }

    private String inferAnswerMode(String question) {
        String normalized = question.toLowerCase(Locale.ROOT);
        if (normalized.contains("推荐") || normalized.contains("适合") || normalized.contains("想看")
                || normalized.contains("recommend") || normalized.contains("suggest")) {
            return "RECOMMENDATION";
        }
        if (normalized.contains("比较") || normalized.contains("区别") || normalized.contains("哪个好")
                || normalized.contains("compare") || normalized.contains("difference")) {
            return "COMPARISON";
        }
        if (normalized.contains("作者") || normalized.contains("代表作") || normalized.contains("author")
                || normalized.contains("work")) {
            return "AUTHOR_OR_WORK";
        }
        return "FACTUAL_LOOKUP";
    }

    private String normalizeQuestion(String question) {
        String normalized = question == null ? "" : question.trim();
        if (normalized.isBlank()) {
            throw new IllegalArgumentException("Question must not be blank.");
        }
        return normalized.length() <= 500 ? normalized : normalized.substring(0, 500);
    }

    private int sanitizeLimit(Integer limit) {
        if (limit == null || limit < 1) {
            return DEFAULT_EVIDENCE_LIMIT;
        }
        return Math.min(limit, MAX_EVIDENCE_LIMIT);
    }

    private String truncate(String value, int maxLength) {
        if (value == null || value.isBlank()) {
            return null;
        }
        String normalized = value.trim();
        return normalized.length() <= maxLength ? normalized : normalized.substring(0, maxLength) + "...";
    }

    private String safe(String value) {
        return value == null || value.isBlank() ? "暂无信息" : value;
    }
}
