const escapeHtml = window.BookUi.escapeHtml;
const t = window.BookI18n.t;
const isChinese = () => window.BookI18n.isChinese();
const currentLocale = () => window.BookI18n.getLocale();

const CATEGORY_BLURBS = {
  'Science Fiction': {
    zh: '关注未来世界、技术想象与宇宙探索，适合从大胆设定里寻找阅读灵感。',
    en: 'Focuses on future worlds, speculative technology, and space exploration, ideal for readers who want bold ideas and imagination.'
  },
  'Horror': {
    zh: '从悬疑氛围、惊悚情节到心理压迫感，适合偏爱强烈情绪体验的读者。',
    en: 'Ranges from suspense and shock to psychological pressure, suited for readers who enjoy intense emotional atmosphere.'
  },
  'Classic': {
    zh: '收录经久不衰的文学作品，适合从经典文本里回看人物、时代与表达。',
    en: 'Built around enduring literary works, useful when revisiting character, era, and craft through classics.'
  },
  'Action and Adventure': {
    zh: '以节奏感和冒险旅程见长，适合喜欢剧情推进与探索感的读者。',
    en: 'Strong on pace and adventure, ideal for readers who want plot momentum and a sense of exploration.'
  },
  'Romantic': {
    zh: '围绕情感关系与人物成长展开，适合想快速进入故事情绪的阅读场景。',
    en: 'Centered on relationships and character growth, good when you want to get into a story mood quickly.'
  },
  'Kids': {
    zh: '面向轻松阅读与启蒙体验，适合从趣味性和陪伴感出发挑选图书。',
    en: 'Designed for light reading and early reading experiences, with a stronger focus on fun and companionship.'
  },
  'History': {
    zh: '从人物、事件和时代切面理解历史，适合喜欢主题式阅读与知识延伸。',
    en: 'Understands history through people, events, and eras, suitable for readers who enjoy thematic learning.'
  },
  'Sport': {
    zh: '聚焦竞技、训练与体育精神，适合想从兴趣主题切入阅读的读者。',
    en: 'Focused on competition, training, and sportsmanship, useful when reading through an interest-driven theme.'
  }
};

const homeState = {
  user: null,
  categories: [],
  readingPreferenceStatus: null,
  overview: { shelves: [] },
  dashboard: {
    readingStreakDays: 0,
    activeLoansCount: 0,
    activeReservationsCount: 0,
    dueSoonCount: 0,
    overdueCount: 0,
    monthlyBorrowCount: 0,
    monthlyRatingCount: 0,
    readingLevel: null,
    preferredCategories: [],
    dueSoonLoans: [],
    activeReservations: [],
    recentViewedBooks: [],
    hotKeywords: [],
    hotCategories: [],
    newArrivalBooks: [],
    popularBooks: []
  }
};

let homeMessageTimer = null;
const preferenceDraftCategoryIds = new Set();
let preferenceDraftReadingLevel = 'BEGINNER';

function categoryBlurb(name) {
  const entry = CATEGORY_BLURBS[name];
  if (entry) {
    return isChinese() ? entry.zh : entry.en;
  }
  return isChinese()
    ? '点击进入这一分类，快速查看相关图书、筛选条件和推荐结果。'
    : 'Open this category to jump into related books, continue filtering, and explore recommendation results.';
}

function showTransientMessage(type, message, timeout = 2400) {
  if (!message) return;
  BookUi.showMessage('home-message', type, message);
  if (homeMessageTimer) {
    window.clearTimeout(homeMessageTimer);
  }
  homeMessageTimer = window.setTimeout(() => {
    BookUi.hideMessage('home-message');
  }, timeout);
}

function hasUsefulReadingPreference(status) {
  return Boolean(status?.initialized) && Number(status?.preferredCategoryCount || 0) > 0;
}

function getCategoryId(category) {
  const id = Number(category?.id);
  return Number.isFinite(id) && id > 0 ? id : null;
}

function renderPreferenceCategoryOptions() {
  const options = (homeState.categories || []).slice(0, 16);
  if (!options.length) {
    return `<div class="muted">${escapeHtml(isChinese() ? '分类数据暂时不可用，请稍后到个人资料页完善偏好。' : 'Category data is temporarily unavailable. Please update preferences from Profile later.')}</div>`;
  }
  return options.map(category => {
    const id = getCategoryId(category);
    if (!id) return '';
    const active = preferenceDraftCategoryIds.has(id);
    const name = BookUi.localizeCategoryName(category?.name);
    return `
      <button class="preference-chip${active ? ' active' : ''}" type="button" data-preference-category-id="${id}">
        ${escapeHtml(name)}
      </button>
    `;
  }).join('');
}

function ensureReadingPreferencePrompt() {
  let container = document.getElementById('reading-preference-onboarding');
  if (container) return container;

  container = document.createElement('section');
  container.id = 'reading-preference-onboarding';
  container.className = 'reading-preference-onboarding hidden';
  const homeMessage = document.getElementById('home-message');
  homeMessage?.insertAdjacentElement('afterend', container);
  return container;
}

function renderReadingPreferencePrompt() {
  const container = ensureReadingPreferencePrompt();
  if (hasUsefulReadingPreference(homeState.readingPreferenceStatus)) {
    container.classList.add('hidden');
    container.innerHTML = '';
    return;
  }

  container.classList.remove('hidden');
  container.innerHTML = `
    <div class="preference-onboarding-card">
      <div>
        <div class="panel-kicker">${escapeHtml(isChinese() ? '新用户兴趣初始化' : 'Preference setup')}</div>
        <h2>${escapeHtml(isChinese() ? '先选几个阅读偏好，推荐会更稳定' : 'Choose a few interests to stabilize recommendations')}</h2>
        <p class="muted">${escapeHtml(isChinese() ? '这里会写入你的阅读等级和偏好分类，用于首页推荐、可解释推荐和后续检索排序。' : 'This saves reading level and preferred categories for homepage recommendations, explanations, and future ranking signals.')}</p>
      </div>
      <form id="reading-preference-form" class="preference-onboarding-form">
        <label class="label" for="home-reading-level">${escapeHtml(isChinese() ? '阅读等级' : 'Reading level')}</label>
        <select id="home-reading-level">
          <option value="BEGINNER"${preferenceDraftReadingLevel === 'BEGINNER' ? ' selected' : ''}>${escapeHtml(t('common.readLevelBeginner'))}</option>
          <option value="INTERMEDIATE"${preferenceDraftReadingLevel === 'INTERMEDIATE' ? ' selected' : ''}>${escapeHtml(t('common.readLevelIntermediate'))}</option>
          <option value="EXPERT"${preferenceDraftReadingLevel === 'EXPERT' ? ' selected' : ''}>${escapeHtml(t('common.readLevelExpert'))}</option>
        </select>
        <div class="preference-picker-head">
          <span class="label">${escapeHtml(isChinese() ? '偏好分类' : 'Preferred categories')}</span>
          <span class="muted">${escapeHtml(isChinese() ? '至少选择 1 个' : 'Select at least one')}</span>
        </div>
        <div class="preference-chip-grid" id="home-preference-category-grid">
          ${renderPreferenceCategoryOptions()}
        </div>
        <div class="preference-onboarding-actions">
          <button class="primary" type="submit">${escapeHtml(isChinese() ? '保存偏好并刷新推荐' : 'Save and refresh recommendations')}</button>
          <a class="button-link soft" href="profile.html">${escapeHtml(isChinese() ? '去个人资料页维护' : 'Open profile')}</a>
        </div>
      </form>
    </div>
  `;
}

