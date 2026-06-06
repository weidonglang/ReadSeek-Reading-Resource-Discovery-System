<template>
  <div class="page">
    <div class="page-header">
      <div>
        <h1 class="page-title">{{ bi('找书', 'Find Books') }}</h1>
        <p class="page-subtitle">{{ bi('按主题、作者、分类和关键词查找馆藏图书。', 'Find catalog books by topic, author, category, and keyword.') }}</p>
      </div>
      <el-button v-if="auth.isAdmin" type="primary" @click="openCreate">{{ bi('新增资源', 'New resource') }}</el-button>
    </div>

    <section class="panel toolbar-panel">
      <el-input v-model="filters.name" :placeholder="bi('书名、ISBN、作者、标签', 'Title, ISBN, author, tag')" clearable @keyup.enter="loadBooks(1)" />
      <el-select v-model="filters.categoryId" :placeholder="bi('分类', 'Category')" clearable>
        <el-option v-for="item in categories" :key="item.id" :label="item.name" :value="item.id" />
      </el-select>
      <el-select v-model="filters.authorId" :placeholder="bi('作者', 'Author')" filterable clearable>
        <el-option v-for="item in authors" :key="item.id" :label="item.name" :value="item.id" />
      </el-select>
      <el-button type="primary" :loading="loading" @click="loadBooks(1)">{{ bi('筛选', 'Filter') }}</el-button>
      <el-button @click="reset">{{ bi('重置', 'Reset') }}</el-button>
    </section>

    <section class="panel result-toolbar">
      <span>{{ bi('总数', 'Total') }}: {{ total }}</span>
      <span>{{ bi('当前页', 'Page') }}: {{ page }}</span>
      <el-button text @click="$router.push('/search')">{{ bi('使用智能问答', 'Use smart ask') }}</el-button>
    </section>

    <div class="book-grid">
      <BookCard v-for="book in books" :key="book.id" :book="book" />
    </div>
    <el-empty v-if="!loading && !books.length" :description="emptyText()" />

    <div class="pagination-bar">
      <el-pagination
        background
        layout="prev, pager, next, sizes"
        :page-size="pageSize"
        :current-page="page"
        :total="total"
        @current-change="loadBooks"
        @size-change="changeSize"
      />
    </div>

    <el-dialog v-model="editorVisible" :title="editorMode === 'create' ? bi('新增资源', 'Create resource') : bi('编辑资源', 'Edit resource')" width="760px">
      <p class="muted">{{ bi('高级字段可直接按后端 DTO JSON 编辑，适合覆盖旧前端管理能力。', 'Edit backend DTO JSON directly for advanced fields and full legacy management coverage.') }}</p>
      <el-input v-model="editorJson" type="textarea" :rows="18" spellcheck="false" />
      <template #footer>
        <el-button @click="editorVisible = false">{{ bi('取消', 'Cancel') }}</el-button>
        <el-button type="primary" :loading="saving" @click="saveBook">{{ bi('保存', 'Save') }}</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue';
import { ElMessage } from 'element-plus';
import BookCard from '../components/BookCard.vue';
import { catalogApi, normalizePage } from '../services/domain';
import { errorMessage } from '../services/api';
import { useAuthStore } from '../stores/auth';
import type { Book } from '../types';
import { bi, emptyText } from '../i18n';

const auth = useAuthStore();

const books = ref<Book[]>([]);
const categories = ref<any[]>([]);
const authors = ref<any[]>([]);
const total = ref(0);
const page = ref(1);
const pageSize = ref(12);
const loading = ref(false);
const saving = ref(false);
const editorVisible = ref(false);
const editorMode = ref<'create' | 'edit'>('create');
const editorJson = ref('');

const filters = reactive({
  name: '',
  categoryId: null as number | null,
  authorId: null as number | null
});

function buildCriteria() {
  return {
    name: filters.name || null,
    categories: filters.categoryId ? [filters.categoryId] : null,
    authors: filters.authorId ? [filters.authorId] : null
  };
}

async function loadBooks(targetPage = page.value) {
  loading.value = true;
  try {
    const body = await catalogApi.searchResources(buildCriteria(), targetPage, pageSize.value);
    const normalized = normalizePage<Book>(body);
    books.value = normalized.items;
    total.value = normalized.total;
    page.value = targetPage;
  } catch (error) {
    ElMessage.error(errorMessage(error));
  } finally {
    loading.value = false;
  }
}

function changeSize(size: number) {
  pageSize.value = size;
  loadBooks(1);
}

function reset() {
  filters.name = '';
  filters.categoryId = null;
  filters.authorId = null;
  loadBooks(1);
}

function openCreate() {
  editorMode.value = 'create';
  editorJson.value = JSON.stringify({
    name: '',
    description: '',
    isbn: '',
    totalCopies: 1,
    availableCopies: 1,
    author: { id: authors.value[0]?.id || 1 },
    category: { id: categories.value[0]?.id || 1 }
  }, null, 2);
  editorVisible.value = true;
}

async function saveBook() {
  saving.value = true;
  try {
    const payload = JSON.parse(editorJson.value);
    if (editorMode.value === 'create') await catalogApi.createBook(payload);
    else await catalogApi.updateBook(payload);
    ElMessage.success(bi('保存成功', 'Saved'));
    editorVisible.value = false;
    await loadBooks(page.value);
  } catch (error) {
    ElMessage.error(errorMessage(error));
  } finally {
    saving.value = false;
  }
}

onMounted(async () => {
  const [categoryRes, authorRes] = await Promise.allSettled([catalogApi.categories(), catalogApi.authors()]);
  if (categoryRes.status === 'fulfilled') categories.value = categoryRes.value || [];
  if (authorRes.status === 'fulfilled') authors.value = normalizePage<any>(authorRes.value).items;
  loadBooks(1);
});
</script>
