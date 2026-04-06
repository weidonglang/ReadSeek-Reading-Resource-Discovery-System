document.addEventListener('DOMContentLoaded', async () => {
  if (!BookUi.requireLogin()) return;
  BookUi.injectLayout();

  const wrap = document.getElementById('recommend-result');

  try {
    const currentUser = await BookApi.fetchCurrentUser();
    if (currentUser) {
      document.getElementById('recommend-user').textContent =
        `${currentUser.firstName || ''} ${currentUser.lastName || ''}`.trim() || currentUser.email;
    }

    const res = await BookApi.apiRequest('/api/book/recommendations/overview');
    wrap.innerHTML = BookUi.renderRecommendationShelves(res?.body, {
      emptyMessage: '当前账号暂无可展示推荐结果。'
    });
  } catch (error) {
    wrap.innerHTML = `<div class="card">推荐结果加载失败：${escapeHtml(error.message)}</div>`;
  }
});

function escapeHtml(value) {
  return String(value ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}