async function refreshRecommendationPanelsAfterPreferenceSave() {
  const [recommendResult, dashboardResult] = await Promise.allSettled([
    BookApi.apiRequest('/api/resources/recommendations/overview'),
    BookApi.apiRequest('/api/user/home-dashboard')
  ]);

  if (recommendResult.status === 'fulfilled') {
    homeState.overview = recommendResult.value?.body || { shelves: [] };
  }
  if (dashboardResult.status === 'fulfilled') {
    homeState.dashboard = {
      ...homeState.dashboard,
      ...(dashboardResult.value?.body || {})
    };
  }

  const recommendSummary = document.getElementById('recommend-summary');
  const recommendWrap = document.getElementById('recommend-list');
  if (recommendSummary) {
    recommendSummary.innerHTML = renderRecommendationSummary(homeState.overview);
  }
  if (recommendWrap) {
    recommendWrap.innerHTML = BookUi.renderRecommendationShelves(buildPreviewOverview(homeState.overview), {
      emptyMessage: isChinese() ? '暂无推荐数据。' : 'No recommendation data available.'
    });
  }
  renderInsightCards();
  BookUi.refreshSaveButtons(document);
}

function toDisplayDateTime(value) {
  if (!value) return '-';
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return String(value);
  return date.toLocaleString(currentLocale(), {
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });
}

function toDateOnly(value) {
  if (!value) return '-';
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return String(value);
  return date.toLocaleDateString(currentLocale(), {
    month: 'numeric',
    day: 'numeric'
  });
}

function diffDaysFromNow(value) {
  if (!value) return null;
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return null;
  const today = new Date();
  const start = new Date(today.getFullYear(), today.getMonth(), today.getDate()).getTime();
  const target = new Date(date.getFullYear(), date.getMonth(), date.getDate()).getTime();
  return Math.round((target - start) / (24 * 60 * 60 * 1000));
}

function loanDueCopy(loan) {
  const diff = diffDaysFromNow(loan?.dueDate);
  if (diff === null) return isChinese() ? '到期时间待确认' : 'Due date pending confirmation';
  if (diff < 0) return isChinese() ? `已逾期 ${Math.abs(diff)} 天` : `${Math.abs(diff)} day(s) overdue`;
  if (diff === 0) return isChinese() ? '今天到期' : 'Due today';
  return isChinese() ? `还有 ${diff} 天到期` : `${diff} day(s) until due`;
}

function renderHomeStats(user, categories, overview, dashboard) {
  const shelves = Array.isArray(overview?.shelves) ? overview.shelves : [];
  const stats = [
    {
      label: isChinese() ? '推荐书架' : 'Recommendation shelves',
      value: shelves.length,
      note: isChinese() ? '覆盖热门推荐、偏好匹配与相似图书' : 'Covers trending shelves, preference matches, and similar books'
    },
    {
      label: isChinese() ? '图书分类' : 'Book categories',
      value: categories.length,
      note: isChinese() ? '支持从分类入口继续浏览与筛选' : 'Lets you continue browsing and filtering from category entry points'
    },
    {
      label: isChinese() ? '待处理借阅' : 'Borrowings to handle',
      value: Number(dashboard?.dueSoonCount || 0) + Number(dashboard?.overdueCount || 0),
      note: isChinese() ? '临近到期与逾期提醒会集中展示' : 'Due-soon and overdue reminders are collected here'
    },
    {
      label: isChinese() ? '当前身份' : 'Current role',
      value: user?.role === 'ADMIN' ? (isChinese() ? '管理员' : 'System Admin') : (isChinese() ? '读者' : 'Reader'),
      note: user?.role === 'ADMIN'
        ? (isChinese() ? '可继续进入后台维护与管理' : 'You can continue into the admin console for maintenance and management')
        : (isChinese()
          ? `本月已借阅 ${dashboard?.monthlyBorrowCount || 0} 本 / 已评分 ${dashboard?.monthlyRatingCount || 0} 本`
          : `${dashboard?.monthlyBorrowCount || 0} borrowed / ${dashboard?.monthlyRatingCount || 0} rated this month`)
    }
  ];

  return stats.map(item => `
    <div class="home-stat-card">
      <span>${escapeHtml(item.label)}</span>
      <strong>${escapeHtml(item.value)}</strong>
      <span>${escapeHtml(item.note)}</span>
    </div>
  `).join('');
}

function renderCategoryCards(categories) {
  if (!categories.length) {
    return `<div class="muted">${escapeHtml(isChinese() ? '暂无分类数据。' : 'No category data available.')}</div>`;
  }

  return categories.map(item => {
    const rawName = item?.name || String(item || '');
    const displayName = BookUi.localizeCategoryName(rawName);
    const href = `books.html?categoryId=${encodeURIComponent(item.id)}`;
    return `
      <a class="category-card" href="${href}">
        <div class="category-card-header">
          <h3>${escapeHtml(displayName)}</h3>
          <span class="tag">${escapeHtml(isChinese() ? '进入分类' : 'Open category')}</span>
        </div>
        <p>${escapeHtml(categoryBlurb(rawName))}</p>
        <span class="category-card-action">${escapeHtml(isChinese() ? '查看这一分类的图书' : 'View books in this category')}</span>
      </a>
    `;
  }).join('');
}

function buildPreviewOverview(overview) {
  const shelves = Array.isArray(overview?.shelves) ? overview.shelves : [];
  return {
    title: overview?.title || (isChinese() ? '推荐预览' : 'Recommendation preview'),
    shelves: shelves.slice(0, 2).map(shelf => ({
      ...shelf,
      books: Array.isArray(shelf.books) ? shelf.books.slice(0, 2) : []
    }))
  };
}

function renderRecommendationSummary(overview) {
  const shelves = Array.isArray(overview?.shelves) ? overview.shelves : [];
  if (!shelves.length) {
    return `
      <div class="panel-kicker">${escapeHtml(isChinese() ? '推荐摘要' : 'Recommendation summary')}</div>
      <h3>${escapeHtml(isChinese() ? '暂时还没有推荐结果' : 'No recommendation results yet')}</h3>
      <p class="muted">${escapeHtml(isChinese() ? '可以先浏览图书、补充阅读偏好或进行评分，系统会逐步生成更贴近你的推荐。' : 'You can browse books, refine your reading preferences, or rate books first. The system will gradually shape recommendations that fit you better.')}</p>
      <div class="recommend-summary-actions">
        <a class="button-link" href="profile.html">${escapeHtml(isChinese() ? '完善阅读偏好' : 'Complete reading preferences')}</a>
        <a class="button-link" href="books.html">${escapeHtml(isChinese() ? '先去浏览图书' : 'Browse books first')}</a>
      </div>
    `;
  }

  const featuredShelf = shelves[0];
  const shelfList = shelves.slice(0, 4).map(shelf => `
    <div class="recommend-summary-item">
      <strong>
        <span>${escapeHtml(BookUi.localizeRecommendationTitle ? BookUi.localizeRecommendationTitle(shelf.title || '') : shelf.title || (isChinese() ? '推荐书架' : 'Recommendation shelf'))}</span>
        <span>${escapeHtml((shelf.books || []).length)} ${escapeHtml(isChinese() ? '本' : 'books')}</span>
      </strong>
      <span>${escapeHtml(BookUi.localizeRecommendationDescription ? BookUi.localizeRecommendationDescription(shelf.description || '') : (shelf.description || (isChinese() ? '这一书架会根据你的阅读记录与偏好持续更新。' : 'This shelf keeps updating according to your reading history and preferences.')))}</span>
    </div>
  `).join('');

  return `
    <div class="panel-kicker">${escapeHtml(isChinese() ? '推荐摘要' : 'Recommendation summary')}</div>
    <h3>${escapeHtml(BookUi.localizeRecommendationTitle ? BookUi.localizeRecommendationTitle(overview?.title || '') : (overview?.title || (isChinese() ? '推荐书架' : 'Recommendation shelf')))}</h3>
    <div class="recommend-summary-highlight">
      <strong>${escapeHtml(BookUi.localizeRecommendationTitle ? BookUi.localizeRecommendationTitle(featuredShelf.title || '') : (featuredShelf.title || (isChinese() ? '精选推荐' : 'Featured picks')))}</strong>
      <p>${escapeHtml(BookUi.localizeRecommendationDescription ? BookUi.localizeRecommendationDescription(featuredShelf.description || '') : (featuredShelf.description || (isChinese() ? '从当前推荐结果中优先整理出更值得先看的内容。' : 'Prioritized picks from the current recommendation result.')))}</p>
      <span class="tag">${escapeHtml(isChinese() ? '本次重点推荐' : 'Featured this time')}</span>
    </div>
    <div class="recommend-summary-list">${shelfList}</div>
    <div class="recommend-summary-actions">
      <a class="button-link primary" href="recommendations.html">${escapeHtml(isChinese() ? '查看全部推荐' : 'View all recommendations')}</a>
      <a class="button-link" href="books.html">${escapeHtml(isChinese() ? '继续浏览图书' : 'Continue browsing books')}</a>
    </div>
  `;
}

