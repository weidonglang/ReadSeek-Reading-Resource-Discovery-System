document.addEventListener('DOMContentLoaded', async () => {
  const t = window.BookI18n.t;
  BookUi.injectLayout();
  if (!BookUi.requireLogin()) return;

  const birthdateInput = document.getElementById('birthdate');
  const selectedCategoryIds = new Set();
  let categoryOptions = [];

  function formatBirthdateForInput(value) {
    if (!value) return '';
    const normalized = String(value).trim();
    const match = normalized.match(/^(\d{4})-(\d{2})-(\d{2})/);
    if (match) {
      return `${match[1]}/${match[2]}/${match[3]}`;
    }
    const slashMatch = normalized.match(/^(\d{4})\/(\d{1,2})\/(\d{1,2})$/);
    if (slashMatch) {
      return `${slashMatch[1]}/${slashMatch[2].padStart(2, '0')}/${slashMatch[3].padStart(2, '0')}`;
    }
    return normalized;
  }

  function normalizeBirthdateForApi(value) {
    const normalized = String(value || '').trim();
    if (!normalized) return null;
    const slashMatch = normalized.match(/^(\d{4})\/(\d{1,2})\/(\d{1,2})$/);
    if (slashMatch) {
      return `${slashMatch[1]}-${slashMatch[2].padStart(2, '0')}-${slashMatch[3].padStart(2, '0')}`;
    }
    const dashMatch = normalized.match(/^(\d{4})-(\d{1,2})-(\d{1,2})$/);
    if (dashMatch) {
      return `${dashMatch[1]}-${dashMatch[2].padStart(2, '0')}-${dashMatch[3].padStart(2, '0')}`;
    }
    return normalized;
  }

  birthdateInput?.addEventListener('blur', () => {
    birthdateInput.value = formatBirthdateForInput(birthdateInput.value);
  });

  function getCategoryId(category) {
    const id = Number(category?.id);
    return Number.isFinite(id) && id > 0 ? id : null;
  }

  function updateCategoryIdsInput() {
    const input = document.getElementById('categoryIds');
    if (input) {
      input.value = Array.from(selectedCategoryIds).join(',');
    }
  }

  function renderCategoryPicker() {
    const input = document.getElementById('categoryIds');
    if (!input) return;
    input.type = 'hidden';

    let picker = document.getElementById('profile-category-picker');
    if (!picker) {
      picker = document.createElement('div');
      picker.id = 'profile-category-picker';
      picker.className = 'profile-category-picker';
      input.insertAdjacentElement('afterend', picker);
    }

    if (!categoryOptions.length) {
      picker.innerHTML = `<div class="muted">${BookUi.escapeHtml(window.BookI18n.isChinese() ? '分类数据暂时不可用，可以先保留原有偏好。' : 'Category data is temporarily unavailable. Existing preferences can be kept for now.')}</div>`;
      return;
    }

    picker.innerHTML = categoryOptions.map(category => {
      const id = getCategoryId(category);
      if (!id) return '';
      const active = selectedCategoryIds.has(id);
      return `
        <button class="profile-category-chip${active ? ' active' : ''}" type="button" data-profile-category-id="${id}">
          ${BookUi.escapeHtml(BookUi.localizeCategoryName(category?.name))}
        </button>
      `;
    }).join('');
  }

  function setSelectedCategoryIds(ids) {
    selectedCategoryIds.clear();
    ids.forEach(id => {
      const normalizedId = Number(id);
      if (Number.isFinite(normalizedId) && normalizedId > 0) {
        selectedCategoryIds.add(normalizedId);
      }
    });
    updateCategoryIdsInput();
    renderCategoryPicker();
  }

  document.getElementById('gender').innerHTML = `
    <option value="">${t('common.noneSelected')}</option>
    <option value="MALE">${t('common.genderMale')}</option>
    <option value="FEMALE">${t('common.genderFemale')}</option>
    <option value="OTHERS">${t('common.genderOther')}</option>
  `;
  document.getElementById('maritalStatus').innerHTML = `
    <option value="">${t('common.noneSelected')}</option>
    <option value="SINGLE">${t('common.maritalSingle')}</option>
    <option value="MARRIED">${t('common.maritalMarried')}</option>
    <option value="IN_RELATIONSHIP">${t('common.maritalRelationship')}</option>
  `;
  document.getElementById('readingLevel').innerHTML = `
    <option value="BEGINNER">${t('common.readLevelBeginner')}</option>
    <option value="INTERMEDIATE">${t('common.readLevelIntermediate')}</option>
    <option value="EXPERT">${t('common.readLevelExpert')}</option>
  `;

  try {
    const [user, readingRes, categoryRes] = await Promise.all([
      BookApi.fetchCurrentUser(),
      BookApi.apiRequest('/api/user/find-reading-info').catch(() => ({ body: null })),
      BookApi.apiRequest('/api/resources/categories').catch(() => ({ body: [] }))
    ]);

    categoryOptions = Array.isArray(categoryRes?.body) ? categoryRes.body : [];

    document.getElementById('profile-id').textContent = user?.id ?? '-';
    document.getElementById('profile-email-view').textContent = user?.email ?? '-';

    document.getElementById('profile-id-input').value = user?.id ?? '';
    document.getElementById('firstName').value = user?.firstName ?? '';
    document.getElementById('lastName').value = user?.lastName ?? '';
    document.getElementById('email').value = user?.email ?? '';
    document.getElementById('password').value = '';
    document.getElementById('phoneNumber').value = user?.phoneNumber ?? '';
    birthdateInput.value = user?.birthdate ? formatBirthdateForInput(user.birthdate) : '';
    document.getElementById('country').value = user?.country ?? '';
    document.getElementById('age').value = user?.age ?? '';
    document.getElementById('gender').value = user?.gender ?? '';
    document.getElementById('maritalStatus').value = user?.maritalStatus ?? '';
    document.getElementById('imageUrl').value = user?.imageUrl ?? '';

    const readingInfo = readingRes?.body;
    document.getElementById('reading-user-id').value = user?.id ?? '';
    document.getElementById('readingLevel').value = readingInfo?.readingLevel ?? 'BEGINNER';
    setSelectedCategoryIds(Array.isArray(readingInfo?.userBookCategories)
      ? readingInfo.userBookCategories.map(item => item?.category?.id).filter(Boolean)
      : []);
  } catch (error) {
    if (/anonymousUser|401|403|not exists/i.test(error.message)) {
      BookApi.clearSession();
      BookUi.showMessage('profile-message', 'error', t('profile.sessionExpired'));
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
      birthdate: normalizeBirthdateForApi(birthdateInput.value),
      country: document.getElementById('country').value.trim(),
      age: document.getElementById('age').value ? Number(document.getElementById('age').value) : null,
      gender: document.getElementById('gender').value || null,
      maritalStatus: document.getElementById('maritalStatus').value || null,
      imageUrl: document.getElementById('imageUrl').value.trim()
    };

    try {
      await BookApi.apiRequest('/api/user', { method: 'PUT', body: payload });
      await BookApi.fetchCurrentUser();
      BookUi.showMessage('profile-message', 'success', t('profile.profileSaved'));
    } catch (error) {
      if (/anonymousUser|401|403|not exists/i.test(error.message)) {
        BookApi.clearSession();
        BookUi.showMessage('profile-message', 'error', t('profile.sessionExpired'));
        setTimeout(() => BookUi.requireLogin(), 600);
      } else {
        BookUi.showMessage('profile-message', 'error', error.message);
      }
    }
  });

  document.getElementById('reading-form').addEventListener('submit', async event => {
    event.preventDefault();
    const ids = selectedCategoryIds.size
      ? Array.from(selectedCategoryIds)
      : document.getElementById('categoryIds').value
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
      BookUi.showMessage('reading-message', 'success', t('profile.readingSaved'));
    } catch (error) {
      BookUi.showMessage('reading-message', 'error', error.message);
    }
  });

  document.addEventListener('click', event => {
    const categoryButton = event.target.closest('[data-profile-category-id]');
    if (!categoryButton) return;
    const id = Number(categoryButton.dataset.profileCategoryId);
    if (!Number.isFinite(id) || id <= 0) return;
    if (selectedCategoryIds.has(id)) {
      selectedCategoryIds.delete(id);
    } else {
      selectedCategoryIds.add(id);
    }
    updateCategoryIdsInput();
    renderCategoryPicker();
  });
});
