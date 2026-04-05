function escapeHtml(value) {
  return String(value ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
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
    : '<div class="muted">当前搜索条件下没有匹配的作者。</div>';

  const selectedAuthors = allAuthors.filter(author => selectedIds.has(String(author.id)));
  summary.innerHTML = selectedAuthors.length
    ? selectedAuthors.map(author => `<span class="tag">${escapeHtml(author.name)}</span>`).join('')
    : '<span class="muted">暂未选择作者。</span>';
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
      BookUi.showMessage('books-message', 'info', '已根据来源页面自动选中对应作者。');
    }
  }

  if (categoryId) {
    const categoryMap = new Map((categories || []).map(category => [String(category.id), category]));
    if (categoryMap.has(String(categoryId))) {
      setCheckboxSelection('category', [categoryId]);
      const category = categoryMap.get(String(categoryId));
      BookUi.showMessage('books-message', 'info', `已为你自动选中分类：${BookUi.localizeCategoryName(category.name)}`);
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
      reasons.push(`书名命中关键词“${keyword}”`);
    } else if (includesIgnoreCase(book.isbn, keyword)) {
      reasons.push(`ISBN 命中关键词“${keyword}”`);
    } else if (includesIgnoreCase(book.author?.name, keyword)) {
      reasons.push(`作者命中关键词“${keyword}”`);
    } else if (includesIgnoreCase(book.category?.name, keyword)) {
      reasons.push(`分类命中关键词“${keyword}”`);
    } else if (includesIgnoreCase(book.publisher?.name, keyword)) {
      reasons.push(`出版社命中关键词“${keyword}”`);
    } else if ((book.tags || []).some(tag => includesIgnoreCase(tag?.name, keyword))) {
      reasons.push(`标签命中关键词“${keyword}”`);
    }
  }

  if (criteria.categories && book.category?.id && criteria.categories.includes(book.category.id)) {
    reasons.push(`符合分类筛选：${BookUi.localizeCategoryName(book.category.name) || book.category.id}`);
  }
  if (criteria.authors && book.author?.id && criteria.authors.includes(book.author.id)) {
    reasons.push(`符合作者筛选：${book.author.name || book.author.id}`);
  }
  if (criteria.publishers && book.publisher?.id && criteria.publishers.includes(book.publisher.id)) {
    reasons.push(`符合出版社筛选：${book.publisher.name || book.publisher.id}`);
  }
  if (criteria.tags && Array.isArray(book.tags)) {
    const matchedTagNames = book.tags
      .filter(tag => tag?.id && criteria.tags.includes(tag.id))
      .map(tag => tag.name)
      .filter(Boolean);
    if (matchedTagNames.length) {
      reasons.push(`符合标签筛选：${matchedTagNames.join(', ')}`);
    }
  }

  const sortField = payload.sortingByList?.[0]?.fieldName || 'id';
  if (sortField === 'usersRateCount') {
    reasons.push(`当前按热度排序，评分人数 ${book.usersRateCount ?? 0}`);
  } else if (sortField === 'publishDate') {
    reasons.push(`当前按出版时间排序，出版日期 ${BookApi.toDisplayDate(book.publishDate)}`);
  } else if (sortField === 'rate') {
    reasons.push(`当前按评分排序，平均分 ${book.rate ?? '-'}`);
  }

  return reasons.length ? reasons.join('；') : '来自基础检索结果，可继续查看图书详情。';
}

async function loadBooks(pageNumber = 1) {
  const target = document.getElementById('book-results');
  target.innerHTML = '<div class="card muted">正在加载图书...</div>';
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
        sourceLabel: '图书检索',
        reason: buildSearchHitReason(book, payload),
        actionType: 'BOOK_DETAIL_CLICK',
        searchKeyword
      })).join('')
      : '<div class="card muted">当前筛选条件下没有匹配图书。</div>';

    document.getElementById('page-summary').textContent =
      `第 ${currentPage} / ${pagination.totalNumberOfPages || 1} 页，共 ${pagination.totalNumberOfElements} 本图书`;
    document.getElementById('currentPage').value = String(currentPage);
  } catch (error) {
    target.innerHTML = `<div class="card">图书加载失败：${escapeHtml(error.message)}</div>`;
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
    renderSelectOptions('publisher-filter', allPublishers, '暂无可选出版社');
    renderAuthorPicker();
    applyQueryDefaults(allAuthors, allCategories);
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