function applyHomeHeader(user, categories, overview, dashboard) {
  const userName = document.getElementById('home-user-name');
  const userCopy = document.getElementById('home-user-copy');
  const statWrap = document.getElementById('home-summary-stats');

  const displayName = `${user?.firstName || ''} ${user?.lastName || ''}`.trim() || (isChinese() ? '欢迎回来' : 'Welcome back');
  const readingLevel = dashboard?.readingLevel ? BookUi.localizeReadingLevel(dashboard.readingLevel) : (isChinese() ? '尚未设置阅读档案' : 'no reading profile yet');
  userName.textContent = isChinese()
    ? `${displayName}，从这里继续今天的阅读`
    : `${displayName}, continue today’s reading from here`;
  userCopy.textContent = isChinese()
    ? `你的阅读画像当前为“${readingLevel}”，首页会优先整理推荐、提醒和近期行为，减少来回跳转。`
    : `Your reading profile is currently "${readingLevel}". The homepage prioritizes recommendations, reminders, and recent activity so you can move around less.`;
  statWrap.innerHTML = renderHomeStats(user, categories, overview, dashboard);
}

function updateLiveClock() {
  const timeEl = document.getElementById('home-live-time');
  const dateEl = document.getElementById('home-live-date');
  if (!timeEl || !dateEl) return;

  const now = new Date();
  timeEl.textContent = now.toLocaleTimeString(currentLocale(), {
    hour: '2-digit',
    minute: '2-digit'
  });
  dateEl.textContent = now.toLocaleDateString(currentLocale(), {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    weekday: 'long'
  });

  updateReadingTip(now);
  renderDailySuggestion(now);
}

function getWeatherVisual(code) {
  if (code === 0 || code === 1) {
    return { label: isChinese() ? '晴朗' : 'Sunny', icon: '☀', className: 'weather-sun' };
  }
  if (code === 2 || code === 3) {
    return { label: isChinese() ? '多云' : 'Cloudy', icon: '⛅', className: 'weather-cloud' };
  }
  if (code === 45 || code === 48) {
    return { label: isChinese() ? '有雾' : 'Foggy', icon: '🌫', className: 'weather-fog' };
  }
  if ([51, 53, 55, 61, 63, 65, 80, 81, 82].includes(code)) {
    return { label: isChinese() ? '下雨' : 'Rainy', icon: '🌧', className: 'weather-rain' };
  }
  if ([71, 73, 75].includes(code)) {
    return { label: isChinese() ? '降雪' : 'Snow', icon: '❄', className: 'weather-snow' };
  }
  if (code === 95) {
    return { label: isChinese() ? '雷暴' : 'Thunderstorm', icon: '⛈', className: 'weather-storm' };
  }
  return { label: isChinese() ? '天气更新中' : 'Updating weather', icon: '☁', className: 'weather-neutral' };
}

function setWeatherVisual(visual, temperature, copy) {
  const iconEl = document.getElementById('home-weather-icon');
  const textEl = document.getElementById('home-weather-text');
  const copyEl = document.getElementById('home-weather-copy');
  if (!iconEl || !textEl || !copyEl) return;

  iconEl.textContent = visual.icon;
  iconEl.className = `weather-icon ${visual.className}`;
  textEl.textContent = temperature === null || temperature === undefined
    ? visual.label
    : `${visual.label} ${temperature}°C`;
  copyEl.textContent = copy;
}

const WEATHER_COORDS_KEY = 'book_weather_coords_cache';
const WEATHER_SNAPSHOT_KEY = 'book_weather_snapshot_cache';
const WEATHER_SNAPSHOT_TTL_MS = 30 * 60 * 1000;
let weatherRenderPriority = -1;

function loadCachedWeatherCoords() {
  try {
    const raw = window.localStorage.getItem(WEATHER_COORDS_KEY);
    if (!raw) return null;
    const parsed = JSON.parse(raw);
    const latitude = Number(parsed?.latitude);
    const longitude = Number(parsed?.longitude);
    if (!Number.isFinite(latitude) || !Number.isFinite(longitude)) {
      return null;
    }
    return {
      latitude,
      longitude,
      source: parsed?.source || 'cache'
    };
  } catch (error) {
    return null;
  }
}

function loadCachedWeatherSnapshot() {
  try {
    const raw = window.localStorage.getItem(WEATHER_SNAPSHOT_KEY);
    if (!raw) return null;
    const parsed = JSON.parse(raw);
    const savedAt = Number(parsed?.savedAt);
    if (!savedAt || Date.now() - savedAt > WEATHER_SNAPSHOT_TTL_MS) {
      return null;
    }
    const label = String(parsed?.visual?.label || '').trim();
    const icon = String(parsed?.visual?.icon || '').trim();
    const className = String(parsed?.visual?.className || '').trim();
    if (!label || !icon || !className) {
      return null;
    }
    return {
      visual: {
        label,
        icon,
        className
      },
      temperature: parsed?.temperature,
      source: parsed?.source || 'cache',
      savedAt
    };
  } catch (error) {
    return null;
  }
}

function saveWeatherCoords(latitude, longitude, source = 'browser') {
  if (!Number.isFinite(latitude) || !Number.isFinite(longitude)) return;
  try {
    window.localStorage.setItem(WEATHER_COORDS_KEY, JSON.stringify({
      latitude,
      longitude,
      source,
      savedAt: Date.now()
    }));
  } catch (error) {
    console.warn('weather coords cache failed:', error.message);
  }
}

function saveWeatherSnapshot(weatherResult, source = 'browser') {
  if (!weatherResult?.visual?.label || !weatherResult?.visual?.icon || !weatherResult?.visual?.className) return;
  try {
    window.localStorage.setItem(WEATHER_SNAPSHOT_KEY, JSON.stringify({
      visual: weatherResult.visual,
      temperature: weatherResult.temperature,
      source,
      savedAt: Date.now()
    }));
  } catch (error) {
    console.warn('weather snapshot cache failed:', error.message);
  }
}

function getWeatherRenderPriority(source) {
  if (source === 'browser') return 3;
  if (source === 'ip') return 2;
  if (source === 'cache') return 1;
  if (source === 'cache-snapshot') return 0;
  return 0;
}

function buildWeatherCopy(source, options = {}) {
  if (options.fromSnapshot) {
    return isChinese()
      ? '先显示最近一次天气记录，系统正在刷新当前位置天气。'
      : 'Showing the most recent weather snapshot first while refreshing your current local weather.';
  }
  if (source === 'ip') {
    return isChinese()
      ? '已根据当前网络位置近似获取天气，定位完成后会自动刷新为更精确结果。'
      : 'Weather is based on an approximate network location and will refresh automatically if precise device location becomes available.';
  }
  if (source === 'cache') {
    return isChinese()
      ? '已根据最近一次定位快速刷新天气，当前位置结果返回后会自动覆盖。'
      : 'Weather was refreshed from your last known location and will be replaced automatically if current location data arrives.';
  }
  return isChinese()
    ? '天气信息会根据你当前设备定位自动更新。'
    : 'Weather updates automatically according to your device location.';
}

function applyWeatherResult(weatherResult, source = 'browser', options = {}) {
  if (!weatherResult?.visual) return false;
  const incomingPriority = getWeatherRenderPriority(source);
  if (incomingPriority < weatherRenderPriority) {
    return false;
  }
  weatherRenderPriority = incomingPriority;
  setWeatherVisual(weatherResult.visual, weatherResult.temperature, buildWeatherCopy(source, options));
  renderDailySuggestion(new Date(), weatherResult.visual.label);
  if (!options.fromSnapshot) {
    saveWeatherSnapshot(weatherResult, source);
  }
  return true;
}

