function escapeHtml(value) {
  return String(value ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

function renderInfoItem(label, value) {
  return `
    <div class="info-item">
      <div class="info-key">${escapeHtml(label)}</div>
      <div class="info-value">${value}</div>
    </div>`;
}

document.addEventListener('DOMContentLoaded', async () => {
  if (!BookUi.requireLogin()) return;
  BookUi.injectLayout();

  const params = new URLSearchParams(window.location.search);
  const id = params.get('id');
  const source = params.get('source') || '';
  const reason = params.get('reason') || '';
  const borrowButton = document.getElementById('borrow-book-btn');
  const reserveButton = document.getElementById('reserve-book-btn');
  const cancelReservationButton = document.getElementById('cancel-reservation-btn');
  const similarBooksWrap = document.getElementById('similar-books');

  if (!id) {
    BookUi.showMessage('detail-message', 'error', '缺少图书 ID 参数。');
    return;
  }

  function setButtonState(button, visible, text, disabled) {
    if (!button) return;
    button.textContent = text;
    button.disabled = Boolean(disabled);
    button.classList.toggle('hidden', !visible);
  }

  function renderMeta(book, summary) {
    const tagNames = (book.tags || []).map(tag => tag.name).filter(Boolean);
    const queueLabel = summary.currentUserHasActiveReservation
      ? `${summary.activeReservationsCount} 个预约，你当前排第 ${summary.currentUserQueuePosition} 位`
      : `${summary.activeReservationsCount} 个预约`;

    document.getElementById('detail-meta').innerHTML = [
      renderInfoItem('作者', escapeHtml(book.author?.name || '未知作者')),
      renderInfoItem('ISBN', escapeHtml(book.isbn || '暂无 ISBN')),
      renderInfoItem('分类', escapeHtml(BookUi.localizeCategoryName(book.category?.name))),
      renderInfoItem('出版社', escapeHtml(book.publisher?.name || '无出版社')),
      renderInfoItem('标签', escapeHtml(tagNames.length ? tagNames.join(', ') : '暂无标签')),
      renderInfoItem('评分', escapeHtml(book.rate ?? '-')),
      renderInfoItem('评分人数', escapeHtml(book.usersRateCount ?? '-')),
      renderInfoItem('价格', escapeHtml(book.price ?? '-')),
      renderInfoItem('页数', escapeHtml(book.pagesNumber ?? '-')),
      renderInfoItem('阅读时长', escapeHtml(book.readingDuration ?? '-')),
      renderInfoItem('出版日期', escapeHtml(BookApi.toDisplayDate(book.publishDate))),
      renderInfoItem('可借库存', escapeHtml(`${book.availableCopies ?? 0} / ${book.totalCopies ?? 0}`)),
      renderInfoItem('预约队列', escapeHtml(queueLabel))
    ].join('');
  }

  function renderButtons(book, activeLoan, summary) {
    if (activeLoan) {
      setButtonState(borrowButton, true, `已借阅，归还截止 ${BookApi.toDisplayDate(activeLoan.dueDate)}`, true);
      setButtonState(reserveButton, false, '预约图书', true);
      setButtonState(cancelReservationButton, false, '取消预约', true);
      return;
    }

    if (summary.currentUserHasActiveReservation) {
      setButtonState(cancelReservationButton, true, `取消预约（第 ${summary.currentUserQueuePosition} 位）`, false);
      if (summary.currentUserIsFirstInQueue && Number(book.availableCopies || 0) > 0) {
        setButtonState(borrowButton, true, '借阅已预约图书', false);
      } else {
        setButtonState(borrowButton, true, '等待可借库存', true);
      }
      setButtonState(reserveButton, false, '预约图书', true);
      return;
    }

    setButtonState(cancelReservationButton, false, '取消预约', true);

    if (Number(book.availableCopies || 0) > 0) {
      if (Number(summary.activeReservationsCount || 0) > 0) {
        setButtonState(borrowButton, true, '当前存在预约队列', true);
      } else {
        setButtonState(borrowButton, true, '借阅图书', false);
      }
      setButtonState(reserveButton, false, '预约图书', true);
      return;
    }

    setButtonState(borrowButton, true, '暂无可借库存', true);
    setButtonState(reserveButton, true, '预约图书', false);
  }

  async function loadDetailState(trackEntrySource = false) {
    const detailPath = trackEntrySource && source
      ? `/api/book/find-by-id/${id}?source=${encodeURIComponent(source)}&reason=${encodeURIComponent(reason)}`
      : `/api/book/find-by-id/${id}`;
    const [detailRes, activeLoanRes, summaryRes] = await Promise.all([
      BookApi.apiRequest(detailPath),
      BookApi.apiRequest('/api/loan/my-active'),
      BookApi.apiRequest(`/api/reservation/book/${id}/summary`)
    ]);

    const book = detailRes?.body;
    if (!book) throw new Error('接口未返回图书详情数据。');

    const activeLoans = Array.isArray(activeLoanRes?.body) ? activeLoanRes.body : [];
    const activeLoan = activeLoans.find(loan => String(loan?.book?.id) === String(id)) || null;
    const summary = summaryRes?.body || {
      bookId: Number(id),
      activeReservationsCount: 0,
      currentUserHasActiveReservation: false,
      currentUserIsFirstInQueue: false,
      currentUserQueuePosition: null,
      currentUserReservationId: null
    };

    document.getElementById('detail-cover').innerHTML = window.BookUi.renderBookImage(book);
    document.getElementById('detail-title').textContent = book.name || '未命名图书';
    document.getElementById('detail-desc').textContent = book.description || '暂无简介。';
    renderMeta(book, summary);
    renderButtons(book, activeLoan, summary);
    document.getElementById('go-rate').href = `rate-book.html?bookId=${id}`;

    return { book, summary };
  }

  try {
    const state = await loadDetailState(true);

    borrowButton.addEventListener('click', async () => {
      try {
        await BookApi.apiRequest('/api/loan/borrow', {
          method: 'POST',
          body: { bookId: Number(id) }
        });
        BookUi.showMessage('detail-message', 'success', '借阅成功。');
        await loadDetailState();
      } catch (error) {
        BookUi.showMessage('detail-message', 'error', error.message);
      }
    });

    reserveButton.addEventListener('click', async () => {
      try {
        await BookApi.apiRequest('/api/reservation/reserve', {
          method: 'POST',
          body: { bookId: Number(id) }
        });
        BookUi.showMessage('detail-message', 'success', '预约成功。');
        await loadDetailState();
      } catch (error) {
        BookUi.showMessage('detail-message', 'error', error.message);
      }
    });

    cancelReservationButton.addEventListener('click', async () => {
      try {
        const summaryRes = await BookApi.apiRequest(`/api/reservation/book/${id}/summary`);
        const summary = summaryRes?.body;
        if (!summary?.currentUserReservationId) {
          throw new Error('当前图书没有你的有效预约记录。');
        }
        await BookApi.apiRequest(`/api/reservation/${summary.currentUserReservationId}/cancel`, {
          method: 'POST'
        });
        BookUi.showMessage('detail-message', 'success', '预约已取消。');
        await loadDetailState();
      } catch (error) {
        BookUi.showMessage('detail-message', 'error', error.message);
      }
    });

    const similarRes = await BookApi.apiRequest(`/api/book/recommendations/similar/${id}`);
    similarBooksWrap.innerHTML = BookUi.renderRecommendationShelves(similarRes?.body, {
      emptyMessage: '当前图书暂无相关推荐。'
    });

    if (state.book.author?.id) {
      const authorRes = await BookApi.apiRequest(`/api/book/find-all-by-author-id/${state.book.author.id}`);
      const authorBooks = Array.isArray(authorRes?.body) ? authorRes.body : [];
      const relatedBooks = authorBooks.filter(item => String(item.id) !== String(id)).slice(0, 6);
      document.getElementById('author-books').innerHTML = relatedBooks.length
        ? relatedBooks.map(item => BookUi.renderBookCard(item, {
          source: 'author-shelf',
          sourceLabel: '同作者书架',
          reason: `与当前图书同属作者 ${state.book.author?.name || '未知作者'} 的作品。`,
          actionType: 'BOOK_DETAIL_CLICK'
        })).join('')
        : '<div class="card muted">该作者暂无更多可展示图书。</div>';
    } else {
      document.getElementById('author-books').innerHTML = '<div class="card muted">当前图书暂无作者书架数据。</div>';
    }
  } catch (error) {
    BookUi.showMessage('detail-message', 'error', error.message);
  }
});
