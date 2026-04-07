function buildBookAdminPayload(pageNumber = 1) {
  return {
    pageNumber,
    pageSize: 200,
    sortingByList: [{ fieldName: 'id', direction: 'ASC', isNumber: true }],
    criteria: null,
    deletedRecords: false
  };
}

function buildAuthorAdminPayload(pageNumber = 1) {
  return {
    pageNumber,
    pageSize: 200,
    sortingByList: [{ fieldName: 'id', direction: 'ASC', isNumber: true }],
    criteria: { name: null },
    deletedRecords: false
  };
}

function toDateInput(value) {
  if (!value) return '';
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return '';
  return date.toISOString().slice(0, 10);
}

function escapeHtml(value) {
  return String(value ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

function isChinese() {
  return window.BookI18n?.isChinese ? window.BookI18n.isChinese() : true;
}

function adminText(zh, en) {
  return isChinese() ? zh : en;
}

function truncateText(value, length = 160) {
  const text = String(value || '');
  return text.length > length ? `${text.slice(0, length)}...` : text;
}

function getSelectedIds(select) {
  return Array.from(select.selectedOptions)
    .map(option => Number(option.value))
    .filter(value => Number.isFinite(value) && value > 0);
}

function setSelectedIds(select, ids) {
  const selected = new Set((ids || []).map(value => String(value)));
  Array.from(select.options).forEach(option => {
    option.selected = selected.has(option.value);
  });
}

function filterItemsByQuery(items, query, selectedIds = []) {
  const normalizedQuery = String(query || '').trim().toLowerCase();
  const selected = new Set((selectedIds || []).map(value => String(value)));
  if (!normalizedQuery) return items;
  return items.filter(item => selected.has(String(item.id)) || String(item.name || '').toLowerCase().includes(normalizedQuery));
}

function formatDateTime(value) {
  if (!value) return '-';
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return String(value);
  return date.toLocaleString(window.BookI18n.getLocale());
}

function formatUserName(user) {
  const fullName = `${user?.firstName || ''} ${user?.lastName || ''}`.trim();
  return fullName || user?.email || adminText('未知用户', 'Unknown user');
}

function formatGender(gender) {
  if (gender === 'MALE') return adminText('男', 'Male');
  if (gender === 'FEMALE') return adminText('女', 'Female');
  if (gender === 'OTHERS') return adminText('其他', 'Other');
  return adminText('未知性别', 'Unknown gender');
}

function formatReservationStatus(status) {
  if (status === 'FULFILLED') return adminText('已完成', 'Fulfilled');
  if (status === 'CANCELLED') return adminText('已取消', 'Cancelled');
  return adminText('预约中', 'Reserving');
}

function renderAdminLoanItem(loan) {
  const book = loan.book || {};
  const userName = formatUserName(loan.user);
  const statusClass = loan.status === 'RETURNED' ? 'returned' : 'active';
  const statusLabel = loan.status === 'RETURNED'
    ? adminText('已归还', 'Returned')
    : adminText('借阅中', 'Borrowing');
  return `
    <article class="loan-card">
      <div class="loan-cover">${BookUi.renderBookImage(book)}</div>
      <div class="loan-body">
        <div class="loan-head">
          <div>
            <h3>${escapeHtml(book.name || adminText('未命名图书', 'Untitled book'))}</h3>
            <div class="muted">${escapeHtml(book.author?.name || adminText('未知作者', 'Unknown author'))} | ${escapeHtml(userName)}</div>
          </div>
          <span class="loan-status ${statusClass}">${statusLabel}</span>
        </div>
        <div class="loan-meta">
          <span class="tag">${escapeHtml(adminText('借阅编号', 'Loan ID'))} #${escapeHtml(loan.id ?? '-')}</span>
          <span class="tag">${escapeHtml(adminText('用户编号', 'User ID'))} #${escapeHtml(loan.user?.id ?? '-')}</span>
          <span class="tag">${escapeHtml(adminText('借出时间：', 'Borrowed at: '))}${escapeHtml(formatDateTime(loan.borrowedAt))}</span>
          <span class="tag">${escapeHtml(adminText('应还时间：', 'Due at: '))}${escapeHtml(formatDateTime(loan.dueDate))}</span>
          <span class="tag">${escapeHtml(adminText('续借次数：', 'Renew count: '))}${escapeHtml(loan.renewCount ?? 0)}</span>
        </div>
        ${loan.returnedAt ? `<div class="muted">${escapeHtml(adminText('归还时间：', 'Returned at: '))}${escapeHtml(formatDateTime(loan.returnedAt))}</div>` : ''}
      </div>
    </article>`;
}

function renderAdminReservationItem(reservation) {
  const book = reservation.book || {};
  const userName = formatUserName(reservation.user);
  const statusClass = reservation.status === 'FULFILLED'
    ? 'returned'
    : (reservation.status === 'CANCELLED' ? 'overdue' : 'pending');
  return `
    <article class="loan-card">
      <div class="loan-cover">${BookUi.renderBookImage(book)}</div>
      <div class="loan-body">
        <div class="loan-head">
          <div>
            <h3>${escapeHtml(book.name || adminText('未命名图书', 'Untitled book'))}</h3>
            <div class="muted">${escapeHtml(book.author?.name || adminText('未知作者', 'Unknown author'))} | ${escapeHtml(userName)}</div>
          </div>
          <span class="loan-status ${statusClass}">${escapeHtml(formatReservationStatus(reservation.status))}</span>
        </div>
        <div class="loan-meta">
          <span class="tag">${escapeHtml(adminText('预约编号', 'Reservation ID'))} #${escapeHtml(reservation.id ?? '-')}</span>
          <span class="tag">${escapeHtml(adminText('用户编号', 'User ID'))} #${escapeHtml(reservation.user?.id ?? '-')}</span>
          <span class="tag">${escapeHtml(adminText('预约时间：', 'Requested at: '))}${escapeHtml(formatDateTime(reservation.requestedAt))}</span>
          <span class="tag">${escapeHtml(adminText('可借库存：', 'Copies: '))}${escapeHtml(`${book.availableCopies ?? 0}/${book.totalCopies ?? 0}`)}</span>
        </div>
        ${reservation.fulfilledAt ? `<div class="muted">${escapeHtml(adminText('完成时间：', 'Fulfilled at: '))}${escapeHtml(formatDateTime(reservation.fulfilledAt))}</div>` : ''}
        ${reservation.cancelledAt ? `<div class="muted">${escapeHtml(adminText('取消时间：', 'Cancelled at: '))}${escapeHtml(formatDateTime(reservation.cancelledAt))}</div>` : ''}
      </div>
    </article>`;
}

function formatBehaviorAction(actionType) {
  switch (actionType) {
    case 'SEARCH':
      return adminText('搜索', 'Search');
    case 'BOOK_DETAIL_CLICK':
      return adminText('详情点击', 'Detail Click');
    case 'RECOMMENDATION_CLICK':
      return adminText('推荐点击', 'Recommendation Click');
    case 'RATE_BOOK':
      return adminText('评分', 'Rate Book');
    case 'BORROW_BOOK':
      return adminText('借阅', 'Borrow Book');
    default:
      return actionType || adminText('未知动作', 'Unknown');
  }
}

function renderKeywordStatItem(item, index) {
  return `
    <article class="admin-item">
      <div class="compact-item-title">
        <div>
          <span class="compact-rank">${index + 1}</span>
          <strong>${escapeHtml(item.keyword || adminText('未命名关键词', 'Unnamed keyword'))}</strong>
        </div>
        <span class="tag">${escapeHtml(item.count ?? 0)} ${escapeHtml(adminText('次', 'hits'))}</span>
      </div>
    </article>`;
}

function renderBookStatItem(item, index, metricLabel) {
  return `
    <article class="admin-item">
      <div class="compact-item-title">
        <div>
          <span class="compact-rank">${index + 1}</span>
          <strong>${escapeHtml(item.bookName || adminText('未命名图书', 'Untitled book'))}</strong>
        </div>
        <span class="tag">${escapeHtml(item.count ?? 0)} ${escapeHtml(metricLabel)}</span>
      </div>
      <div class="muted">#${escapeHtml(item.bookId ?? '-')}</div>
    </article>`;
}

function renderNamedCountItem(item, index) {
  return `
    <article class="admin-item">
      <div class="compact-item-title">
        <div>
          <span class="compact-rank">${index + 1}</span>
          <strong>${escapeHtml(item.name || adminText('未命名', 'Unnamed'))}</strong>
        </div>
        <span class="tag">${escapeHtml(item.count ?? 0)} ${escapeHtml(adminText('次', 'hits'))}</span>
      </div>
      <div class="muted">#${escapeHtml(item.id ?? '-')}</div>
    </article>`;
}

function renderRecommendationStrategy(strategy, recentDaysApplied) {
  if (!strategy) {
    return `<div class="muted">${escapeHtml(adminText('暂无推荐模型元数据。', 'No recommendation model metadata available.'))}</div>`;
  }
  const windowLabel = recentDaysApplied
    ? adminText(`最近 ${recentDaysApplied} 天`, `Last ${recentDaysApplied} days`)
    : adminText('全部记录行为', 'All recorded activity');
  return `
    <article class="admin-item">
      <div class="compact-item-title">
        <strong>${escapeHtml(adminText('行为驱动热度模型', 'Behavior-driven popularity model'))}</strong>
        <span class="tag">${escapeHtml(windowLabel)}</span>
      </div>
      <div class="strategy-line">
        <span class="tag">${escapeHtml(adminText('借阅', 'Borrows'))} x ${escapeHtml(strategy.borrowWeight ?? 0)}</span>
        <span class="tag">${escapeHtml(adminText('详情点击', 'Detail Clicks'))} x ${escapeHtml(strategy.detailClickWeight ?? 0)}</span>
        <span class="tag">${escapeHtml(adminText('评分', 'Ratings'))} x ${escapeHtml(strategy.ratingWeight ?? 0)}</span>
      </div>
      <div class="muted">${escapeHtml(strategy.formula || '')}</div>
      <div class="muted">${escapeHtml(strategy.fallbackRule || '')}</div>
    </article>`;
}

function buildSearchDetailLines(item) {
  const details = [];
  if (item.resultCount !== null && item.resultCount !== undefined) {
    details.push(`results=${item.resultCount}`);
  }
  if (item.categoryIds) details.push(`categories=${item.categoryIds}`);
  if (item.authorIds) details.push(`authors=${item.authorIds}`);
  if (item.publisherIds) details.push(`publishers=${item.publisherIds}`);
  if (item.tagIds) details.push(`tags=${item.tagIds}`);
  if (item.fromPrice !== null || item.toPrice !== null) {
    details.push(`price=${item.fromPrice ?? '-'}-${item.toPrice ?? '-'}`);
  }
  if (item.fromPagesNumber !== null || item.toPagesNumber !== null) {
    details.push(`pages=${item.fromPagesNumber ?? '-'}-${item.toPagesNumber ?? '-'}`);
  }
  if (item.fromReadingDuration !== null || item.toReadingDuration !== null) {
    details.push(`duration=${item.fromReadingDuration ?? '-'}-${item.toReadingDuration ?? '-'}`);
  }
  if (item.sortBy) details.push(`sort=${item.sortBy}`);
  if (item.pageNumber !== null && item.pageNumber !== undefined) details.push(`page=${item.pageNumber}`);
  if (item.pageSize !== null && item.pageSize !== undefined) details.push(`size=${item.pageSize}`);
  return details;
}

function renderSearchLogItem(item) {
  const detailLines = buildSearchDetailLines(item);
  return `
    <article class="admin-item">
      <div class="compact-item-title">
        <strong>${escapeHtml(item.keyword || 'browse-books')}</strong>
        <span class="tag">${escapeHtml(formatDateTime(item.createdDate))}</span>
      </div>
      <div class="muted">${escapeHtml(item.userEmail || adminText('匿名用户', 'Anonymous user'))}</div>
      ${detailLines.length ? `<div class="muted">${escapeHtml(detailLines.join(' | '))}</div>` : ''}
      <div class="muted">${escapeHtml(item.reason || adminText('没有额外说明。', 'No extra reason provided.'))}</div>
    </article>`;
}

function renderBehaviorLogItem(item) {
  return `
    <article class="admin-item">
      <div class="compact-item-title">
        <strong>${escapeHtml(formatBehaviorAction(item.actionType))}</strong>
        <span class="tag">${escapeHtml(formatDateTime(item.createdDate))}</span>
      </div>
      <div class="muted">${escapeHtml(item.userEmail || adminText('匿名用户', 'Anonymous user'))}</div>
      <div class="muted">${escapeHtml(item.bookName || item.keyword || adminText('没有关联图书或关键词', 'No linked book or keyword'))}</div>
      <div class="muted">${escapeHtml(item.reason || item.source || adminText('没有额外上下文', 'No extra context'))}</div>
    </article>`;
}

document.addEventListener('DOMContentLoaded', async () => {
  const t = window.BookI18n.t;
  if (!BookUi.requireLogin()) return;
  BookUi.injectLayout();

  try {
    const currentUser = await BookApi.fetchCurrentUser();
    if (!currentUser || currentUser.role !== 'ADMIN') {
      BookUi.showMessage('admin-message', 'error', t('admin.adminOnly'));
      setTimeout(() => {
        window.location.href = 'index.html';
      }, 800);
      return;
    }
  } catch (error) {
    BookUi.showMessage('admin-message', 'error', error.message);
    return;
  }

  if (!BookUi.requireAdmin()) return;

  let authors = [];
  let categories = [];
  let books = [];
  let publishers = [];
  let tags = [];

  const bookForm = document.getElementById('book-form');
  const authorForm = document.getElementById('author-form');
  const categoryForm = document.getElementById('category-form');
  const publisherForm = document.getElementById('publisher-form');
  const tagForm = document.getElementById('tag-form');

  const bookList = document.getElementById('book-admin-list');
  const authorList = document.getElementById('author-admin-list');
  const categoryList = document.getElementById('category-admin-list');
  const publisherList = document.getElementById('publisher-admin-list');
  const tagList = document.getElementById('tag-admin-list');
  const adminActiveLoans = document.getElementById('admin-active-loans');
  const adminLoanHistory = document.getElementById('admin-loan-history');
  const adminActiveReservations = document.getElementById('admin-active-reservations');
  const adminReservationHistory = document.getElementById('admin-reservation-history');
  const analyticsSummary = document.getElementById('admin-analytics-summary');
  const recommendationStrategyList = document.getElementById('admin-recommendation-strategy');
  const topKeywordsList = document.getElementById('admin-top-keywords');
  const topCategoriesList = document.getElementById('admin-top-categories');
  const topAuthorsList = document.getElementById('admin-top-authors');
  const topTagsList = document.getElementById('admin-top-tags');
  const topPublishersList = document.getElementById('admin-top-publishers');
  const topClickedBooksList = document.getElementById('admin-top-clicked-books');
  const topBorrowedBooksList = document.getElementById('admin-top-borrowed-books');
  const recentSearchesList = document.getElementById('admin-recent-searches');
  const recentBehaviorList = document.getElementById('admin-recent-behavior');
  const analyticsWindowSelect = document.getElementById('analytics-window');
  const totalCopiesInput = document.getElementById('book-total-copies');
  const availableCopiesInput = document.getElementById('book-available-copies');
  const authorSelect = document.getElementById('book-author');
  const categorySelect = document.getElementById('book-category');
  const publisherSelect = document.getElementById('book-publisher');
  const tagSelect = document.getElementById('book-tags');
  const authorSearchInput = document.getElementById('book-author-search');
  const categorySearchInput = document.getElementById('book-category-search');
  const publisherSearchInput = document.getElementById('book-publisher-search');
  const tagSearchInput = document.getElementById('book-tag-search');
  const tagSummary = document.getElementById('book-tag-summary');
  const bookListSearchInput = document.getElementById('book-list-search');
  const authorListSearchInput = document.getElementById('author-list-search');
  const categoryListSearchInput = document.getElementById('category-list-search');
  const publisherListSearchInput = document.getElementById('publisher-list-search');
  const tagListSearchInput = document.getElementById('tag-list-search');

  function syncAvailableCopiesPreview() {
    const totalCopies = Math.max(1, Number(totalCopiesInput.value || 1));
    const borrowedCount = Number(totalCopiesInput.dataset.borrowedCount || 0);
    availableCopiesInput.value = String(Math.max(0, totalCopies - borrowedCount));
  }

  function renderAuthorOptions() {
    const selectedId = authorSelect.value;
    const filteredAuthors = filterItemsByQuery(authors, authorSearchInput.value, selectedId ? [selectedId] : []);
    authorSelect.innerHTML = filteredAuthors.map(author => (
      `<option value="${author.id}">${escapeHtml(author.name)}</option>`
    )).join('');
    if (selectedId && filteredAuthors.some(author => String(author.id) === String(selectedId))) {
      authorSelect.value = String(selectedId);
    } else if (filteredAuthors.length) {
      authorSelect.value = String(filteredAuthors[0].id);
    }
  }

  function renderCategoryOptions() {
    const selectedId = categorySelect.value;
    const filteredCategories = filterItemsByQuery(categories, categorySearchInput.value, selectedId ? [selectedId] : []);
    categorySelect.innerHTML = filteredCategories.map(category => (
      `<option value="${category.id}">${escapeHtml(BookUi.localizeCategoryName(category.name))}</option>`
    )).join('');
    if (selectedId && filteredCategories.some(category => String(category.id) === String(selectedId))) {
      categorySelect.value = String(selectedId);
    } else if (filteredCategories.length) {
      categorySelect.value = String(filteredCategories[0].id);
    }
  }

  function renderPublisherOptions() {
    const selectedId = publisherSelect.value;
    const filteredPublishers = filterItemsByQuery(publishers, publisherSearchInput.value, selectedId ? [selectedId] : []);
    const options = filteredPublishers.map(publisher => (
      `<option value="${publisher.id}">${escapeHtml(publisher.name)}</option>`
    )).join('');
    publisherSelect.innerHTML = `<option value="">${escapeHtml(adminText('无出版社', 'No publisher'))}</option>${options}`;
    publisherSelect.value = selectedId || '';
  }

  function renderTagOptions() {
    const selectedIds = getSelectedIds(tagSelect);
    const filteredTags = filterItemsByQuery(tags, tagSearchInput.value, selectedIds);
    tagSelect.innerHTML = filteredTags.map(tag => (
      `<option value="${tag.id}">${escapeHtml(tag.name)}</option>`
    )).join('');
    setSelectedIds(tagSelect, selectedIds);
    const selectedTags = tags.filter(tag => selectedIds.includes(tag.id));
    tagSummary.innerHTML = selectedTags.length
      ? selectedTags.map(tag => `<span class="tag">${escapeHtml(tag.name)}</span>`).join('')
      : `<span class="muted">${escapeHtml(adminText('暂未选择标签。', 'No tags selected yet.'))}</span>`;
  }

  function resetBookForm() {
    bookForm.reset();
    document.getElementById('book-id').value = '';
    authorSearchInput.value = '';
    categorySearchInput.value = '';
    publisherSearchInput.value = '';
    tagSearchInput.value = '';
    if (authors.length) authorSelect.value = String(authors[0].id);
    if (categories.length) categorySelect.value = String(categories[0].id);
    publisherSelect.value = '';
    setSelectedIds(tagSelect, []);
    document.getElementById('book-rate').value = '0';
    document.getElementById('book-users-rate-count').value = '0';
    document.getElementById('book-total-copies').value = '1';
    document.getElementById('book-available-copies').value = '1';
    totalCopiesInput.dataset.borrowedCount = '0';
    renderAuthorOptions();
    renderCategoryOptions();
    renderPublisherOptions();
    renderTagOptions();
  }

  function resetAuthorForm() {
    authorForm.reset();
    document.getElementById('author-id').value = '';
    document.getElementById('author-gender').value = 'MALE';
  }

  function resetCategoryForm() {
    categoryForm.reset();
    document.getElementById('category-id').value = '';
  }

  function resetPublisherForm() {
    publisherForm.reset();
    document.getElementById('publisher-id').value = '';
  }

  function resetTagForm() {
    tagForm.reset();
    document.getElementById('tag-id').value = '';
  }

  function editBook(id) {
    const book = books.find(item => String(item.id) === String(id));
    if (!book) return;
    document.getElementById('book-id').value = book.id;
    document.getElementById('book-name').value = book.name || '';
    document.getElementById('book-isbn').value = book.isbn || '';
    authorSearchInput.value = '';
    categorySearchInput.value = '';
    publisherSearchInput.value = '';
    tagSearchInput.value = '';
    renderAuthorOptions();
    renderCategoryOptions();
    renderPublisherOptions();
    renderTagOptions();
    authorSelect.value = book.author?.id ? String(book.author.id) : '';
    categorySelect.value = book.category?.id ? String(book.category.id) : '';
    publisherSelect.value = book.publisher?.id ? String(book.publisher.id) : '';
    setSelectedIds(tagSelect, (book.tags || []).map(tag => tag.id));
    renderTagOptions();
    document.getElementById('book-price').value = book.price ?? 0;
    document.getElementById('book-rate').value = book.rate ?? 0;
    document.getElementById('book-users-rate-count').value = book.usersRateCount ?? 0;
    document.getElementById('book-pages').value = book.pagesNumber ?? '';
    document.getElementById('book-duration').value = book.readingDuration ?? '';
    document.getElementById('book-publish-date').value = toDateInput(book.publishDate);
    document.getElementById('book-image-url').value = book.imageUrl || '';
    document.getElementById('book-total-copies').value = book.totalCopies ?? 1;
    document.getElementById('book-available-copies').value = book.availableCopies ?? 0;
    totalCopiesInput.dataset.borrowedCount = String(Math.max(0, Number(book.totalCopies ?? 0) - Number(book.availableCopies ?? 0)));
    document.getElementById('book-description').value = book.description || '';
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  function editAuthor(id) {
    const author = authors.find(item => String(item.id) === String(id));
    if (!author) return;
    document.getElementById('author-id').value = author.id;
    document.getElementById('author-name').value = author.name || '';
    document.getElementById('author-country').value = author.country || '';
    document.getElementById('author-birthdate').value = toDateInput(author.birthdate);
    document.getElementById('author-deathdate').value = toDateInput(author.deathdate);
    document.getElementById('author-age').value = author.age ?? '';
    document.getElementById('author-gender').value = author.gender || 'MALE';
    document.getElementById('author-image-url').value = author.imageUrl || '';
    document.getElementById('author-description').value = author.description || '';
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  function editCategory(id) {
    const category = categories.find(item => String(item.id) === String(id));
    if (!category) return;
    document.getElementById('category-id').value = category.id;
    document.getElementById('category-name').value = category.name || '';
    document.getElementById('category-description').value = category.description || '';
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  function editPublisher(id) {
    const publisher = publishers.find(item => String(item.id) === String(id));
    if (!publisher) return;
    document.getElementById('publisher-id').value = publisher.id;
    document.getElementById('publisher-name').value = publisher.name || '';
    document.getElementById('publisher-country').value = publisher.country || '';
    document.getElementById('publisher-website').value = publisher.websiteUrl || '';
    document.getElementById('publisher-description').value = publisher.description || '';
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  function editTag(id) {
    const tag = tags.find(item => String(item.id) === String(id));
    if (!tag) return;
    document.getElementById('tag-id').value = tag.id;
    document.getElementById('tag-name').value = tag.name || '';
    document.getElementById('tag-description').value = tag.description || '';
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  async function removeBook(id) {
    if (!window.confirm(adminText(`确认软删除图书 #${id} 吗？`, `Soft-delete book #${id}?`))) return;
    await BookApi.apiRequest(`/api/book/${id}`, { method: 'DELETE' });
    await loadBooks();
  }

  async function removeAuthor(id) {
    if (!window.confirm(adminText(`确认软删除作者 #${id} 吗？`, `Soft-delete author #${id}?`))) return;
    await BookApi.apiRequest(`/api/author/${id}`, { method: 'DELETE' });
    await loadAuthors();
  }

  async function removeCategory(id) {
    if (!window.confirm(adminText(`确认软删除分类 #${id} 吗？`, `Soft-delete category #${id}?`))) return;
    await BookApi.apiRequest(`/api/category/${id}`, { method: 'DELETE' });
    await loadCategories();
  }

  async function removePublisher(id) {
    if (!window.confirm(adminText(`确认软删除出版社 #${id} 吗？`, `Soft-delete publisher #${id}?`))) return;
    await BookApi.apiRequest(`/api/publisher/${id}`, { method: 'DELETE' });
    await loadPublishers();
  }

  async function removeTag(id) {
    if (!window.confirm(adminText(`确认软删除标签 #${id} 吗？`, `Soft-delete tag #${id}?`))) return;
    await BookApi.apiRequest(`/api/tag/${id}`, { method: 'DELETE' });
    await loadTags();
  }

  function renderBookList() {
    const query = String(bookListSearchInput.value || '').trim().toLowerCase();
    const filteredBooks = books.filter(book => {
      if (!query) return true;
      const haystack = [
        book.name,
        book.author?.name,
        book.category?.name,
        book.publisher?.name
      ].filter(Boolean).join(' ').toLowerCase();
      return haystack.includes(query);
    });

    bookList.innerHTML = filteredBooks.length
      ? filteredBooks.map(book => {
        const publisherLabel = book.publisher?.name || adminText('无出版社', 'No publisher');
        const tagLabels = (book.tags || []).map(tag => `<span class="tag">${escapeHtml(tag.name)}</span>`).join('');
        return `
          <article class="admin-item">
            <div class="admin-item-head">
              <div>
                <h3>${escapeHtml(book.name)}</h3>
                <div class="muted">#${book.id} | ${escapeHtml(book.author?.name || adminText('未知作者', 'Unknown author'))} | ${escapeHtml(BookUi.localizeCategoryName(book.category?.name))}</div>
              </div>
              <div class="admin-actions">
                <button type="button" data-edit-book="${book.id}">${escapeHtml(adminText('编辑', 'Edit'))}</button>
                <button type="button" class="danger" data-delete-book="${book.id}">${escapeHtml(adminText('删除', 'Delete'))}</button>
              </div>
            </div>
            <div class="admin-meta">
              <span class="tag">${escapeHtml(adminText('ISBN：', 'ISBN: '))}${escapeHtml(book.isbn || adminText('暂无 ISBN', 'No ISBN'))}</span>
              <span class="tag">${escapeHtml(adminText('出版社：', 'Publisher: '))}${escapeHtml(publisherLabel)}</span>
              <span class="tag">${escapeHtml(adminText('价格：', 'Price: '))}${escapeHtml(book.price ?? '-')}</span>
              <span class="tag">${escapeHtml(adminText('评分：', 'Rating: '))}${escapeHtml(book.rate ?? '-')}</span>
              <span class="tag">${escapeHtml(adminText('页数：', 'Pages: '))}${escapeHtml(book.pagesNumber ?? '-')}</span>
              <span class="tag">${escapeHtml(adminText('可借库存：', 'Available copies: '))}${escapeHtml(book.availableCopies ?? '-')} / ${escapeHtml(book.totalCopies ?? '-')}</span>
            </div>
            <div class="tags">${tagLabels || `<span class="muted">${escapeHtml(adminText('暂无标签。', 'No tags.'))}</span>`}</div>
            <div class="muted">${escapeHtml(truncateText(book.description, 180))}</div>
          </article>`;
      }).join('')
      : `<div class="muted">${escapeHtml(adminText('当前搜索条件下没有匹配图书。', 'No books match the current search.'))}</div>`;

    bookList.querySelectorAll('[data-edit-book]').forEach(button => {
      button.addEventListener('click', () => editBook(button.dataset.editBook));
    });
    bookList.querySelectorAll('[data-delete-book]').forEach(button => {
      button.addEventListener('click', async () => {
        try {
          await removeBook(button.dataset.deleteBook);
          BookUi.showMessage('admin-message', 'success', adminText('图书删除成功。', 'Book deleted successfully.'));
        } catch (error) {
          BookUi.showMessage('admin-message', 'error', error.message);
        }
      });
    });
  }

  function renderAuthorList() {
    const query = String(authorListSearchInput.value || '').trim().toLowerCase();
    const filteredAuthors = authors.filter(author => {
      if (!query) return true;
      const haystack = [
        author.name,
        author.country,
        author.description
      ].filter(Boolean).join(' ').toLowerCase();
      return haystack.includes(query);
    });

    authorList.innerHTML = filteredAuthors.length
      ? filteredAuthors.map(author => `
        <article class="admin-item">
          <div class="admin-item-head">
            <div>
              <h3>${escapeHtml(author.name)}</h3>
              <div class="muted">#${author.id} | ${escapeHtml(author.country || adminText('未知国家', 'Unknown country'))} | ${escapeHtml(formatGender(author.gender))}</div>
            </div>
            <div class="admin-actions">
              <button type="button" data-edit-author="${author.id}">${escapeHtml(adminText('编辑', 'Edit'))}</button>
              <button type="button" class="danger" data-delete-author="${author.id}">${escapeHtml(adminText('删除', 'Delete'))}</button>
            </div>
          </div>
          <div class="muted">${escapeHtml(truncateText(author.description))}</div>
        </article>`).join('')
      : `<div class="muted">${escapeHtml(adminText('当前搜索条件下没有匹配作者。', 'No authors match the current search.'))}</div>`;

    authorList.querySelectorAll('[data-edit-author]').forEach(button => {
      button.addEventListener('click', () => editAuthor(button.dataset.editAuthor));
    });
    authorList.querySelectorAll('[data-delete-author]').forEach(button => {
      button.addEventListener('click', async () => {
        try {
          await removeAuthor(button.dataset.deleteAuthor);
          renderAuthorOptions();
          resetAuthorForm();
          resetBookForm();
          BookUi.showMessage('admin-message', 'success', adminText('作者删除成功。', 'Author deleted successfully.'));
        } catch (error) {
          BookUi.showMessage('admin-message', 'error', error.message);
        }
      });
    });
  }

  function renderCategoryList() {
    const query = String(categoryListSearchInput.value || '').trim().toLowerCase();
    const filteredCategories = categories.filter(category => {
      if (!query) return true;
      const haystack = [
        category.name,
        category.description
      ].filter(Boolean).join(' ').toLowerCase();
      return haystack.includes(query);
    });

    categoryList.innerHTML = filteredCategories.length
      ? filteredCategories.map(category => `
        <article class="admin-item">
          <div class="admin-item-head">
            <div>
              <h3>${escapeHtml(BookUi.localizeCategoryName(category.name))}</h3>
              <div class="muted">#${category.id}</div>
            </div>
            <div class="admin-actions">
              <button type="button" data-edit-category="${category.id}">${escapeHtml(adminText('编辑', 'Edit'))}</button>
              <button type="button" class="danger" data-delete-category="${category.id}">${escapeHtml(adminText('删除', 'Delete'))}</button>
            </div>
          </div>
          <div class="muted">${escapeHtml(truncateText(category.description || adminText('暂无说明。', 'No description yet.')))}</div>
        </article>`).join('')
      : `<div class="muted">${escapeHtml(adminText('当前搜索条件下没有匹配分类。', 'No categories match the current search.'))}</div>`;

    categoryList.querySelectorAll('[data-edit-category]').forEach(button => {
      button.addEventListener('click', () => editCategory(button.dataset.editCategory));
    });
    categoryList.querySelectorAll('[data-delete-category]').forEach(button => {
      button.addEventListener('click', async () => {
        try {
          await removeCategory(button.dataset.deleteCategory);
          renderCategoryOptions();
          resetCategoryForm();
          resetBookForm();
          BookUi.showMessage('admin-message', 'success', adminText('分类删除成功。', 'Category deleted successfully.'));
        } catch (error) {
          BookUi.showMessage('admin-message', 'error', error.message);
        }
      });
    });
  }

  function renderPublisherList() {
    const query = String(publisherListSearchInput.value || '').trim().toLowerCase();
    const filteredPublishers = publishers.filter(publisher => {
      if (!query) return true;
      const haystack = [
        publisher.name,
        publisher.country,
        publisher.description,
        publisher.websiteUrl
      ].filter(Boolean).join(' ').toLowerCase();
      return haystack.includes(query);
    });

    publisherList.innerHTML = filteredPublishers.length
      ? filteredPublishers.map(publisher => `
        <article class="admin-item">
          <div class="admin-item-head">
            <div>
              <h3>${escapeHtml(publisher.name)}</h3>
              <div class="muted">#${publisher.id} | ${escapeHtml(publisher.country || adminText('未知国家', 'Unknown country'))}</div>
            </div>
            <div class="admin-actions">
              <button type="button" data-edit-publisher="${publisher.id}">${escapeHtml(adminText('编辑', 'Edit'))}</button>
              <button type="button" class="danger" data-delete-publisher="${publisher.id}">${escapeHtml(adminText('删除', 'Delete'))}</button>
            </div>
          </div>
          <div class="muted">${escapeHtml(truncateText(publisher.description || publisher.websiteUrl || adminText('暂无说明。', 'No description yet.')))}</div>
        </article>`).join('')
      : `<div class="muted">${escapeHtml(adminText('当前搜索条件下没有匹配出版社。', 'No publishers match the current search.'))}</div>`;

    publisherList.querySelectorAll('[data-edit-publisher]').forEach(button => {
      button.addEventListener('click', () => editPublisher(button.dataset.editPublisher));
    });
    publisherList.querySelectorAll('[data-delete-publisher]').forEach(button => {
      button.addEventListener('click', async () => {
        try {
          await removePublisher(button.dataset.deletePublisher);
          renderPublisherOptions();
          resetPublisherForm();
          resetBookForm();
          BookUi.showMessage('admin-message', 'success', adminText('出版社删除成功。', 'Publisher deleted successfully.'));
        } catch (error) {
          BookUi.showMessage('admin-message', 'error', error.message);
        }
      });
    });
  }

  function renderTagList() {
    const query = String(tagListSearchInput.value || '').trim().toLowerCase();
    const filteredTags = tags.filter(tag => {
      if (!query) return true;
      const haystack = [
        tag.name,
        tag.description
      ].filter(Boolean).join(' ').toLowerCase();
      return haystack.includes(query);
    });

    tagList.innerHTML = filteredTags.length
      ? filteredTags.map(tag => `
        <article class="admin-item">
          <div class="admin-item-head">
            <div>
              <h3>${escapeHtml(tag.name)}</h3>
              <div class="muted">#${tag.id}</div>
            </div>
            <div class="admin-actions">
              <button type="button" data-edit-tag="${tag.id}">${escapeHtml(adminText('编辑', 'Edit'))}</button>
              <button type="button" class="danger" data-delete-tag="${tag.id}">${escapeHtml(adminText('删除', 'Delete'))}</button>
            </div>
          </div>
          <div class="muted">${escapeHtml(truncateText(tag.description || adminText('暂无说明。', 'No description yet.')))}</div>
        </article>`).join('')
      : `<div class="muted">${escapeHtml(adminText('当前搜索条件下没有匹配标签。', 'No tags match the current search.'))}</div>`;

    tagList.querySelectorAll('[data-edit-tag]').forEach(button => {
      button.addEventListener('click', () => editTag(button.dataset.editTag));
    });
    tagList.querySelectorAll('[data-delete-tag]').forEach(button => {
      button.addEventListener('click', async () => {
        try {
          await removeTag(button.dataset.deleteTag);
          renderTagOptions();
          resetTagForm();
          resetBookForm();
          BookUi.showMessage('admin-message', 'success', adminText('标签删除成功。', 'Tag deleted successfully.'));
        } catch (error) {
          BookUi.showMessage('admin-message', 'error', error.message);
        }
      });
    });
  }

  async function loadCategories() {
    const response = await BookApi.apiRequest('/api/category');
    categories = Array.isArray(response?.body) ? response.body : [];
    renderCategoryOptions();
    renderCategoryList();
  }

  async function loadAuthors() {
    const response = await BookApi.apiRequest('/api/author/find-all-paginated-filtered', {
      method: 'POST',
      body: buildAuthorAdminPayload()
    });
    authors = BookApi.parsePaginationResult(response).list;
    renderAuthorOptions();
    renderAuthorList();
    BookUi.refreshScrollShells(document);
  }

  async function loadBooks() {
    const response = await BookApi.apiRequest('/api/book/find-all-paginated-filtered', {
      method: 'POST',
      body: buildBookAdminPayload()
    });
    books = BookApi.parsePaginationResult(response).list;
    renderBookList();
    BookUi.refreshScrollShells(document);
  }

  async function loadPublishers() {
    const response = await BookApi.apiRequest('/api/publisher');
    publishers = Array.isArray(response?.body) ? response.body : [];
    renderPublisherOptions();
    renderPublisherList();
  }

  async function loadTags() {
    const response = await BookApi.apiRequest('/api/tag');
    tags = Array.isArray(response?.body) ? response.body : [];
    renderTagOptions();
    renderTagList();
    BookUi.refreshScrollShells(document);
  }

  async function loadCirculation() {
    adminActiveLoans.innerHTML = `<div class="muted">${escapeHtml(adminText('正在加载当前借阅...', 'Loading current loans...'))}</div>`;
    adminLoanHistory.innerHTML = `<div class="muted">${escapeHtml(adminText('正在加载借阅历史...', 'Loading loan history...'))}</div>`;
    adminActiveReservations.innerHTML = `<div class="muted">${escapeHtml(adminText('正在加载当前预约...', 'Loading current reservations...'))}</div>`;
    adminReservationHistory.innerHTML = `<div class="muted">${escapeHtml(adminText('正在加载预约历史...', 'Loading reservation history...'))}</div>`;

    const [activeLoanRes, loanHistoryRes, activeReservationRes, reservationHistoryRes] = await Promise.all([
      BookApi.apiRequest('/api/loan/admin/active'),
      BookApi.apiRequest('/api/loan/admin/history'),
      BookApi.apiRequest('/api/reservation/admin/active'),
      BookApi.apiRequest('/api/reservation/admin/history')
    ]);

    const activeLoans = Array.isArray(activeLoanRes?.body) ? activeLoanRes.body : [];
    const loanHistory = Array.isArray(loanHistoryRes?.body) ? loanHistoryRes.body : [];
    const activeReservations = Array.isArray(activeReservationRes?.body) ? activeReservationRes.body : [];
    const reservationHistory = Array.isArray(reservationHistoryRes?.body) ? reservationHistoryRes.body : [];

    adminActiveLoans.innerHTML = activeLoans.length
      ? activeLoans.map(loan => renderAdminLoanItem(loan)).join('')
      : `<div class="muted">${escapeHtml(adminText('暂无当前借阅记录。', 'No current loan records.'))}</div>`;
    adminLoanHistory.innerHTML = loanHistory.length
      ? loanHistory.map(loan => renderAdminLoanItem(loan)).join('')
      : `<div class="muted">${escapeHtml(adminText('暂无已归还借阅记录。', 'No returned loan records yet.'))}</div>`;
    adminActiveReservations.innerHTML = activeReservations.length
      ? activeReservations.map(reservation => renderAdminReservationItem(reservation)).join('')
      : `<div class="muted">${escapeHtml(adminText('暂无当前预约记录。', 'No current reservation records.'))}</div>`;
    adminReservationHistory.innerHTML = reservationHistory.length
      ? reservationHistory.map(reservation => renderAdminReservationItem(reservation)).join('')
      : `<div class="muted">${escapeHtml(adminText('暂无预约历史记录。', 'No reservation history records yet.'))}</div>`;
    BookUi.refreshScrollShells(document);
  }

  async function loadAnalytics() {
    analyticsSummary.innerHTML = `<div class="analytics-stat"><span class="muted">${escapeHtml(adminText('正在加载摘要...', 'Loading summary...'))}</span></div>`;
    recommendationStrategyList.innerHTML = `<div class="muted">${escapeHtml(adminText('正在加载推荐模型...', 'Loading recommendation model...'))}</div>`;
    topKeywordsList.innerHTML = `<div class="muted">${escapeHtml(adminText('正在加载热门关键词...', 'Loading top keywords...'))}</div>`;
    topCategoriesList.innerHTML = `<div class="muted">${escapeHtml(adminText('正在加载热门分类...', 'Loading top categories...'))}</div>`;
    topAuthorsList.innerHTML = `<div class="muted">${escapeHtml(adminText('正在加载热门作者...', 'Loading top authors...'))}</div>`;
    topTagsList.innerHTML = `<div class="muted">${escapeHtml(adminText('正在加载热门标签...', 'Loading top tags...'))}</div>`;
    topPublishersList.innerHTML = `<div class="muted">${escapeHtml(adminText('正在加载热门出版社...', 'Loading top publishers...'))}</div>`;
    topClickedBooksList.innerHTML = `<div class="muted">${escapeHtml(adminText('正在加载热门点击图书...', 'Loading clicked books...'))}</div>`;
    topBorrowedBooksList.innerHTML = `<div class="muted">${escapeHtml(adminText('正在加载热门借阅图书...', 'Loading borrowed books...'))}</div>`;
    recentSearchesList.innerHTML = `<div class="muted">${escapeHtml(adminText('正在加载最近搜索...', 'Loading recent searches...'))}</div>`;
    recentBehaviorList.innerHTML = `<div class="muted">${escapeHtml(adminText('正在加载最近行为...', 'Loading recent behavior...'))}</div>`;

    const selectedWindow = analyticsWindowSelect?.value ? Number(analyticsWindowSelect.value) : null;
    const query = selectedWindow ? `?limit=5&recentDays=${selectedWindow}` : '?limit=5';
    const response = await BookApi.apiRequest(`/api/behavior-log/dashboard${query}`);
    const dashboard = response?.body || {};
    const recentDaysApplied = dashboard.recentDaysApplied ?? selectedWindow;
    const windowLabel = recentDaysApplied
      ? adminText(`最近 ${recentDaysApplied} 天`, `last ${recentDaysApplied} days`)
      : adminText('全部记录行为', 'all recorded activity');

    const summaryCards = [
      {
        label: adminText('行为事件总数', 'Total Behavior Events'),
        value: dashboard.totalBehaviorEvents ?? 0,
        note: adminText('包含搜索、点击、评分与借阅等已跟踪行为', 'Across tracked search, click, rating, and borrowing actions')
      },
      {
        label: adminText('最近搜索次数', 'Recent Searches'),
        value: dashboard.recentSearchCount ?? 0,
        note: adminText(`${windowLabel}内记录的查询次数`, `Queries recorded in ${windowLabel}`)
      },
      {
        label: adminText('最近详情点击', 'Recent Detail Clicks'),
        value: dashboard.recentDetailClickCount ?? 0,
        note: adminText(`${windowLabel}内记录的详情访问`, `Book detail visits recorded in ${windowLabel}`)
      },
      {
        label: adminText('最近借阅次数', 'Recent Borrows'),
        value: dashboard.recentBorrowCount ?? 0,
        note: adminText(`${windowLabel}内记录的借阅行为`, `Borrowing activity recorded in ${windowLabel}`)
      }
    ];

    analyticsSummary.innerHTML = summaryCards.map(card => `
      <article class="analytics-stat">
        <span class="muted">${escapeHtml(card.label)}</span>
        <strong>${escapeHtml(card.value ?? 0)}</strong>
        <span class="muted">${escapeHtml(card.note)}</span>
      </article>
    `).join('');

    const topKeywords = Array.isArray(dashboard.topKeywords) ? dashboard.topKeywords : [];
    const topCategories = Array.isArray(dashboard.topCategories) ? dashboard.topCategories : [];
    const topAuthors = Array.isArray(dashboard.topAuthors) ? dashboard.topAuthors : [];
    const topTags = Array.isArray(dashboard.topTags) ? dashboard.topTags : [];
    const topPublishers = Array.isArray(dashboard.topPublishers) ? dashboard.topPublishers : [];
    const topClickedBooks = Array.isArray(dashboard.topClickedBooks) ? dashboard.topClickedBooks : [];
    const topBorrowedBooks = Array.isArray(dashboard.topBorrowedBooks) ? dashboard.topBorrowedBooks : [];
    const recentSearches = Array.isArray(dashboard.recentSearchLogs) ? dashboard.recentSearchLogs : [];
    const recentBehavior = Array.isArray(dashboard.recentBehaviorLogs) ? dashboard.recentBehaviorLogs : [];

    recommendationStrategyList.innerHTML = renderRecommendationStrategy(dashboard.recommendationStrategy, recentDaysApplied);
    topKeywordsList.innerHTML = topKeywords.length
      ? topKeywords.map((item, index) => renderKeywordStatItem(item, index)).join('')
      : `<div class="muted">${escapeHtml(adminText('暂无关键词行为记录。', 'No keyword activity has been recorded yet.'))}</div>`;
    topCategoriesList.innerHTML = topCategories.length
      ? topCategories.map((item, index) => renderNamedCountItem(item, index)).join('')
      : `<div class="muted">${escapeHtml(adminText('暂无分类搜索记录。', 'No category search activity has been recorded yet.'))}</div>`;
    topAuthorsList.innerHTML = topAuthors.length
      ? topAuthors.map((item, index) => renderNamedCountItem(item, index)).join('')
      : `<div class="muted">${escapeHtml(adminText('暂无作者搜索记录。', 'No author search activity has been recorded yet.'))}</div>`;
    topTagsList.innerHTML = topTags.length
      ? topTags.map((item, index) => renderNamedCountItem(item, index)).join('')
      : `<div class="muted">${escapeHtml(adminText('暂无标签搜索记录。', 'No tag search activity has been recorded yet.'))}</div>`;
    topPublishersList.innerHTML = topPublishers.length
      ? topPublishers.map((item, index) => renderNamedCountItem(item, index)).join('')
      : `<div class="muted">${escapeHtml(adminText('暂无出版社搜索记录。', 'No publisher search activity has been recorded yet.'))}</div>`;
    topClickedBooksList.innerHTML = topClickedBooks.length
      ? topClickedBooks.map((item, index) => renderBookStatItem(item, index, adminText('次点击', 'clicks'))).join('')
      : `<div class="muted">${escapeHtml(adminText('暂无详情点击记录。', 'No detail click activity has been recorded yet.'))}</div>`;
    topBorrowedBooksList.innerHTML = topBorrowedBooks.length
      ? topBorrowedBooks.map((item, index) => renderBookStatItem(item, index, adminText('次借阅', 'borrows'))).join('')
      : `<div class="muted">${escapeHtml(adminText('暂无借阅行为记录。', 'No borrowing activity has been recorded yet.'))}</div>`;
    recentSearchesList.innerHTML = recentSearches.length
      ? recentSearches.map(item => renderSearchLogItem(item)).join('')
      : `<div class="muted">${escapeHtml(adminText('暂无搜索日志。', 'No search logs have been recorded yet.'))}</div>`;
    recentBehaviorList.innerHTML = recentBehavior.length
      ? recentBehavior.map(item => renderBehaviorLogItem(item)).join('')
      : `<div class="muted">${escapeHtml(adminText('暂无行为日志。', 'No behavior logs have been recorded yet.'))}</div>`;
    BookUi.refreshScrollShells(document);
  }

  bookForm.addEventListener('submit', async event => {
    event.preventDefault();
    const bookId = document.getElementById('book-id').value;
    const publisherId = document.getElementById('book-publisher').value;
    const payload = {
      id: bookId ? Number(bookId) : null,
      name: document.getElementById('book-name').value.trim(),
      isbn: document.getElementById('book-isbn').value.trim() || null,
      author: { id: Number(authorSelect.value) },
      category: { id: Number(categorySelect.value) },
      publisher: publisherId ? { id: Number(publisherId) } : null,
      tags: getSelectedIds(tagSelect).map(id => ({ id })),
      price: Number(document.getElementById('book-price').value),
      rate: Number(document.getElementById('book-rate').value),
      usersRateCount: Number(document.getElementById('book-users-rate-count').value),
      pagesNumber: Number(document.getElementById('book-pages').value),
      readingDuration: Number(document.getElementById('book-duration').value),
      publishDate: `${document.getElementById('book-publish-date').value}T00:00:00.000+00:00`,
      description: document.getElementById('book-description').value.trim(),
      imageUrl: document.getElementById('book-image-url').value.trim(),
      totalCopies: Number(document.getElementById('book-total-copies').value),
      availableCopies: Number(document.getElementById('book-available-copies').value)
    };

    try {
      await BookApi.apiRequest('/api/book', {
        method: bookId ? 'PUT' : 'POST',
        body: payload
      });
      BookUi.showMessage('admin-message', 'success', bookId ? adminText('图书更新成功。', 'Book updated successfully.') : adminText('图书创建成功。', 'Book created successfully.'));
      resetBookForm();
      await loadBooks();
    } catch (error) {
      BookUi.showMessage('admin-message', 'error', error.message);
    }
  });

  categoryForm.addEventListener('submit', async event => {
    event.preventDefault();
    const categoryId = document.getElementById('category-id').value;
    const payload = {
      id: categoryId ? Number(categoryId) : null,
      name: document.getElementById('category-name').value.trim(),
      description: document.getElementById('category-description').value.trim() || null
    };

    try {
      await BookApi.apiRequest('/api/category', {
        method: categoryId ? 'PUT' : 'POST',
        body: payload
      });
      BookUi.showMessage('admin-message', 'success', categoryId ? adminText('分类更新成功。', 'Category updated successfully.') : adminText('分类创建成功。', 'Category created successfully.'));
      resetCategoryForm();
      await loadCategories();
    } catch (error) {
      BookUi.showMessage('admin-message', 'error', error.message);
    }
  });

  authorForm.addEventListener('submit', async event => {
    event.preventDefault();
    const authorId = document.getElementById('author-id').value;
    const payload = {
      id: authorId ? Number(authorId) : null,
      name: document.getElementById('author-name').value.trim(),
      country: document.getElementById('author-country').value.trim(),
      birthdate: `${document.getElementById('author-birthdate').value}T00:00:00.000+00:00`,
      deathdate: document.getElementById('author-deathdate').value
        ? `${document.getElementById('author-deathdate').value}T00:00:00.000+00:00`
        : null,
      age: Number(document.getElementById('author-age').value),
      gender: document.getElementById('author-gender').value,
      imageUrl: document.getElementById('author-image-url').value.trim(),
      description: document.getElementById('author-description').value.trim()
    };

    try {
      await BookApi.apiRequest('/api/author', {
        method: authorId ? 'PUT' : 'POST',
        body: payload
      });
      BookUi.showMessage('admin-message', 'success', authorId ? adminText('作者更新成功。', 'Author updated successfully.') : adminText('作者创建成功。', 'Author created successfully.'));
      resetAuthorForm();
      await loadAuthors();
    } catch (error) {
      BookUi.showMessage('admin-message', 'error', error.message);
    }
  });

  publisherForm.addEventListener('submit', async event => {
    event.preventDefault();
    const publisherId = document.getElementById('publisher-id').value;
    const payload = {
      id: publisherId ? Number(publisherId) : null,
      name: document.getElementById('publisher-name').value.trim(),
      country: document.getElementById('publisher-country').value.trim() || null,
      websiteUrl: document.getElementById('publisher-website').value.trim() || null,
      description: document.getElementById('publisher-description').value.trim() || null
    };

    try {
      await BookApi.apiRequest('/api/publisher', {
        method: publisherId ? 'PUT' : 'POST',
        body: payload
      });
      BookUi.showMessage('admin-message', 'success', publisherId ? adminText('出版社更新成功。', 'Publisher updated successfully.') : adminText('出版社创建成功。', 'Publisher created successfully.'));
      resetPublisherForm();
      await loadPublishers();
    } catch (error) {
      BookUi.showMessage('admin-message', 'error', error.message);
    }
  });

  tagForm.addEventListener('submit', async event => {
    event.preventDefault();
    const tagId = document.getElementById('tag-id').value;
    const payload = {
      id: tagId ? Number(tagId) : null,
      name: document.getElementById('tag-name').value.trim(),
      description: document.getElementById('tag-description').value.trim() || null
    };

    try {
      await BookApi.apiRequest('/api/tag', {
        method: tagId ? 'PUT' : 'POST',
        body: payload
      });
      BookUi.showMessage('admin-message', 'success', tagId ? adminText('标签更新成功。', 'Tag updated successfully.') : adminText('标签创建成功。', 'Tag created successfully.'));
      resetTagForm();
      await loadTags();
    } catch (error) {
      BookUi.showMessage('admin-message', 'error', error.message);
    }
  });

  document.getElementById('reset-book-form').addEventListener('click', resetBookForm);
  totalCopiesInput.addEventListener('input', syncAvailableCopiesPreview);
  authorSearchInput.addEventListener('input', renderAuthorOptions);
  categorySearchInput.addEventListener('input', renderCategoryOptions);
  publisherSearchInput.addEventListener('input', renderPublisherOptions);
  tagSearchInput.addEventListener('input', renderTagOptions);
  tagSelect.addEventListener('change', renderTagOptions);
  bookListSearchInput.addEventListener('input', renderBookList);
  authorListSearchInput.addEventListener('input', renderAuthorList);
  categoryListSearchInput.addEventListener('input', renderCategoryList);
  publisherListSearchInput.addEventListener('input', renderPublisherList);
  tagListSearchInput.addEventListener('input', renderTagList);
  document.getElementById('reset-author-form').addEventListener('click', resetAuthorForm);
  document.getElementById('reset-category-form').addEventListener('click', resetCategoryForm);
  document.getElementById('reset-publisher-form').addEventListener('click', resetPublisherForm);
  document.getElementById('reset-tag-form').addEventListener('click', resetTagForm);

  document.getElementById('reload-books').addEventListener('click', () => loadBooks().catch(error => BookUi.showMessage('admin-message', 'error', error.message)));
  document.getElementById('reload-authors').addEventListener('click', () => loadAuthors().catch(error => BookUi.showMessage('admin-message', 'error', error.message)));
  document.getElementById('reload-categories').addEventListener('click', () => loadCategories().catch(error => BookUi.showMessage('admin-message', 'error', error.message)));
  document.getElementById('reload-publishers').addEventListener('click', () => loadPublishers().catch(error => BookUi.showMessage('admin-message', 'error', error.message)));
  document.getElementById('reload-tags').addEventListener('click', () => loadTags().catch(error => BookUi.showMessage('admin-message', 'error', error.message)));
  document.getElementById('reload-circulation').addEventListener('click', () => loadCirculation().catch(error => BookUi.showMessage('admin-message', 'error', error.message)));
  document.getElementById('reload-analytics').addEventListener('click', () => loadAnalytics().catch(error => BookUi.showMessage('admin-message', 'error', error.message)));
  analyticsWindowSelect.addEventListener('change', () => loadAnalytics().catch(error => BookUi.showMessage('admin-message', 'error', error.message)));

  try {
    await Promise.all([loadCategories(), loadAuthors(), loadBooks(), loadPublishers(), loadTags(), loadCirculation(), loadAnalytics()]);
    resetBookForm();
    resetAuthorForm();
    resetCategoryForm();
    resetPublisherForm();
    resetTagForm();
  } catch (error) {
    BookUi.showMessage('admin-message', 'error', error.message);
  }
});