async function fetchWeatherByCoords(latitude, longitude, source = 'browser') {
  const weatherProviders = [
    async () => {
      const response = await fetch(
        `https://api.open-meteo.com/v1/forecast?latitude=${latitude}&longitude=${longitude}&current=temperature_2m,weather_code&timezone=auto`
      );
      if (!response.ok) {
        throw new Error(`open-meteo ${response.status}`);
      }
      const data = await response.json();
      const current = data?.current || {};
      return {
        visual: getWeatherVisual(current.weather_code),
        temperature: current.temperature_2m
      };
    },
    async () => {
      const response = await fetch(`https://wttr.in/${latitude},${longitude}?format=j1`);
      if (!response.ok) {
        throw new Error(`wttr ${response.status}`);
      }
      const data = await response.json();
      const current = Array.isArray(data?.current_condition) ? data.current_condition[0] : null;
      const label = current?.weatherDesc?.[0]?.value || current?.weatherCode || null;
      const temp = current?.temp_C;
      if (!label || temp === undefined) {
        throw new Error('wttr data missing');
      }
      const lower = String(label).toLowerCase();
      let visual = { label, icon: '☁', className: 'weather-neutral' };
      if (lower.includes('sun') || lower.includes('clear')) {
        visual = { label: isChinese() ? '晴朗' : 'Sunny', icon: '☀', className: 'weather-sun' };
      } else if (lower.includes('cloud')) {
        visual = { label: isChinese() ? '多云' : 'Cloudy', icon: '⛅', className: 'weather-cloud' };
      } else if (lower.includes('fog') || lower.includes('mist')) {
        visual = { label: isChinese() ? '有雾' : 'Foggy', icon: '🌫', className: 'weather-fog' };
      } else if (lower.includes('rain') || lower.includes('drizzle')) {
        visual = { label: isChinese() ? '下雨' : 'Rainy', icon: '🌧', className: 'weather-rain' };
      } else if (lower.includes('snow') || lower.includes('sleet')) {
        visual = { label: isChinese() ? '降雪' : 'Snow', icon: '❄', className: 'weather-snow' };
      } else if (lower.includes('thunder')) {
        visual = { label: isChinese() ? '雷暴' : 'Thunderstorm', icon: '⛈', className: 'weather-storm' };
      }
      return {
        visual,
        temperature: temp
      };
    }
  ];

  let weatherResult = null;
  let lastError = null;
  for (const provider of weatherProviders) {
    try {
      weatherResult = await provider();
      break;
    } catch (error) {
      lastError = error;
      console.warn('weather provider failed:', error.message);
    }
  }
  if (!weatherResult) {
    throw lastError || new Error('weather request failed');
  }
  const copy = source === 'ip'
    ? (isChinese()
      ? '已根据当前网络位置近似获取天气，可能与精确定位有轻微偏差。'
      : 'Weather is based on an approximate network location and may differ slightly from precise device location.')
    : (isChinese()
      ? '天气信息会根据你当前设备定位自动更新。'
      : 'Weather updates automatically according to your device location.');
  setWeatherVisual(weatherResult.visual, weatherResult.temperature, copy);
  renderDailySuggestion(new Date(), weatherResult.visual.label);
  saveWeatherSnapshot(weatherResult, source);
  return weatherResult;
}

async function fetchWeatherByIp() {
  const geoProviders = [
    async () => {
      const response = await fetch('https://ipwho.is/');
      if (!response.ok) {
        throw new Error(`ipwhois ${response.status}`);
      }
      const data = await response.json();
      if (!data?.success) {
        throw new Error('ipwhois unsuccessful');
      }
      return {
        latitude: Number(data.latitude),
        longitude: Number(data.longitude)
      };
    },
    async () => {
      const response = await fetch('https://ipapi.co/json/');
      if (!response.ok) {
        throw new Error(`ipapi ${response.status}`);
      }
      const data = await response.json();
      return {
        latitude: Number(data?.latitude),
        longitude: Number(data?.longitude)
      };
    }
  ];

  let coords = null;
  let lastError = null;
  for (const provider of geoProviders) {
    try {
      coords = await provider();
      if (Number.isFinite(coords.latitude) && Number.isFinite(coords.longitude)) {
        break;
      }
      coords = null;
    } catch (error) {
      lastError = error;
      console.warn('ip geolocation provider failed:', error.message);
    }
  }
  if (!coords) {
    throw lastError || new Error('ip geolocation coordinates missing');
  }
  saveWeatherCoords(coords.latitude, coords.longitude, 'ip');
  return fetchWeatherByCoords(coords.latitude, coords.longitude, 'ip');
}

function updateReadingTip(now = new Date()) {
  const titleEl = document.getElementById('home-reading-tip-title');
  const copyEl = document.getElementById('home-reading-tip-copy');
  if (!titleEl || !copyEl) return;

  const hour = now.getHours();
  if (hour < 9) {
    titleEl.textContent = isChinese() ? '晨间轻阅读' : 'Light morning reading';
    copyEl.textContent = isChinese()
      ? '适合先看推荐摘要或短篇图书，用更轻的内容开启今天的阅读状态。'
      : 'A good time to start with the recommendation summary or shorter books and ease into the day.';
  } else if (hour < 14) {
    titleEl.textContent = isChinese() ? '白天专注时段' : 'Focused daytime window';
    copyEl.textContent = isChinese()
      ? '如果你想系统地浏览图书，适合现在进入分类或检索页慢慢筛选。'
      : 'If you want to browse books systematically, this is a good time to move into category or search views and filter slowly.';
  } else if (hour < 19) {
    titleEl.textContent = isChinese() ? '下午探索时段' : 'Afternoon discovery window';
    copyEl.textContent = isChinese()
      ? '可以从相似图书和个性化推荐里继续扩展，寻找下一本想深入阅读的书。'
      : 'A good time to expand from similar books and personalized shelves to find the next title worth diving into.';
  } else {
    titleEl.textContent = isChinese() ? '晚间沉浸阅读' : 'Evening deep reading';
    copyEl.textContent = isChinese()
      ? '更适合从推荐书架里挑一本节奏稳定、可以连续投入时间的图书。'
      : 'Better suited to choosing one steady-paced book from the recommendation shelves and staying with it for a while.';
  }
}

