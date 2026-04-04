(function () {
  const TOKEN_KEY = 'book_access_token';
  const REFRESH_TOKEN_KEY = 'book_refresh_token';
  const USER_KEY = 'book_current_user';

  function getApiBaseUrl() {
    return window.APP_CONFIG.apiBaseUrl;
  }

  function saveApiBaseUrl(value) {
    localStorage.setItem('book_api_base_url', value);
    window.APP_CONFIG.apiBaseUrl = value;
  }

  function getAccessToken() {
    return localStorage.getItem(TOKEN_KEY);
  }

  function getRefreshToken() {
    return localStorage.getItem(REFRESH_TOKEN_KEY);
  }

  function saveTokens(accessToken, refreshToken) {
    if (accessToken) localStorage.setItem(TOKEN_KEY, accessToken);
    if (refreshToken) localStorage.setItem(REFRESH_TOKEN_KEY, refreshToken);
  }

  function clearSession() {
    localStorage.removeItem(TOKEN_KEY);
    localStorage.removeItem(REFRESH_TOKEN_KEY);
    localStorage.removeItem(USER_KEY);
  }

  function saveCurrentUser(user) {
    if (user) localStorage.setItem(USER_KEY, JSON.stringify(user));
  }

  function getCurrentUserCache() {
    try {
      return JSON.parse(localStorage.getItem(USER_KEY) || 'null');
    } catch (e) {
      return null;
    }
  }

  function toChineseApiMessage(message) {
    const text = String(message || '').trim();
    if (!text) return '接口请求失败';
    if (/Invalid email or password/i.test(text)) return '邮箱或密码错误。';
    if (/User email already exists/i.test(text)) return '该邮箱已经被注册。';
    if (/User not found/i.test(text) || /User not exists/i.test(text)) return '用户不存在或登录状态已失效。';
    if (/Book not found/i.test(text)) return '未找到对应图书。';
    if (/Author not found/i.test(text)) return '未找到对应作者。';
    if (/Category not found/i.test(text)) return '未找到对应分类。';
    if (/Publisher not found/i.test(text)) return '未找到对应出版社。';
    if (/Tag not found/i.test(text)) return '未找到对应标签。';
    if (/Total copies must be at least 1/i.test(text)) return '图书总库存至少为 1。';
    if (/Total copies cannot be lower than active borrowed copies/i.test(text)) return '总库存不能小于当前借出数量。';
    if (/You can only update your own profile/i.test(text)) return '普通用户只能修改自己的个人资料。';
    if (/Reservation deleted successfully/i.test(text)) return '预约已删除。';
    return text;
  }

  async function apiRequest(path, options = {}) {
    const method = options.method || 'GET';
    const headers = { 'Content-Type': 'application/json', ...(options.headers || {}) };
    if (options.auth !== false) {
      const token = getAccessToken();
      if (token) headers.Authorization = `Bearer ${token}`;
    }

    const response = await fetch(`${getApiBaseUrl()}${path}`, {
      method,
      headers,
      body: options.body ? JSON.stringify(options.body) : undefined,
      credentials: 'include'
    });

    let data = null;
    try {
      data = await response.json();
    } catch (e) {
      data = null;
    }

    if (!response.ok) {
      const message = toChineseApiMessage(data?.message || data?.error || `请求失败：${response.status}`);
      if (response.status === 401 || response.status === 403) {
        clearSession();
      }
      throw new Error(message);
    }

    if (data && data.success === false) {
      throw new Error(toChineseApiMessage(data.message || '接口返回失败'));
    }

    return data;
  }

  async function login(email, password) {
    const res = await apiRequest('/api/auth/log-in', {
      method: 'POST',
      auth: false,
      body: { email, password }
    });
    const auth = res?.body || {};
    saveTokens(auth.accessToken, auth.refreshToken);
    return res;
  }

  async function fetchCurrentUser() {
    const res = await apiRequest('/api/auth/current');
    if (res?.body) saveCurrentUser(res.body);
    return res?.body;
  }

  async function logout() {
    try {
      await apiRequest('/api/auth/log-out');
    } catch (e) {
      console.warn('logout api failed:', e.message);
    } finally {
      clearSession();
    }
  }

  async function logBehavior(payload) {
    if (!payload || !payload.actionType) {
      return null;
    }
    try {
      return await apiRequest('/api/behavior-log', {
        method: 'POST',
        body: payload
      });
    } catch (error) {
      console.warn('behavior log failed:', error.message);
      return null;
    }
  }

  function toDisplayDate(value) {
    if (!value) return '-';
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) return String(value);
    return date.toLocaleDateString('zh-CN');
  }

  function safeText(value, fallback = '-') {
    if (value === null || value === undefined || value === '') return fallback;
    return String(value);
  }

  function parsePaginationResult(apiResponse) {
    const body = apiResponse?.body || {};
    const list = Array.isArray(body.result) ? body.result : [];
    return {
      list,
      pageNumber: Number(body.pageNumber || 0),
      pageSize: Number(body.pageSize || list.length || 0),
      totalNumberOfPages: Number(body.totalNumberOfPages || 0),
      totalNumberOfElements: Number(body.totalNumberOfElements || list.length || 0),
      isFirst: Boolean(body.isFirst),
      isLast: Boolean(body.isLast)
    };
  }

  window.BookApi = {
    apiRequest,
    login,
    fetchCurrentUser,
    logout,
    getApiBaseUrl,
    saveApiBaseUrl,
    getAccessToken,
    getRefreshToken,
    saveTokens,
    saveCurrentUser,
    getCurrentUserCache,
    clearSession,
    logBehavior,
    toDisplayDate,
    safeText,
    parsePaginationResult
  };
})();
