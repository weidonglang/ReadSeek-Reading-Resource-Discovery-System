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
  return date.toLocaleString('zh-CN');
}

function formatUserName(user) {
  const fullName = `${user?.firstName || ''} ${user?.lastName || ''}`.trim();
  return fullName || user?.email || 'Unknown User';
}

function renderAdminLoanItem(loan) {
  const book = loan.book || {};
  const userName = formatUserName(loan.user);
  const statusClass = loan.status === 'RETURNED' ? 'returned' : 'active';
  const statusLabel = loan.status === 'RETURNED' ? 'Returned' : 'Borrowed';
  return `
    <article class="loan-card">
      <div class="loan-cover">${BookUi.renderBookImage(book)}</div>
      <div class="loan-body">
        <div class="loan-head">
          <div>
            <h3>${escapeHtml(book.name || 'Untitled Book')}</h3>
            <div class="muted">${escapeHtml(book.author?.name || 'Unknown Author')} | ${escapeHtml(userName)}</div>
          </div>
          <span class="loan-status ${statusClass}">${statusLabel}</span>
        </div>
        <div class="loan-meta">
          <span class="tag">Loan #${escapeHtml(loan.id ?? '-')}</span>
          <span class="tag">User #${escapeHtml(loan.user?.id ?? '-')}</span>
          <span class="tag">Borrowed: ${escapeHtml(formatDateTime(loan.borrowedAt))}</span>
          <span class="tag">Due: ${escapeHtml(formatDateTime(loan.dueDate))}</span>
          <span class="tag">Renew Count: ${escapeHtml(loan.renewCount ?? 0)}</span>
        </div>
        ${loan.returnedAt ? `<div class="muted">Returned at ${escapeHtml(formatDateTime(loan.returnedAt))}</div>` : ''}
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
            <h3>${escapeHtml(book.name || 'Untitled Book')}</h3>
            <div class="muted">${escapeHtml(book.author?.name || 'Unknown Author')} | ${escapeHtml(userName)}</div>
          </div>
          <span class="loan-status ${statusClass}">${escapeHtml(reservation.status || 'ACTIVE')}</span>
        </div>
        <div class="loan-meta">
          <span class="tag">Reservation #${escapeHtml(reservation.id ?? '-')}</span>
          <span class="tag">User #${escapeHtml(reservation.user?.id ?? '-')}</span>
          <span class="tag">Requested: ${escapeHtml(formatDateTime(reservation.requestedAt))}</span>
          <span class="tag">Available: ${escapeHtml(`${book.availableCopies ?? 0}/${book.totalCopies ?? 0}`)}</span>
        </div>
        ${reservation.fulfilledAt ? `<div class="muted">Fulfilled at ${escapeHtml(formatDateTime(reservation.fulfilledAt))}</div>` : ''}
        ${reservation.cancelledAt ? `<div class="muted">Cancelled at ${escapeHtml(formatDateTime(reservation.cancelledAt))}</div>` : ''}
      </div>
    </article>`;
}