async function loadWeatherWidget() {
  const textEl = document.getElementById('home-weather-text');
  const copyEl = document.getElementById('home-weather-copy');
  if (!textEl || !copyEl) {
    return;
  }

  weatherRenderPriority = -1;

  const cachedSnapshot = loadCachedWeatherSnapshot();
  if (cachedSnapshot) {
    applyWeatherResult(cachedSnapshot, 'cache-snapshot', { fromSnapshot: true });
  }

  const cachedCoords = loadCachedWeatherCoords();
  if (cachedCoords) {
    fetchWeatherByCoords(cachedCoords.latitude, cachedCoords.longitude, 'cache').catch(error => {
      console.warn('cached weather lookup failed:', error.message);
    });
  }

  let settled = false;
  let fallbackTimer = null;

  const finishWithFallback = async message => {
    if (settled) return;
    const cachedCoords = loadCachedWeatherCoords();
    if (cachedCoords) {
      try {
        await fetchWeatherByCoords(cachedCoords.latitude, cachedCoords.longitude, cachedCoords.source || 'cache');
        settled = true;
        if (fallbackTimer) {
          window.clearTimeout(fallbackTimer);
        }
        return;
      } catch (error) {
        console.warn('cached weather lookup failed:', error.message);
      }
    }
    try {
      await fetchWeatherByIp();
      settled = true;
      if (fallbackTimer) {
        window.clearTimeout(fallbackTimer);
      }
      return;
    } catch (error) {
      console.warn('ip weather fallback failed:', error.message);
    }
    settled = true;
    if (fallbackTimer) {
      window.clearTimeout(fallbackTimer);
    }
    setWeatherVisual({ label: isChinese() ? '未获取' : 'Unavailable', icon: '☁', className: 'weather-neutral' }, null, message);
    renderDailySuggestion(new Date());
  };

  const geolocationUnavailableMessage = isChinese()
    ? '当前环境不支持定位或不是安全上下文，无法获取当前位置天气。'
    : 'Location is unavailable in this context, so local weather cannot be retrieved.';
  const weatherTimeoutMessage = isChinese()
    ? '定位请求超时，暂时无法获取当前位置天气。'
    : 'The location request timed out, so local weather could not be retrieved.';

  if (!('geolocation' in navigator)) {
    finishWithFallback(geolocationUnavailableMessage);
    return;
  }

  if (!window.isSecureContext && !['localhost', '127.0.0.1'].includes(window.location.hostname)) {
    finishWithFallback(geolocationUnavailableMessage);
    return;
  }

  if (navigator.permissions?.query) {
    try {
      const permission = await navigator.permissions.query({ name: 'geolocation' });
      if (permission?.state === 'denied') {
        finishWithFallback(isChinese() ? '未开启定位权限，无法显示当前位置天气。' : 'Location permission is disabled, so local weather cannot be shown.');
        return;
      }
    } catch (error) {
      console.warn('geolocation permission query failed:', error.message);
    }
  }

  fallbackTimer = window.setTimeout(() => {
    finishWithFallback(weatherTimeoutMessage);
  }, 1800);

  navigator.geolocation.getCurrentPosition(async position => {
    try {
      const { latitude, longitude } = position.coords;
      saveWeatherCoords(latitude, longitude, 'browser');
      settled = true;
      if (fallbackTimer) {
        window.clearTimeout(fallbackTimer);
      }
      await fetchWeatherByCoords(latitude, longitude, 'browser');
    } catch (error) {
      settled = false;
      await finishWithFallback(isChinese() ? '天气服务暂时不可用，你仍然可以正常浏览推荐内容。' : 'Weather service is temporarily unavailable. You can still browse recommendations normally.');
    }
  }, async () => {
    await finishWithFallback(isChinese() ? '未开启定位权限，无法显示当前位置天气。' : 'Location permission is disabled, so local weather cannot be shown.');
  }, {
    enableHighAccuracy: false,
    timeout: 3200,
    maximumAge: 30 * 60 * 1000
  });
}

function buildDailySuggestion(now = new Date(), weatherLabel = '') {
  const dashboard = homeState.dashboard || {};
  const overview = homeState.overview || {};
  const hour = now.getHours();
  const preferredCategories = Array.isArray(dashboard.preferredCategories) ? dashboard.preferredCategories : [];
  const featuredShelf = Array.isArray(overview.shelves) && overview.shelves.length ? overview.shelves[0] : null;
  const firstPreference = preferredCategories[0] ? BookUi.localizeCategoryName(preferredCategories[0]) : '';

  if (Number(dashboard.overdueCount || 0) > 0) {
    return {
      title: isChinese() ? '先处理逾期图书' : 'Handle overdue books first',
      copy: isChinese()
        ? `你当前有 ${dashboard.overdueCount} 本图书已经逾期。建议先去借阅页处理归还或续借，再决定今天的新阅读安排。`
        : `You currently have ${dashboard.overdueCount} overdue book(s). It is better to return or renew them first before planning new reading today.`,
      href: 'borrowings.html',
      label: isChinese() ? '处理借阅提醒' : 'Handle borrowing alerts'
    };
  }

  if (Number(dashboard.dueSoonCount || 0) > 0) {
    return {
      title: isChinese() ? '优先读短一点的内容' : 'Prefer shorter reads first',
      copy: isChinese()
        ? `你有 ${dashboard.dueSoonCount} 条临近到期提醒。今天更适合先看节奏轻、可快速完成的内容，避免阅读计划被到期时间打断。`
        : `You have ${dashboard.dueSoonCount} due-soon reminder(s). Lighter and faster reads fit better today so due dates do not interrupt your plan.`,
      href: 'borrowings.html',
      label: isChinese() ? '查看到期提醒' : 'View due reminders'
    };
  }

  if (!preferredCategories.length) {
    return {
      title: isChinese() ? '先补齐阅读偏好' : 'Complete your reading preferences first',
      copy: isChinese()
        ? '你的阅读档案还不够完整。完善偏好后，首页的建议、推荐和趋势会更贴近你。'
        : 'Your reading profile is still incomplete. Once you refine it, the homepage suggestions, recommendations, and trends will fit better.',
      href: 'profile.html',
      label: isChinese() ? '完善阅读偏好' : 'Complete preferences'
    };
  }

  if (hour < 10) {
    return {
      title: isChinese() ? '从熟悉类型热身' : 'Warm up with a familiar genre',
      copy: isChinese()
        ? `${firstPreference} 很适合作为今天的开场。如果你想尽快进入状态，可以先看该分类下评分更高的短内容。${weatherLabel ? `现在的天气偏${weatherLabel}，更适合安静地读一会。` : ''}`
        : `${firstPreference} is a good starting point for today. If you want to get into rhythm quickly, begin with shorter and higher-rated books in that category.${weatherLabel ? ` The weather is ${weatherLabel.toLowerCase()}, which also suits a quieter reading session.` : ''}`,
      href: 'books.html',
      label: isChinese() ? '去分类浏览' : 'Browse category'
    };
  }

  if (hour < 17 && featuredShelf?.title) {
    return {
      title: isChinese() ? '中段时间适合扩展阅读面' : 'This is a good time to widen your reading range',
      copy: isChinese()
        ? `你可以先看“${BookUi.localizeRecommendationTitle ? BookUi.localizeRecommendationTitle(featuredShelf.title) : featuredShelf.title}”这组推荐，再从 ${firstPreference} 之外补一两本不同题材，避免首页只重复同一类书。`
        : `Start with the "${BookUi.localizeRecommendationTitle ? BookUi.localizeRecommendationTitle(featuredShelf.title) : featuredShelf.title}" shelf, then add one or two books outside ${firstPreference} so the homepage does not keep repeating the same type.`,
      href: 'recommendations.html',
      label: isChinese() ? '打开推荐页' : 'Open recommendations'
    };
  }

  if (Number(dashboard.readingStreakDays || 0) >= 3) {
    return {
      title: isChinese() ? '把连续阅读再往前推一步' : 'Push the reading streak one step further',
      copy: isChinese()
        ? `你已经连续活跃 ${dashboard.readingStreakDays} 天，今晚适合从稍后阅读清单里拿出一本，别让节奏中断。`
        : `You have stayed active for ${dashboard.readingStreakDays} days in a row. Tonight is a good time to pick one book from your read-later list and keep the streak going.`,
      href: '#saved',
      label: isChinese() ? '看看待读清单' : 'Check the reading list'
    };
  }

  return {
    title: isChinese() ? '用热门书补足今天的阅读量' : 'Use popular books to fill today’s reading time',
    copy: isChinese()
      ? `如果还没决定看什么，可以先从最近更受欢迎的图书开始，再回到你偏好的 ${firstPreference} 继续深挖。`
      : `If you still have not decided what to read, start with recently popular books and then return to your preferred ${firstPreference} category for deeper exploration.`,
    href: 'recommendations.html',
    label: isChinese() ? '查看热门推荐' : 'View popular recommendations'
  };
}

function renderDailySuggestion(now = new Date(), weatherLabel = '') {
  const suggestion = buildDailySuggestion(now, weatherLabel);
  const titleEl = document.getElementById('daily-suggestion-title');
  const copyEl = document.getElementById('daily-suggestion-copy');
  const linkEl = document.getElementById('daily-suggestion-link');
  if (!titleEl || !copyEl || !linkEl) return;

  titleEl.textContent = suggestion.title;
  copyEl.textContent = suggestion.copy;
  linkEl.textContent = suggestion.label;
  linkEl.href = suggestion.href === '#saved' ? '#' : suggestion.href;
  linkEl.dataset.modalOpen = suggestion.href === '#saved' ? 'saved' : '';
}

function renderCompactItems(items, emptyMessage, itemRenderer) {
  if (!items || !items.length) {
    return `<div class="compact-item"><span>${escapeHtml(emptyMessage)}</span></div>`;
  }
  return items.map(itemRenderer).join('');
}

