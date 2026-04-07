(function () {
  let behaviorTrackerBound = false;
  let storageActionBound = false;

  const CATEGORY_NAME_MAP = {
    'Science Fiction': '科幻',
    'Horror': '惊悚',
    'Classic': '经典',
    'Action and Adventure': '动作冒险',
    'Romantic': '爱情',
    'Kids': '儿童',
    'History': '历史',
    'Sport': '体育'
  };
  const CATEGORY_NAME_REVERSE_MAP = Object.fromEntries(
    Object.entries(CATEGORY_NAME_MAP).map(([englishName, chineseName]) => [chineseName, englishName])
  );
  Object.assign(CATEGORY_NAME_REVERSE_MAP, {
    '恐怖': 'Horror',
    '动作与冒险': 'Action and Adventure',
    '浪漫': 'Romantic',
    '儿童文学': 'Kids'
  });

  const READING_LEVEL_MAP = {
    BEGINNER: '入门读者',
    INTERMEDIATE: '进阶读者',
    EXPERT: '深度读者'
  };

  const SAVED_BOOKS_KEY = 'book_saved_items';
  const RECENT_VIEWED_KEY = 'book_recent_viewed_items';
  const MONTHLY_GOAL_KEY = 'book_monthly_goal';

  function t(key, variables = {}) {
    return window.BookI18n?.t ? window.BookI18n.t(key, variables) : key;
  }

  function currentLocale() {
    return window.BookI18n?.getLocale ? window.BookI18n.getLocale() : 'zh-CN';
  }

  function currentLanguage() {
    return window.BookI18n?.isChinese && window.BookI18n.isChinese() ? 'zh' : 'en';
  }

  const RECOMMENDATION_TITLE_MAP = {
    '近期热门': { zh: '近期热门', en: 'Recently popular' },
    'Recently popular': { zh: '近期热门', en: 'Recently popular' },
    '符合你的阅读偏好': { zh: '符合你的阅读偏好', en: 'Matched to your reading preferences' },
    'Matched to your reading preferences': { zh: '符合你的阅读偏好', en: 'Matched to your reading preferences' },
    '基于你的评分和借阅行为': { zh: '基于你的评分和借阅行为', en: 'Based on your ratings and borrowing behavior' },
    'Based on your ratings and borrowing behavior': { zh: '基于你的评分和借阅行为', en: 'Based on your ratings and borrowing behavior' },
    '推荐预览': { zh: '推荐预览', en: 'Recommendation preview' },
    'Recommendation preview': { zh: '推荐预览', en: 'Recommendation preview' },
    '精选推荐': { zh: '精选推荐', en: 'Featured picks' },
    'Featured picks': { zh: '精选推荐', en: 'Featured picks' },
    '同分类推荐': { zh: '同分类推荐', en: 'Same-category recommendations' },
    'Same-category recommendations': { zh: '同分类推荐', en: 'Same-category recommendations' },
    '同作者更多作品': { zh: '同作者更多作品', en: 'More from the same author' },
    'More from the same author': { zh: '同作者更多作品', en: 'More from the same author' },
    '同作者书架': { zh: '同作者书架', en: 'Author shelf' },
    'Author shelf': { zh: '同作者书架', en: 'Author shelf' }
  };

  function localizeRecommendationTitle(title) {
    const normalized = String(title || '').trim();
    if (!normalized) return normalized;
    const overviewZhMatch = normalized.match(/^推荐书架（热门窗口\s*(\d+)\s*天）$/);
    if (overviewZhMatch) {
      return currentLanguage() === 'zh'
        ? normalized
        : `Recommendation shelves (popular window: ${overviewZhMatch[1]} days)`;
    }
    const overviewEnMatch = normalized.match(/^Recommendation shelves \(popular window: (\d+) days\)$/);
    if (overviewEnMatch) {
      return currentLanguage() === 'zh'
        ? `推荐书架（热门窗口 ${overviewEnMatch[1]} 天）`
        : normalized;
    }
    const entry = RECOMMENDATION_TITLE_MAP[normalized];
    return entry ? entry[currentLanguage()] : normalized;
  }

  function localizeRecommendationDescription(description) {
    const normalized = String(description || '').trim();
    if (!normalized) return normalized;
    const language = currentLanguage();
    const popularZhMatch = normalized.match(/^综合近\s*(\d+)\s*天的借阅、详情点击和评分人数信号生成的热门图书榜单。权重策略：借阅 x5，点击 x3，评分人数 x2。$/);
    if (popularZhMatch) {
      const days = popularZhMatch[1];
      return language === 'zh'
        ? normalized
        : `A popular shelf generated from borrow, detail-click, and rating-count signals over the last ${days} days. Weighting: borrows x5, clicks x3, rating count x2.`;
    }
    const popularEnMatch = normalized.match(/^A popular shelf generated from borrow, detail-click, and rating-count signals over the last (\d+) days\. Weighting: borrows x5, clicks x3, rating count x2\.$/);
    if (popularEnMatch) {
      const days = popularEnMatch[1];
      return language === 'zh'
        ? `综合近 ${days} 天的借阅、详情点击和评分人数信号生成的热门图书榜单。权重策略：借阅 x5，点击 x3，评分人数 x2。`
        : normalized;
    }
    if (normalized === '匹配你在个人中心选择的偏好分类。') {
      return language === 'zh' ? normalized : 'Matches the preferred categories selected in your profile.';
    }
    if (normalized === 'Matches the preferred categories selected in your profile.') {
      return language === 'zh' ? '匹配你在个人中心选择的偏好分类。' : normalized;
    }
    if (normalized === '根据你评分或借阅过图书的分类与标签生成推荐。') {
      return language === 'zh' ? normalized : 'Generated from the categories and tags of books you rated or borrowed.';
    }
    if (normalized === 'Generated from the categories and tags of books you rated or borrowed.') {
      return language === 'zh' ? '根据你评分或借阅过图书的分类与标签生成推荐。' : normalized;
    }
    if (normalized === '这一书架会根据你的阅读记录与偏好持续更新。') {
      return language === 'zh' ? normalized : 'This shelf keeps updating based on your reading history and preferences.';
    }
    if (normalized === 'This shelf keeps updating based on your reading history and preferences.') {
      return language === 'zh' ? '这一书架会根据你的阅读记录与偏好持续更新。' : normalized;
    }
    if (normalized === '从当前推荐结果中优先整理出更值得先看的内容。') {
      return language === 'zh' ? normalized : 'A prioritized selection of the most worthwhile items from the current recommendation result.';
    }
    if (normalized === 'A prioritized selection of the most worthwhile items from the current recommendation result.') {
      return language === 'zh' ? '从当前推荐结果中优先整理出更值得先看的内容。' : normalized;
    }
    if (normalized === '优先推荐同分类图书，并结合共享标签数量和热度排序。') {
      return language === 'zh' ? normalized : 'Prioritizes books from the same category, then ranks them by shared tags and popularity.';
    }
    if (normalized === 'Prioritizes books from the same category, then ranks them by shared tags and popularity.') {
      return language === 'zh' ? '优先推荐同分类图书，并结合共享标签数量和热度排序。' : normalized;
    }
    if (normalized === '补充展示同一作者的其他图书，方便继续浏览。') {
      return language === 'zh' ? normalized : 'Shows more books by the same author so you can keep browsing.';
    }
    if (normalized === 'Shows more books by the same author so you can keep browsing.') {
      return language === 'zh' ? '补充展示同一作者的其他图书，方便继续浏览。' : normalized;
    }
    return normalized;
  }

  function localizeRecommendationReason(reason) {
    const normalized = String(reason || '').trim();
    if (!normalized) return normalized;
    const language = currentLanguage();
    const popularZhMatch = normalized.match(/^近期热门：(\d+)\s*位读者评分，平均分\s*([\d.]+)，当前可借\s*([\d/]+)\s*本。$/);
    if (popularZhMatch) {
      const [, count, rate, copies] = popularZhMatch;
      return language === 'zh'
        ? normalized
        : `Recently popular: ${count} ratings, average ${rate}, currently ${copies} available.`;
    }
    const popularEnMatch = normalized.match(/^Recently popular: (\d+) ratings, average ([\d.]+), currently ([\d/]+) available\.$/);
    if (popularEnMatch) {
      const [, count, rate, copies] = popularEnMatch;
      return language === 'zh'
        ? `近期热门：${count} 位读者评分，平均分 ${rate}，当前可借 ${copies} 本。`
        : normalized;
    }
    const preferenceZhMatch = normalized.match(/^与你偏好的“(.+)”分类一致。$/);
    if (preferenceZhMatch) {
      return language === 'zh'
        ? normalized
        : `Matches your preferred "${localizeCategoryName(preferenceZhMatch[1])}" category.`;
    }
    const preferenceEnMatch = normalized.match(/^Matches your preferred "(.+)" category\.$/);
    if (preferenceEnMatch) {
      return language === 'zh'
        ? `与你偏好的“${localizeCategoryName(preferenceEnMatch[1])}”分类一致。`
        : normalized;
    }
    const behaviorZhMatch = normalized.match(/^与你高分或借阅过的图书在“(.+)”分类或相近标签上更接近。$/);
    if (behaviorZhMatch) {
      return language === 'zh'
        ? normalized
        : `Closer to books you rated highly or borrowed through the "${localizeCategoryName(behaviorZhMatch[1])}" category or similar tags.`;
    }
    const behaviorEnMatch = normalized.match(/^Closer to books you rated highly or borrowed through the "(.+)" category or similar tags\.$/);
    if (behaviorEnMatch) {
      return language === 'zh'
        ? `与你高分或借阅过的图书在“${localizeCategoryName(behaviorEnMatch[1])}”分类或相近标签上更接近。`
        : normalized;
    }
    const sameCategoryZhMatch = normalized.match(/^与《(.+)》同属“(.+)”分类，并共享\s*(\d+)\s*个标签。$/);
    if (sameCategoryZhMatch) {
      const [, title, category, count] = sameCategoryZhMatch;
      return language === 'zh'
        ? normalized
        : `Belongs to the same "${localizeCategoryName(category)}" category as "${title}" and shares ${count} tag(s).`;
    }
    const sameCategoryEnMatch = normalized.match(/^Belongs to the same "(.+)" category as "(.+)" and shares (\d+) tag\(s\)\.$/);
    if (sameCategoryEnMatch) {
      const [, category, title, count] = sameCategoryEnMatch;
      return language === 'zh'
        ? `与《${title}》同属“${localizeCategoryName(category)}”分类，并共享 ${count} 个标签。`
        : normalized;
    }
    return normalized;
  }

  function parseStorageJson(key, fallback) {
    try {
      const raw = localStorage.getItem(key);
      return raw ? JSON.parse(raw) : fallback;
    } catch (error) {
      return fallback;
    }
  }

  function escapeHtml(value) {
    return String(value ?? '')
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  function localizeCategoryName(name) {
    const normalizedName = String(name || '').trim();
    if (!window.BookI18n?.isChinese || !window.BookI18n.isChinese()) {
      return CATEGORY_NAME_REVERSE_MAP[normalizedName] || normalizedName || t('common.noData');
    }
    return CATEGORY_NAME_MAP[normalizedName] || normalizedName || t('common.noData');
  }

  function localizeReadingLevel(level) {
    const normalizedLevel = String(level || '').trim().toUpperCase();
    if (normalizedLevel === 'BEGINNER') return t('common.readLevelBeginner');
    if (normalizedLevel === 'INTERMEDIATE') return t('common.readLevelIntermediate');
    if (normalizedLevel === 'EXPERT') return t('common.readLevelExpert');
    return READING_LEVEL_MAP[normalizedLevel] || normalizedLevel || t('common.noData');
  }

  function setActiveNav() {
    const page = document.body.dataset.page;
    const navPage = page === 'bookDetail' || page === 'rateBook' ? 'books' : page;
    document.querySelectorAll('[data-nav]').forEach(link => {
      if (link.dataset.nav === navPage) {
        link.classList.add('active');
      }
    });
  }

  function navTemplate() {
    const user = window.BookApi.getCurrentUserCache();
    const isAdmin = user?.role === 'ADMIN';
    const displayName = `${(user?.firstName || '')} ${(user?.lastName || '')}`.trim() || user?.email || t('common.loginFirst');
    const protectedLinks = user ? `
            <a data-nav="home" href="index.html">${t('common.nav.home')}</a>
            <a data-nav="books" href="books.html">${t('common.nav.books')}</a>
            <a data-nav="borrowings" href="borrowings.html">${t('common.nav.borrowings')}</a>
            <a data-nav="recommendations" href="recommendations.html">${t('common.nav.recommendations')}</a>
            <a data-nav="profile" href="profile.html">${t('common.nav.profile')}</a>
            ${isAdmin ? `<a data-nav="admin" href="admin.html">${t('common.nav.admin')}</a>` : ''}` : '';
    const guestLinks = user ? '' : `
            <a data-nav="login" href="login.html">${t('common.nav.login')}</a>
            <a data-nav="register" href="register.html">${t('common.nav.register')}</a>`;
    const roleLabel = user?.role === 'ADMIN' ? t('common.userRoleAdmin') : t('common.userRoleUser');

    return `
      <header class="topbar">
        <div class="topbar-inner">
          <div class="topbar-main">
            <a class="brand" href="${user ? 'index.html' : 'login.html'}">
              <span class="brand-mark" aria-hidden="true">
                <span class="brand-mark-core"></span>
              </span>
              <span class="brand-copy">
                <span class="brand-title">${t('common.appName')}</span>
                <span class="brand-subtitle">${t('common.appTagline')}</span>
              </span>
            </a>
            <div class="user-meta">
              <div class="language-switch" aria-label="${t('common.languageLabel')}">
                <span class="language-switch-label">${t('common.languageLabel')}</span>
                <div class="language-switch-group">
                  <button type="button" class="language-switch-btn${currentLocale() === 'zh-CN' ? ' active' : ''}" data-language-switch="zh-CN">${t('common.langZh')}</button>
                  <button type="button" class="language-switch-btn${currentLocale() === 'en-US' ? ' active' : ''}" data-language-switch="en-US">${t('common.langEn')}</button>
                </div>
              </div>
              <div class="user-chip" title="${escapeHtml(displayName)}${user ? ` · ${escapeHtml(roleLabel)}` : ''}">
                <span class="user-chip-name">${escapeHtml(displayName)}</span>
                ${user ? `<span class="user-chip-role">${escapeHtml(roleLabel)}</span>` : ''}
              </div>
              <button id="nav-logout-btn" class="ghost topbar-logout ${user ? '' : 'hidden'}">${t('common.nav.logout')}</button>
            </div>
          </div>
          <nav class="nav-links">${protectedLinks}${guestLinks}</nav>
        </div>
      </header>`;
  }

  function footerTemplate() {
    return `<footer class="footer"><div class="footer-inner">${t('common.footer')}</div></footer>`;
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

  function renderBookFallback(book) {
    const title = escapeHtml(book?.name || t('common.unknownBook'));
    const author = escapeHtml(book?.author?.name || t('common.unknownAuthor'));
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
    } catch (error) {
      book = {};
    }
    img.parentNode.innerHTML = renderBookFallback(book);
  }

  function renderBookImage(book) {
    const imageUrl = getBookImageUrl(book);
    if (!imageUrl) return renderBookFallback(book);
    const alt = book?.name || t('common.appName');
    const payload = escapeHtml(JSON.stringify({
      name: book?.name || '',
      author: { name: book?.author?.name || '' },
      category: { name: book?.category?.name || '' }
    }));
    return `<img src="${imageUrl}" alt="${escapeHtml(alt)}" loading="lazy" referrerpolicy="no-referrer" data-book-payload="${payload}" onerror="window.BookUi.handleBookImageError(this)">`;
  }

  function normalizeStoredBook(book) {
    if (!book || book.id === null || book.id === undefined) {
      return null;
    }
    return {
      id: Number(book.id),
      name: book.name || t('common.unknownBook'),
      imageUrl: getBookImageUrl(book),
      isbn: book.isbn || '',
      rate: book.rate ?? null,
      usersRateCount: book.usersRateCount ?? null,
      description: book.description || '',
      availableCopies: book.availableCopies ?? null,
      totalCopies: book.totalCopies ?? null,
      author: book.author ? { id: book.author.id ?? null, name: book.author.name || '' } : null,
      category: book.category ? { id: book.category.id ?? null, name: book.category.name || '' } : null,
      publisher: book.publisher ? { id: book.publisher.id ?? null, name: book.publisher.name || '' } : null,
      recommendationSource: book.recommendationSource || '',
      recommendationReason: book.recommendationReason || ''
    };
  }

  function getSavedBooks() {
    const list = parseStorageJson(SAVED_BOOKS_KEY, []);
    return Array.isArray(list) ? list : [];
  }

  function persistSavedBooks(list) {
    localStorage.setItem(SAVED_BOOKS_KEY, JSON.stringify(list));
    document.dispatchEvent(new CustomEvent('book:saved-updated', {
      detail: { books: list }
    }));
  }

  function isBookSaved(bookId) {
    return getSavedBooks().some(item => String(item.id) === String(bookId));
  }

  function toggleSavedBook(book) {
    const normalized = normalizeStoredBook(book);
    if (!normalized) {
      return { saved: false, books: getSavedBooks() };
    }
    const current = getSavedBooks();
    const exists = current.some(item => String(item.id) === String(normalized.id));
    const next = exists
      ? current.filter(item => String(item.id) !== String(normalized.id))
      : [normalized, ...current].slice(0, 24);
    persistSavedBooks(next);
    return { saved: !exists, books: next };
  }

  function getRecentViewedBooks() {
    const list = parseStorageJson(RECENT_VIEWED_KEY, []);
    return Array.isArray(list) ? list : [];
  }

  function saveRecentView(book) {
    const normalized = normalizeStoredBook(book);
    if (!normalized) return;
    const next = getRecentViewedBooks()
      .filter(item => String(item.id) !== String(normalized.id));
    next.unshift({
      ...normalized,
      viewedAt: new Date().toISOString()
    });
    const trimmed = next.slice(0, 18);
    localStorage.setItem(RECENT_VIEWED_KEY, JSON.stringify(trimmed));
    document.dispatchEvent(new CustomEvent('book:recent-viewed-updated', {
      detail: { books: trimmed }
    }));
  }

  function getMonthlyGoal() {
    const goal = parseStorageJson(MONTHLY_GOAL_KEY, null);
    return {
      borrowTarget: Number(goal?.borrowTarget) > 0 ? Number(goal.borrowTarget) : 4,
      ratingTarget: Number(goal?.ratingTarget) > 0 ? Number(goal.ratingTarget) : 2
    };
  }

  function saveMonthlyGoal(goal) {
    const normalized = {
      borrowTarget: Math.max(1, Number(goal?.borrowTarget) || 4),
      ratingTarget: Math.max(1, Number(goal?.ratingTarget) || 2)
    };
    localStorage.setItem(MONTHLY_GOAL_KEY, JSON.stringify(normalized));
    document.dispatchEvent(new CustomEvent('book:goal-updated', {
      detail: normalized
    }));
    return normalized;
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

  function updateSaveButtonLabel(button) {
    if (!button) return;
    const payload = button.dataset.bookPayload;
    let book = null;
    try {
      book = payload ? JSON.parse(payload) : null;
    } catch (error) {
      book = null;
    }
    const saved = isBookSaved(book?.id);
    button.textContent = saved ? t('common.removeReadLater') : t('common.readLater');
    button.classList.toggle('soft', saved);
  }

  function refreshSaveButtons(root = document) {
    root.querySelectorAll('[data-save-book="1"]').forEach(updateSaveButtonLabel);
  }

  function refreshScrollShells(root = document) {
    root.querySelectorAll('.hover-scroll-shell').forEach(shell => {
      const scrollWindow = shell.querySelector('.hover-scroll-window');
      if (!scrollWindow) return;
      const canScroll = scrollWindow.scrollHeight > scrollWindow.clientHeight + 4;
      shell.classList.toggle('can-scroll', canScroll);
    });
  }

  function bindStorageActions() {
    if (storageActionBound) return;
    storageActionBound = true;
    document.addEventListener('click', event => {
      if (!event.target || typeof event.target.closest !== 'function') return;
      const button = event.target.closest('[data-save-book="1"]');
      if (!button) return;
      let book = null;
      try {
        book = JSON.parse(button.dataset.bookPayload || 'null');
      } catch (error) {
        book = null;
      }
      const result = toggleSavedBook(book);
      updateSaveButtonLabel(button);
      const message = result.saved ? t('common.savedAdded') : t('common.savedRemoved');
      document.dispatchEvent(new CustomEvent('book:toast', {
        detail: { message }
      }));
    });
  }

  function injectLayout() {
    const shell = document.querySelector('.app-shell');
    if (!shell) return;
    shell.insertAdjacentHTML('afterbegin', navTemplate());
    shell.insertAdjacentHTML('beforeend', footerTemplate());
    window.BookI18n?.applyI18n();
    setActiveNav();
    bindBehaviorTracker();
    bindStorageActions();
    refreshSaveButtons();
    refreshScrollShells();
    window.addEventListener('resize', () => refreshScrollShells());
    document.querySelectorAll('[data-language-switch]').forEach(button => {
      button.addEventListener('click', () => {
        window.BookI18n?.setLanguage(button.dataset.languageSwitch);
      });
    });
    const logoutBtn = document.getElementById('nav-logout-btn');
    if (logoutBtn) {
      logoutBtn.addEventListener('click', async () => {
        await window.BookApi.logout();
        window.location.href = 'login.html';
      });
    }
  }

  function renderBookCard(book, options = {}) {
    const id = book?.id ?? '';
    const authorId = book?.author?.id ?? '';
    const categoryName = localizeCategoryName(book?.category?.name);
    const isbnLabel = book?.isbn ? `<span class="tag">ISBN: ${escapeHtml(book.isbn)}</span>` : '';
    const rate = book?.rate ?? '-';
    const totalCopies = book?.totalCopies ?? '-';
    const availableCopies = book?.availableCopies ?? '-';
    const description = book?.description || t('common.noDescription');
    const reason = localizeRecommendationReason(options.reason || book?.recommendationReason || options.comment || '');
    const source = options.source || book?.recommendationSource || '';
    const actionType = options.actionType || (source.startsWith('recommendation:') ? 'RECOMMENDATION_CLICK' : 'BOOK_DETAIL_CLICK');
    const sourceLabel = localizeRecommendationTitle(options.sourceLabel || source);
    const searchKeyword = options.searchKeyword || '';
    const detailHref = buildBookDetailHref(id, { source, reason });
    const normalizedBook = normalizeStoredBook(book) || { id };
    const savePayload = escapeHtml(JSON.stringify(normalizedBook));
    const hitMeta = (sourceLabel || reason) ? `
      <div class="book-hit-meta">
        ${sourceLabel ? `<span class="tag source-chip">${escapeHtml(t('common.source', { value: sourceLabel }))}</span>` : ''}
        ${reason ? `<span class="tag reason-chip">${escapeHtml(t('common.reason', { value: reason }))}</span>` : ''}
      </div>` : '';

    return `
      <article class="card book-card">
        <div class="book-cover">${renderBookImage(book)}</div>
        <div>
          <h3 class="book-title">${escapeHtml(book?.name || t('common.unknownBook'))}</h3>
          <div class="book-meta">${escapeHtml(t('common.author'))}: ${escapeHtml(book?.author?.name || t('common.unknownAuthor'))}</div>
        </div>
        <div class="tags">
          ${isbnLabel}
          <span class="tag">${escapeHtml(t('common.category'))}: ${escapeHtml(categoryName)}</span>
          <span class="tag">${escapeHtml(t('common.rating'))}: ${escapeHtml(rate)}</span>
          <span class="tag">${escapeHtml(t('common.pages'))}: ${escapeHtml(book?.pagesNumber ?? '-')}</span>
          <span class="tag">${escapeHtml(t('common.availableCopies'))}: ${escapeHtml(`${availableCopies}/${totalCopies}`)}</span>
        </div>
        <div class="muted">${escapeHtml(description.slice(0, 100))}${description.length > 100 ? '...' : ''}</div>
        ${hitMeta}
        <div class="book-actions">
          <a href="${detailHref}"
             class="action-link primary"
             data-behavior-track="1"
             data-action-type="${escapeHtml(actionType)}"
             data-book-id="${escapeHtml(id)}"
             data-source="${escapeHtml(source)}"
             data-reason="${escapeHtml(reason)}"
             data-keyword="${escapeHtml(searchKeyword)}">${escapeHtml(t('common.viewDetail'))}</a>
          <a href="rate-book.html?bookId=${id}" class="action-link">${escapeHtml(t('common.rateBook'))}</a>
          <button type="button" class="action-link" data-save-book="1" data-book-payload="${savePayload}">${escapeHtml(t('common.readLater'))}</button>
          ${authorId ? `<a href="books.html?authorId=${authorId}" class="action-link">${escapeHtml(t('common.sameAuthorBooks'))}</a>` : ''}
        </div>
      </article>`;
  }

  function renderRecommendationShelves(overview, options = {}) {
    const shelves = Array.isArray(overview?.shelves) ? overview.shelves : [];
    const emptyMessage = options.emptyMessage || t('common.emptyRecommendation');
    if (!shelves.length) {
      return `<div class="card muted">${escapeHtml(emptyMessage)}</div>`;
    }

    return shelves.map((shelf, index) => {
      const resolvedScrollSize = typeof options.getShelfScrollSize === 'function'
        ? options.getShelfScrollSize(shelf, index)
        : (Array.isArray(options.shelfScrollSizes) ? options.shelfScrollSizes[index] : options.shelfScrollSize);
      const listClassName = ['book-list'];
      if (resolvedScrollSize) {
        listClassName.push('hover-scroll-window', resolvedScrollSize);
      }

      const booksMarkup = (Array.isArray(shelf.books) ? shelf.books : []).map(book => renderBookCard(book, {
        source: `recommendation:${shelf.key || 'overview'}`,
        sourceLabel: shelf.title || shelf.key || t('common.recommendationShelf'),
        reason: book?.recommendationReason || shelf.description || '',
        actionType: 'RECOMMENDATION_CLICK'
      })).join('');

      const listMarkup = `
        <div class="${listClassName.join(' ')}">
          ${booksMarkup}
        </div>`;

      return `
      <section class="recommend-shelf">
        <div class="section-head">
          <div>
            <h2>${escapeHtml(localizeRecommendationTitle(shelf.title || t('common.recommendationShelf')))}</h2>
            <div class="muted">${escapeHtml(localizeRecommendationDescription(shelf.description || ''))}</div>
          </div>
        </div>
        ${resolvedScrollSize ? `<div class="hover-scroll-shell recommend-scroll-shell">${listMarkup}</div>` : listMarkup}
      </section>`;
    }).join('');
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
    escapeHtml,
    injectLayout,
    showMessage,
    hideMessage,
    getBookImageUrl,
    handleBookImageError,
    renderBookImage,
    renderBookCard,
    renderRecommendationShelves,
    localizeRecommendationTitle,
    localizeRecommendationDescription,
    localizeCategoryName,
    localizeReadingLevel,
    buildBookDetailHref,
    getSavedBooks,
    isBookSaved,
    toggleSavedBook,
    refreshSaveButtons,
    refreshScrollShells,
    getRecentViewedBooks,
    saveRecentView,
    getMonthlyGoal,
    saveMonthlyGoal,
    requireLogin,
    requireAdmin,
    redirectIfLoggedIn
  };
})();
