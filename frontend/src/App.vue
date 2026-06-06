<template>
  <el-container class="app-shell" :class="{ 'chat-shell': route.path === '/ai-chat' }">
    <el-aside v-if="auth.isAuthenticated" width="276px" class="side-nav">
      <div class="brand">
        <div class="brand-mark">R</div>
        <div>
          <strong>ReadSeek</strong>
          <span>{{ bi('AI 阅读资源发现系统', 'AI Reading Discovery') }}</span>
        </div>
      </div>

      <el-menu router :default-active="route.path" class="nav-menu">
        <el-menu-item v-for="item in visibleNavItems" :key="item.path" :index="item.path">
          <el-icon><component :is="item.icon" /></el-icon>
          <span>{{ item.label }}</span>
        </el-menu-item>
      </el-menu>
    </el-aside>

    <el-container>
      <el-header v-if="auth.isAuthenticated" class="top-bar">
        <div>
          <strong>{{ pageTitle }}</strong>
          <span>{{ auth.user?.email }} · {{ auth.user?.role || 'USER' }}</span>
        </div>
        <div class="top-actions">
          <el-button text @click="router.push('/profile')">{{ bi('个人中心', 'Profile') }}</el-button>
          <el-button @click="logout">{{ bi('退出', 'Sign out') }}</el-button>
        </div>
      </el-header>
      <el-main>
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import {
  Aim,
  ChatDotRound,
  Collection,
  DataAnalysis,
  DocumentChecked,
  HomeFilled,
  Management,
  Notebook,
  Reading,
  Search,
  Star,
  User
} from '@element-plus/icons-vue';
import { useAuthStore } from './stores/auth';
import { bi, isDemoModeEnabled } from './i18n';

const auth = useAuthStore();
const route = useRoute();
const router = useRouter();
const demoMode = computed(() => isDemoModeEnabled());

const navItems = [
  { path: '/', label: bi('首页', 'Home'), icon: HomeFilled },
  { path: '/books', label: bi('找书', 'Find Books'), icon: Collection },
  { path: '/search', label: bi('智能问答', 'Smart Ask'), icon: Search },
  { path: '/ai-chat', label: bi('AI 助手', 'AI Assistant'), icon: ChatDotRound },
  { path: '/recommendations', label: bi('推荐', 'Recommendations'), icon: Star },
  { path: '/planning', label: bi('阅读计划', 'Reading Plan'), icon: Notebook },
  { path: '/borrowings', label: bi('我的借阅', 'My Loans'), icon: Reading },
  { path: '/profile', label: bi('个人中心', 'Profile'), icon: User },
  { path: '/rag', label: bi('RAG 技术页', 'RAG Technical'), icon: Aim, demoOnly: true },
  { path: '/management', label: bi('资源管理', 'Management'), icon: Management, adminOnly: true },
  { path: '/admin', label: bi('管理分析', 'Analytics'), icon: DataAnalysis, adminOnly: true },
  { path: '/evaluation', label: bi('检索测评', 'Evaluation'), icon: DocumentChecked, demoOnly: true }
];

const visibleNavItems = computed(() => navItems.filter((item) => {
  if (item.adminOnly) return auth.isAdmin;
  if (item.demoOnly) return auth.isAdmin || demoMode.value;
  return true;
}));

const pageTitle = computed(() => {
  return navItems.find((item) => item.path === route.path)?.label || 'ReadSeek';
});

function logout() {
  auth.logout();
  router.push('/login');
}
</script>