function renderDueReminderCard() {
  const dashboard = homeState.dashboard;
  const preview = (dashboard?.dueSoonLoans || []).slice(0, 2);
  const totalUrgent = Number(dashboard?.dueSoonCount || 0) + Number(dashboard?.overdueCount || 0);
  document.getElementById('due-reminder-count').textContent = String(totalUrgent);
  document.getElementById('due-reminder-copy').textContent = totalUrgent
    ? (isChinese()
      ? `其中 ${dashboard.overdueCount || 0} 条已逾期，${dashboard.dueSoonCount || 0} 条将在 3 天内到期。`
      : `${dashboard.overdueCount || 0} overdue and ${dashboard.dueSoonCount || 0} due within 3 days.`)
    : (isChinese() ? '暂无临近到期或已逾期的图书。' : 'No due-soon or overdue books.');
  document.getElementById('due-reminder-preview').innerHTML = renderCompactItems(
    preview,
    isChinese() ? '当前没有需要优先处理的借阅提醒。' : 'There are no urgent borrowing reminders right now.',
    loan => `
      <div class="compact-item">
        <strong><span>${escapeHtml(loan?.book?.name || t('common.unknownBook'))}</span><span>${escapeHtml(loanDueCopy(loan))}</span></strong>
        <span>${escapeHtml(loan?.book?.author?.name || t('common.unknownAuthor'))}</span>
        <a href="borrowings.html">${escapeHtml(isChinese() ? '去借阅页处理' : 'Open borrowing page')}</a>
      </div>
    `
  );
}

function mergeRecentViewedBooks() {
  const merged = new Map();
  (homeState.dashboard?.recentViewedBooks || []).forEach(book => {
    if (book?.id !== undefined && book?.id !== null) {
      merged.set(String(book.id), book);
    }
  });
  BookUi.getRecentViewedBooks().forEach(book => {
    if (book?.id !== undefined && book?.id !== null && !merged.has(String(book.id))) {
      merged.set(String(book.id), book);
    }
  });
  return Array.from(merged.values()).slice(0, 6);
}

function renderRecentViewedCard() {
  const recentBooks = mergeRecentViewedBooks().slice(0, 2);
  document.getElementById('recent-viewed-preview').innerHTML = renderCompactItems(
    recentBooks,
    isChinese() ? '还没有最近浏览记录。你打开过的图书会出现在这里。' : 'No recent views yet. Books you open will appear here.',
    book => `
      <div class="compact-item">
        <strong><span>${escapeHtml(book?.name || t('common.unknownBook'))}</span><span>${escapeHtml(BookUi.localizeCategoryName(book?.category?.name))}</span></strong>
        <span>${escapeHtml(book?.author?.name || t('common.unknownAuthor'))}</span>
        <a href="${BookUi.buildBookDetailHref(book?.id, { source: 'home-recent', reason: isChinese() ? '从最近浏览继续阅读' : 'Continue from recent views' })}">${escapeHtml(isChinese() ? '继续查看' : 'Continue')}</a>
      </div>
    `
  );
}

function renderTrendCard() {
  const keywords = (homeState.dashboard?.hotKeywords || []).slice(0, 4);
  const categories = (homeState.dashboard?.hotCategories || []).slice(0, 4);
  document.getElementById('trend-keywords').innerHTML = keywords.length
    ? keywords.map(item => `<span class="trend-chip">${escapeHtml(item.keyword)} · ${escapeHtml(item.count)}</span>`).join('')
    : `<span class="trend-chip">${escapeHtml(isChinese() ? '暂无热门搜索词' : 'No hot keywords')}</span>`;
  document.getElementById('trend-categories').innerHTML = categories.length
    ? categories.map(item => `<span class="trend-chip">${escapeHtml(BookUi.localizeCategoryName(item.name))} · ${escapeHtml(item.count)}</span>`).join('')
    : `<span class="trend-chip">${escapeHtml(isChinese() ? '暂无热门分类' : 'No hot categories')}</span>`;
}

function renderNewArrivalsCard() {
  const books = (homeState.dashboard?.newArrivalBooks || []).slice(0, 3);
  document.getElementById('new-arrivals-preview').innerHTML = renderCompactItems(
    books,
    isChinese() ? '暂时没有新的上架图书。' : 'No newly added books at the moment.',
    book => `
      <div class="compact-item">
        <strong><span>${escapeHtml(book?.name || t('common.unknownBook'))}</span><span>${escapeHtml(toDateOnly(book?.creationDate || book?.publishDate))}</span></strong>
        <span>${escapeHtml(book?.author?.name || t('common.unknownAuthor'))}</span>
        <a href="${BookUi.buildBookDetailHref(book?.id, { source: 'home-new-arrivals', reason: isChinese() ? '查看新上架图书' : 'Open newly added book' })}">${escapeHtml(isChinese() ? '查看图书' : 'View book')}</a>
      </div>
    `
  );
}

function renderSavedBooksCard() {
  const savedBooks = BookUi.getSavedBooks();
  document.getElementById('saved-books-count').textContent = String(savedBooks.length);
  document.getElementById('saved-books-preview').innerHTML = renderCompactItems(
    savedBooks.slice(0, 3),
    isChinese() ? '点击图书卡片里的“稍后阅读”，就能把书加入这里。' : 'Click "Read later" on any book card to add books here.',
    book => `
      <div class="compact-item">
        <strong><span>${escapeHtml(book?.name || t('common.unknownBook'))}</span><span>${escapeHtml(BookUi.localizeCategoryName(book?.category?.name))}</span></strong>
        <span>${escapeHtml(book?.author?.name || t('common.unknownAuthor'))}</span>
        <a href="${BookUi.buildBookDetailHref(book?.id, { source: 'home-saved', reason: isChinese() ? '从稍后阅读清单继续查看' : 'Continue from the read-later list' })}">${escapeHtml(isChinese() ? '打开图书' : 'Open book')}</a>
      </div>
    `
  );
}

function renderGoalCard() {
  const goal = BookUi.getMonthlyGoal();
  const monthlyBorrowCount = Number(homeState.dashboard?.monthlyBorrowCount || 0);
  const monthlyRatingCount = Number(homeState.dashboard?.monthlyRatingCount || 0);
  const borrowRatio = Math.min(100, Math.round((monthlyBorrowCount / goal.borrowTarget) * 100));
  const ratingRatio = Math.min(100, Math.round((monthlyRatingCount / goal.ratingTarget) * 100));

  document.getElementById('goal-progress-summary').innerHTML = `
    <strong>${escapeHtml(`${monthlyBorrowCount + monthlyRatingCount}`)}</strong>
    <span class="muted">${escapeHtml(isChinese() ? `本月累计动作：借阅 ${monthlyBorrowCount} 本，评分 ${monthlyRatingCount} 本` : `Monthly activity total: ${monthlyBorrowCount} borrowed, ${monthlyRatingCount} rated`)}</span>
  `;
  document.getElementById('goal-progress-bars').innerHTML = `
    <div class="goal-progress-item">
      <div class="goal-progress-meta">
        <span>${escapeHtml(isChinese() ? '借阅目标' : 'Borrow target')}</span>
        <span>${monthlyBorrowCount} / ${goal.borrowTarget}</span>
      </div>
      <div class="goal-progress-bar"><div class="goal-progress-fill" style="width:${borrowRatio}%"></div></div>
    </div>
    <div class="goal-progress-item">
      <div class="goal-progress-meta">
        <span>${escapeHtml(isChinese() ? '评分目标' : 'Rating target')}</span>
        <span>${monthlyRatingCount} / ${goal.ratingTarget}</span>
      </div>
      <div class="goal-progress-bar"><div class="goal-progress-fill" style="width:${ratingRatio}%"></div></div>
    </div>
  `;
}

function renderStreakCard() {
  const streak = Number(homeState.dashboard?.readingStreakDays || 0);
  document.getElementById('reading-streak-days').textContent = String(streak);
  document.getElementById('reading-streak-copy').textContent = streak > 0
    ? (isChinese()
      ? `你最近已经连续活跃 ${streak} 天，适合继续保持一点点稳定输入。`
      : `You have stayed active for ${streak} days in a row. It is a good time to keep that steady rhythm going.`)
    : (isChinese()
      ? '最近还没有形成连续阅读记录，今天可以先从一条短推荐开始。'
      : 'No reading streak has formed yet. Today can start with one short recommendation.');
}

