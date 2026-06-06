const aiChatEscape = window.BookUi.escapeHtml;

let aiChatSessionId = null;
let aiChatMessages = [];
let aiChatLastResponse = null;

function aiChatText(zh, en) {
  return window.BookI18n?.isChinese?.() ? zh : en;
}

function aiChatFormatDate(value) {
  if (!value) return '';
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return String(value);
  return date.toLocaleTimeString(window.BookI18n?.getLocale?.() || 'zh-CN', { hour: '2-digit', minute: '2-digit' });
}

function aiChatRenderMessages() {
  const stream = document.getElementById('ai-chat-stream');
  if (!aiChatMessages.length) {
    stream.innerHTML = `
      <div class="ai-chat-empty">
        <strong>${aiChatEscape(aiChatText('开始一次馆藏证据约束的阅读对话', 'Start a catalog-grounded reading conversation'))}</strong>
        <p>${aiChatEscape(aiChatText('可以询问阅读目标、图书比较、推荐理由、阅读路径；简单寒暄会直接回答，具体推荐会调用 RAG 证据。', 'Ask about reading goals, book comparison, recommendation reasons, or reading paths.'))}</p>
      </div>`;
    return;
  }

  stream.innerHTML = aiChatMessages.map(message => {
    const role = message.role === 'assistant' ? 'assistant' : 'user';
    const roleLabel = role === 'assistant' ? 'ReadSeek AI' : aiChatText('你', 'You');
    return `
      <article class="ai-chat-bubble ${role}">
        <div class="ai-chat-avatar">${role === 'assistant' ? 'R' : 'U'}</div>
        <div class="ai-chat-content">
          <div class="ai-chat-role">
            <strong>${aiChatEscape(roleLabel)}</strong>
            <span>${aiChatEscape(aiChatFormatDate(message.createdAt))}</span>
          </div>
          <p>${aiChatEscape(message.content || '').replace(/\n/g, '<br>')}</p>
        </div>
      </article>`;
  }).join('');
  stream.scrollTop = stream.scrollHeight;
}

function aiChatRenderMeta() {
  const wrap = document.getElementById('ai-chat-meta');
  const body = aiChatLastResponse;
  if (!body) {
    wrap.innerHTML = `<div class="muted">${aiChatEscape(aiChatText('还没有回答。', 'No response yet.'))}</div>`;
    return;
  }

  const citations = Array.isArray(body.citations) ? body.citations : [];
  const evidence = Array.isArray(body.evidence) ? body.evidence : [];
  const recommendations = Array.isArray(body.recommendations) ? body.recommendations : [];
  const limitations = Array.isArray(body.limitations) ? body.limitations : [];
  const followUps = Array.isArray(body.followUpSuggestions) ? body.followUpSuggestions : [];

  wrap.innerHTML = `
    <div class="ai-chat-stat-grid">
      <div><span>Strategy</span><strong>${aiChatEscape(body.strategy || '-')}</strong></div>
      <div><span>Mode</span><strong>${aiChatEscape(body.ragMode || '-')}</strong></div>
      <div><span>Model</span><strong>${aiChatEscape(body.model || '-')}</strong></div>
      <div><span>Answerable</span><strong>${aiChatEscape(body.answerable ? 'Yes' : 'No')}</strong></div>
      <div><span>Fallback</span><strong>${aiChatEscape(body.fallbackApplied || body.llmFallbackApplied ? 'Yes' : 'No')}</strong></div>
      <div><span>Latency</span><strong>${aiChatEscape(body.totalLatencyMs == null ? '-' : `${body.totalLatencyMs} ms`)}</strong></div>
    </div>

    <h3>${aiChatEscape(aiChatText('引用 / Citations', 'Citations'))}</h3>
    <ul class="ai-chat-list">${citations.length ? citations.map(item => `<li>${aiChatEscape(item)}</li>`).join('') : `<li>${aiChatEscape(aiChatText('暂无引用', 'No citations'))}</li>`}</ul>

    <h3>${aiChatEscape(aiChatText('证据 / Evidence', 'Evidence'))}</h3>
    <div class="ai-chat-evidence-list">
      ${evidence.length ? evidence.map(item => `
        <article class="ai-chat-evidence">
          <strong>${aiChatEscape(item.title || item.citation || aiChatText('未知资源', 'Unknown resource'))}</strong>
          <span>${aiChatEscape([item.author, item.category].filter(Boolean).join(' · ') || '-')}</span>
          <p>${aiChatEscape(item.description || aiChatText('暂无简介', 'No description available.'))}</p>
          <div class="tags">
            <span class="tag">source: ${aiChatEscape(item.source || '-')}</span>
            <span class="tag">match: ${aiChatEscape(item.matchType || '-')}</span>
            <span class="tag">rerank: ${aiChatEscape(item.reranked ? 'yes' : 'no')}</span>
          </div>
        </article>`).join('') : `<div class="muted">${aiChatEscape(aiChatText('暂无证据', 'No evidence'))}</div>`}
    </div>

    <h3>${aiChatEscape(aiChatText('推荐 / Recommendations', 'Recommendations'))}</h3>
    <div class="ai-chat-rec-list">
      ${recommendations.length ? recommendations.map(item => `
        <article class="ai-chat-rec">
          <strong>${aiChatEscape(item.title || aiChatText('未知资源', 'Unknown resource'))}</strong>
          <span>${aiChatEscape(item.author || '-')}</span>
          <p>${aiChatEscape(item.reason || '')}</p>
        </article>`).join('') : `<div class="muted">${aiChatEscape(aiChatText('暂无推荐卡片', 'No recommendation cards'))}</div>`}
    </div>

    <h3>${aiChatEscape(aiChatText('限制与追问 / Limits and follow-ups', 'Limits and follow-ups'))}</h3>
    <ul class="ai-chat-list">
      ${limitations.concat(followUps).map(item => `<li>${aiChatEscape(item)}</li>`).join('') || `<li>${aiChatEscape(aiChatText('暂无补充说明', 'No extra notes'))}</li>`}
    </ul>`;
}

