document.addEventListener('DOMContentLoaded', () => {
  if (BookUi.redirectIfLoggedIn()) return;
  BookUi.injectLayout();

  const form = document.getElementById('login-form');
  const apiBaseInput = document.getElementById('api-base-url');
  apiBaseInput.value = BookApi.getApiBaseUrl();

  const initialParams = new URLSearchParams(window.location.search);
  if (initialParams.get('email')) {
    document.getElementById('email').value = initialParams.get('email');
  }

  form.addEventListener('submit', async event => {
    event.preventDefault();
    BookUi.hideMessage('login-message');

    const email = document.getElementById('email').value.trim();
    const password = document.getElementById('password').value.trim();

    try {
      BookApi.saveApiBaseUrl(apiBaseInput.value.trim());
      await BookApi.login(email, password);
      await BookApi.fetchCurrentUser();

      const params = new URLSearchParams(window.location.search);
      const redirect = params.get('redirect') || 'index.html';
      BookUi.showMessage('login-message', 'success', '登录成功，正在进入系统。');
      setTimeout(() => {
        window.location.href = redirect;
      }, 600);
    } catch (error) {
      BookUi.showMessage('login-message', 'error', error.message);
    }
  });
});