function renderInsightCards() {
  renderStreakCard();
  renderDueReminderCard();
  renderRecentViewedCard();
  renderTrendCard();
  renderNewArrivalsCard();
  renderSavedBooksCard();
  renderGoalCard();
  renderDailySuggestion(new Date());
}

function openHomeModal(type) {
  const modal = document.getElementById('home-modal');
  const title = document.getElementById('home-modal-title');
  const subtitle = document.getElementById('home-modal-subtitle');
  const body = document.getElementById('home-modal-body');
  if (!modal || !title || !subtitle || !body) return;

  const dashboard = homeState.dashboard;
  const savedBooks = BookUi.getSavedBooks();
  const recentBooks = mergeRecentViewedBooks();
  const goal = BookUi.getMonthlyGoal();

  if (type === 'due') {
    title.textContent = '到期提醒';
    subtitle.textContent = '把临近到期、已逾期和当前预约队列放到一起看。';
    body.innerHTML = `
      <section class="modal-section">
        <div class="modal-grid">
          <div class="modal-card">
            <h4>紧急借阅</h4>
            <p class="muted">已逾期 ${dashboard.overdueCount || 0} 条，3 天内到期 ${dashboard.dueSoonCount || 0} 条。</p>
          </div>
          <div class="modal-card">
            <h4>当前预约</h4>
            <p class="muted">你当前有 ${dashboard.activeReservationsCount || 0} 条预约记录，方便一起安排后续阅读。</p>
          </div>
        </div>
        <div class="modal-list">
          ${(dashboard.dueSoonLoans || []).length ? dashboard.dueSoonLoans.map(loan => `
            <div class="modal-card">
              <h4>${escapeHtml(loan?.book?.name || '未命名图书')}</h4>
              <p class="muted">${escapeHtml(loan?.book?.author?.name || '未知作者')} · ${escapeHtml(loanDueCopy(loan))}</p>
              <div class="hero-actions compact">
                <a class="button-link soft" href="borrowings.html">去处理借阅</a>
                <a class="button-link" href="${BookUi.buildBookDetailHref(loan?.book?.id, { source: 'home-due', reason: '从到期提醒查看图书' })}">查看图书</a>
              </div>
            </div>
          `).join('') : '<div class="modal-card"><p class="muted">目前没有临近到期或逾期的图书。</p></div>'}
        </div>
        <div class="modal-list">
          ${(dashboard.activeReservations || []).length ? dashboard.activeReservations.map(item => `
            <div class="modal-card">
              <h4>${escapeHtml(item?.book?.name || '未命名图书')}</h4>
              <p class="muted">预约时间：${escapeHtml(toDisplayDateTime(item?.requestedAt))}</p>
            </div>
          `).join('') : '<div class="modal-card"><p class="muted">当前没有预约记录。</p></div>'}
        </div>
      </section>
    `;
  } else if (type === 'recent') {
    title.textContent = '最近浏览';
    subtitle.textContent = '你最近打开过的图书会保存在这里，方便回看。';
    body.innerHTML = recentBooks.length
      ? `<div class="book-list">${recentBooks.map(book => BookUi.renderBookCard(book, {
        source: 'home-recent',
        sourceLabel: '最近浏览',
        reason: '从首页最近浏览继续查看'
      })).join('')}</div>`
      : '<div class="modal-card"><p class="muted">还没有最近浏览记录。打开图书详情后，这里会自动累积。</p></div>';
  } else if (type === 'trend') {
    title.textContent = '热门趋势';
    subtitle.textContent = '包括最近更常见的搜索词、热门分类和更受关注的图书。';
    body.innerHTML = `
      <section class="modal-section">
        <div class="modal-grid">
          <div class="modal-card">
            <h4>热门搜索词</h4>
            <div class="chip-list">
              ${(dashboard.hotKeywords || []).length
                ? dashboard.hotKeywords.map(item => `<span class="trend-chip">${escapeHtml(item.keyword)} · ${escapeHtml(item.count)}</span>`).join('')
                : '<span class="trend-chip">暂无数据</span>'}
            </div>
          </div>
          <div class="modal-card">
            <h4>热门分类</h4>
            <div class="chip-list">
              ${(dashboard.hotCategories || []).length
                ? dashboard.hotCategories.map(item => `<span class="trend-chip">${escapeHtml(BookUi.localizeCategoryName(item.name))} · ${escapeHtml(item.count)}</span>`).join('')
                : '<span class="trend-chip">暂无数据</span>'}
            </div>
          </div>
        </div>
        <div class="modal-section">
          <h4>热门图书</h4>
          ${(dashboard.popularBooks || []).length
            ? `<div class="book-list">${dashboard.popularBooks.map(book => BookUi.renderBookCard(book, {
              source: 'home-popular',
              sourceLabel: '热门图书',
              reason: '从首页热门趋势查看图书'
            })).join('')}</div>`
            : '<div class="modal-card"><p class="muted">暂无热门图书数据。</p></div>'}
        </div>
      </section>
    `;
  } else if (type === 'new-arrivals') {
    title.textContent = '新书上架';
    subtitle.textContent = '这里展示最近加入系统的图书，方便快速发现新内容。';
    body.innerHTML = (dashboard.newArrivalBooks || []).length
      ? `<div class="book-list">${dashboard.newArrivalBooks.map(book => BookUi.renderBookCard(book, {
        source: 'home-new-arrivals',
        sourceLabel: '新书上架',
        reason: '从首页新书上架查看图书'
      })).join('')}</div>`
      : '<div class="modal-card"><p class="muted">暂时没有新的上架图书。</p></div>';
  } else if (type === 'saved') {
    title.textContent = '稍后阅读';
    subtitle.textContent = '你手动保存的待看书单会一直留在本地浏览器里。';
    body.innerHTML = savedBooks.length
      ? `<div class="book-list">${savedBooks.map(book => BookUi.renderBookCard(book, {
        source: 'home-saved',
        sourceLabel: '稍后阅读',
        reason: '从稍后阅读清单查看图书'
      })).join('')}</div>`
      : '<div class="modal-card"><p class="muted">当前清单为空。你可以在推荐卡片或图书卡片中点击“稍后阅读”加入清单。</p></div>';
  } else if (type === 'goal') {
    title.textContent = '设置阅读目标';
    subtitle.textContent = '目标会保存在当前浏览器里，用来驱动首页的月度进度卡片。';
    body.innerHTML = `
      <section class="modal-section">
        <div class="modal-grid">
          <div class="modal-card">
            <h4>本月现状</h4>
            <p class="muted">已借阅 ${homeState.dashboard.monthlyBorrowCount || 0} 本，已评分 ${homeState.dashboard.monthlyRatingCount || 0} 本。</p>
          </div>
          <div class="modal-card">
            <h4>当前目标</h4>
            <p class="muted">借阅 ${goal.borrowTarget} 本，评分 ${goal.ratingTarget} 本。</p>
          </div>
        </div>
        <form id="goal-form" class="modal-form">
          <div class="field">
            <label class="label" for="goal-borrow-target">本月借阅目标</label>
            <input id="goal-borrow-target" type="number" min="1" value="${escapeHtml(goal.borrowTarget)}" />
          </div>
          <div class="field">
            <label class="label" for="goal-rating-target">本月评分目标</label>
            <input id="goal-rating-target" type="number" min="1" value="${escapeHtml(goal.ratingTarget)}" />
          </div>
          <div class="form-actions">
            <button class="primary" type="submit">保存目标</button>
          </div>
        </form>
      </section>
    `;
    const goalForm = document.getElementById('goal-form');
    if (goalForm) {
      goalForm.addEventListener('submit', event => {
        event.preventDefault();
        const borrowTarget = document.getElementById('goal-borrow-target').value;
        const ratingTarget = document.getElementById('goal-rating-target').value;
        BookUi.saveMonthlyGoal({ borrowTarget, ratingTarget });
        renderGoalCard();
        showTransientMessage('success', isChinese() ? '本月目标已更新' : 'Monthly goals updated');
        openHomeModal('goal');
      });
    }
  }

  BookUi.refreshSaveButtons(body);
  modal.classList.remove('hidden');
  document.body.classList.add('modal-open');
}

