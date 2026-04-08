document.addEventListener('DOMContentLoaded', () => {
  const t = window.BookI18n.t;
  if (BookUi.redirectIfLoggedIn()) return;
  BookUi.injectLayout();

  const form = document.getElementById('login-form');
  const apiBaseInput = document.getElementById('api-base-url');
  const subtitle = document.querySelector('.page-subtitle');
  apiBaseInput.value = BookApi.getApiBaseUrl();

  const initialParams = new URLSearchParams(window.location.search);
  const redirect = initialParams.get('redirect') || 'index.html';

  function resolveRedirectLabel(target) {
    const normalized = String(target || '').split('?')[0];
    const redirectNameMap = {
      'index.html': t('common.nav.home'),
      'books.html': t('common.nav.books'),
      'borrowings.html': t('common.nav.borrowings'),
      'recommendations.html': t('common.nav.recommendations'),
      'profile.html': t('common.nav.profile'),
      'admin.html': t('common.nav.admin'),
      'login.html': t('common.nav.login'),
      'register.html': t('common.nav.register')
    };
    return redirectNameMap[normalized] || t('common.nav.home');
  }

  const redirectLabel = resolveRedirectLabel(redirect);
  if (subtitle && initialParams.has('redirect')) {
    subtitle.textContent = t('login.redirectSubtitle', { target: redirectLabel });
  }

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

      const successMessage = initialParams.has('redirect')
        ? t('login.successRedirect', { target: redirectLabel })
        : t('login.success');
      BookUi.showMessage('login-message', 'success', successMessage);
      setTimeout(() => {
        window.location.href = redirect;
      }, 600);
    } catch (error) {
      BookUi.showMessage('login-message', 'error', error.message);
    }
  });
});
