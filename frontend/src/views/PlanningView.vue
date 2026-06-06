<template>
  <div class="page">
    <div class="page-header">
      <div>
        <h1 class="page-title">{{ bi('我的阅读计划', 'My Reading Plan') }}</h1>
        <p class="page-subtitle">{{ bi('输入想学习的主题，生成分阶段阅读路径；也可以选择几本书做对比。', 'Enter a topic to create a staged reading path, or compare selected books.') }}</p>
      </div>
    </div>

    <div class="grid grid-2">
      <section class="panel">
        <h2>{{ bi('生成阅读路径', 'Create reading path') }}</h2>
        <el-form label-position="top" @submit.prevent="generatePath">
          <el-form-item :label="bi('我想学习的主题', 'Topic')">
            <el-input v-model="pathForm.topic" :placeholder="bi('例如：人工智能入门、个人成长、Java 后端', 'e.g. AI fundamentals, personal growth, Java backend')" />
          </el-form-item>
          <div class="grid grid-2">
            <el-form-item :label="bi('我的基础水平', 'Level')">
              <el-select v-model="pathForm.readingLevel">
                <el-option :label="bi('入门', 'Beginner')" value="BEGINNER" />
                <el-option :label="bi('有基础', 'Intermediate')" value="INTERMEDIATE" />
                <el-option :label="bi('进阶', 'Advanced')" value="EXPERT" />
              </el-select>
            </el-form-item>
            <el-form-item :label="bi('计划周期', 'Plan period')">
              <el-select v-model="pathForm.period">
                <el-option :label="bi('1 周', '1 week')" value="1w" />
                <el-option :label="bi('2 周', '2 weeks')" value="2w" />
                <el-option :label="bi('1 个月', '1 month')" value="1m" />
                <el-option :label="bi('自定义', 'Custom')" value="custom" />
              </el-select>
            </el-form-item>
            <el-form-item :label="bi('每周阅读时间', 'Weekly reading time')">
              <el-input-number v-model="pathForm.weeklyHours" :min="1" :max="40" />
            </el-form-item>
            <el-form-item :label="bi('候选图书数量', 'Book count')">
              <el-input-number v-model="pathForm.limit" :min="3" :max="12" />
            </el-form-item>
          </div>
          <el-checkbox v-model="pathForm.preferAvailable">{{ bi('优先考虑当前可借资源', 'Prefer currently available resources') }}</el-checkbox>
          <div class="form-actions">
            <el-button type="primary" native-type="submit" :loading="pathLoading">{{ bi('生成计划', 'Create plan') }}</el-button>
          </div>
        </el-form>
      </section>

      <section class="panel">
        <h2>{{ bi('比较所选图书', 'Compare selected books') }}</h2>
        <p class="muted">{{ bi('从馆藏里选择 2-4 本书，比较主题、难度、评分和可借状态。', 'Choose 2-4 books from the catalog to compare topic, difficulty, rating, and availability.') }}</p>
        <el-select v-model="selectedBookIds" multiple filterable :placeholder="bi('选择图书', 'Select books')">
          <el-option v-for="book in bookOptions" :key="book.id" :label="book.name" :value="book.id" />
        </el-select>
        <div class="form-actions">
          <el-button type="primary" :disabled="selectedBookIds.length < 2" :loading="compareLoading" @click="compareSelectedBooks">
            {{ bi('比较所选图书', 'Compare selected books') }}
          </el-button>
        </div>
      </section>
    </div>

    <section v-if="pathResult" class="panel">
      <div class="page-header compact-header">
        <div>
          <h2>{{ bi('推荐阅读路径', 'Recommended reading path') }}</h2>
          <p class="muted">{{ pathResult.topic }} · {{ levelLabel(pathResult.readingLevel) }} · {{ pathForm.weeklyHours }}h/{{ bi('周', 'week') }}</p>
        </div>
      </div>
      <el-empty
        v-if="!pathResult.steps?.length"
        :description="bi('暂时没有找到完全匹配的馆藏资源。可以换一个关键词，或扩大到相关主题。', 'No matching catalog resources were found. Try another keyword or broaden the topic.')"
      />
      <div v-else class="plan-stage-list">
        <el-card v-for="step in pathResult.steps" :key="step.stepOrder" shadow="never" class="plan-stage-card">
          <template #header>
            <div class="result-head">
              <strong>{{ bi(`第 ${step.stepOrder} 阶段`, `Stage ${step.stepOrder}`) }}：{{ friendlyStage(step.stage) }}</strong>
              <span class="muted">{{ step.goal }}</span>
            </div>
          </template>
          <div class="book-grid compact-book-grid">
            <el-card v-for="book in step.resources || []" :key="book.resourceId" shadow="never" class="mini-card">
              <strong>{{ book.title }}</strong>
              <div class="muted">{{ book.author || bi('未知作者', 'Unknown author') }} · {{ book.category || bi('未分类', 'Uncategorized') }}</div>
              <p>{{ book.description || book.reason || bi('适合作为本阶段阅读材料。', 'A suitable resource for this stage.') }}</p>
              <div class="tag-row">
                <el-tag size="small">{{ difficultyLabel(step.stepOrder) }}</el-tag>
                <el-button text @click="$router.push(`/books/${book.resourceId}`)">{{ bi('查看详情', 'Details') }}</el-button>
              </div>
            </el-card>
          </div>
        </el-card>
      </div>
    </section>

    <section v-if="compareResult" class="panel">
      <h2>{{ bi('图书对比结果', 'Book comparison') }}</h2>
      <el-alert class="answer-box" type="success" :closable="false">
        <p>{{ compareResult.summary }}</p>
      </el-alert>
      <div class="grid grid-2">
        <el-card v-for="item in compareResult.items || []" :key="item.id" shadow="never" class="mini-card">
          <strong>{{ item.title }}</strong>
          <div class="muted">{{ item.author || bi('未知作者', 'Unknown author') }} · {{ item.category || bi('未分类', 'Uncategorized') }}</div>
          <p>{{ item.summary }}</p>
          <div class="tag-row">
            <el-tag>{{ bi('评分', 'Rating') }} {{ item.rating ?? 0 }}</el-tag>
            <el-tag type="success">{{ bi('可借', 'Available') }} {{ item.availableCopies ?? 0 }}/{{ item.totalCopies ?? 0 }}</el-tag>
          </div>
        </el-card>
      </div>
      <h3>{{ bi('选择建议', 'Suggestions') }}</h3>
      <ul class="clean-list">
        <li v-for="item in compareResult.decisionSuggestions || []" :key="item">{{ item }}</li>
      </ul>
    </section>
  </div>
