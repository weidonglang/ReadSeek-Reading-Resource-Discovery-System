<template>
  <div class="auth-page">
    <section class="auth-hero">
      <div class="brand-row">
        <div class="brand-mark large">R</div>
        <div>
          <h1>{{ bi('创建 ReadSeek 账号', 'Create a ReadSeek account') }}</h1>
          <p>{{ bi('注册后可维护阅读偏好、借阅预约、评分和推荐反馈。', 'Use preferences, loans, reservations, ratings, and recommendation feedback after registration.') }}</p>
        </div>
      </div>
    </section>

    <section class="auth-panel">
      <h2>{{ bi('注册', 'Register') }}</h2>
      <el-form label-position="top" @submit.prevent="submit">
        <div class="grid grid-2">
          <el-form-item :label="bi('名', 'First name')"><el-input v-model="form.firstName" /></el-form-item>
          <el-form-item :label="bi('姓', 'Last name')"><el-input v-model="form.lastName" /></el-form-item>
        </div>
        <el-form-item :label="bi('邮箱', 'Email')"><el-input v-model="form.email" autocomplete="email" /></el-form-item>
        <el-form-item :label="bi('密码', 'Password')"><el-input v-model="form.password" type="password" show-password /></el-form-item>
        <el-button type="primary" native-type="submit" :loading="loading" class="wide-button">{{ bi('创建账号', 'Create account') }}</el-button>
      </el-form>
      <div class="auth-links">
        <router-link to="/login">{{ bi('已有账号，返回登录', 'Already have an account? Sign in') }}</router-link>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref } from 'vue';
import { useRouter } from 'vue-router';
import { ElMessage } from 'element-plus';
import { userApi } from '../services/domain';
import { errorMessage } from '../services/api';
import { bi } from '../i18n';

const router = useRouter();
const loading = ref(false);
const form = reactive({
  firstName: '',
  lastName: '',
  email: '',
  password: ''
});

async function submit() {
  loading.value = true;
  try {
    await userApi.register({ ...form, role: 'USER' });
    ElMessage.success(bi('注册成功，请登录', 'Registration succeeded. Please sign in.'));
    router.push('/login');
  } catch (error) {
    ElMessage.error(errorMessage(error));
  } finally {
    loading.value = false;
  }
}
</script>
