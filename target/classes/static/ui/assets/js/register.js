document.addEventListener('DOMContentLoaded', () => {
  if (BookUi.redirectIfLoggedIn()) return;
  BookUi.injectLayout();

  const genderSelect = document.getElementById('gender');
  const maritalSelect = document.getElementById('maritalStatus');
  [
    { value: 'MALE', label: '男' },
    { value: 'FEMALE', label: '女' },
    { value: 'OTHERS', label: '其他' }
  ].forEach(option => {
    genderSelect.insertAdjacentHTML('beforeend', `<option value="${option.value}">${option.label}</option>`);
  });
  [
    { value: 'SINGLE', label: '未婚' },
    { value: 'MARRIED', label: '已婚' },
    { value: 'IN_RELATIONSHIP', label: '恋爱中' }
  ].forEach(option => {
    maritalSelect.insertAdjacentHTML('beforeend', `<option value="${option.value}">${option.label}</option>`);
  });

  document.getElementById('email').addEventListener('blur', async event => {
    const email = event.target.value.trim();
    if (!email) return;

    try {
      const res = await BookApi.apiRequest(`/api/user/find-is-email-exists/${encodeURIComponent(email)}`, {
        auth: false
      });
      const exists = Boolean(res?.body);
      BookUi.showMessage(
        'register-message',
        exists ? 'warning' : 'info',
        exists ? '该邮箱已经被注册。' : '该邮箱当前可以使用。'
      );
    } catch (error) {
      BookUi.showMessage('register-message', 'warning', `邮箱校验失败：${error.message}`);
    }
  });

  document.getElementById('register-form').addEventListener('submit', async event => {
    event.preventDefault();
    BookUi.hideMessage('register-message');

    const payload = {
      firstName: document.getElementById('firstName').value.trim(),
      lastName: document.getElementById('lastName').value.trim(),
      email: document.getElementById('email').value.trim(),
      password: document.getElementById('password').value.trim(),
      phoneNumber: document.getElementById('phoneNumber').value.trim(),
      birthdate: document.getElementById('birthdate').value || null,
      country: document.getElementById('country').value.trim(),
      age: document.getElementById('age').value ? Number(document.getElementById('age').value) : null,
      gender: document.getElementById('gender').value || null,
      maritalStatus: document.getElementById('maritalStatus').value || null,
      imageUrl: document.getElementById('imageUrl').value.trim()
    };

    try {
      await BookApi.apiRequest('/api/user', {
        method: 'POST',
        auth: false,
        body: payload
      });
      BookUi.showMessage('register-message', 'success', '注册成功，正在跳转到登录页。');
      setTimeout(() => {
        window.location.href = `login.html?email=${encodeURIComponent(payload.email)}`;
      }, 800);
    } catch (error) {
      BookUi.showMessage('register-message', 'error', error.message);
    }
  });
});
