function escapeHtml(value) {
  return String(value ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

const CATEGORY_BLURBS = {
  'Science Fiction': '关注未来世界、技术想象与宇宙探索，适合从大胆设定里寻找阅读灵感。',
  'Horror': '从悬疑氛围、惊悚情节到心理压迫感，适合偏爱强烈情绪体验的读者。',
  'Classic': '收录经久不衰的文学作品，适合从经典文本里回看人物、时代与表达。',
  'Action and Adventure': '以节奏感和冒险旅程见长，适合喜欢剧情推进与探索感的读者。',
  'Romantic': '围绕情感关系与人物成长展开，适合想快速进入故事情绪的阅读场景。',
  'Kids': '面向轻松阅读与启蒙体验，适合从趣味性和陪伴感出发挑选图书。',
  'History': '从人物、事件和时代切面理解历史，适合喜欢主题式阅读与知识延伸。',
  'Sport': '聚焦竞技、训练与体育精神，适合想从兴趣主题切入阅读的读者。'
};

function categoryBlurb(name) {
  return CATEGORY_BLURBS[name] || '点击进入这一分类，快速查看相关图书、筛选条件和推荐结果。';
}

function renderHomeStats(user, categories, overview) {
  const shelves = Array.isArray(overview?.shelves) ? overview.shelves : [];
  const previewBooks = shelves.reduce((total, shelf) => total + (Array.isArray(shelf.books) ? shelf.books.length : 0), 0);
  const stats = [
    {
      label: '推荐书架',
      value: shelves.length,
      note: '覆盖热门推荐、偏好匹配与相似图书'
    },
    {
      label: '图书分类',
      value: categories.length,
      note: '支持从分类入口继续浏览与筛选'
    },
    {
      label: '预览图书',
      value: previewBooks,
      note: '首页展示更值得先看的代表图书'
    },
    {
      label: '当前身份',
      value: user?.role === 'ADMIN' ? '管理员' : '读者',
      note: user?.role === 'ADMIN' ? '可继续进入后台维护与管理' : '可继续浏览、评分与借阅'
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
    return '<div class="muted">暂无分类数据。</div>';
  }

  return categories.map(item => {
    const rawName = item?.name || String(item || '');
    const displayName = BookUi.localizeCategoryName(rawName);
    const href = `books.html?categoryId=${encodeURIComponent(item.id)}`;
    return `
      <a class="category-card" href="${href}">
        <div class="category-card-header">
          <h3>${escapeHtml(displayName)}</h3>
          <span class="tag">进入分类</span>
        </div>
        <p>${escapeHtml(categoryBlurb(rawName))}</p>
        <span class="category-card-action">查看这一分类的图书</span>
      </a>
    `;
  }).join('');
}

function buildPreviewOverview(overview) {
  const shelves = Array.isArray(overview?.shelves) ? overview.shelves : [];
  return {
    title: overview?.title || '推荐预览',
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
      <div class="panel-kicker">推荐摘要</div>
      <h3>暂时还没有推荐结果</h3>
      <p class="muted">可以先浏览图书、补充阅读偏好或进行评分，系统会逐步生成更贴近你的推荐。</p>
      <div class="recommend-summary-actions">
        <a class="button-link" href="profile.html">完善阅读偏好</a>
        <a class="button-link" href="books.html">先去浏览图书</a>
      </div>
    `;
  }

  const featuredShelf = shelves[0];
  const shelfList = shelves.slice(0, 4).map(shelf => `
    <div class="recommend-summary-item">
      <strong>
        <span>${escapeHtml(shelf.title || '推荐书架')}</span>
        <span>${escapeHtml((shelf.books || []).length)} 本</span>
      </strong>
      <span>${escapeHtml(shelf.description || '这一书架会根据你的阅读记录与偏好持续更新。')}</span>
    </div>
  `).join('');

  return `
    <div class="panel-kicker">推荐摘要</div>
    <h3>${escapeHtml(overview?.title || '推荐书架')}</h3>
    <div class="recommend-summary-highlight">
      <strong>${escapeHtml(featuredShelf.title || '精选推荐')}</strong>
      <p>${escapeHtml(featuredShelf.description || '从当前推荐结果中优先整理出更值得先看的内容。')}</p>
      <span class="tag">本次重点推荐</span>
    </div>
    <div class="recommend-summary-list">${shelfList}</div>
    <div class="recommend-summary-actions">
      <a class="button-link primary" href="recommendations.html">查看全部推荐</a>
      <a class="button-link" href="books.html">继续浏览图书</a>
    </div>
  `;
}

function applyHomeHeader(user, categories, overview) {
  const userName = document.getElementById('home-user-name');
  const userCopy = document.getElementById('home-user-copy');
  const statWrap = document.getElementById('home-summary-stats');

  const displayName = `${user?.firstName || ''} ${user?.lastName || ''}`.trim() || '欢迎回来';
  userName.textContent = `${displayName}，从这里开始发现下一本值得阅读的书`;
  userCopy.textContent = '你可以先查看推荐预览，也可以从分类和检索入口快速进入更具体的图书列表。';
  statWrap.innerHTML = renderHomeStats(user, categories, overview);
}

document.addEventListener('DOMContentLoaded', async () => {
  if (!BookUi.requireLogin()) return;
  BookUi.injectLayout();

  const categoryWrap = document.getElementById('category-list');
  const recommendWrap = document.getElementById('recommend-list');
  const recommendSummary = document.getElementById('recommend-summary');

  document.getElementById('quick-search-form').addEventListener('submit', event => {
    event.preventDefault();
    const keyword = document.getElementById('quick-keyword').value.trim();
    window.location.href = keyword
      ? `books.html?keyword=${encodeURIComponent(keyword)}`
      : 'books.html';
  });

  try {
    const currentUser = await BookApi.fetchCurrentUser();
    const [categoryRes, recommendRes] = await Promise.all([
      BookApi.apiRequest('/api/book/find-all-categories'),
      BookApi.apiRequest('/api/book/recommendations/overview')
    ]);

    const categories = Array.isArray(categoryRes?.body) ? categoryRes.body : [];
    const overview = recommendRes?.body || { shelves: [] };

    applyHomeHeader(currentUser, categories, overview);
    categoryWrap.innerHTML = renderCategoryCards(categories);
    recommendSummary.innerHTML = renderRecommendationSummary(overview);
    recommendWrap.innerHTML = BookUi.renderRecommendationShelves(buildPreviewOverview(overview), {
      emptyMessage: '暂无推荐数据。'
    });
  } catch (error) {
    BookUi.showMessage('home-message', 'warning', `首页数据加载失败：${error.message}`);
    categoryWrap.innerHTML = '<div class="muted">分类数据加载失败。</div>';
    recommendSummary.innerHTML = `
      <div class="panel-kicker">推荐摘要</div>
      <h3>推荐信息暂时不可用</h3>
      <p class="muted">你可以先进入图书检索页继续浏览，稍后再返回首页查看推荐结果。</p>
      <div class="recommend-summary-actions">
        <a class="button-link" href="books.html">进入图书检索</a>
      </div>
    `;
    recommendWrap.innerHTML = '<div class="card muted">推荐预览加载失败。</div>';
  }
});
