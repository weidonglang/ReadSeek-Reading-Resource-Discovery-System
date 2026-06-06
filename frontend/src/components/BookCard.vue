<template>
  <el-card class="book-card" shadow="never">
    <img class="book-cover" :src="book.imageUrl || fallbackCover" :alt="book.name" />
    <div>
      <strong>{{ book.name }}</strong>
      <div class="muted">{{ book.author?.name || bi('未知作者', 'Unknown author') }}</div>
      <div class="muted">{{ book.category?.name || bi('未分类', 'Uncategorized') }}</div>
    </div>
    <div class="tag-row">
      <el-tag size="small">{{ bi('评分', 'Rate') }} {{ book.rate ?? 0 }}</el-tag>
      <el-tag size="small" type="success">{{ bi('可借', 'Available') }} {{ book.availableCopies ?? 0 }}/{{ book.totalCopies ?? 0 }}</el-tag>
    </div>
    <p v-if="book.recommendationReason" class="muted line-clamp">{{ book.recommendationReason }}</p>
    <el-button type="primary" plain @click="$router.push(`/books/${book.id}`)">{{ bi('查看详情', 'Details') }}</el-button>
  </el-card>
</template>

<script setup lang="ts">
import type { Book } from '../types';
import { bi } from '../i18n';

defineProps<{ book: Book }>();

const fallbackCover = '/readseek-service/book-covers/default-book-cover.svg';
</script>