document.addEventListener('DOMContentLoaded', async () => {
  if (!BookUi.requireLogin()) return;
  BookUi.injectLayout();

  try {
    const currentUser = await BookApi.fetchCurrentUser();
    if (!currentUser || currentUser.role !== 'ADMIN') {
      BookUi.showMessage('admin-message', 'error', 'Admin access is required.');
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
      `<option value="${category.id}">${escapeHtml(category.name)}</option>`
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
    publisherSelect.innerHTML = `<option value="">No Publisher</option>${options}`;
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
      : '<span class="muted">No tags selected.</span>';
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
    if (!window.confirm(`Soft delete book #${id}?`)) return;
    await BookApi.apiRequest(`/api/book/${id}`, { method: 'DELETE' });
    await loadBooks();
  }

  async function removeAuthor(id) {
    if (!window.confirm(`Soft delete author #${id}?`)) return;
    await BookApi.apiRequest(`/api/author/${id}`, { method: 'DELETE' });
    await loadAuthors();
  }

  async function removeCategory(id) {
    if (!window.confirm(`Soft delete category #${id}?`)) return;
    await BookApi.apiRequest(`/api/category/${id}`, { method: 'DELETE' });
    await loadCategories();
  }

  async function removePublisher(id) {
    if (!window.confirm(`Soft delete publisher #${id}?`)) return;
    await BookApi.apiRequest(`/api/publisher/${id}`, { method: 'DELETE' });
    await loadPublishers();
  }

  async function removeTag(id) {
    if (!window.confirm(`Soft delete tag #${id}?`)) return;
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
        const publisherLabel = book.publisher?.name || 'No publisher';
        const tagLabels = (book.tags || []).map(tag => `<span class="tag">${escapeHtml(tag.name)}</span>`).join('');
        return `
          <article class="admin-item">
            <div class="admin-item-head">
              <div>
                <h3>${escapeHtml(book.name)}</h3>
                <div class="muted">#${book.id} | ${escapeHtml(book.author?.name || 'Unknown Author')} | ${escapeHtml(book.category?.name || 'Unknown Category')}</div>
              </div>
              <div class="admin-actions">
                <button type="button" data-edit-book="${book.id}">Edit</button>
                <button type="button" class="danger" data-delete-book="${book.id}">Delete</button>
              </div>
            </div>
            <div class="admin-meta">
              <span class="tag">ISBN: ${escapeHtml(book.isbn || 'No ISBN')}</span>
              <span class="tag">Publisher: ${escapeHtml(publisherLabel)}</span>
              <span class="tag">Price: ${escapeHtml(book.price ?? '-')}</span>
              <span class="tag">Rate: ${escapeHtml(book.rate ?? '-')}</span>
              <span class="tag">Pages: ${escapeHtml(book.pagesNumber ?? '-')}</span>
              <span class="tag">Available: ${escapeHtml(book.availableCopies ?? '-')} / ${escapeHtml(book.totalCopies ?? '-')}</span>
            </div>
            <div class="tags">${tagLabels || '<span class="muted">No tags assigned.</span>'}</div>
            <div class="muted">${escapeHtml(truncateText(book.description, 180))}</div>
          </article>`;
      }).join('')
      : '<div class="muted">No books matched the current search.</div>';

    bookList.querySelectorAll('[data-edit-book]').forEach(button => {
      button.addEventListener('click', () => editBook(button.dataset.editBook));
    });
    bookList.querySelectorAll('[data-delete-book]').forEach(button => {
      button.addEventListener('click', async () => {
        try {
          await removeBook(button.dataset.deleteBook);
          BookUi.showMessage('admin-message', 'success', 'Book deleted.');
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
              <div class="muted">#${author.id} | ${escapeHtml(author.country || 'Unknown Country')} | ${escapeHtml(author.gender || 'Unknown Gender')}</div>
            </div>
            <div class="admin-actions">
              <button type="button" data-edit-author="${author.id}">Edit</button>
              <button type="button" class="danger" data-delete-author="${author.id}">Delete</button>
            </div>
          </div>
          <div class="muted">${escapeHtml(truncateText(author.description))}</div>
        </article>`).join('')
      : '<div class="muted">No authors matched the current search.</div>';

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
          BookUi.showMessage('admin-message', 'success', 'Author deleted.');
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
              <h3>${escapeHtml(category.name)}</h3>
              <div class="muted">#${category.id}</div>
            </div>
            <div class="admin-actions">
              <button type="button" data-edit-category="${category.id}">Edit</button>
              <button type="button" class="danger" data-delete-category="${category.id}">Delete</button>
            </div>
          </div>
          <div class="muted">${escapeHtml(truncateText(category.description || 'No description.'))}</div>
        </article>`).join('')
      : '<div class="muted">No categories matched the current search.</div>';

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
          BookUi.showMessage('admin-message', 'success', 'Category deleted.');
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
              <div class="muted">#${publisher.id} | ${escapeHtml(publisher.country || 'Unknown Country')}</div>
            </div>
            <div class="admin-actions">
              <button type="button" data-edit-publisher="${publisher.id}">Edit</button>
              <button type="button" class="danger" data-delete-publisher="${publisher.id}">Delete</button>
            </div>
          </div>
          <div class="muted">${escapeHtml(truncateText(publisher.description || publisher.websiteUrl || 'No description.'))}</div>
        </article>`).join('')
      : '<div class="muted">No publishers matched the current search.</div>';

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
          BookUi.showMessage('admin-message', 'success', 'Publisher deleted.');
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
              <button type="button" data-edit-tag="${tag.id}">Edit</button>
              <button type="button" class="danger" data-delete-tag="${tag.id}">Delete</button>
            </div>
          </div>
          <div class="muted">${escapeHtml(truncateText(tag.description || 'No description.'))}</div>
        </article>`).join('')
      : '<div class="muted">No tags matched the current search.</div>';

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
          BookUi.showMessage('admin-message', 'success', 'Tag deleted.');
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
  }

  async function loadBooks() {
    const response = await BookApi.apiRequest('/api/book/find-all-paginated-filtered', {
      method: 'POST',
      body: buildBookAdminPayload()
    });
    books = BookApi.parsePaginationResult(response).list;
    renderBookList();
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
  }

  async function loadCirculation() {
    adminActiveLoans.innerHTML = '<div class="muted">Loading active loans...</div>';
    adminLoanHistory.innerHTML = '<div class="muted">Loading loan history...</div>';
    adminActiveReservations.innerHTML = '<div class="muted">Loading active reservations...</div>';
    adminReservationHistory.innerHTML = '<div class="muted">Loading reservation history...</div>';

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
      : '<div class="muted">No active loans.</div>';
    adminLoanHistory.innerHTML = loanHistory.length
      ? loanHistory.map(loan => renderAdminLoanItem(loan)).join('')
      : '<div class="muted">No returned loans yet.</div>';
    adminActiveReservations.innerHTML = activeReservations.length
      ? activeReservations.map(reservation => renderAdminReservationItem(reservation)).join('')
      : '<div class="muted">No active reservations.</div>';
    adminReservationHistory.innerHTML = reservationHistory.length
      ? reservationHistory.map(reservation => renderAdminReservationItem(reservation)).join('')
      : '<div class="muted">No reservation history yet.</div>';
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
      BookUi.showMessage('admin-message', 'success', bookId ? 'Book updated.' : 'Book created.');
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
      BookUi.showMessage('admin-message', 'success', categoryId ? 'Category updated.' : 'Category created.');
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
      BookUi.showMessage('admin-message', 'success', authorId ? 'Author updated.' : 'Author created.');
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
      BookUi.showMessage('admin-message', 'success', publisherId ? 'Publisher updated.' : 'Publisher created.');
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
      BookUi.showMessage('admin-message', 'success', tagId ? 'Tag updated.' : 'Tag created.');
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

  try {
    await Promise.all([loadCategories(), loadAuthors(), loadBooks(), loadPublishers(), loadTags(), loadCirculation()]);
    resetBookForm();
    resetAuthorForm();
    resetCategoryForm();
    resetPublisherForm();
    resetTagForm();
  } catch (error) {
    BookUi.showMessage('admin-message', 'error', error.message);
  }
});
