function escapeHtml(value) {
  return String(value ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

function t(key, variables = {}) {
  return window.BookI18n.t(key, variables);
}

function pageText(zh, en) {
  return window.BookI18n.isChinese() ? zh : en;
}

function getBooksLabels() {
  return {
    keyword: pageText('关键词', 'Keyword'),
    author: pageText('作者', 'Author'),
    category: pageText('分类', 'Category'),
    publisher: pageText('出版社', 'Publisher'),
    tag: pageText('标签', 'Tag'),
    range: pageText('范围', 'Range'),
    pages: pageText('页数', 'Pages'),
    duration: pageText('时长', 'Duration'),
    mode: pageText('模式', 'Mode'),
    intent: pageText('意图', 'Intent'),
    strategy: pageText('策略', 'Strategy'),
    results: pageText('结果', 'Results'),
    sort: pageText('排序', 'Sort'),
    fallback: pageText('回退', 'Fallback'),
    query: pageText('查询', 'Query'),
    browseMode: pageText('图书浏览', 'Catalog browse'),
    filteredMode: pageText('高级筛选', 'Advanced filters'),
    searchMode: pageText('智能搜索', 'Search API'),
    relevanceSort: pageText('相关性优先', 'Relevance first'),
    fallbackYes: pageText('已启用', 'Applied'),
    fallbackNo: pageText('未启用', 'Not applied'),
    noPaging: pageText('当前模式不分页，按限制条数返回', 'This mode is not paginated and returns up to the requested limit'),
    filterSourceLabel: pageText('图书筛选', 'Filtered browse'),
    searchSourceLabel: pageText('智能搜索', 'Hybrid search'),
    browseHint: pageText('未输入关键词时按目录浏览，可配合下方筛选条件缩小范围。', 'Without a keyword, the page stays in catalog browse mode. Add filters below to narrow results.'),
    searchHint: pageText('当前只输入了文本，将使用智能搜索接口，按相关性返回结果。', 'Text-only queries use the smart search API and return relevance-ranked results.'),
    filterHint: pageText('当前启用了高级筛选，将切换为筛选分页模式。', 'Advanced filters are active, so the page switches to paginated filter mode.'),
    waitingSearch: pageText('等待搜索', 'Waiting for search'),
    hybridLimit: limit => pageText(`返回前 ${limit} 条相关结果`, `Returning up to ${limit} relevant hits`),
    filteredSummary: (count, page, totalPages) => pageText(`第 ${page} / ${totalPages} 页，共 ${count} 本图书`, `Page ${page} / ${totalPages}, ${count} books total`),
    searchSummary: count => pageText(`返回 ${count} 条相关结果`, `${count} relevant hits returned`),
    filterLoadFailed: message => pageText(`图书加载失败：${message}`, `Failed to load books: ${message}`),
    filterBootstrapFailed: message => pageText(`筛选条件加载失败：${message}`, `Failed to load filters: ${message}`),
    exactIntent: pageText('精确查找', 'Exact lookup'),
    keywordIntent: pageText('关键词检索', 'Keyword search'),
    naturalLanguageIntent: pageText('自然语言检索', 'Natural-language search'),
    unknownIntent: pageText('未识别', 'Unknown'),
    exactMatch: pageText('精确匹配', 'Exact match'),
    bm25Match: pageText('全文相关性命中', 'BM25 relevance hit'),
    searchMatch: pageText('搜索命中', 'Search hit')
  };
}

let allAuthors = [];
let allCategories = [];
let allPublishers = [];
let allTags = [];

function getCheckedValues(name) {
  return Array.from(document.querySelectorAll(`input[name="${name}"]:checked`))
    .map(input => Number(input.value))
    .filter(value => Number.isFinite(value));
}

function getSelectedValues(selectId) {
  return Array.from(document.getElementById(selectId).selectedOptions)
    .map(option => Number(option.value))
    .filter(value => Number.isFinite(value));
}

function toNullableArray(values) {
  return values.length ? values : null;
}

function buildBookFilterPayload(pageNumber = 1) {
  const sortField = document.getElementById('sortField').value || 'id';
  const criteria = {
    name: document.getElementById('keyword').value.trim() || null,
    categories: toNullableArray(getCheckedValues('category')),
    authors: toNullableArray(getCheckedValues('author')),
    publishers: toNullableArray(getSelectedValues('publisher-filter')),
    tags: toNullableArray(getCheckedValues('tag')),
    fromPrice: document.getElementById('fromPrice').value ? Number(document.getElementById('fromPrice').value) : null,
    toPrice: document.getElementById('toPrice').value ? Number(document.getElementById('toPrice').value) : null,
    fromPagesNumber: document.getElementById('fromPagesNumber').value ? Number(document.getElementById('fromPagesNumber').value) : null,
    toPagesNumber: document.getElementById('toPagesNumber').value ? Number(document.getElementById('toPagesNumber').value) : null,
    fromReadingDuration: document.getElementById('fromReadingDuration').value ? Number(document.getElementById('fromReadingDuration').value) : null,
    toReadingDuration: document.getElementById('toReadingDuration').value ? Number(document.getElementById('toReadingDuration').value) : null
  };
  const hasCriteria = Object.values(criteria).some(value => value !== null);

  return {
    pageNumber,
    pageSize: Math.max(1, Number(document.getElementById('pageSize').value || 8)),
    sortingByList: [
      {
        fieldName: sortField,
        direction: document.getElementById('sortDirection').value || 'ASC',
        isNumber: ['price', 'pagesNumber', 'readingDuration', 'rate', 'id', 'availableCopies', 'usersRateCount'].includes(sortField)
      }
    ],
    criteria: hasCriteria ? criteria : null,
    deletedRecords: false
  };
}

function hasKeyword(payload) {
  return Boolean(String(payload.criteria?.name || '').trim());
}

function hasAdvancedFilters(payload) {
  const criteria = payload.criteria || {};
  return [
    Array.isArray(criteria.categories) && criteria.categories.length,
    Array.isArray(criteria.authors) && criteria.authors.length,
    Array.isArray(criteria.publishers) && criteria.publishers.length,
    Array.isArray(criteria.tags) && criteria.tags.length,
    criteria.fromPrice !== null,
    criteria.toPrice !== null,
    criteria.fromPagesNumber !== null,
    criteria.toPagesNumber !== null,
    criteria.fromReadingDuration !== null,
    criteria.toReadingDuration !== null
  ].some(Boolean);
}

function shouldUseSearchApi(payload) {
  return hasKeyword(payload) && !hasAdvancedFilters(payload);
}

function ensureSearchModeHint() {
  let hint = document.getElementById('search-mode-hint');
  if (hint) {
    return hint;
  }

  const keywordInput = document.getElementById('keyword');
  if (!keywordInput || !keywordInput.parentElement) {
    return null;
  }

  hint = document.createElement('div');
  hint.id = 'search-mode-hint';
  hint.className = 'books-search-hint';
  keywordInput.insertAdjacentElement('afterend', hint);
  return hint;
}

function updateSearchModeHint() {
  const hint = ensureSearchModeHint();
  if (!hint) return;

  const payload = buildBookFilterPayload(Number(document.getElementById('currentPage')?.value || 1));
  const labels = getBooksLabels();

  if (shouldUseSearchApi(payload)) {
    hint.textContent = labels.searchHint;
    hint.dataset.mode = 'search';
    return;
  }

  if (hasAdvancedFilters(payload)) {
    hint.textContent = labels.filterHint;
    hint.dataset.mode = 'filtered';
    return;
  }

  hint.textContent = labels.browseHint;
  hint.dataset.mode = 'browse';
}

function renderCheckboxList(targetId, name, items) {
  const target = document.getElementById(targetId);
  target.innerHTML = items.map(item => `
    <label class="filter-option">
      <input type="checkbox" name="${name}" value="${item.id}">
      <span>${escapeHtml(name === 'category' ? BookUi.localizeCategoryName(item.name) : item.name)}</span>
    </label>`).join('');
}

function renderSelectOptions(targetId, items, emptyLabel) {
  const select = document.getElementById(targetId);
  select.innerHTML = items.length
    ? items.map(item => `<option value="${item.id}">${escapeHtml(item.name)}</option>`).join('')
    : `<option disabled>${escapeHtml(emptyLabel)}</option>`;
}

function renderAuthorPicker() {
  const container = document.getElementById('author-filter');
  const summary = document.getElementById('author-selected');
  const selectedIds = new Set(getCheckedValues('author').map(String));
  const query = document.getElementById('author-search').value.trim().toLowerCase();
  const filteredAuthors = allAuthors.filter(author => author.name.toLowerCase().includes(query));

  container.innerHTML = filteredAuthors.length
    ? filteredAuthors.map(author => `
      <label class="filter-option">
        <input type="checkbox" name="author" value="${author.id}" ${selectedIds.has(String(author.id)) ? 'checked' : ''}>
        <span>${escapeHtml(author.name)}</span>
      </label>`).join('')
    : `<div class="muted">${escapeHtml(t('books.noAuthors'))}</div>`;

  const selectedAuthors = allAuthors.filter(author => selectedIds.has(String(author.id)));
  summary.innerHTML = selectedAuthors.length
    ? selectedAuthors.map(author => `<span class="tag">${escapeHtml(author.name)}</span>`).join('')
    : `<span class="muted">${escapeHtml(t('books.noAuthorSelected'))}</span>`;
}

function setAuthorSelection(authorIds) {
  const selectedSet = new Set((authorIds || []).map(String));
  document.querySelectorAll('input[name="author"]').forEach(input => {
    input.checked = selectedSet.has(input.value);
  });
  renderAuthorPicker();
}

function setCheckboxSelection(name, ids) {
  const selectedSet = new Set((ids || []).map(String));
  document.querySelectorAll(`input[name="${name}"]`).forEach(input => {
    input.checked = selectedSet.has(input.value);
  });
}

function applyQueryDefaults(authors, categories) {
  const params = new URLSearchParams(window.location.search);
  const keyword = params.get('keyword');
  const authorId = params.get('authorId');
  const categoryId = params.get('categoryId');

  if (keyword) {
    document.getElementById('keyword').value = keyword;
  }

  if (authorId) {
    const availableIds = new Set(authors.map(author => String(author.id)));
    if (availableIds.has(String(authorId))) {
      setAuthorSelection([authorId]);
      BookUi.showMessage('books-message', 'info', t('books.autoAuthor'));
    }
  }

  if (categoryId) {
    const categoryMap = new Map((categories || []).map(category => [String(category.id), category]));
    if (categoryMap.has(String(categoryId))) {
      setCheckboxSelection('category', [categoryId]);
      const category = categoryMap.get(String(categoryId));
      BookUi.showMessage('books-message', 'info', t('books.autoCategory', { category: BookUi.localizeCategoryName(category.name) }));
    }
  }
}

function includesIgnoreCase(value, keyword) {
  return String(value || '').toLowerCase().includes(String(keyword || '').toLowerCase());
}

function buildFilterHitReason(book, payload) {
  const criteria = payload.criteria || {};
  const reasons = [];
  const keyword = String(criteria.name || '').trim();

  if (keyword) {
    if (includesIgnoreCase(book.name, keyword)) {
      reasons.push(t('books.reasonName', { keyword }));
    } else if (includesIgnoreCase(book.isbn, keyword)) {
      reasons.push(t('books.reasonIsbn', { keyword }));
    } else if (includesIgnoreCase(book.author?.name, keyword)) {
      reasons.push(t('books.reasonAuthor', { keyword }));
    } else if (includesIgnoreCase(book.category?.name, keyword)) {
      reasons.push(t('books.reasonCategory', { keyword }));
    } else if (includesIgnoreCase(book.publisher?.name, keyword)) {
      reasons.push(t('books.reasonPublisher', { keyword }));
    } else if ((book.tags || []).some(tag => includesIgnoreCase(tag?.name, keyword))) {
      reasons.push(t('books.reasonTag', { keyword }));
    }
  }

  if (criteria.categories && book.category?.id && criteria.categories.includes(book.category.id)) {
    reasons.push(t('books.reasonCategoryFilter', { value: BookUi.localizeCategoryName(book.category.name) || book.category.id }));
  }
  if (criteria.authors && book.author?.id && criteria.authors.includes(book.author.id)) {
    reasons.push(t('books.reasonAuthorFilter', { value: book.author.name || book.author.id }));
  }
  if (criteria.publishers && book.publisher?.id && criteria.publishers.includes(book.publisher.id)) {
    reasons.push(t('books.reasonPublisherFilter', { value: book.publisher.name || book.publisher.id }));
  }
  if (criteria.tags && Array.isArray(book.tags)) {
    const matchedTagNames = book.tags
      .filter(tag => tag?.id && criteria.tags.includes(tag.id))
      .map(tag => tag.name)
      .filter(Boolean);
    if (matchedTagNames.length) {
      reasons.push(t('books.reasonTagFilter', { value: matchedTagNames.join(', ') }));
    }
  }

  const sortField = payload.sortingByList?.[0]?.fieldName || 'id';
  if (sortField === 'usersRateCount') {
    reasons.push(t('books.reasonSortPopularity', { value: book.usersRateCount ?? 0 }));
  } else if (sortField === 'publishDate') {
    reasons.push(t('books.reasonSortPublishDate', { value: BookApi.toDisplayDate(book.publishDate) }));
  } else if (sortField === 'rate') {
    reasons.push(t('books.reasonSortRate', { value: book.rate ?? '-' }));
  }

  return reasons.length ? reasons.join(window.BookI18n.isChinese() ? '；' : '; ') : t('books.reasonFallback');
}

function findNamesByIds(items, ids, mapper = item => item.name) {
  const selectedSet = new Set((ids || []).map(String));
  return (items || [])
    .filter(item => selectedSet.has(String(item.id)))
    .map(mapper)
    .filter(Boolean);
}

function toFiniteNumberOrNull(value) {
  return Number.isFinite(value) ? value : null;
}

function formatRangeLabel(label, from, to, unit = '') {
  const normalizedFrom = toFiniteNumberOrNull(from);
  const normalizedTo = toFiniteNumberOrNull(to);
  if (normalizedFrom === null && normalizedTo === null) return null;
  if (normalizedFrom !== null && normalizedTo !== null) {
    return `${label}${normalizedFrom}-${normalizedTo}${unit}`;
  }
  if (normalizedFrom !== null) {
    return pageText(`${label}${normalizedFrom}${unit} 以上`, `${label}${normalizedFrom}${unit}+`);
  }
  return pageText(`${label}${normalizedTo}${unit} 以下`, `${label}up to ${normalizedTo}${unit}`);
}

function renderSummaryChips(items) {
  const wrap = document.getElementById('active-filter-summary');
  if (!wrap) return;

  if (!items.length) {
    wrap.classList.add('hidden');
    wrap.innerHTML = '';
    return;
  }

  wrap.classList.remove('hidden');
  wrap.innerHTML = items.map(item => `
    <span class="books-active-label">
      <strong>${escapeHtml(item.label)}</strong>${escapeHtml(item.value)}
    </span>
  `).join('');
}

function humanizeQueryIntent(queryIntent) {
  const labels = getBooksLabels();
  if (queryIntent === 'EXACT_LOOKUP') return labels.exactIntent;
  if (queryIntent === 'KEYWORD') return labels.keywordIntent;
  if (queryIntent === 'NATURAL_LANGUAGE') return labels.naturalLanguageIntent;
  return labels.unknownIntent;
}

function humanizeSearchStrategy(strategy) {
  if (!strategy) return '-';

  if (strategy.startsWith('hybrid-v1')) {
    return pageText('Hybrid v1（精确匹配 + BM25）', 'Hybrid v1 (exact match + BM25)');
  }
  if (strategy.startsWith('hybrid-v2(exact-db+vector+bm25)')) {
    return pageText('Hybrid v2（精确匹配 + 向量语义 + BM25）', 'Hybrid v2 (exact match + vector + BM25)');
  }
  if (strategy.startsWith('hybrid-v2(exact-db+bm25+vector)')) {
    return pageText('Hybrid v2（精确匹配 + BM25 + 向量语义）', 'Hybrid v2 (exact match + BM25 + vector)');
  }
  if (strategy === 'bm25') {
    return 'BM25';
  }
  if (strategy === 'exact-db') {
    return pageText('数据库精确匹配', 'Database exact match');
  }
  return strategy;
}

function humanizeMatchType(matchType) {
  const labels = getBooksLabels();
  if (matchType === 'EXACT_DB') return labels.exactMatch;
  if (matchType === 'BM25') return labels.bm25Match;
  if (matchType === 'VECTOR') return pageText('语义相似命中', 'Vector semantic hit');
  return labels.searchMatch;
}

function buildSearchHitReason(hit) {
  const parts = [];
  if (hit.reason) {
    parts.push(hit.reason);
  }
  if (hit.matchType) {
    parts.push(humanizeMatchType(hit.matchType));
  }
  return parts.join(window.BookI18n.isChinese() ? '；' : '; ');
}

function renderFilterSummary(payload, pagination) {
  const labels = getBooksLabels();
  const criteria = payload.criteria || {};
  const segments = [];
  const keyword = String(criteria.name || '').trim();

  segments.push({
    label: labels.mode,
    value: hasAdvancedFilters(payload) ? labels.filteredMode : labels.browseMode
  });

  if (keyword) {
    segments.push({ label: labels.keyword, value: keyword });
  }

  const authorNames = findNamesByIds(allAuthors, criteria.authors, item => item.name);
  if (authorNames.length) {
    segments.push({ label: labels.author, value: authorNames.join(', ') });
  }

  const categoryNames = findNamesByIds(allCategories, criteria.categories, item => BookUi.localizeCategoryName(item.name));
  if (categoryNames.length) {
    segments.push({ label: labels.category, value: categoryNames.join(', ') });
  }

  const publisherNames = findNamesByIds(allPublishers, criteria.publishers, item => item.name);
  if (publisherNames.length) {
    segments.push({ label: labels.publisher, value: publisherNames.join(', ') });
  }

  const tagNames = findNamesByIds(allTags, criteria.tags, item => item.name);
  if (tagNames.length) {
    segments.push({ label: labels.tag, value: tagNames.join(', ') });
  }

  const priceRange = formatRangeLabel(pageText('价格 ', 'Price '), criteria.fromPrice, criteria.toPrice, pageText(' 元', ''));
  if (priceRange) segments.push({ label: labels.range, value: priceRange });

  const pagesRange = formatRangeLabel(pageText('页数 ', 'Pages '), criteria.fromPagesNumber, criteria.toPagesNumber, '');
  if (pagesRange) segments.push({ label: labels.pages, value: pagesRange });

  const durationRange = formatRangeLabel(pageText('时长 ', 'Duration '), criteria.fromReadingDuration, criteria.toReadingDuration, pageText(' 分钟', ' min'));
  if (durationRange) segments.push({ label: labels.duration, value: durationRange });

  const sortFieldOption = document.querySelector(`#sortField option[value="${payload.sortingByList?.[0]?.fieldName || 'id'}"]`);
  const sortDirectionOption = document.querySelector(`#sortDirection option[value="${payload.sortingByList?.[0]?.direction || 'ASC'}"]`);
  segments.push({
    label: labels.sort,
    value: `${sortFieldOption?.textContent || 'id'} / ${sortDirectionOption?.textContent || 'ASC'}`
  });

  segments.push({
    label: labels.results,
    value: labels.filteredSummary(
      pagination.totalNumberOfElements || 0,
      Math.max(1, Number(pagination.pageNumber || 1)),
      pagination.totalNumberOfPages || 1
    )
  });

  renderSummaryChips(segments);
}

function renderSearchSummary(response, limit) {
  const labels = getBooksLabels();
  const segments = [
    { label: labels.mode, value: labels.searchMode },
    { label: labels.query, value: response.query || '' },
    { label: labels.intent, value: humanizeQueryIntent(response.queryIntent) },
    { label: labels.strategy, value: humanizeSearchStrategy(response.strategy) },
    { label: labels.results, value: labels.searchSummary(response.returnedCount || 0) },
    { label: labels.sort, value: labels.relevanceSort },
    { label: labels.fallback, value: response.fallbackApplied ? labels.fallbackYes : labels.fallbackNo },
    { label: labels.range, value: labels.hybridLimit(limit) }
  ];

  renderSummaryChips(segments);
}

function setPageControls({ currentPage = 1, prevDisabled = true, nextDisabled = true }) {
  document.getElementById('currentPage').value = String(currentPage);
  document.getElementById('prev-page').disabled = prevDisabled;
  document.getElementById('next-page').disabled = nextDisabled;
}

async function loadBooks(pageNumber = 1) {
  const target = document.getElementById('book-results');
  const pageSummary = document.getElementById('page-summary');
  const payload = buildBookFilterPayload(pageNumber);
  const labels = getBooksLabels();
  const keyword = payload.criteria?.name || '';

  BookUi.hideMessage('books-message');
  target.innerHTML = `<div class="card muted">${escapeHtml(t('books.loading'))}</div>`;

  try {
    if (shouldUseSearchApi(payload)) {
      const limit = payload.pageSize;
      const encodedQuery = encodeURIComponent(keyword.trim());
      const response = await BookApi.apiRequest(`/api/search/books?q=${encodedQuery}&limit=${limit}`);
      const body = response?.body || {};
      const hits = Array.isArray(body.hits) ? body.hits : [];

      target.innerHTML = hits.length
        ? hits.map(hit => BookUi.renderBookCard(hit.book, {
          source: `search:${body.strategy || 'hybrid'}`,
          sourceLabel: labels.searchSourceLabel,
          reason: buildSearchHitReason(hit),
          actionType: 'BOOK_DETAIL_CLICK',
          searchKeyword: body.query || keyword
        })).join('')
        : `<div class="card muted">${escapeHtml(t('books.emptyResults'))}</div>`;

      BookUi.refreshSaveButtons(target);
      pageSummary.textContent = labels.searchSummary(body.returnedCount || hits.length);
      renderSearchSummary({
        query: body.query || keyword,
        queryIntent: body.queryIntent,
        strategy: body.strategy,
        fallbackApplied: Boolean(body.fallbackApplied),
        returnedCount: body.returnedCount || hits.length
      }, limit);
      setPageControls({ currentPage: 1, prevDisabled: true, nextDisabled: true });
      return;
    }

    const response = await BookApi.apiRequest('/api/book/find-all-paginated-filtered', {
      method: 'POST',
      body: payload
    });
    const pagination = BookApi.parsePaginationResult(response);
    const currentPage = Math.max(1, Number(pagination.pageNumber || pageNumber));

    target.innerHTML = pagination.list.length
      ? pagination.list.map(book => BookUi.renderBookCard(book, {
        source: 'search:books-page',
        sourceLabel: labels.filterSourceLabel,
        reason: buildFilterHitReason(book, payload),
        actionType: 'BOOK_DETAIL_CLICK',
        searchKeyword: keyword
      })).join('')
      : `<div class="card muted">${escapeHtml(t('books.emptyResults'))}</div>`;

    BookUi.refreshSaveButtons(target);
    pageSummary.textContent = t('books.pageSummary', {
      page: currentPage,
      totalPages: pagination.totalNumberOfPages || 1,
      totalElements: pagination.totalNumberOfElements
    });
    renderFilterSummary(payload, pagination);
    setPageControls({
      currentPage,
      prevDisabled: currentPage <= 1,
      nextDisabled: currentPage >= Math.max(1, Number(pagination.totalNumberOfPages || 1))
    });
  } catch (error) {
    renderSummaryChips([]);
    setPageControls({ currentPage: 1, prevDisabled: true, nextDisabled: true });
    target.innerHTML = `<div class="card">${escapeHtml(t('books.loadFailed', { message: error.message }))}</div>`;
    pageSummary.textContent = labels.waitingSearch;
  }
}

function resetSearchForm() {
  document.getElementById('filter-form').reset();
  document.querySelectorAll('#category-filters input[type="checkbox"], #tag-filters input[type="checkbox"], #author-filter input[type="checkbox"]').forEach(input => {
    input.checked = false;
  });
  Array.from(document.getElementById('publisher-filter').options).forEach(option => {
    option.selected = false;
  });
  document.getElementById('author-search').value = '';
  renderAuthorPicker();
  document.getElementById('pageSize').value = '8';
  document.getElementById('sortField').value = 'id';
  document.getElementById('sortDirection').value = 'ASC';
  updateSearchModeHint();
}

document.addEventListener('DOMContentLoaded', async () => {
  if (!BookUi.requireLogin()) return;
  BookUi.injectLayout();
  ensureSearchModeHint();

  document.getElementById('sortField').innerHTML = `
    <option value="id">${t('books.optionId')}</option>
    <option value="name">${t('books.optionName')}</option>
    <option value="price">${t('books.optionPrice')}</option>
    <option value="pagesNumber">${t('books.optionPages')}</option>
    <option value="readingDuration">${t('books.optionDuration')}</option>
    <option value="rate">${t('books.optionRate')}</option>
    <option value="usersRateCount">${t('books.optionPopularity')}</option>
    <option value="publishDate">${t('books.optionPublishDate')}</option>
    <option value="availableCopies">${t('books.optionCopies')}</option>
  `;
  document.getElementById('sortDirection').innerHTML = `
    <option value="ASC">${t('books.sortAsc')}</option>
    <option value="DESC">${t('books.sortDesc')}</option>
  `;

  try {
    const [categoryRes, tagRes, publisherRes, authorRes] = await Promise.all([
      BookApi.apiRequest('/api/book/find-all-categories'),
      BookApi.apiRequest('/api/tag'),
      BookApi.apiRequest('/api/publisher'),
      BookApi.apiRequest('/api/author/find-all-paginated-filtered', {
        method: 'POST',
        body: {
          pageNumber: 1,
          pageSize: 300,
          sortingByList: [{ fieldName: 'name', direction: 'ASC', isNumber: false }],
          criteria: { name: null },
          deletedRecords: false
        }
      })
    ]);

    allCategories = Array.isArray(categoryRes?.body) ? categoryRes.body : [];
    allTags = Array.isArray(tagRes?.body) ? tagRes.body : [];
    allPublishers = Array.isArray(publisherRes?.body) ? publisherRes.body : [];
    allAuthors = BookApi.parsePaginationResult(authorRes).list;

    renderCheckboxList('category-filters', 'category', allCategories);
    renderCheckboxList('tag-filters', 'tag', allTags);
    renderSelectOptions('publisher-filter', allPublishers, t('common.noData'));
    renderAuthorPicker();
    applyQueryDefaults(allAuthors, allCategories);
    BookUi.refreshScrollShells(document);
    updateSearchModeHint();
  } catch (error) {
    BookUi.showMessage('books-message', 'warning', getBooksLabels().filterBootstrapFailed(error.message));
  }

  document.getElementById('author-search').addEventListener('input', () => {
    renderAuthorPicker();
    updateSearchModeHint();
  });

  document.getElementById('author-filter').addEventListener('change', event => {
    if (event.target.matches('input[name="author"]')) {
      renderAuthorPicker();
      updateSearchModeHint();
    }
  });

  document.getElementById('keyword').addEventListener('input', updateSearchModeHint);
  document.getElementById('publisher-filter').addEventListener('change', updateSearchModeHint);
  document.getElementById('sortField').addEventListener('change', updateSearchModeHint);
  document.getElementById('sortDirection').addEventListener('change', updateSearchModeHint);
  [
    'fromPrice',
    'toPrice',
    'fromPagesNumber',
    'toPagesNumber',
    'fromReadingDuration',
    'toReadingDuration',
    'pageSize'
  ].forEach(id => {
    document.getElementById(id).addEventListener('input', updateSearchModeHint);
  });

  document.getElementById('category-filters').addEventListener('change', updateSearchModeHint);
  document.getElementById('tag-filters').addEventListener('change', updateSearchModeHint);

  document.getElementById('filter-form').addEventListener('submit', event => {
    event.preventDefault();
    loadBooks(1);
  });

  document.getElementById('reset-search').addEventListener('click', () => {
    resetSearchForm();
    loadBooks(1);
  });

  document.getElementById('prev-page').addEventListener('click', () => {
    if (document.getElementById('prev-page').disabled) return;
    const page = Math.max(1, Number(document.getElementById('currentPage').value || 1) - 1);
    loadBooks(page);
  });

  document.getElementById('next-page').addEventListener('click', () => {
    if (document.getElementById('next-page').disabled) return;
    const page = Number(document.getElementById('currentPage').value || 1) + 1;
    loadBooks(page);
  });

  loadBooks(1);
});
