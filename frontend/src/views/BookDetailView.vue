<template>
  <div class="page">
    <el-button text @click="$router.back()">{{ bi('返回', 'Back') }}</el-button>

    <section v-if="book" class="panel detail-layout">
      <img class="book-cover detail-cover" :src="book.imageUrl || fallbackCover" :alt="book.name" />
      <div>
        <h1 class="page-title">{{ book.name }}</h1>
        <p class="page-subtitle">{{ book.author?.name }} / {{ book.category?.name }} / {{ book.publisher?.name || '-' }}</p>
        <div class="tag-row detail-tags">
          <el-tag>{{ bi('评分', 'Rate') }} {{ book.rate ?? 0 }}</el-tag>
          <el-tag type="success">{{ bi('库存', 'Copies') }} {{ book.availableCopies ?? 0 }}/{{ book.totalCopies ?? 0 }}</el-tag>
          <el-tag v-if="book.pagesNumber">{{ bi('页数', 'Pages') }} {{ book.pagesNumber }}</el-tag>
          <el-tag v-if="book.readingDuration">{{ bi('阅读时长', 'Reading time') }} {{ book.readingDuration }} min</el-tag>
          <el-tag v-if="book.isbn">ISBN {{ book.isbn }}</el-tag>
        </div>

        <p class="description">{{ book.description || bi('暂无简介。', 'No description yet.') }}</p>

        <div class="action-row">
          <el-button type="primary" :loading="borrowing" @click="borrow">{{ bi('借阅', 'Borrow') }}</el-button>
          <el-button :loading="reserving" @click="reserve">{{ bi('预约', 'Reserve') }}</el-button>
          <el-rate v-model="rating" />
          <el-button plain :loading="ratingSaving" @click="rate">{{ bi('提交评分', 'Submit rating') }}</el-button>
        </div>

        <el-divider />
        <h3>{{ bi('标签与推荐解释', 'Tags and recommendation explanation') }}</h3>
        <div class="tag-row">
          <el-tag v-for="tag in book.tags || []" :key="tag.id" type="info">{{ tag.name }}</el-tag>
        </div>
        <p class="muted">{{ book.recommendationReason || bi('当前详情入口没有携带推荐解释。', 'No recommendation explanation was attached to this entry point.') }}</p>
      </div>
    </section>

    <section class="panel" v-if="similar.length">
      <h2>{{ bi('相似资源', 'Similar resources') }}</h2>
      <div class="book-grid">
        <BookCard v-for="item in similar" :key="item.id" :book="item" />
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue';
import { useRoute } from 'vue-router';
import { ElMessage } from 'element-plus';
import BookCard from '../components/BookCard.vue';
import { catalogApi, loanApi, reservationApi } from '../services/domain';
import { errorMessage } from '../services/api';
import type { Book } from '../types';
import { bi } from '../i18n';

const route = useRoute();
const book = ref<Book | null>(null);
const similar = ref<Book[]>([]);
const rating = ref(0);
const borrowing = ref(false);
const reserving = ref(false);
const ratingSaving = ref(false);
const fallbackCover = '/readseek-service/book-covers/default-book-cover.svg';

async function borrow() {
  if (!book.value) return;
  borrowing.value = true;
  try {
    await loanApi.borrow(book.value.id);
    ElMessage.success(bi('借阅成功', 'Borrowed'));
  } catch (error) {
    ElMessage.error(errorMessage(error));
  } finally {
    borrowing.value = false;
  }
}

async function reserve() {
  if (!book.value) return;
  reserving.value = true;
  try {
    await reservationApi.reserve(book.value.id);
    ElMessage.success(bi('预约成功', 'Reserved'));
  } catch (error) {
    ElMessage.error(errorMessage(error));
  } finally {
    reserving.value = false;
  }
}

async function rate() {
  if (!book.value || !rating.value) return;
  ratingSaving.value = true;
  try {
    await catalogApi.rateBook(book.value.id, rating.value);
    ElMessage.success(bi('评分已提交', 'Rating submitted'));
  } catch (error) {
    ElMessage.error(errorMessage(error));
  } finally {
    ratingSaving.value = false;
  }
}

onMounted(async () => {
  try {
    book.value = await catalogApi.getBook(String(route.params.id));
    rating.value = book.value.rate || 0;
    similar.value = await catalogApi.similar(String(route.params.id)).catch(() => []);
  } catch (error) {
    ElMessage.error(errorMessage(error));
  }
});
</script>

<style scoped>
.detail-layout {
  display: grid;
  gap: 24px;
  grid-template-columns: 260px minmax(0, 1fr);
  margin-bottom: 16px;
}

.detail-cover {
  max-width: 260px;
}

.detail-tags {
  margin: 14px 0;
}

.description {
  color: #344054;
  line-height: 1.75;
}

.action-row {
  align-items: center;
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

@media (max-width: 800px) {
  .detail-layout {
    grid-template-columns: 1fr;
  }
}
</style>
