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
  const borrowButton = document.getElementById('borrow-book-btn');
  const reserveButton = document.getElementById('reserve-book-btn');
  const cancelReservationButton = document.getElementById('cancel-reservation-btn');
  const similarBooksWrap = document.getElementById('similar-books');

  if (!id) {
    BookUi.showMessage('detail-message', 'error', 'Missing book id.');
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
      ? `${summary.activeReservationsCount} active, your position ${summary.currentUserQueuePosition}`
      : `${summary.activeReservationsCount} active`;

    document.getElementById('detail-meta').innerHTML = [
      renderInfoItem('Author', escapeHtml(book.author?.name || 'Unknown Author')),
      renderInfoItem('ISBN', escapeHtml(book.isbn || 'No ISBN')),
      renderInfoItem('Category', escapeHtml(book.category?.name || 'Uncategorized')),
      renderInfoItem('Publisher', escapeHtml(book.publisher?.name || 'No publisher')),
      renderInfoItem('Tags', escapeHtml(tagNames.length ? tagNames.join(', ') : 'No tags')),
      renderInfoItem('Rate', escapeHtml(book.rate ?? '-')),
      renderInfoItem('Ratings', escapeHtml(book.usersRateCount ?? '-')),
      renderInfoItem('Price', escapeHtml(book.price ?? '-')),
      renderInfoItem('Pages', escapeHtml(book.pagesNumber ?? '-')),
      renderInfoItem('Reading Duration', escapeHtml(book.readingDuration ?? '-')),
      renderInfoItem('Publish Date', escapeHtml(BookApi.toDisplayDate(book.publishDate))),
      renderInfoItem('Available Copies', escapeHtml(`${book.availableCopies ?? 0} / ${book.totalCopies ?? 0}`)),
      renderInfoItem('Reservation Queue', escapeHtml(queueLabel))
    ].join('');
  }

  function renderButtons(book, activeLoan, summary) {
    if (activeLoan) {
      setButtonState(borrowButton, true, `Borrowed until ${BookApi.toDisplayDate(activeLoan.dueDate)}`, true);
      setButtonState(reserveButton, false, 'Reserve Book', true);
      setButtonState(cancelReservationButton, false, 'Cancel Reservation', true);
      return;
    }

    if (summary.currentUserHasActiveReservation) {
      setButtonState(cancelReservationButton, true, `Cancel Reservation (#${summary.currentUserQueuePosition})`, false);
      if (summary.currentUserIsFirstInQueue && Number(book.availableCopies || 0) > 0) {
        setButtonState(borrowButton, true, 'Borrow Reserved Copy', false);
      } else {
        setButtonState(borrowButton, true, 'Waiting For Available Copy', true);
      }
      setButtonState(reserveButton, false, 'Reserve Book', true);
      return;
    }

    setButtonState(cancelReservationButton, false, 'Cancel Reservation', true);

    if (Number(book.availableCopies || 0) > 0) {
      if (Number(summary.activeReservationsCount || 0) > 0) {
        setButtonState(borrowButton, true, 'Reserved Queue Active', true);
      } else {
        setButtonState(borrowButton, true, 'Borrow Book', false);
      }
      setButtonState(reserveButton, false, 'Reserve Book', true);
      return;
    }

    setButtonState(borrowButton, true, 'No Copies Available', true);
    setButtonState(reserveButton, true, 'Reserve Book', false);
  }

  async function loadDetailState() {
    const [detailRes, activeLoanRes, summaryRes] = await Promise.all([
      BookApi.apiRequest(`/api/book/find-by-id/${id}`),
      BookApi.apiRequest('/api/loan/my-active'),
      BookApi.apiRequest(`/api/reservation/book/${id}/summary`)
    ]);

    const book = detailRes?.body;
    if (!book) throw new Error('Book details were not returned by the API.');

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
    document.getElementById('detail-title').textContent = book.name || 'Untitled Book';
    document.getElementById('detail-desc').textContent = book.description || 'No description available.';
    renderMeta(book, summary);
    renderButtons(book, activeLoan, summary);
    document.getElementById('go-rate').href = `rate-book.html?bookId=${id}`;

    return { book, summary };
  }

  try {
    const state = await loadDetailState();

    borrowButton.addEventListener('click', async () => {
      try {
        await BookApi.apiRequest('/api/loan/borrow', {
          method: 'POST',
          body: { bookId: Number(id) }
        });
        BookUi.showMessage('detail-message', 'success', 'Book borrowed successfully.');
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
        BookUi.showMessage('detail-message', 'success', 'Reservation created successfully.');
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
          throw new Error('No active reservation found for this book.');
        }
        await BookApi.apiRequest(`/api/reservation/${summary.currentUserReservationId}/cancel`, {
          method: 'POST'
        });
        BookUi.showMessage('detail-message', 'success', 'Reservation cancelled.');
        await loadDetailState();
      } catch (error) {
        BookUi.showMessage('detail-message', 'error', error.message);
      }
    });

    const similarRes = await BookApi.apiRequest(`/api/book/recommendations/similar/${id}`);
    similarBooksWrap.innerHTML = BookUi.renderRecommendationShelves(similarRes?.body, {
      emptyMessage: 'No related recommendations were found for this book.'
    });

    if (state.book.author?.id) {
      const authorRes = await BookApi.apiRequest(`/api/book/find-all-by-author-id/${state.book.author.id}`);
      const authorBooks = Array.isArray(authorRes?.body) ? authorRes.body : [];
      const relatedBooks = authorBooks.filter(item => String(item.id) !== String(id)).slice(0, 6);
      document.getElementById('author-books').innerHTML = relatedBooks.length
        ? relatedBooks.map(item => BookUi.renderBookCard(item)).join('')
        : '<div class="card muted">No more books from this author.</div>';
    } else {
      document.getElementById('author-books').innerHTML = '<div class="card muted">No author shelf is available for this book.</div>';
    }
  } catch (error) {
    BookUi.showMessage('detail-message', 'error', error.message);
  }
});
