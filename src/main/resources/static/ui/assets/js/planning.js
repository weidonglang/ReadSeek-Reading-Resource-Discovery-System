const escapeHtml = window.BookUi.escapeHtml;
const selectedCompareResources = [];

function planningText(zh, en) {
  return window.BookI18n?.isChinese?.() ? zh : en;
}

function renderList(items) {
  const values = Array.isArray(items) ? items : [];
  if (!values.length) return '';
  return `<ul class="planning-list">${values.map(item => `<li>${escapeHtml(item)}</li>`).join('')}</ul>`;
}

function getResourceFromHit(hit) {
  const book = hit?.book || hit || {};
  return {
    id: book.id ?? book.resourceId,
    title: book.name || book.title || '-',
    author: book.author?.name || book.author || '-',
    category: book.category?.name || book.category || '',
    rating: book.rate ?? book.rating,
    pages: book.pagesNumber,
    availableCopies: book.availableCopies,
    totalCopies: book.totalCopies,
    description: book.description || '',
    matchType: hit?.matchType || '',
    score: hit?.score
  };
}

function renderComparison(body) {
  const wrap = document.getElementById('compare-result');
  const items = Array.isArray(body.items) ? body.items : [];
  wrap.className = 'planning-result';
  wrap.innerHTML = `
    <div class="comparison-summary">
      <strong>${escapeHtml(planningText('对比结论', 'Comparison summary'))}</strong>
      <p>${escapeHtml(body.summary || '-')}</p>
      ${renderList(body.dimensionNotes)}
      ${renderList(body.decisionSuggestions)}
    </div>
    <div class="comparison-grid">
      ${items.map(item => `
        <article class="comparison-item">
          <h3>${escapeHtml(item.title || '-')}</h3>
          <div class="muted">${escapeHtml(item.author || '-')} · ${escapeHtml(BookUi.localizeCategoryName(item.category || ''))}</div>
          <div class="tags">
            <span class="tag">ID: ${escapeHtml(item.id ?? '-')}</span>
            <span class="tag">${escapeHtml(planningText('评分', 'Rating'))}: ${escapeHtml(item.rating ?? '-')}</span>
            <span class="tag">${escapeHtml(planningText('页数', 'Pages'))}: ${escapeHtml(item.pagesNumber ?? '-')}</span>
            <span class="tag">${escapeHtml(planningText('库存', 'Copies'))}: ${escapeHtml(`${item.availableCopies ?? '-'}/${item.totalCopies ?? '-'}`)}</span>
          </div>
          <p class="muted">${escapeHtml(item.summary || planningText('暂无简介。', 'No description available.'))}</p>
          ${item.id ? `<a class="action-link primary" href="${BookUi.buildBookDetailHref(item.id, { source: 'planning:compare', reason: 'resource comparison' })}">${escapeHtml(planningText('查看详情', 'View detail'))}</a>` : ''}
        </article>
      `).join('')}
    </div>
  `;
}

