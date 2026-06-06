<template>
  <div class="page">
    <div class="page-header">
      <div>
        <h1 class="page-title">{{ bi('为你推荐', 'Recommended for You') }}</h1>
        <p class="page-subtitle">{{ bi('根据你的阅读兴趣、搜索主题和馆藏资源，挑选可能适合你的图书。', 'Books selected from your interests, search topics, and the catalog.') }}</p>
      </div>
      <el-select v-if="auth.isAdmin" v-model="recentDays" style="width: 180px" @change="load">
        <el-option :label="bi('近 7 天', 'Last 7 days')" :value="7" />
        <el-option :label="bi('近 30 天', 'Last 30 days')" :value="30" />
        <el-option :label="bi('近 90 天', 'Last 90 days')" :value="90" />
      </el-select>
    </div>

    <div class="grid grid-4" v-if="analytics && auth.isAdmin">
      <MetricCard :label="bi('曝光', 'Exposure')" :value="analytics.exposureCount || 0" />
      <MetricCard :label="bi('点击', 'Clicks')" :value="analytics.clickCount || 0" />
      <MetricCard label="CTR" :value="analytics.ctr || analytics.clickThroughRate || 0" />
      <MetricCard :label="bi('反馈率', 'Feedback rate')" :value="analytics.feedbackRate || 0" />
    </div>

    <section v-for="shelf in overview?.shelves || []" :key="shelf.key" class="panel shelf-section">
      <div class="page-header">
        <div>
          <h2>{{ shelf.title }}</h2>
          <p class="muted">{{ shelf.description }}</p>
        </div>
        <div v-if="auth.isAdmin" class="tag-row">
          <el-tag>{{ shelf.source || shelf.key }}</el-tag>
          <el-tag v-if="shelf.reasonType" type="warning">{{ shelf.reasonType }}</el-tag>
        </div>
      </div>
      <p v-if="auth.isAdmin" class="muted">{{ shelf.strategy }}</p>
      <div class="book-grid">
        <div v-for="book in shelf.books || []" :key="book.id" class="recommend-card">
          <BookCard :book="book" />
          <div class="feedback-row">
            <el-button size="small" @click="sendFeedback(book, shelf, 'INTERESTED')">{{ bi('感兴趣', 'Interested') }}</el-button>
            <el-button size="small" @click="sendFeedback(book, shelf, 'NOT_INTERESTED')">{{ bi('不感兴趣', 'Not interested') }}</el-button>
          </div>
        </div>
      </div>
    </section>
    <el-empty v-if="!overview?.shelves?.length" :description="emptyText()" />
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue';
import { ElMessage } from 'element-plus';
import BookCard from '../components/BookCard.vue';
import MetricCard from '../components/MetricCard.vue';
import { api, errorMessage, unwrap } from '../services/api';
import { analyticsApi, catalogApi } from '../services/domain';
import { useAuthStore } from '../stores/auth';
import type { Book, RecommendationOverview, RecommendationShelf } from '../types';
import { bi, emptyText } from '../i18n';

const auth = useAuthStore();
const recentDays = ref(30);
const overview = ref<RecommendationOverview | null>(null);
const analytics = ref<any>(null);

async function load() {
  try {
    const [rec, stats] = await Promise.allSettled([
      catalogApi.recommendationOverview(),
      auth.isAdmin ? analyticsApi.recAnalytics() : Promise.resolve(null)
    ]);
    if (rec.status === 'fulfilled') overview.value = rec.value;
    if (stats.status === 'fulfilled' && stats.value) analytics.value = stats.value;
  } catch (error) {
    ElMessage.error(errorMessage(error));
  }
}

async function sendFeedback(book: Book, shelf: RecommendationShelf, feedback: string) {
  try {
    await unwrap<any>(api.post('/api/recommendation-events/feedback', {
      resourceId: book.id,
      recommendationSource: shelf.source || shelf.key,
      reasonType: shelf.reasonType,
      strategy: shelf.strategy,
      feedback
    }));
    ElMessage.success(bi('反馈已记录', 'Feedback recorded'));
  } catch (error) {
    ElMessage.error(errorMessage(error));
  }
}

onMounted(load);
</script>