</template>

<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue';
import { ElMessage } from 'element-plus';
import { catalogApi, normalizePage, planningApi } from '../services/domain';
import { errorMessage } from '../services/api';
import type { Book } from '../types';
import { bi } from '../i18n';

const pathLoading = ref(false);
const compareLoading = ref(false);
const pathResult = ref<any>(null);
const compareResult = ref<any>(null);
const bookOptions = ref<Book[]>([]);
const selectedBookIds = ref<number[]>([]);
const pathForm = reactive({
  topic: bi('人工智能入门', 'AI fundamentals'),
  readingLevel: 'BEGINNER',
  period: '2w',
  weeklyHours: 5,
  preferAvailable: true,
  limit: 6
});

async function loadBookOptions() {
  try {
    const body = await catalogApi.searchResources({ name: null }, 1, 80);
    bookOptions.value = normalizePage<Book>(body).items;
  } catch {
    bookOptions.value = [];
  }
}

async function generatePath() {
  pathLoading.value = true;
  try {
    pathResult.value = await planningApi.path({
      topic: pathForm.topic,
      readingLevel: pathForm.readingLevel,
      limit: pathForm.limit,
      period: pathForm.period,
      weeklyHours: pathForm.weeklyHours,
      preferAvailable: pathForm.preferAvailable
    });
  } catch (error) {
    ElMessage.error(errorMessage(error));
  } finally {
    pathLoading.value = false;
  }
}

async function compareSelectedBooks() {
  compareLoading.value = true;
  try {
    compareResult.value = await planningApi.compare({ resourceIds: selectedBookIds.value.slice(0, 4) });
  } catch (error) {
    ElMessage.error(errorMessage(error));
  } finally {
    compareLoading.value = false;
  }
}

function levelLabel(level?: string) {
  if (level === 'BEGINNER') return bi('入门', 'Beginner');
  if (level === 'EXPERT') return bi('进阶', 'Advanced');
  return bi('有基础', 'Intermediate');
}

function friendlyStage(stage?: string) {
  if (!stage) return bi('阅读阶段', 'Reading stage');
  return stage;
}

function difficultyLabel(order?: number) {
  if (order === 1) return bi('难度：入门', 'Difficulty: easy');
  if (order === 2) return bi('难度：核心', 'Difficulty: core');
  return bi('难度：拓展', 'Difficulty: extended');
}

onMounted(loadBookOptions);
</script>
