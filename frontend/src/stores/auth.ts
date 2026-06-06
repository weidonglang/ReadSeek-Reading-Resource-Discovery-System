import { defineStore } from 'pinia';
import { api, unwrap } from '../services/api';
import type { User } from '../types';

interface AuthState {
  accessToken: string;
  refreshToken: string;
  user: User | null;
}

export const useAuthStore = defineStore('auth', {
  state: (): AuthState => ({
    accessToken: localStorage.getItem('readseek_vue_access_token') || '',
    refreshToken: localStorage.getItem('readseek_vue_refresh_token') || '',
    user: JSON.parse(localStorage.getItem('readseek_vue_user') || 'null')
  }),
  getters: {
    isAuthenticated: (state) => Boolean(state.accessToken),
    isAdmin: (state) => state.user?.role === 'ADMIN'
  },
  actions: {
    async login(email: string, password: string) {
      this.logout();
      const auth = await unwrap<any>(api.post('/api/auth/log-in', { email, password }));
      this.accessToken = auth.accessToken;
      this.refreshToken = auth.refreshToken;
      localStorage.setItem('readseek_vue_access_token', this.accessToken);
      if (this.refreshToken) {
        localStorage.setItem('readseek_vue_refresh_token', this.refreshToken);
      }
      await this.fetchCurrentUser();
    },
    async fetchCurrentUser() {
      const user = await unwrap<User>(api.get('/api/auth/current'));
      this.user = user;
      localStorage.setItem('readseek_vue_user', JSON.stringify(user));
    },
    logout() {
      this.accessToken = '';
      this.refreshToken = '';
      this.user = null;
      localStorage.removeItem('readseek_vue_access_token');
      localStorage.removeItem('readseek_vue_refresh_token');
      localStorage.removeItem('readseek_vue_user');
    }
  }
});
