document.addEventListener('DOMContentLoaded', async () => {
  BookUi.injectLayout();
  if (!BookUi.requireLogin()) return;

  try {
    const [user, readingRes] = await Promise.all([
      BookApi.fetchCurrentUser(),
      BookApi.apiRequest('/api/user/find-reading-info').catch(() => ({ body: null }))
    ]);

    document.getElementById('profile-id').textContent = user?.id ?? '-';
    document.getElementById('profile-email-view').textContent = user?.email ?? '-';

    document.getElementById('profile-id-input').value = user?.id ?? '';
    document.getElementById('firstName').value = user?.firstName ?? '';
    document.getElementById('lastName').value = user?.lastName ?? '';
    document.getElementById('email').value = user?.email ?? '';
    document.getElementById('password').value = '';
    document.getElementById('phoneNumber').value = user?.phoneNumber ?? '';
    document.getElementById('birthdate').value = user?.birthdate ? new Date(user.birthdate).toISOString().slice(0, 10) : '';
    document.getElementById('country').value = user?.country ?? '';
    document.getElementById('age').value = user?.age ?? '';
    document.getElementById('gender').value = user?.gender ?? '';
    document.getElementById('maritalStatus').value = user?.maritalStatus ?? '';
    document.getElementById('imageUrl').value = user?.imageUrl ?? '';

    const readingInfo = readingRes?.body;
    document.getElementById('reading-user-id').value = user?.id ?? '';
    document.getElementById('readingLevel').value = readingInfo?.readingLevel ?? 'BEGINNER';
    document.getElementById('categoryIds').value = Array.isArray(readingInfo?.userBookCategories)
      ? readingInfo.userBookCategories.map(item => item?.category?.id || '').filter(Boolean).join(',')
      : '';
  } catch (error) {
    if (/anonymousUser|401|403|not exists/i.test(error.message)) {
      BookApi.clearSession();
      BookUi.showMessage('profile-message', 'error', '登录状态已失效，请重新登录。');
      setTimeout(() => BookUi.requireLogin(), 600);
    } else {
      BookUi.showMessage('profile-message', 'error', error.message);
    }
  }

  document.getElementById('profile-form').addEventListener('submit', async event => {
    event.preventDefault();
    const payload = {
      id: Number(document.getElementById('profile-id-input').value),
      firstName: document.getElementById('firstName').value.trim(),
      lastName: document.getElementById('lastName').value.trim(),
      email: document.getElementById('email').value.trim(),
      password: document.getElementById('password').value.trim() || null,
      phoneNumber: document.getElementById('phoneNumber').value.trim(),
      birthdate: document.getElementById('birthdate').value || null,
      country: document.getElementById('country').value.trim(),
      age: document.getElementById('age').value ? Number(document.getElementById('age').value) : null,
      gender: document.getElementById('gender').value || null,
      maritalStatus: document.getElementById('maritalStatus').value || null,
      imageUrl: document.getElementById('imageUrl').value.trim()
    };

    try {
      await BookApi.apiRequest('/api/user', { method: 'PUT', body: payload });
      await BookApi.fetchCurrentUser();
      BookUi.showMessage('profile-message', 'success', '个人资料更新成功。');
    } catch (error) {
      if (/anonymousUser|401|403|not exists/i.test(error.message)) {
        BookApi.clearSession();
        BookUi.showMessage('profile-message', 'error', '登录状态已失效，请重新登录。');
        setTimeout(() => BookUi.requireLogin(), 600);
      } else {
        BookUi.showMessage('profile-message', 'error', error.message);
      }
    }
  });

  document.getElementById('reading-form').addEventListener('submit', async event => {
    event.preventDefault();
    const ids = document.getElementById('categoryIds').value
      .split(',')
      .map(value => value.trim())
      .filter(Boolean)
      .map(Number)
      .filter(value => Number.isFinite(value) && value > 0);
    const payload = {
      readingLevel: document.getElementById('readingLevel').value,
      userBookCategories: ids.map(id => ({ category: { id } }))
    };

    try {
      await BookApi.apiRequest('/api/user/reading-info', { method: 'POST', body: payload });
      BookUi.showMessage('reading-message', 'success', '阅读偏好保存成功。');
    } catch (error) {
      BookUi.showMessage('reading-message', 'error', error.message);
    }
  });
});
