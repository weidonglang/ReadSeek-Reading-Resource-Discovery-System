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
          <h2>{{ shelfTitle(shelf) }}</h2>
          <p class="muted">{{ shelfDescription(shelf) }}</p>
        </div>
        <div v-if="auth.isAdmin" class="tag-row">
          <el-tag>{{ shelfSource(shelf) }}</el-tag>
          <el-tag v-if="shelf.reasonType" type="warning">{{ reasonTypeLabel(shelf.reasonType) }}</el-tag>
        </div>
      </div>
      <p v-if="auth.isAdmin" class="muted">{{ shelfStrategy(shelf) }}</p>
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
import { bi, currentLanguage, emptyText } from '../i18n';

const auth = useAuthStore();
const recentDays = ref(30);
const overview = ref<RecommendationOverview | null>(null);
const analytics = ref<any>(null);

const shelfCopy: Record<string, { title: string; description: string; source: string; strategy: string }> = {
  popular: {
    title: '热门图书',
    description: '综合近 30 天借阅、点击和评分信号得到的热门推荐。',
    source: '热门',
    strategy: '按近期借阅、点击、评分、评分人数和可借数量综合排序。'
  },
  collaborative: {
    title: '相似读者也喜欢',
    description: '根据与你评分模式相近的读者推断出的推荐。',
    source: '协同过滤',
    strategy: '使用相似评分用户的协同过滤结果。'
  },
  preferences: {
    title: '偏好分类推荐',
    description: '与你个人资料中选择的偏好分类相匹配的推荐。',
    source: '偏好',
    strategy: '匹配用户阅读资料中选择的分类。'
  },
  activity: {
    title: '基于你的活动',
    description: '根据你评分或借阅过的图书分类与标签生成。',
    source: '行为',
    strategy: '匹配你评分或借阅过的资源分类和标签。'
  },
  'same-category': {
    title: '同类图书',
    description: '与当前图书分类相同的相关推荐。',
    source: '同分类',
    strategy: '基于分类重叠、共享标签和热度进行内容相似推荐。'
  },
  'shared-tags': {
    title: '共享标签',
    description: '与当前图书拥有相同标签的相关推荐。',
    source: '共享标签',
    strategy: '基于共享标签和热度进行内容相似推荐。'
  },
  'cold-start': {
    title: '新用户精选',
    description: '在用户或图书证据不足时，使用热门资源兜底。',
    source: '冷启动',
    strategy: '当用户或资源证据不足时，使用热门资源。'
  },
  fallback: {
    title: '兜底推荐',
    description: '在个性化信号不足时，使用热门资源兜底。',
    source: '兜底',
    strategy: '当用户或资源证据不足时，使用热门资源。'
  }
};

const reasonTypeZh: Record<string, string> = {
  POPULARITY: '热度',
  COLLABORATIVE_FILTERING: '协同过滤',
  PROFILE_PREFERENCE: '个人偏好',
  USER_ACTIVITY: '用户行为',
  CONTENT_SIMILARITY: '内容相似',
  TAG_SIMILARITY: '标签相似',
  COLD_START_FALLBACK: '冷启动兜底',
  RECOMMENDATION_RULE: '推荐规则'
};

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

function shelfKey(shelf: RecommendationShelf) {
  return shelf.key || shelf.source || '';
}

function shelfTitle(shelf: RecommendationShelf) {
  if (currentLanguage() === 'en') return shelf.title;
  return shelfCopy[shelfKey(shelf)]?.title || shelf.title;
}

function shelfDescription(shelf: RecommendationShelf) {
  if (currentLanguage() === 'en') return shelf.description || '';

  if (shelfKey(shelf) === 'popular') {
    const days = shelf.description?.match(/last (\d+) days/)?.[1] || String(recentDays.value);
    return `综合近 ${days} 天借阅、点击和评分信号得到的热门推荐。`;
  }

  return shelfCopy[shelfKey(shelf)]?.description || shelf.description || '';
}

function shelfSource(shelf: RecommendationShelf) {
  const source = shelf.source || shelf.key;
  if (currentLanguage() === 'en') return source;
  return shelfCopy[shelfKey(shelf)]?.source || source;
}

function reasonTypeLabel(reasonType: string) {
  if (currentLanguage() === 'en') return reasonType;
  return reasonTypeZh[reasonType] || reasonType;
}

function shelfStrategy(shelf: RecommendationShelf) {
  if (currentLanguage() === 'en') return shelf.strategy || '';
  return shelfCopy[shelfKey(shelf)]?.strategy || shelf.strategy || '';
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
