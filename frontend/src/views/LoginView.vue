<template>
  <div class="auth-page">
    <section class="auth-hero">
      <div class="brand-row">
        <div class="brand-mark large">R</div>
        <div>
          <h1>ReadSeek</h1>
          <p>{{ bi('AI 阅读资源发现系统', 'AI Reading Resource Discovery') }}</p>
        </div>
      </div>
      <div class="auth-points">
        <span>{{ bi('混合检索', 'Hybrid Search') }}</span>
        <span>{{ bi('证据约束 RAG', 'Grounded RAG') }}</span>
        <span>{{ bi('类 ChatGPT 阅读助手', 'ChatGPT-style Reading Assistant') }}</span>
      </div>
    </section>

    <section class="auth-panel">
      <h2>{{ bi('登录', 'Sign in') }}</h2>
      <p class="muted">{{ bi('进入图书、检索、推荐、问答和分析工作台。', 'Access catalog, search, recommendations, QA, and analytics.') }}</p>
      <el-form class="login-form" label-position="top" @submit.prevent="submit">
        <el-form-item :label="bi('邮箱', 'Email')">
          <el-input v-model="email" autocomplete="email" />
        </el-form-item>
        <el-form-item :label="bi('密码', 'Password')">
          <el-input v-model="password" type="password" show-password autocomplete="current-password" />
        </el-form-item>
        <el-button type="primary" :loading="loading" native-type="submit" class="wide-button">
          {{ bi('登录', 'Sign in') }}
        </el-button>
      </el-form>
      <div class="auth-links">
        <router-link to="/register">{{ bi('注册新用户', 'Create account') }}</router-link>
        <span>{{ bi('默认管理员来自 .env 配置', 'Default admin is configured in .env') }}</span>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { ElMessage } from 'element-plus';
import { useAuthStore } from '../stores/auth';
import { errorMessage } from '../services/api';
import { bi } from '../i18n';

const auth = useAuthStore();
const router = useRouter();
const route = useRoute();
const email = ref('admin@booknook.local');
const password = ref('');
const loading = ref(false);

async function submit() {
  loading.value = true;
  try {
    await auth.login(email.value.trim(), password.value);
    router.push(String(route.query.redirect || '/'));
  } catch (error) {
    ElMessage.error(errorMessage(error));
  } finally {
    loading.value = false;
  }
}
</script>
