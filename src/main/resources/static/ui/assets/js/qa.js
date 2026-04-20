const escapeHtml = window.BookUi.escapeHtml;

function qaText(zh, en) {
  return window.BookI18n?.isChinese?.() ? zh : en;
}

function formatStrategy(strategy) {
  if (!strategy) return '-';
  if (strategy.startsWith('hybrid-v2')) return 'Hybrid v2';
  if (strategy.startsWith('hybrid-v1')) return 'Hybrid v1';
  return strategy;
}

function renderAnswer(body) {
  const answerWrap = document.getElementById('qa-answer');
  const summary = document.getElementById('qa-summary');
  const limitations = Array.isArray(body.limitations) ? body.limitations : [];
  const followUps = Array.isArray(body.followUpSuggestions) ? body.followUpSuggestions : [];

  summary.textContent = qaText(
    `已生成回答，使用 ${body.evidenceCount || 0} 条证据。`,
    `Answer generated with ${body.evidenceCount || 0} evidence item(s).`
  );

  answerWrap.className = 'qa-answer-body';
  answerWrap.innerHTML = `
    <p>${escapeHtml(body.answer || qaText('暂无回答。', 'No answer available.'))}</p>
    <div class="qa-meta-grid">
      <div class="qa-meta-item"><span>问题</span><strong>${escapeHtml(body.question || '-')}</strong></div>
      <div class="qa-meta-item"><span>模式</span><strong>${escapeHtml(body.answerMode || '-')}</strong></div>
      <div class="qa-meta-item"><span>检索策略</span><strong>${escapeHtml(formatStrategy(body.strategy))}</strong></div>
      <div class="qa-meta-item"><span>回退</span><strong>${escapeHtml(body.fallbackApplied ? '是' : '否')}</strong></div>
    </div>
    <div class="qa-lists">
      <div>
        <strong>${escapeHtml(qaText('限制说明', 'Limitations'))}</strong>
        <ul>${limitations.map(item => `<li>${escapeHtml(item)}</li>`).join('')}</ul>
      </div>
      <div>
        <strong>${escapeHtml(qaText('可继续追问', 'Follow-up suggestions'))}</strong>
        <ul>${followUps.map(item => `<li>${escapeHtml(item)}</li>`).join('')}</ul>
      </div>
    </div>
  `;
}

function renderEvidence(body) {
  const wrap = document.getElementById('qa-evidence-list');
  const evidence = Array.isArray(body.evidence) ? body.evidence : [];
  if (!evidence.length) {
    wrap.innerHTML = `<div class="muted">${escapeHtml(qaText('暂无证据。', 'No evidence available.'))}</div>`;
    return;
  }

  wrap.innerHTML = evidence.map(item => `
    <article class="qa-evidence-item">
      <div class="qa-evidence-head">
        <div>
          <h3>${escapeHtml(item.rank || '-')}. ${escapeHtml(item.title || qaText('未知资源', 'Unknown resource'))}</h3>
          <div class="muted">${escapeHtml(item.author || qaText('未知作者', 'Unknown author'))} · ${escapeHtml(BookUi.localizeCategoryName(item.category || ''))}</div>
        </div>
        ${item.resourceId ? `<a class="action-link primary" href="${BookUi.buildBookDetailHref(item.resourceId, { source: 'qa:evidence', reason: item.reason || 'Evidence QA' })}">${escapeHtml(qaText('查看详情', 'View detail'))}</a>` : ''}
      </div>
      <div class="tags">
        <span class="tag">match: ${escapeHtml(item.matchType || '-')}</span>
        <span class="tag">score: ${escapeHtml(item.score == null ? '-' : Number(item.score).toFixed(3))}</span>
      </div>
      ${item.reason ? `<div class="book-hit-meta"><span class="tag reason-chip">${escapeHtml(item.reason)}</span></div>` : ''}
      <p class="muted">${escapeHtml(item.description || qaText('暂无简介。', 'No description available.'))}</p>
    </article>
  `).join('');
}

async function askQuestion(event) {
  event.preventDefault();
  const question = document.getElementById('qa-question').value.trim();
  const limit = Number(document.getElementById('qa-limit').value || 5);
  if (!question) {
    BookUi.showMessage('qa-message', 'warning', qaText('请先输入问题。', 'Please enter a question first.'));
    return;
  }

  BookUi.hideMessage('qa-message');
  document.getElementById('qa-summary').textContent = qaText('正在检索证据并生成回答...', 'Retrieving evidence and generating answer...');
  document.getElementById('qa-answer').className = 'qa-answer-placeholder';
  document.getElementById('qa-answer').textContent = qaText('生成中...', 'Generating...');
  document.getElementById('qa-evidence-list').innerHTML = `<div class="muted">${escapeHtml(qaText('正在加载证据...', 'Loading evidence...'))}</div>`;

  try {
    const response = await BookApi.apiRequest('/api/qa/evidence', {
      method: 'POST',
      body: { question, limit }
    });
    const body = response?.body || {};
    renderAnswer(body);
    renderEvidence(body);
  } catch (error) {
    BookUi.showMessage('qa-message', 'error', error.message);
    document.getElementById('qa-summary').textContent = qaText('生成失败。', 'Generation failed.');
    document.getElementById('qa-answer').textContent = qaText('请稍后重试，或换一个更具体的问题。', 'Please retry later or use a more specific question.');
    document.getElementById('qa-evidence-list').innerHTML = '';
  }
}

document.addEventListener('DOMContentLoaded', () => {
  BookUi.injectLayout();
  if (!BookUi.requireLogin()) return;

  document.getElementById('qa-form').addEventListener('submit', askQuestion);
  document.addEventListener('click', event => {
    const button = event.target.closest('[data-example-question]');
    if (!button) return;
    document.getElementById('qa-question').value = button.dataset.exampleQuestion || '';
    document.getElementById('qa-question').focus();
  });
});
