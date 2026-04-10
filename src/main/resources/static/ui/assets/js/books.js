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

let allAuthors = [];
let allCategories = [];
let allPublishers = [];
let allTags = [];

function getCheckedValues(name) {
  return Array.from(document.querySelectorAll(`input[name="${name}"]:checked`))
    .map(input => Number(input.value))
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

function getSelectedValues(selectId) {
  return Array.from(document.getElementById(selectId).selectedOptions)
    .map(option => Number(option.value))
    .filter(value => Number.isFinite(value));
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

function buildSearchHitReason(book, payload) {
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

function formatRangeLabel(label, from, to, unit = '') {
  if (from === null && to === null) return null;
  if (from !== null && to !== null) {
    return `${label}${from}-${to}${unit}`;
  }
  if (from !== null) {
    return `${label}${from}${unit} 起`;
  }
  return `${label}${to}${unit} 以下`;
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
    return `${label}${normalizedFrom}${unit} 以上`;
  }
  return `${label}${normalizedTo}${unit} 以下`;
}

function renderActiveFilterSummary(payload, pagination) {
  const wrap = document.getElementById('active-filter-summary');
  if (!wrap) return;

  const criteria = payload.criteria || {};
  const segments = [];
  const keyword = String(criteria.name || '').trim();

  if (keyword) {
    segments.push({ label: '关键词', value: keyword });
  }

  const authorNames = findNamesByIds(allAuthors, criteria.authors, item => item.name);
  if (authorNames.length) {
    segments.push({ label: '作者', value: authorNames.join('、') });
  }

  const categoryNames = findNamesByIds(allCategories, criteria.categories, item => BookUi.localizeCategoryName(item.name));
  if (categoryNames.length) {
    segments.push({ label: '分类', value: categoryNames.join('、') });
  }

  const publisherNames = findNamesByIds(allPublishers, criteria.publishers, item => item.name);
  if (publisherNames.length) {
    segments.push({ label: '出版社', value: publisherNames.join('、') });
  }

  const tagNames = findNamesByIds(allTags, criteria.tags, item => item.name);
  if (tagNames.length) {
    segments.push({ label: '标签', value: tagNames.join('、') });
  }

  const priceRange = formatRangeLabel('价格 ', criteria.fromPrice, criteria.toPrice, ' 元');
  if (priceRange) segments.push({ label: '区间', value: priceRange });

  const pagesRange = formatRangeLabel('页数 ', criteria.fromPagesNumber, criteria.toPagesNumber, ' 页');
  if (pagesRange) segments.push({ label: '页数', value: pagesRange });

  const durationRange = formatRangeLabel('时长 ', criteria.fromReadingDuration, criteria.toReadingDuration, ' 分钟');
  if (durationRange) segments.push({ label: '时长', value: durationRange });

  const sortFieldOption = document.querySelector(`#sortField option[value="${payload.sortingByList?.[0]?.fieldName || 'id'}"]`);
  const sortDirectionOption = document.querySelector(`#sortDirection option[value="${payload.sortingByList?.[0]?.direction || 'ASC'}"]`);
  segments.push({
    label: '排序',
    value: `${sortFieldOption?.textContent || '图书编号'} · ${sortDirectionOption?.textContent || '升序'}`
  });

  segments.push({
    label: '结果',
    value: pagination ? `${pagination.totalNumberOfElements || 0} 本 / 第 ${pagination.pageNumber || 1} 页` : '等待检索'
  });

  if (!segments.length) {
    wrap.classList.add('hidden');
    wrap.innerHTML = '';
    return;
  }

  wrap.classList.remove('hidden');
  wrap.innerHTML = segments.map(item => `
    <span class="books-active-label">
      <strong>${escapeHtml(item.label)}</strong>${escapeHtml(item.value)}
    </span>
  `).join('');
}

async function loadBooks(pageNumber = 1) {
  const target = document.getElementById('book-results');
  target.innerHTML = `<div class="card muted">${escapeHtml(t('books.loading'))}</div>`;
  const payload = buildBookFilterPayload(pageNumber);

  try {
    const response = await BookApi.apiRequest('/api/book/find-all-paginated-filtered', {
      method: 'POST',
      body: payload
    });
    const pagination = BookApi.parsePaginationResult(response);
    const currentPage = Math.max(1, Number(pagination.pageNumber || pageNumber));
    const searchKeyword = payload.criteria?.name || '';

    target.innerHTML = pagination.list.length
      ? pagination.list.map(book => BookUi.renderBookCard(book, {
        source: 'search:books-page',
        sourceLabel: t('books.sourceLabel'),
        reason: buildSearchHitReason(book, payload),
        actionType: 'BOOK_DETAIL_CLICK',
        searchKeyword
      })).join('')
      : `<div class="card muted">${escapeHtml(t('books.emptyResults'))}</div>`;
    BookUi.refreshSaveButtons(target);

    document.getElementById('page-summary').textContent =
      t('books.pageSummary', {
        page: currentPage,
        totalPages: pagination.totalNumberOfPages || 1,
        totalElements: pagination.totalNumberOfElements
      });
    document.getElementById('currentPage').value = String(currentPage);
    renderActiveFilterSummary(payload, pagination);
  } catch (error) {
    const summary = document.getElementById('active-filter-summary');
    if (summary) {
      summary.classList.add('hidden');
      summary.innerHTML = '';
    }
    target.innerHTML = `<div class="card">${escapeHtml(t('books.loadFailed', { message: error.message }))}</div>`;
  }
}

function resetSearchForm() {
  document.getElementById('filter-form').reset();
  document.querySelectorAll('#category-filters input[type="checkbox"], #tag-filters input[type="checkbox"], #author-filter input[type="checkbox"]').forEach(input => {
    input.checked = false;
  });
  ['publisher-filter'].forEach(selectId => {
    Array.from(document.getElementById(selectId).options).forEach(option => {
      option.selected = false;
    });
  });
  document.getElementById('author-search').value = '';
  renderAuthorPicker();
  document.getElementById('pageSize').value = '8';
  document.getElementById('sortField').value = 'id';
  document.getElementById('sortDirection').value = 'ASC';
}

document.addEventListener('DOMContentLoaded', async () => {
  if (!BookUi.requireLogin()) return;
  BookUi.injectLayout();
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
  } catch (error) {
    BookUi.showMessage('books-message', 'warning', `筛选条件加载失败：${error.message}`);
  }

  document.getElementById('author-search').addEventListener('input', () => {
    renderAuthorPicker();
  });

  document.getElementById('author-filter').addEventListener('change', event => {
    if (event.target.matches('input[name="author"]')) {
      renderAuthorPicker();
    }
  });

  document.getElementById('filter-form').addEventListener('submit', event => {
    event.preventDefault();
    loadBooks(1);
  });

  document.getElementById('reset-search').addEventListener('click', () => {
    resetSearchForm();
    loadBooks(1);
  });

  document.getElementById('prev-page').addEventListener('click', () => {
    const page = Math.max(1, Number(document.getElementById('currentPage').value || 1) - 1);
    loadBooks(page);
  });

  document.getElementById('next-page').addEventListener('click', () => {
    const page = Number(document.getElementById('currentPage').value || 1) + 1;
    loadBooks(page);
  });

  loadBooks(1);
});
