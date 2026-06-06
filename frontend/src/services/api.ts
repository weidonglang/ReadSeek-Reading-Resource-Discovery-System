import axios from 'axios';
import type { ApiResponse } from '../types';

const defaultBaseUrl = import.meta.env.VITE_API_BASE_URL || '/readseek-service';

export const api = axios.create({
  baseURL: defaultBaseUrl,
  timeout: 180000,
  headers: {
    'Content-Type': 'application/json'
  }
});

const authStorageKeys = [
  'readseek_vue_access_token',
  'readseek_vue_refresh_token',
  'readseek_vue_user'
];

function clearStoredAuth() {
  authStorageKeys.forEach((key) => localStorage.removeItem(key));
}

function isUsableToken(token: string | null) {
  if (!token) {
    return false;
  }
  const normalized = token.trim();
  return Boolean(normalized) && normalized !== 'undefined' && normalized !== 'null';
}

function isJwtAuthError(error: unknown) {
  if (!axios.isAxiosError(error)) {
    return false;
  }
  const status = error.response?.status;
  const message = String(
    error.response?.data?.message ||
      error.response?.data?.error ||
      error.response?.data ||
      ''
  ).toLowerCase();
  return status === 401 ||
    (status === 400 && (message.includes('jwt') || message.includes('bearer') || message.includes('token')));
}

api.interceptors.request.use((config) => {
  const requestUrl = config.url || '';
  const isAuthBootstrapRequest =
    requestUrl.includes('/api/auth/log-in') || requestUrl.includes('/api/auth/refresh-token');
  if (isAuthBootstrapRequest) {
    delete config.headers.Authorization;
    return config;
  }

  const token = localStorage.getItem('readseek_vue_access_token');
  if (isUsableToken(token)) {
    config.headers.Authorization = `Bearer ${token!.trim()}`;
  } else {
    delete config.headers.Authorization;
  }
  return config;
});

api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (isJwtAuthError(error)) {
      clearStoredAuth();
      if (!window.location.pathname.includes('/login')) {
        window.location.assign(`/login?redirect=${encodeURIComponent(window.location.pathname)}`);
      }
    }
    return Promise.reject(error);
  }
);

export async function unwrap<T>(request: Promise<{ data: ApiResponse<T> }>): Promise<T> {
  const response = await request;
  return response.data.body;
}

export function errorMessage(error: unknown): string {
  if (axios.isAxiosError(error)) {
    return error.response?.data?.message || error.response?.data?.error || error.message;
  }
  return error instanceof Error ? error.message : String(error);
}