function renderPath(body) {
  const wrap = document.getElementById('path-result');
  const summary = document.getElementById('path-summary');
  const steps = Array.isArray(body.steps) ? body.steps : [];
  summary.textContent = planningText(
    `围绕“${body.topic || '-'}”生成 ${steps.length} 个阶段，使用 ${body.resourceCount || 0} 条资源证据。`,
    `Generated ${steps.length} stage(s) for "${body.topic || '-'}" with ${body.resourceCount || 0} resource evidence item(s).`
  );

  if (!steps.length) {
    wrap.className = 'path-result muted';
    wrap.textContent = planningText('暂无可用路径，请换一个更具体的主题。', 'No path available. Try a more specific topic.');
    return;
  }

  wrap.className = 'path-result';
  wrap.innerHTML = `
    <div class="path-summary-box">
      <strong>${escapeHtml(planningText('路径依据', 'Path rationale'))}</strong>
      ${renderList(body.pathRationale)}
      <strong>${escapeHtml(planningText('限制说明', 'Limitations'))}</strong>
      ${renderList(body.limitations)}
    </div>
    ${steps.map(step => `
      <section class="path-step">
        <h3>${escapeHtml(step.stepOrder || '-')}. ${escapeHtml(step.stage || '-')}</h3>
        <p class="muted">${escapeHtml(step.goal || '')}</p>
        <div class="path-resource-list">
          ${(step.resources || []).map(resource => `
            <article class="path-resource">
              <div class="path-resource-head">
                <div>
                  <h4>${escapeHtml(resource.title || '-')}</h4>
                  <div class="muted">${escapeHtml(resource.author || '-')} · ${escapeHtml(BookUi.localizeCategoryName(resource.category || ''))}</div>
                </div>
                ${resource.resourceId ? `<a class="action-link" href="${BookUi.buildBookDetailHref(resource.resourceId, { source: 'planning:path', reason: resource.reason || 'reading path' })}">${escapeHtml(planningText('详情', 'Detail'))}</a>` : ''}
              </div>
              <div class="tags">
                <span class="tag">match: ${escapeHtml(resource.matchType || '-')}</span>
                <span class="tag">score: ${escapeHtml(resource.score == null ? '-' : Number(resource.score).toFixed(3))}</span>
              </div>
              <p class="muted">${escapeHtml(resource.description || planningText('暂无简介。', 'No description available.'))}</p>
            </article>
          `).join('')}
        </div>
      </section>
    `).join('')}
  `;
}

function updateSelectedResources() {
  const wrap = document.getElementById('compare-selected');
  const count = document.getElementById('compare-selected-count');
  const submit = document.getElementById('compare-submit');
  count.textContent = `${selectedCompareResources.length} / 4`;
  submit.disabled = selectedCompareResources.length < 2;

  if (!selectedCompareResources.length) {
    wrap.className = 'compare-selected muted';
    wrap.textContent = planningText('暂未选择资源。', 'No resources selected.');
    return;
  }

  wrap.className = 'compare-selected';
  wrap.innerHTML = selectedCompareResources.map(resource => `
    <article class="compare-selected-item">
      <div>
        <strong>${escapeHtml(resource.title)}</strong>
        <span class="muted">ID ${escapeHtml(resource.id)} · ${escapeHtml(resource.author)} · ${escapeHtml(BookUi.localizeCategoryName(resource.category || ''))}</span>
      </div>
      <button type="button" class="ghost-button" data-remove-compare="${escapeHtml(resource.id)}">${escapeHtml(planningText('移除', 'Remove'))}</button>
    </article>
  `).join('');
}

function addCompareResource(resource) {
  if (!resource.id || selectedCompareResources.some(item => String(item.id) === String(resource.id))) {
    return;
  }
  if (selectedCompareResources.length >= 4) {
    BookUi.showMessage('planning-message', 'warning', planningText('最多只能选择 4 个资源进行对比。', 'Select at most four resources.'));
    return;
  }
  selectedCompareResources.push(resource);
  updateSelectedResources();
}

function renderSearchResults(hits) {
  const wrap = document.getElementById('compare-search-results');
  const resources = (Array.isArray(hits) ? hits : []).map(getResourceFromHit).filter(item => item.id);
  if (!resources.length) {
    wrap.className = 'compare-search-results muted';
    wrap.textContent = planningText('没有找到可加入对比的资源。', 'No comparable resources found.');
    return;
  }

  wrap.className = 'compare-search-results';
  wrap.innerHTML = resources.map(resource => {
    const selected = selectedCompareResources.some(item => String(item.id) === String(resource.id));
    return `
      <article class="compare-search-item">
        <div>
          <h3>${escapeHtml(resource.title)}</h3>
          <div class="muted">ID ${escapeHtml(resource.id)} · ${escapeHtml(resource.author)} · ${escapeHtml(BookUi.localizeCategoryName(resource.category || ''))}</div>
          <p class="muted">${escapeHtml(resource.description ? resource.description.slice(0, 120) : planningText('暂无简介。', 'No description available.'))}${resource.description && resource.description.length > 120 ? '...' : ''}</p>
        </div>
        <button type="button"
                class="action-link primary"
                data-add-compare="${escapeHtml(resource.id)}"
                data-resource-payload="${escapeHtml(JSON.stringify(resource))}"
                ${selected ? 'disabled' : ''}>${escapeHtml(selected ? planningText('已加入', 'Added') : planningText('加入对比', 'Add'))}</button>
      </article>
    `;
  }).join('');
}

