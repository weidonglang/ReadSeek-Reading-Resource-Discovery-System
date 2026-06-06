<template>
  <div class="page">
    <div class="page-header">
      <div>
        <h1 class="page-title">{{ bi('智能问答与找书', 'Smart Ask and Search') }}</h1>
        <p class="page-subtitle">{{ bi('直接输入书名、作者、主题或阅读问题，系统会帮你找资源或生成回答。', 'Enter a title, author, topic, or reading question to find resources or get an answer.') }}</p>
      </div>
    </div>

    <section class="panel search-hero search-hero-prominent">
      <div class="search-mode-wrap">
        <span>{{ bi('模式', 'Mode') }}</span>
        <el-segmented v-model="task" :options="taskOptions" class="search-mode" />
      </div>
      <div class="search-query-wrap">
        <span>{{ task === 'ask' ? bi('输入你的阅读问题', 'Ask a reading question') : bi('输入书名、作者或主题', 'Search title, author, or topic') }}</span>
        <el-input
          v-model="query"
          class="search-query"
          size="large"
          clearable
          :placeholder="task === 'ask' ? bi('例如：我想系统学习人工智能，先读哪几本？', 'e.g. Which books should I read first to learn AI?') : bi('例如：人工智能、机器学习、Java、心理学', 'e.g. AI, machine learning, Java, psychology')"
          @keyup.enter="run"
        />
      </div>
      <div v-if="technicalMode" class="search-limit-wrap">
        <span>{{ bi('数量', 'Limit') }}</span>
        <el-input-number v-model="limit" class="search-limit" :min="1" :max="20" />
      </div>
      <el-button class="search-submit" type="primary" size="large" :loading="loading" @click="run">{{ task === 'ask' ? bi('生成回答', 'Answer') : bi('查找图书', 'Search') }}</el-button>
    </section>

    <section class="panel clean-list">
      <strong>{{ bi('如果暂时没有结果', 'If nothing is found') }}</strong>
      <p class="muted">{{ bi('系统会先用搜索索引和向量召回；如果索引未建立或简介不完整，会自动回退到数据库里的书名、作者、分类、标签、出版社和 ISBN。仍然没有结果时，请先确认这些基础字段里包含相关关键词。', 'The system tries index and vector retrieval first. If the index is missing or descriptions are incomplete, it falls back to title, author, category, tags, publisher, and ISBN in the database. If results are still empty, make sure those basic fields contain the keyword.') }}</p>
    </section>

    <section v-if="answer" class="panel answer-panel">
      <el-alert class="answer-box" :type="answer.answerable ? 'success' : 'warning'" :closable="false">
        <MarkdownAnswer :content="answer.answer" />
      </el-alert>
      <div v-if="simpleCitations.length" class="tag-row">
        <el-tag v-for="item in simpleCitations" :key="item" type="success">{{ item }}</el-tag>
      </div>
      <el-collapse v-if="technicalMode">
        <el-collapse-item :title="bi('证据详情', 'Evidence details')" name="evidence">
          <EvidenceCard v-for="item in answer.evidence || []" :key="`${item.resourceId}-${item.rank}`" :evidence="item" />
        </el-collapse-item>
      </el-collapse>
    </section>

    <section v-if="searchResponse" class="result-list">
      <el-card v-for="hit in searchResponse.hits || []" :key="hit.book.id" class="result-card" shadow="never">
        <template #header>
          <div class="result-head">
            <div>
              <strong>{{ hit.book.name }}</strong>
              <div class="muted">{{ hit.book.author?.name || bi('未知作者', 'Unknown author') }} · {{ hit.book.category?.name || bi('未分类', 'Uncategorized') }}</div>
            </div>
            <el-button text @click="$router.push(`/books/${hit.book.id}`)">{{ bi('查看详情', 'Details') }}</el-button>
          </div>
        </template>
        <p class="muted">{{ hit.reason || bi('这本书与你的搜索主题相关。', 'This book is related to your search topic.') }}</p>
        <div class="tag-row">
          <el-tag v-if="hit.book.availableCopies !== undefined" type="success">{{ bi('可借', 'Available') }} {{ hit.book.availableCopies }}/{{ hit.book.totalCopies ?? 0 }}</el-tag>
          <el-tag v-if="technicalMode" type="info">{{ hit.matchType || 'match' }}</el-tag>
          <el-tag v-if="technicalMode" type="warning">{{ hit.source || 'source' }}</el-tag>
        </div>
      </el-card>
      <el-empty v-if="!searchResponse.hits?.length" :description="bi('暂时没有找到匹配图书。系统已尝试索引、向量和数据库基础字段兜底，请换成库里已有的书名、作者、分类或标签关键词。', 'No matching books found after index, vector, and database metadata fallback. Try a title, author, category, or tag that exists in the catalog.')" />
    </section>

    <section v-if="technicalMode && searchResponse" class="panel result-summary">
      <div class="grid grid-4">
        <MetricCard :label="bi('查询意图', 'Query intent')" :value="searchResponse.queryIntent || '-'" />
        <MetricCard :label="bi('候选数', 'Candidates')" :value="searchResponse.candidateCount ?? 0" />
        <MetricCard :label="bi('重排序', 'Reranker')" :value="yesNo(searchResponse.rerankerApplied)" />
        <MetricCard :label="bi('降级', 'Fallback')" :value="yesNo(searchResponse.fallbackApplied)" />
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue';
import { useRoute } from 'vue-router';
import { ElMessage } from 'element-plus';
import EvidenceCard from '../components/EvidenceCard.vue';
import MarkdownAnswer from '../components/MarkdownAnswer.vue';
import MetricCard from '../components/MetricCard.vue';
import { catalogApi, ragApi } from '../services/domain';
import { errorMessage } from '../services/api';
import { useAuthStore } from '../stores/auth';
import type { QaResponse, SearchResponse } from '../types';
import { bi, isDemoModeEnabled, yesNo } from '../i18n';

const auth = useAuthStore();
const route = useRoute();
const technicalMode = computed(() => auth.isAdmin || isDemoModeEnabled());
const task = ref<'search' | 'ask'>('search');
const taskOptions = [
  { label: bi('找书', 'Find books'), value: 'search' },
  { label: bi('问问题', 'Ask'), value: 'ask' }
];
const query = ref(bi('人工智能入门', 'AI fundamentals'));
const limit = ref(8);
const loading = ref(false);
const searchResponse = ref<SearchResponse | null>(null);
const answer = ref<QaResponse | null>(null);
const simpleCitations = computed(() => (answer.value?.evidence || [])
  .slice(0, 4)
  .map((item) => item.title)
  .filter(Boolean) as string[]);

async function run() {
  if (!query.value.trim()) return;
  loading.value = true;
  try {
    if (task.value === 'ask') {
      answer.value = await ragApi.ask({ question: query.value, mode: 'standard', provider: 'ollama', limit: limit.value });
      searchResponse.value = null;
    } else {
      searchResponse.value = await catalogApi.hybridSearch(query.value, limit.value);
      answer.value = null;
    }
  } catch (error) {
    ElMessage.error(errorMessage(error));
  } finally {
    loading.value = false;
  }
}

onMounted(() => {
  const routeQuery = typeof route.query.q === 'string' ? route.query.q : '';
  if (routeQuery) {
    query.value = routeQuery;
    void run();
  }
});
</script>
