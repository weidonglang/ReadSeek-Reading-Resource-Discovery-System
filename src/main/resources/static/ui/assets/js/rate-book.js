document.addEventListener('DOMContentLoaded', async () => {
  BookUi.injectLayout();
  if (!BookUi.requireLogin()) return;

  const params = new URLSearchParams(window.location.search);
  const bookId = params.get('bookId');
  if (!bookId) {
    BookUi.showMessage('rate-message', 'error', '缺少 bookId 参数。');
    return;
  }

  try {
    const [user, bookRes] = await Promise.all([
      BookApi.fetchCurrentUser(),
      BookApi.apiRequest(`/api/book/find-by-id/${bookId}`)
    ]);
    const book = bookRes?.body;
    document.getElementById('rate-book-name').textContent = book?.name || `图书 #${bookId}`;
    document.getElementById('rate-book-summary').textContent = `${book?.author?.name || '未知作者'} / ISBN ${book?.isbn || '-'} / 当前评分 ${book?.rate ?? '-'}`;

    document.getElementById('rate-form').addEventListener('submit', async event => {
      event.preventDefault();
      const payload = {
        user: user ? { id: user.id, email: user.email } : null,
        book: { id: Number(bookId) },
        rate: Number(document.getElementById('rate').value),
        comment: document.getElementById('comment').value.trim()
      };

      try {
        await BookApi.apiRequest('/api/book/rate', {
          method: 'POST',
          body: payload
        });
        BookUi.showMessage('rate-message', 'success', '评分提交成功。');
      } catch (error) {
        BookUi.showMessage('rate-message', 'error', error.message);
      }
    });
  } catch (error) {
    BookUi.showMessage('rate-message', 'error', error.message);
  }
});