async function handleCompareSearch(event) {
  event.preventDefault();
  const query = document.getElementById('compare-query').value.trim();
  if (!query) {
    BookUi.showMessage('planning-message', 'warning', planningText('请先输入资源关键词。', 'Enter a resource keyword first.'));
    return;
  }

  BookUi.hideMessage('planning-message');
  document.getElementById('compare-search-results').textContent = planningText('正在搜索资源...', 'Searching resources...');
  try {
    const response = await BookApi.apiRequest(`/api/search/resources?q=${encodeURIComponent(query)}&limit=8`);
    renderSearchResults(response?.body?.hits || []);
  } catch (error) {
    BookUi.showMessage('planning-message', 'error', error.message);
  }
}

async function handleCompareSubmit() {
  const ids = selectedCompareResources.map(resource => Number(resource.id)).filter(id => Number.isFinite(id) && id > 0);
  if (ids.length < 2) {
    BookUi.showMessage('planning-message', 'warning', planningText('请至少选择两个资源。', 'Select at least two resources.'));
    return;
  }

  BookUi.hideMessage('planning-message');
  document.getElementById('compare-result').textContent = planningText('正在生成对比...', 'Generating comparison...');
  try {
    const response = await BookApi.apiRequest('/api/reading-plans/compare', {
      method: 'POST',
      body: { resourceIds: ids }
    });
    renderComparison(response?.body || {});
  } catch (error) {
    BookUi.showMessage('planning-message', 'error', error.message);
  }
}

async function handlePath(event) {
  event.preventDefault();
  const topic = document.getElementById('path-topic').value.trim();
  if (!topic) {
    BookUi.showMessage('planning-message', 'warning', planningText('请先输入阅读主题。', 'Enter a topic first.'));
    return;
  }

  BookUi.hideMessage('planning-message');
  document.getElementById('path-summary').textContent = planningText('正在检索并生成路径...', 'Retrieving and generating path...');
  document.getElementById('path-result').textContent = planningText('生成中...', 'Generating...');
  try {
    const response = await BookApi.apiRequest('/api/reading-plans/path', {
      method: 'POST',
      body: {
        topic,
        readingLevel: document.getElementById('path-level').value,
        limit: Number(document.getElementById('path-limit').value || 9)
      }
    });
    renderPath(response?.body || {});
  } catch (error) {
    BookUi.showMessage('planning-message', 'error', error.message);
  }
}

document.addEventListener('DOMContentLoaded', () => {
  BookUi.injectLayout();
  if (!BookUi.requireLogin()) return;

  updateSelectedResources();
  document.getElementById('compare-search-form').addEventListener('submit', handleCompareSearch);
  document.getElementById('compare-submit').addEventListener('click', handleCompareSubmit);
  document.getElementById('path-form').addEventListener('submit', handlePath);
  document.addEventListener('click', event => {
    const addButton = event.target.closest('[data-add-compare]');
    if (addButton) {
      try {
        addCompareResource(JSON.parse(addButton.dataset.resourcePayload || '{}'));
        addButton.disabled = true;
        addButton.textContent = planningText('已加入', 'Added');
      } catch (error) {
        BookUi.showMessage('planning-message', 'error', error.message);
      }
      return;
    }

    const removeButton = event.target.closest('[data-remove-compare]');
    if (removeButton) {
      const id = removeButton.dataset.removeCompare;
      const index = selectedCompareResources.findIndex(item => String(item.id) === String(id));
      if (index >= 0) {
        selectedCompareResources.splice(index, 1);
        updateSelectedResources();
        const searchButton = document.querySelector(`[data-add-compare="${CSS.escape(String(id))}"]`);
        if (searchButton) {
          searchButton.disabled = false;
          searchButton.textContent = planningText('加入对比', 'Add');
        }
      }
      return;
    }

    const topicButton = event.target.closest('[data-path-topic]');
    if (!topicButton) return;
    document.getElementById('path-topic').value = topicButton.dataset.pathTopic || '';
    document.getElementById('path-topic').focus();
  });
});