async function aiChatLoadSessions() {
  const wrap = document.getElementById('ai-chat-sessions');
  try {
    const response = await BookApi.apiRequest('/api/ai-chat/sessions');
    const sessions = Array.isArray(response?.body) ? response.body : [];
    if (!sessions.length) {
      wrap.innerHTML = `<div class="muted">${aiChatEscape(aiChatText('暂无历史会话', 'No previous sessions'))}</div>`;
      return;
    }
    wrap.innerHTML = sessions.map(session => `
      <button type="button" class="ai-chat-session${session.id === aiChatSessionId ? ' active' : ''}" data-session-id="${aiChatEscape(session.id)}">
        <strong>${aiChatEscape(session.title || aiChatText('未命名会话', 'Untitled session'))}</strong>
        <span>${aiChatEscape(session.updatedAt || '')}</span>
      </button>`).join('');
  } catch (error) {
    wrap.innerHTML = `<div class="muted">${aiChatEscape(error.message)}</div>`;
  }
}

async function aiChatOpenSession(sessionId) {
  try {
    const response = await BookApi.apiRequest(`/api/ai-chat/sessions/${encodeURIComponent(sessionId)}`);
    const session = response?.body || {};
    aiChatSessionId = session.id || sessionId;
    aiChatMessages = Array.isArray(session.messages) ? session.messages : [];
    aiChatLastResponse = null;
    aiChatRenderMessages();
    aiChatRenderMeta();
    aiChatLoadSessions();
  } catch (error) {
    BookUi.showMessage('ai-chat-message', 'error', error.message);
  }
}

async function aiChatSend(event) {
  event.preventDefault();
  const input = document.getElementById('ai-chat-input');
  const submit = document.getElementById('ai-chat-submit');
  const message = input.value.trim();
  if (!message) return;

  const mode = document.getElementById('ai-chat-mode').value || 'standard';
  const limit = Number(document.getElementById('ai-chat-limit').value || 5);
  BookUi.hideMessage('ai-chat-message');
  submit.disabled = true;

  const pendingUser = { id: `pending-user-${Date.now()}`, role: 'user', content: message, createdAt: new Date().toISOString() };
  const pendingAssistant = { id: `pending-assistant-${Date.now()}`, role: 'assistant', content: aiChatText('正在检索馆藏证据并生成回答...', 'Retrieving catalog evidence and generating an answer...'), createdAt: new Date().toISOString() };
  aiChatMessages = aiChatMessages.concat([pendingUser, pendingAssistant]);
  input.value = '';
  aiChatRenderMessages();

  try {
    const response = await BookApi.apiRequest('/api/ai-chat/message', {
      method: 'POST',
      body: { sessionId: aiChatSessionId, message, mode, provider: 'ollama', limit }
    });
    const body = response?.body || {};
    aiChatSessionId = body.sessionId || aiChatSessionId;
    aiChatLastResponse = body;
    aiChatMessages = aiChatMessages.slice(0, -2).concat([body.userMessage || pendingUser, body.assistantMessage || { ...pendingAssistant, content: body.answer || '' }]);
    aiChatRenderMessages();
    aiChatRenderMeta();
    aiChatLoadSessions();
  } catch (error) {
    aiChatMessages = aiChatMessages.slice(0, -1).concat([{ ...pendingAssistant, content: error.message }]);
    aiChatRenderMessages();
    BookUi.showMessage('ai-chat-message', 'error', error.message);
  } finally {
    submit.disabled = false;
    input.focus();
  }
}

function aiChatNewSession() {
  aiChatSessionId = null;
  aiChatMessages = [];
  aiChatLastResponse = null;
  aiChatRenderMessages();
  aiChatRenderMeta();
  aiChatLoadSessions();
  document.getElementById('ai-chat-input').focus();
}

document.addEventListener('DOMContentLoaded', () => {
  BookUi.injectLayout();
  if (!BookUi.requireLogin()) return;

  document.getElementById('ai-chat-form').addEventListener('submit', aiChatSend);
  document.getElementById('ai-chat-new').addEventListener('click', aiChatNewSession);
  document.getElementById('ai-chat-sessions').addEventListener('click', event => {
    const button = event.target.closest('[data-session-id]');
    if (button) aiChatOpenSession(button.dataset.sessionId);
  });
  document.getElementById('ai-chat-input').addEventListener('keydown', event => {
    if (event.key === 'Enter' && !event.shiftKey) {
      event.preventDefault();
      document.getElementById('ai-chat-form').requestSubmit();
    }
  });

  aiChatRenderMessages();
  aiChatRenderMeta();
  aiChatLoadSessions();
});
