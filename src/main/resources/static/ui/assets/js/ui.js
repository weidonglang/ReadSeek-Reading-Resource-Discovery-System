(function () {
  function setActiveNav() {
    const page = document.body.dataset.page;
    document.querySelectorAll('[data-nav]').forEach(link => {
      if (link.dataset.nav === page) link.classList.add('active');
    });
  }

  function navTemplate() {
    const user = window.BookApi.getCurrentUserCache();
    const isAdmin = user?.role === 'ADMIN';
    const protectedLinks = user ? `
            <a data-nav="home" href="index.html">Home</a>
            <a data-nav="books" href="books.html">Books</a>
            <a data-nav="borrowings" href="borrowings.html">Loans</a>
            <a data-nav="recommendations" href="recommendations.html">Recommendations</a>
            <a data-nav="profile" href="profile.html">Profile</a>
            ${isAdmin ? '<a data-nav="admin" href="admin.html">Admin</a>' : ''}` : '';
    const guestLinks = user ? '' : `
            <a data-nav="login" href="login.html">Login</a>
            <a data-nav="register" href="register.html">Register</a>`;
    const userLabel = user
      ? `Current user: ${user.firstName || ''} ${user.lastName || ''}`.trim() + (user.role ? ` (${user.role})` : '')
      : 'Please log in';

    return `
      <header class="topbar">
        <div class="topbar-inner">
          <a class="brand" href="${user ? 'index.html' : 'login.html'}">Book Nook</a>
          <nav class="nav-links">${protectedLinks}${guestLinks}</nav>
          <div class="user-meta">
            <span class="muted">${userLabel}</span>
            <button id="nav-logout-btn" class="ghost ${user ? '' : 'hidden'}">Logout</button>
          </div>
        </div>
      </header>`;
  }

  function footerTemplate() {
    return '<footer class="footer"><div class="footer-inner">Static UI scaffold for the current Spring Boot API.</div></footer>';
  }

  function injectLayout() {
    const shell = document.querySelector('.app-shell');
    if (!shell) return;
    shell.insertAdjacentHTML('afterbegin', navTemplate());
    shell.insertAdjacentHTML('beforeend', footerTemplate());
    setActiveNav();
    const logoutBtn = document.getElementById('nav-logout-btn');
    if (logoutBtn) {
      logoutBtn.addEventListener('click', async () => {
        await window.BookApi.logout();
        window.location.href = 'login.html';
      });
    }
  }

  function showMessage(targetId, type, message) {
    const el = document.getElementById(targetId);
    if (!el) return;
    el.className = `alert ${type}`;
    el.textContent = message;
    el.classList.remove('hidden');
  }

  function hideMessage(targetId) {
    const el = document.getElementById(targetId);
    if (!el) return;
    el.classList.add('hidden');
    el.textContent = '';
  }

  function getBookImageUrl(book) {
    const imageUrl = book?.imageUrl;
    if (!imageUrl || typeof imageUrl !== 'string') return '';
    return imageUrl.trim();
  }

  function escapeHtml(value) {
    return String(value ?? '')
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  function renderBookFallback(book) {
    const title = escapeHtml(book?.name || 'Untitled Book');
    const author = escapeHtml(book?.author?.name || 'Unknown Author');
    const category = escapeHtml(book?.category?.name || 'Unknown');
    return `
      <div class="book-cover-fallback">
        <div class="book-cover-fallback-title">${title}</div>
        <div class="book-cover-fallback-meta">${author}</div>
        <div class="book-cover-fallback-tag">${category}</div>
      </div>`;
  }

  function handleBookImageError(img) {
    if (!img || !img.parentNode) return;
    const payload = img.dataset.bookPayload;
    let book = {};
    try {
      book = payload ? JSON.parse(payload) : {};
    } catch (e) {
      book = {};
    }
    img.parentNode.innerHTML = renderBookFallback(book);
  }

  function renderBookImage(book) {
    const imageUrl = getBookImageUrl(book);
    if (!imageUrl) return renderBookFallback(book);
    const alt = book?.name || 'book';
    const payload = escapeHtml(JSON.stringify({
      name: book?.name || '',
      author: { name: book?.author?.name || '' },
      category: { name: book?.category?.name || '' }
    }));
    return `<img src="${imageUrl}" alt="${escapeHtml(alt)}" loading="lazy" referrerpolicy="no-referrer" data-book-payload="${payload}" onerror="window.BookUi.handleBookImageError(this)">`;
  }

  function renderBookCard(book, options = {}) {
    const id = book?.id ?? '';
    const authorId = book?.author?.id ?? '';
    const categoryName = book?.category?.name || 'Unknown';
    const isbnLabel = book?.isbn ? `<span class="tag">ISBN: ${escapeHtml(book.isbn)}</span>` : '';
    const rate = book?.rate ?? '-';
    const totalCopies = book?.totalCopies ?? '-';
    const availableCopies = book?.availableCopies ?? '-';
    const description = book?.description || 'No description.';
    const comment = options.comment ? `<div class="muted">${options.comment}</div>` : '';

    return `
      <article class="card book-card">
        <div class="book-cover">${renderBookImage(book)}</div>
        <div>
          <h3 class="book-title">${book?.name || 'Untitled Book'}</h3>
          <div class="book-meta">Author: ${book?.author?.name || 'Unknown'}</div>
        </div>
        <div class="tags">
          ${isbnLabel}
          <span class="tag">Category: ${categoryName}</span>
          <span class="tag">Rate: ${rate}</span>
          <span class="tag">Pages: ${book?.pagesNumber ?? '-'}</span>
          <span class="tag">Available: ${availableCopies}/${totalCopies}</span>
        </div>
        <div class="muted">${description.slice(0, 100)}${description.length > 100 ? '...' : ''}</div>
        ${comment}
        <div class="book-actions">
          <a href="book-detail.html?id=${id}" class="primary" style="padding:10px 14px;border-radius:10px;background:#2563eb;color:#fff;">View Details</a>
          <a href="rate-book.html?bookId=${id}" style="padding:10px 14px;border-radius:10px;border:1px solid #dbe3ef;">Rate</a>
          ${authorId ? `<a href="books.html?authorId=${authorId}" style="padding:10px 14px;border-radius:10px;border:1px solid #dbe3ef;">Author Books</a>` : ''}
        </div>
      </article>`;
  }

  function renderRecommendationShelves(overview, options = {}) {
    const shelves = Array.isArray(overview?.shelves) ? overview.shelves : [];
    const emptyMessage = options.emptyMessage || 'No recommendation data available yet.';
    if (!shelves.length) {
      return `<div class="card muted">${escapeHtml(emptyMessage)}</div>`;
    }

    return shelves.map(shelf => `
      <section class="recommend-shelf">
        <div class="section-head">
          <div>
            <h2>${escapeHtml(shelf.title || 'Recommended')}</h2>
            <div class="muted">${escapeHtml(shelf.description || '')}</div>
          </div>
        </div>
        <div class="book-list">
          ${(Array.isArray(shelf.books) ? shelf.books : []).map(book => renderBookCard(book)).join('')}
        </div>
      </section>`).join('');
  }

  function requireLogin(redirect = 'login.html') {
    const token = window.BookApi.getAccessToken();
    if (!token) {
      const current = window.location.pathname.split('/').pop() || 'index.html';
      const target = `${redirect}?redirect=${encodeURIComponent(current + window.location.search)}`;
      window.location.href = target;
      return false;
    }
    return true;
  }

  function redirectIfLoggedIn(defaultTarget = 'index.html') {
    if (window.BookApi.getAccessToken()) {
      window.location.href = defaultTarget;
      return true;
    }
    return false;
  }

  function requireAdmin(redirect = 'index.html') {
    const user = window.BookApi.getCurrentUserCache();
    if (!user || user.role !== 'ADMIN') {
      window.location.href = redirect;
      return false;
    }
    return true;
  }

  window.BookUi = {
    injectLayout,
    showMessage,
    hideMessage,
    getBookImageUrl,
    handleBookImageError,
    renderBookImage,
    renderBookCard,
    renderRecommendationShelves,
    requireLogin,
    requireAdmin,
    redirectIfLoggedIn
  };
})();