function closeHomeModal() {
  const modal = document.getElementById('home-modal');
  if (!modal) return;
  modal.classList.add('hidden');
  document.body.classList.remove('modal-open');
}

function bindHomeModal() {
  document.addEventListener('click', event => {
    const openTrigger = event.target.closest('[data-modal-open]');
    if (openTrigger) {
      const modalType = openTrigger.dataset.modalOpen;
      if (openTrigger.getAttribute('href') === '#') {
        event.preventDefault();
      }
      if (modalType) {
        openHomeModal(modalType);
      }
      return;
    }

    if (event.target.id === 'home-modal-close' || event.target.id === 'home-modal') {
      closeHomeModal();
    }
  });

  document.addEventListener('keydown', event => {
    if (event.key === 'Escape') {
      closeHomeModal();
    }
  });
}

function bindHomeEvents() {
  document.getElementById('quick-search-form').addEventListener('submit', event => {
    event.preventDefault();
    const keyword = document.getElementById('quick-keyword').value.trim();
    window.location.href = keyword
      ? `books.html?keyword=${encodeURIComponent(keyword)}`
      : 'books.html';
  });

  document.addEventListener('book:saved-updated', () => {
    renderSavedBooksCard();
    BookUi.refreshSaveButtons(document);
  });
  document.addEventListener('book:recent-viewed-updated', () => {
    renderRecentViewedCard();
  });
  document.addEventListener('book:goal-updated', () => {
    renderGoalCard();
  });
  document.addEventListener('book:toast', event => {
    showTransientMessage('success', event.detail?.message || (isChinese() ? '操作已完成' : 'Done'));
  });
}

function bindReadingPreferencePromptEvents() {
  document.addEventListener('click', event => {
    const categoryButton = event.target.closest('[data-preference-category-id]');
    if (!categoryButton) return;
    const id = Number(categoryButton.dataset.preferenceCategoryId);
    if (!Number.isFinite(id) || id <= 0) return;
    if (preferenceDraftCategoryIds.has(id)) {
      preferenceDraftCategoryIds.delete(id);
    } else {
      preferenceDraftCategoryIds.add(id);
    }
    renderReadingPreferencePrompt();
  });

  document.addEventListener('submit', async event => {
    if (event.target.id !== 'reading-preference-form') return;
    event.preventDefault();
    if (!preferenceDraftCategoryIds.size) {
      showTransientMessage('warning', isChinese() ? '请至少选择一个偏好分类。' : 'Select at least one preferred category.', 2600);
      return;
    }

    const payload = {
      readingLevel: preferenceDraftReadingLevel,
      userBookCategories: Array.from(preferenceDraftCategoryIds).map(id => ({ category: { id } }))
    };

    try {
      const result = await BookApi.apiRequest('/api/user/reading-info', { method: 'POST', body: payload });
      homeState.readingPreferenceStatus = {
        initialized: true,
        preferredCategoryCount: preferenceDraftCategoryIds.size,
        readingInfo: result?.body || null
      };
      renderReadingPreferencePrompt();
      await refreshRecommendationPanelsAfterPreferenceSave();
      showTransientMessage('success', isChinese() ? '阅读偏好已保存，推荐结果已刷新。' : 'Reading preferences saved and recommendations refreshed.', 2800);
    } catch (error) {
      showTransientMessage('error', error.message, 3600);
    }
  });

  document.addEventListener('change', event => {
    if (event.target.id !== 'home-reading-level') return;
    preferenceDraftReadingLevel = event.target.value || 'BEGINNER';
  });
}

document.addEventListener('DOMContentLoaded', async () => {
  if (!BookUi.requireLogin()) return;
  BookUi.injectLayout();
  bindHomeEvents();
  bindHomeModal();
  bindReadingPreferencePromptEvents();

  updateLiveClock();
  window.setInterval(updateLiveClock, 30 * 1000);
  loadWeatherWidget();

  const categoryWrap = document.getElementById('category-list');
  const recommendWrap = document.getElementById('recommend-list');
  const recommendSummary = document.getElementById('recommend-summary');

  try {
    homeState.user = await BookApi.fetchCurrentUser();

    const [categoryResult, recommendResult, dashboardResult, preferenceStatusResult] = await Promise.allSettled([
      BookApi.apiRequest('/api/resources/categories'),
      BookApi.apiRequest('/api/resources/recommendations/overview'),
      BookApi.apiRequest('/api/user/home-dashboard'),
      BookApi.apiRequest('/api/user/reading-info/status')
    ]);

    if (categoryResult.status === 'fulfilled') {
      homeState.categories = Array.isArray(categoryResult.value?.body) ? categoryResult.value.body : [];
    }
    if (recommendResult.status === 'fulfilled') {
      homeState.overview = recommendResult.value?.body || { shelves: [] };
    }
    if (dashboardResult.status === 'fulfilled') {
      homeState.dashboard = {
        ...homeState.dashboard,
        ...(dashboardResult.value?.body || {})
      };
    }
    if (preferenceStatusResult.status === 'fulfilled') {
      homeState.readingPreferenceStatus = preferenceStatusResult.value?.body || null;
      preferenceDraftReadingLevel = homeState.readingPreferenceStatus?.readingInfo?.readingLevel || 'BEGINNER';
      const existingCategories = homeState.readingPreferenceStatus?.readingInfo?.userBookCategories || [];
      existingCategories.forEach(item => {
        const id = getCategoryId(item?.category);
        if (id) preferenceDraftCategoryIds.add(id);
      });
    }

    if (categoryResult.status === 'rejected' || recommendResult.status === 'rejected' || dashboardResult.status === 'rejected' || preferenceStatusResult.status === 'rejected') {
      showTransientMessage('warning', isChinese() ? '首页部分数据加载失败，已按可用信息继续展示。' : 'Some homepage data failed to load, so the page is continuing with the available information.', 3200);
    }

    applyHomeHeader(homeState.user, homeState.categories, homeState.overview, homeState.dashboard);
    categoryWrap.innerHTML = renderCategoryCards(homeState.categories);
    recommendSummary.innerHTML = renderRecommendationSummary(homeState.overview);
    recommendWrap.innerHTML = BookUi.renderRecommendationShelves(buildPreviewOverview(homeState.overview), {
      emptyMessage: isChinese() ? '暂无推荐数据。' : 'No recommendation data available.'
    });
    renderInsightCards();
    renderReadingPreferencePrompt();
    BookUi.refreshSaveButtons(document);
  } catch (error) {
    BookUi.showMessage('home-message', 'warning', isChinese() ? `首页数据加载失败：${error.message}` : `Failed to load homepage data: ${error.message}`);
    categoryWrap.innerHTML = `<div class="muted">${escapeHtml(isChinese() ? '分类数据加载失败。' : 'Failed to load category data.')}</div>`;
    recommendSummary.innerHTML = `
      <div class="panel-kicker">${escapeHtml(isChinese() ? '推荐摘要' : 'Recommendation summary')}</div>
      <h3>${escapeHtml(isChinese() ? '推荐信息暂时不可用' : 'Recommendation data is temporarily unavailable')}</h3>
      <p class="muted">${escapeHtml(isChinese() ? '你可以先进入图书检索页继续浏览，稍后再回到首页查看推荐结果。' : 'You can continue through the book search page first and come back to the homepage later for recommendations.')}</p>
      <div class="recommend-summary-actions">
        <a class="button-link" href="books.html">${escapeHtml(isChinese() ? '进入图书检索' : 'Open book search')}</a>
      </div>
    `;
    recommendWrap.innerHTML = `<div class="card muted">${escapeHtml(isChinese() ? '推荐预览加载失败。' : 'Failed to load the recommendation preview.')}</div>`;
    renderInsightCards();
  }
});
