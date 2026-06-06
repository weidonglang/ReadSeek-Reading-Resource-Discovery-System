<template>
  <div class="page">
    <div class="page-header">
      <div>
        <h1 class="page-title">{{ bi('个人中心', 'Profile') }}</h1>
        <p class="page-subtitle">{{ bi('管理个人资料、阅读偏好、语言和展示模式。', 'Manage your profile, reading preferences, language, and display mode.') }}</p>
      </div>
      <el-button type="primary" :loading="loading" @click="load">{{ bi('重新加载', 'Reload') }}</el-button>
    </div>

    <div class="grid grid-2">
      <section class="panel">
        <h2>{{ bi('显示设置', 'Display settings') }}</h2>
        <el-form label-position="top">
          <el-form-item :label="bi('界面语言', 'Language')">
            <el-segmented v-model="language" :options="languageOptions" />
          </el-form-item>
          <el-form-item :label="bi('演示模式', 'Demo mode')">
            <el-switch
              v-model="demoMode"
              :active-text="bi('显示技术演示入口', 'Show demo pages')"
              :inactive-text="bi('普通阅读模式', 'Reader mode')"
            />
          </el-form-item>
          <el-button type="primary" @click="saveDisplaySettings">{{ bi('保存显示设置', 'Save display settings') }}</el-button>
        </el-form>
      </section>

      <section class="panel">
        <h2>{{ bi('阅读偏好', 'Reading preferences') }}</h2>
        <el-form label-position="top" @submit.prevent="saveReading">
          <el-form-item :label="bi('阅读水平', 'Reading level')">
            <el-select v-model="readingLevel">
              <el-option :label="bi('入门', 'Beginner')" value="BEGINNER" />
              <el-option :label="bi('有基础', 'Intermediate')" value="INTERMEDIATE" />
              <el-option :label="bi('进阶', 'Advanced')" value="EXPERT" />
            </el-select>
          </el-form-item>
          <el-form-item :label="bi('偏好分类', 'Preferred categories')">
            <el-select v-model="categoryIds" multiple filterable>
              <el-option v-for="item in categories" :key="item.id" :label="item.name" :value="item.id" />
            </el-select>
          </el-form-item>
          <el-button type="primary" native-type="submit" :loading="savingReading">{{ bi('保存偏好', 'Save preferences') }}</el-button>
        </el-form>
      </section>
    </div>

    <section class="panel">
      <h2>{{ bi('用户资料', 'User profile') }}</h2>
      <el-form label-position="top" @submit.prevent="saveProfile">
        <div class="grid grid-2">
          <el-form-item :label="bi('名', 'First name')"><el-input v-model="profile.firstName" /></el-form-item>
          <el-form-item :label="bi('姓', 'Last name')"><el-input v-model="profile.lastName" /></el-form-item>
          <el-form-item :label="bi('邮箱', 'Email')"><el-input v-model="profile.email" disabled /></el-form-item>
          <el-form-item :label="bi('新密码', 'New password')"><el-input v-model="profile.password" type="password" show-password :placeholder="bi('留空则不修改', 'Leave blank to keep current password')" /></el-form-item>
          <el-form-item :label="bi('手机号', 'Phone')"><el-input v-model="profile.phoneNumber" /></el-form-item>
          <el-form-item :label="bi('国家', 'Country')"><el-input v-model="profile.country" /></el-form-item>
          <el-form-item :label="bi('生日', 'Birthdate')"><el-date-picker v-model="profile.birthdate" value-format="YYYY-MM-DD" type="date" /></el-form-item>
          <el-form-item :label="bi('年龄', 'Age')"><el-input-number v-model="profile.age" :min="0" /></el-form-item>
        </div>
        <el-button type="primary" native-type="submit" :loading="savingProfile">{{ bi('保存资料', 'Save profile') }}</el-button>
      </el-form>
    </section>
  </div>
</template>

<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue';
import { ElMessage } from 'element-plus';
import { catalogApi, userApi } from '../services/domain';
import { errorMessage } from '../services/api';
import {
  bi,
  currentLanguage,
  isDemoModeEnabled,
  setDemoModePreference,
  setLanguagePreference,
  type ReadSeekLanguage
} from '../i18n';

const loading = ref(false);
const savingProfile = ref(false);
const savingReading = ref(false);
const categories = ref<any[]>([]);
const categoryIds = ref<number[]>([]);
const readingLevel = ref('BEGINNER');
const language = ref<ReadSeekLanguage>(currentLanguage());
const demoMode = ref(isDemoModeEnabled());
const languageOptions = [
  { label: '中文', value: 'zh' },
  { label: 'English', value: 'en' }
];
const profile = reactive<any>({
  id: null,
  firstName: '',
  lastName: '',
  email: '',
  password: '',
  phoneNumber: '',
  birthdate: '',
  country: '',
  age: null
});

async function load() {
  loading.value = true;
  try {
    const [user, reading, categoryList] = await Promise.all([
      userApi.current(),
      userApi.readingInfo().catch(() => null),
      catalogApi.categories().catch(() => [])
    ]);
    Object.assign(profile, { ...user, password: '' });
    categories.value = categoryList || [];
    readingLevel.value = reading?.readingLevel || 'BEGINNER';
    categoryIds.value = (reading?.userBookCategories || []).map((item: any) => item?.category?.id).filter(Boolean);
  } catch (error) {
    ElMessage.error(errorMessage(error));
  } finally {
    loading.value = false;
  }
}

async function saveProfile() {
  savingProfile.value = true;
  try {
    const payload = { ...profile };
    if (!payload.password) payload.password = null;
    await userApi.update(payload);
    ElMessage.success(bi('资料已保存', 'Profile saved'));
  } catch (error) {
    ElMessage.error(errorMessage(error));
  } finally {
    savingProfile.value = false;
  }
}

async function saveReading() {
  savingReading.value = true;
  try {
    await userApi.saveReadingInfo({
      readingLevel: readingLevel.value,
      userBookCategories: categoryIds.value.map((id) => ({ category: { id } }))
    });
    ElMessage.success(bi('阅读偏好已保存', 'Reading preferences saved'));
  } catch (error) {
    ElMessage.error(errorMessage(error));
  } finally {
    savingReading.value = false;
  }
}

function saveDisplaySettings() {
  setLanguagePreference(language.value);
  setDemoModePreference(demoMode.value);
  ElMessage.success(bi('显示设置已保存，页面将刷新', 'Display settings saved. The page will reload.'));
  window.setTimeout(() => window.location.reload(), 300);
}

onMounted(load);
</script>