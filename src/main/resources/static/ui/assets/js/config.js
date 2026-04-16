window.APP_CONFIG = {
  apiBaseUrl: (() => {
    const { origin, pathname } = window.location;
    const currentBackendBase = `${origin}/readseek-service`;

    if (pathname.includes('/readseek-service/')) {
      return currentBackendBase;
    }

    const stored = localStorage.getItem('book_api_base_url');
    if (stored) return stored;
    return 'http://localhost:8010/readseek-service';
  })(),
  appName: 'ReadSeek'
};
