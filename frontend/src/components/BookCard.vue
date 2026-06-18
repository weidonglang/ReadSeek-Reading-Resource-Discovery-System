<template>
  <el-card class="book-card" shadow="never">
    <img class="book-cover" :src="book.imageUrl || fallbackCover" :alt="book.name" />
    <div>
      <strong>{{ book.name }}</strong>
      <div class="muted">{{ book.author?.name || bi('未知作者', 'Unknown author') }}</div>
      <div class="muted">{{ localizeCategory(book.category?.name) || bi('未分类', 'Uncategorized') }}</div>
    </div>
    <div class="tag-row">
      <el-tag size="small">{{ bi('评分', 'Rate') }} {{ book.rate ?? 0 }}</el-tag>
      <el-tag size="small" type="success">{{ bi('可借', 'Available') }} {{ book.availableCopies ?? 0 }}/{{ book.totalCopies ?? 0 }}</el-tag>
    </div>
    <p v-if="book.recommendationReason" class="muted line-clamp">{{ localizeRecommendationReason(book.recommendationReason) }}</p>
    <el-button type="primary" plain @click="$router.push(`/books/${book.id}`)">{{ bi('查看详情', 'Details') }}</el-button>
  </el-card>
</template>

<script setup lang="ts">
import type { Book } from '../types';
import { bi, currentLanguage } from '../i18n';

defineProps<{ book: Book }>();

const fallbackCover = '/readseek-service/book-covers/default-book-cover.svg';

const categoryZh: Record<string, string> = {
  'Action and Adventure': '动作与冒险',
  Adventure: '冒险',
  Art: '艺术',
  Biography: '传记',
  Business: '商业',
  Children: '儿童',
  Classic: '经典',
  Classics: '经典',
  Computer: '计算机',
  Education: '教育',
  Fantasy: '奇幻',
  Fiction: '小说',
  History: '历史',
  Horror: '恐怖',
  Mathematics: '数学',
  Philosophy: '哲学',
  Psychology: '心理学',
  Romance: '爱情',
  Romantic: '爱情',
  'Science Fiction': '科幻',
  'Sci-Fi': '科幻',
  'Self-Help': '自助成长'
};

function localizeCategory(value?: string | null): string {
  if (!value) return '';
  if (currentLanguage() === 'en') return value;
  return categoryZh[value] || value;
}

function localizeRecommendationReason(reason: string): string {
  if (currentLanguage() === 'en') return reason;

  const popular = reason.match(/^Recently popular: (\d+) ratings, average ([\d.]+), available (\d+)\/(\d+) copies\.$/);
  if (popular) {
    return `近期热门：${popular[1]} 次评分，平均分 ${popular[2]}，可借 ${popular[3]}/${popular[4]} 本。`;
  }

  const preferred = reason.match(/^Matches your preferred category: (.+)\.$/);
  if (preferred) {
    return `匹配你的偏好分类：${localizeCategory(preferred[1])}。`;
  }

  const collaborative = reason.match(/^Users with similar tastes also liked (.+)\. Current rating ([\d.]+)\.$/);
  if (collaborative) {
    return `与你口味相近的读者也喜欢《${collaborative[1]}》。当前评分 ${collaborative[2]}。`;
  }

  const activity = reason.match(/^Close to books you already engaged with in category (.+)\.$/);
  if (activity) {
    return `接近你已互动过的${localizeCategory(activity[1])}类资源。`;
  }

  return reason;
}
</script>
