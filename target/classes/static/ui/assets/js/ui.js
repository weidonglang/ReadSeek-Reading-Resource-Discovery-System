(function () {
  let behaviorTrackerBound = false;
  const CATEGORY_NAME_MAP = {
    'Science Fiction': '科幻',
    'Horror': '恐怖',
    'Classic': '经典',
    'Action and Adventure': '动作冒险',
    'Romantic': '爱情',
    'Kids': '儿童',
    'History': '历史',
    'Sport': '体育'
  };

  function localizeCategoryName(name) {
    const normalizedName = String(name || '').trim();
    return CATEGORY_NAME_MAP[normalizedName] || normalizedName || '未分类';
  }

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
            <a data-nav="home" href="index.html">首页</a>
            <a data-nav="books" href="books.html">图书检索</a>
            <a data-nav="borrowings" href="borrowings.html">我的借阅</a>
            <a data-nav="recommendations" href="recommendations.html">我的推荐</a>
            <a data-nav="profile" href="profile.html">个人中心</a>
            ${isAdmin ? '<a data-nav="admin" href="admin.html">后台管理</a>' : ''}` : '';
    const guestLinks = user ? '' : `
            <a data-nav="login" href="login.html">登录</a>
            <a data-nav="register" href="register.html">注册</a>`;
    const userLabel = user
      ? `当前用户：${user.firstName || ''} ${user.lastName || ''}`.trim() + (user.role ? `（${user.role === 'ADMIN' ? '管理员' : '普通用户'}）` : '')
      : '请先登录';

    return `
      <header class="topbar">
        <div class="topbar-inner">
          <a class="brand" href="${user ? 'index.html' : 'login.html'}">新书推荐系统</a>
          <nav class="nav-links">${protectedLinks}${guestLinks}</nav>
          <div class="user-meta">
            <span class="muted">${userLabel}</span>
            <button id="nav-logout-btn" class="ghost ${user ? '' : 'hidden'}">退出登录</button>
          </div>
        </div>
      </header>`;
  }

  function footerTemplate() {
    return '<footer class="footer"><div class="footer-inner">新书推荐系统演示前端，适合用于毕业设计展示与功能讲解。</div></footer>';
  }

  function injectLayout() {
    const shell = document.querySelector('.app-shell');
    if (!shell) return;
    shell.insertAdjacentHTML('afterbegin', navTemplate());
    shell.insertAdjacentHTML('beforeend', footerTemplate());
    setActiveNav();
    bindBehaviorTracker();
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
    const title = escapeHtml(book?.name || '未命名图书');
    const author = escapeHtml(book?.author?.name || '未知作者');
    const category = escapeHtml(localizeCategoryName(book?.category?.name));
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
    const alt = book?.name || '图书封面';
    const payload = escapeHtml(JSON.stringify({
      name: book?.name || '',
      author: { name: book?.author?.name || '' },
      category: { name: book?.category?.name || '' }
    }));
    return `<img src="${imageUrl}" alt="${escapeHtml(alt)}" loading="lazy" referrerpolicy="no-referrer" data-book-payload="${payload}" onerror="window.BookUi.handleBookImageError(this)">`;
  }

  function buildBookDetailHref(bookId, options = {}) {
    const params = new URLSearchParams();
    params.set('id', bookId ?? '');
    if (options.source) params.set('source', options.source);
    if (options.reason) params.set('reason', options.reason);
    return `book-detail.html?${params.toString()}`;
  }

  async function trackBookLinkClick(event) {
    if (!event.target || typeof event.target.closest !== 'function') return;
    const link = event.target.closest('a[data-behavior-track="1"]');
    if (!link) return;
    if (event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;
    event.preventDefault();
    try {
      const actionType = link.dataset.actionType || 'BOOK_DETAIL_CLICK';
      await window.BookApi.logBehavior({
        actionType,
        bookId: link.dataset.bookId ? Number(link.dataset.bookId) : null,
        keyword: link.dataset.keyword || null,
        source: link.dataset.source || null,
        reason: link.dataset.reason || null
      });
      if (actionType === 'RECOMMENDATION_CLICK') {
        await window.BookApi.logBehavior({
          actionType: 'BOOK_DETAIL_CLICK',
          bookId: link.dataset.bookId ? Number(link.dataset.bookId) : null,
          keyword: link.dataset.keyword || null,
          source: link.dataset.source || null,
          reason: link.dataset.reason || null
        });
      }
    } catch (error) {
      console.warn('behavior tracking failed:', error.message);
    } finally {
      window.location.href = link.href;
    }
  }

  function bindBehaviorTracker() {
    if (behaviorTrackerBound) return;
    behaviorTrackerBound = true;
    document.addEventListener('click', trackBookLinkClick);
  }

  function renderBookCard(book, options = {}) {
    const id = book?.id ?? '';
    const authorId = book?.author?.id ?? '';
    const categoryName = localizeCategoryName(book?.category?.name);
    const isbnLabel = book?.isbn ? `<span class="tag">ISBN: ${escapeHtml(book.isbn)}</span>` : '';
    const rate = book?.rate ?? '-';
    const totalCopies = book?.totalCopies ?? '-';
    const availableCopies = book?.availableCopies ?? '-';
    const description = book?.description || '暂无简介。';
    const reason = options.reason || book?.recommendationReason || options.comment || '';
    const source = options.source || book?.recommendationSource || '';
    const actionType = options.actionType || (source.startsWith('recommendation:') ? 'RECOMMENDATION_CLICK' : 'BOOK_DETAIL_CLICK');
    const sourceLabel = options.sourceLabel || source;
    const searchKeyword = options.searchKeyword || '';
    const detailHref = buildBookDetailHref(id, { source, reason });
    const hitMeta = (sourceLabel || reason) ? `
      <div class="book-hit-meta">
        ${sourceLabel ? `<span class="tag source-chip">来源：${escapeHtml(sourceLabel)}</span>` : ''}
        ${reason ? `<span class="tag reason-chip">原因：${escapeHtml(reason)}</span>` : ''}
      </div>` : '';

    return `
      <article class="card book-card">
        <div class="book-cover">${renderBookImage(book)}</div>
        <div>
          <h3 class="book-title">${book?.name || '未命名图书'}</h3>
          <div class="book-meta">作者：${book?.author?.name || '未知作者'}</div>
        </div>
        <div class="tags">
          ${isbnLabel}
          <span class="tag">分类：${categoryName}</span>
          <span class="tag">评分：${rate}</span>
          <span class="tag">页数：${book?.pagesNumber ?? '-'}</span>
          <span class="tag">可借库存：${availableCopies}/${totalCopies}</span>
        </div>
        <div class="muted">${description.slice(0, 100)}${description.length > 100 ? '...' : ''}</div>
        ${hitMeta}
        <div class="book-actions">
          <a href="${detailHref}"
             class="primary"
             style="padding:10px 14px;border-radius:10px;background:#2563eb;color:#fff;"
             data-behavior-track="1"
             data-action-type="${escapeHtml(actionType)}"
             data-book-id="${escapeHtml(id)}"
             data-source="${escapeHtml(source)}"
             data-reason="${escapeHtml(reason)}"
             data-keyword="${escapeHtml(searchKeyword)}">查看详情</a>
          <a href="rate-book.html?bookId=${id}" style="padding:10px 14px;border-radius:10px;border:1px solid #dbe3ef;">评分</a>
          ${authorId ? `<a href="books.html?authorId=${authorId}" style="padding:10px 14px;border-radius:10px;border:1px solid #dbe3ef;">同作者图书</a>` : ''}
        </div>
      </article>`;
  }

  function renderRecommendationShelves(overview, options = {}) {
    const shelves = Array.isArray(overview?.shelves) ? overview.shelves : [];
    const emptyMessage = options.emptyMessage || '暂无推荐数据。';
    if (!shelves.length) {
      return `<div class="card muted">${escapeHtml(emptyMessage)}</div>`;
    }

    return shelves.map(shelf => `
      <section class="recommend-shelf">
        <div class="section-head">
          <div>
            <h2>${escapeHtml(shelf.title || '推荐书架')}</h2>
            <div class="muted">${escapeHtml(shelf.description || '')}</div>
          </div>
        </div>
        <div class="book-list">
          ${(Array.isArray(shelf.books) ? shelf.books : []).map(book => renderBookCard(book, {
            source: `recommendation:${shelf.key || 'overview'}`,
            sourceLabel: shelf.title || shelf.key || '推荐书架',
            reason: book?.recommendationReason || shelf.description || '',
            actionType: 'RECOMMENDATION_CLICK'
          })).join('')}
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
    localizeCategoryName,
    requireLogin,
    requireAdmin,
    redirectIfLoggedIn
  };
})();
