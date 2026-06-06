import { api, unwrap } from './api';
import type { Book, ChatResponse, QaResponse, RecommendationOverview, SearchResponse } from '../types';

export interface PageResult<T> {
  items: T[];
  total: number;
  page: number;
  pages: number;
}

export function normalizePage<T>(body: any): PageResult<T> {
  const items = body?.result || body?.list || body?.content || [];
  return {
    items: Array.isArray(items) ? items : [],
    total: body?.totalNumberOfElements ?? body?.totalElements ?? items.length ?? 0,
    page: body?.pageNumber ?? body?.number ?? 1,
    pages: body?.totalNumberOfPages ?? body?.totalPages ?? 1
  };
}

export function pagedPayload(criteria: Record<string, unknown> | null = null, pageNumber = 1, pageSize = 12) {
  return {
    criteria,
    pageNumber,
    pageSize,
    deletedRecords: false,
    sortingByList: [{ fieldName: 'id', direction: 'DESC', isNumber: true }]
  };
}

export const catalogApi = {
  searchResources(criteria: Record<string, unknown> | null, pageNumber = 1, pageSize = 12) {
    return unwrap<any>(api.post('/api/resources/search', pagedPayload(criteria, pageNumber, pageSize)));
  },
  hybridSearch(query: string, limit = 10) {
    return unwrap<SearchResponse>(api.get('/api/search/resources', { params: { q: query, limit } }));
  },
  getBook(id: string | number) {
    return unwrap<Book>(api.get(`/api/resources/${id}`));
  },
  createBook(payload: unknown) {
    return unwrap<Book>(api.post('/api/resources', payload));
  },
  updateBook(payload: unknown) {
    return unwrap<Book>(api.put('/api/resources', payload));
  },
  deleteBook(id: number) {
    return unwrap<boolean>(api.delete(`/api/resources/${id}`));
  },
  rateBook(bookId: number, rate: number) {
    return unwrap<any>(api.post('/api/resources/rate', { bookId, rate }));
  },
  categories() {
    return unwrap<any[]>(api.get('/api/resources/categories'));
  },
  tags() {
    return unwrap<any[]>(api.get('/api/tag'));
  },
  publishers() {
    return unwrap<any[]>(api.get('/api/publisher'));
  },
  authors(pageSize = 300) {
    return unwrap<any>(api.post('/api/author/find-all-paginated-filtered', pagedPayload({ name: null }, 1, pageSize)));
  },
  recommendationOverview() {
    return unwrap<RecommendationOverview>(api.get('/api/resources/recommendations/overview'));
  },
  similar(id: string | number) {
    return unwrap<Book[]>(api.get(`/api/resources/recommendations/similar/${id}`));
  }
};

export const loanApi = {
  active() {
    return unwrap<any[]>(api.get('/api/loan/my-active'));
  },
  history() {
    return unwrap<any[]>(api.get('/api/loan/my-history'));
  },
  adminActive() {
    return unwrap<any[]>(api.get('/api/loan/admin/active'));
  },
  adminHistory() {
    return unwrap<any[]>(api.get('/api/loan/admin/history'));
  },
  borrow(bookId: number) {
    return unwrap<any>(api.post('/api/loan/borrow', { bookId }));
  },
  returnBook(loanId: number) {
    return unwrap<any>(api.post(`/api/loan/${loanId}/return`));
  },
  renew(loanId: number) {
    return unwrap<any>(api.post(`/api/loan/${loanId}/renew`));
  }
};

export const reservationApi = {
  active() {
    return unwrap<any[]>(api.get('/api/reservation/my-active'));
  },
  history() {
    return unwrap<any[]>(api.get('/api/reservation/my-history'));
  },
  adminActive() {
    return unwrap<any[]>(api.get('/api/reservation/admin/active'));
  },
  adminHistory() {
    return unwrap<any[]>(api.get('/api/reservation/admin/history'));
  },
  reserve(bookId: number) {
    return unwrap<any>(api.post('/api/reservation/reserve', { bookId }));
  },
  cancel(id: number) {
    return unwrap<any>(api.post(`/api/reservation/${id}/cancel`));
  }
};

export const userApi = {
  register(payload: unknown) {
    return unwrap<any>(api.post('/api/user', payload));
  },
  current() {
    return unwrap<any>(api.get('/api/auth/current'));
  },
  update(payload: unknown) {
    return unwrap<any>(api.put('/api/user', payload));
  },
  readingInfo() {
    return unwrap<any>(api.get('/api/user/find-reading-info'));
  },
  saveReadingInfo(payload: unknown) {
    return unwrap<any>(api.post('/api/user/reading-info', payload));
  },
  dashboard() {
    return unwrap<any>(api.get('/api/user/home-dashboard'));
  }
};

export const ragApi = {
  ask(payload: unknown) {
    return unwrap<QaResponse>(api.post('/api/qa/evidence', payload));
  },
  citationClick(payload: unknown) {
    return unwrap<any>(api.post('/api/qa/citation-click', payload));
  }
};

export const chatApi = {
  send(payload: unknown) {
    return unwrap<ChatResponse>(api.post('/api/ai-chat/message', payload));
  },
  sessions() {
    return unwrap<any[]>(api.get('/api/ai-chat/sessions'));
  },
  session(id: string) {
    return unwrap<any>(api.get(`/api/ai-chat/sessions/${id}`));
  },
  deleteSession(id: string) {
    return unwrap<boolean>(api.delete(`/api/ai-chat/sessions/${id}`));
  }
};

export const planningApi = {
  compare(payload: unknown) {
    return unwrap<any>(api.post('/api/reading-plans/compare', payload));
  },
  path(payload: unknown) {
    return unwrap<any>(api.post('/api/reading-plans/path', payload));
  }
};

export function entityApi(basePath: string, paged = false) {
  return {
    async list() {
      if (paged) {
        const body = await unwrap<any>(api.post(`${basePath}/find-all-paginated-filtered`, pagedPayload({ name: null }, 1, 300)));
        return normalizePage<any>(body).items;
      }
      return unwrap<any[]>(api.get(basePath));
    },
    create(payload: unknown) {
      return unwrap<any>(api.post(basePath, payload));
    },
    update(payload: unknown) {
      return unwrap<any>(api.put(basePath, payload));
    },
    remove(id: number) {
      return unwrap<boolean>(api.delete(`${basePath}/${id}`));
    }
  };
}

export const analyticsApi = {
  behaviorDashboard() {
    return unwrap<any>(api.get('/api/behavior-log/dashboard'));
  },
  recentBehavior(limit = 20) {
    return unwrap<any[]>(api.get('/api/behavior-log/recent', { params: { limit } }));
  },
  qaAnalytics() {
    return unwrap<any>(api.get('/api/qa/analytics'));
  },
  recAnalytics() {
    return unwrap<any>(api.get('/api/recommendation-events/analytics'));
  },
  recRecent(limit = 20) {
    return unwrap<any[]>(api.get('/api/recommendation-events/recent', { params: { limit } }));
  }
};
