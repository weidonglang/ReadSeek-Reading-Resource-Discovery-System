import { createRouter, createWebHistory } from 'vue-router';
import { useAuthStore } from '../stores/auth';
import { isDemoModeEnabled } from '../i18n';
import LoginView from '../views/LoginView.vue';
import RegisterView from '../views/RegisterView.vue';
import DashboardView from '../views/DashboardView.vue';
import BooksView from '../views/BooksView.vue';
import BookDetailView from '../views/BookDetailView.vue';
import BorrowingsView from '../views/BorrowingsView.vue';
import ProfileView from '../views/ProfileView.vue';
import PlanningView from '../views/PlanningView.vue';
import ManagementView from '../views/ManagementView.vue';
import HybridSearchView from '../views/HybridSearchView.vue';
import RagQaView from '../views/RagQaView.vue';
import AiChatView from '../views/AiChatView.vue';
import RecommendationsView from '../views/RecommendationsView.vue';
import AdminAnalyticsView from '../views/AdminAnalyticsView.vue';
import EvaluationView from '../views/EvaluationView.vue';

export const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/login', name: 'login', component: LoginView, meta: { public: true } },
    { path: '/register', name: 'register', component: RegisterView, meta: { public: true } },
    { path: '/', name: 'dashboard', component: DashboardView },
    { path: '/books', name: 'books', component: BooksView },
    { path: '/books/:id', name: 'book-detail', component: BookDetailView },
    { path: '/search', name: 'hybrid-search', component: HybridSearchView },
    { path: '/rag', name: 'rag', component: RagQaView, meta: { demoOnly: true } },
    { path: '/ai-chat', name: 'ai-chat', component: AiChatView },
    { path: '/recommendations', name: 'recommendations', component: RecommendationsView },
    { path: '/borrowings', name: 'borrowings', component: BorrowingsView },
    { path: '/profile', name: 'profile', component: ProfileView },
    { path: '/planning', name: 'planning', component: PlanningView },
    { path: '/management', name: 'management', component: ManagementView, meta: { adminOnly: true } },
    { path: '/admin', name: 'admin', component: AdminAnalyticsView, meta: { adminOnly: true } },
    { path: '/evaluation', name: 'evaluation', component: EvaluationView, meta: { demoOnly: true } }
  ]
});

router.beforeEach((to) => {
  const auth = useAuthStore();
  if (!to.meta.public && !auth.isAuthenticated) {
    return { name: 'login', query: { redirect: to.fullPath } };
  }
  if (to.meta.adminOnly && !auth.isAdmin) {
    return { name: 'dashboard' };
  }
  if (to.meta.demoOnly && !auth.isAdmin && !isDemoModeEnabled()) {
    return { name: 'dashboard' };
  }
  return true;
});
