<template>
  <div class="page">
    <div class="page-header">
      <div>
        <h1 class="page-title">{{ bi('RAG 问答', 'RAG Question Answering') }}</h1>
        <p class="page-subtitle">{{ bi('回答受馆藏证据约束，展示引用、可信度、延迟、模型和 fallback。', 'Answers are grounded in catalog evidence with citations, confidence, latency, model, and fallback details.') }}</p>
      </div>
    </div>

    <section class="panel qa-panel">
      <el-input v-model="question" type="textarea" :rows="4" :placeholder="bi('输入一个需要证据支持的问题', 'Ask a question that needs evidence')" />
      <div class="qa-controls">
        <el-segmented v-model="mode" :options="['fast', 'standard', 'expert']" />
        <el-select v-model="provider" style="width: 160px">
          <el-option label="Ollama" value="ollama" />
          <el-option label="Online API" value="online" />
          <el-option label="Deterministic" value="deterministic" />
        </el-select>
        <el-input-number v-model="limit" :min="1" :max="20" />
        <el-button type="primary" :loading="loading" @click="ask">{{ bi('生成回答', 'Generate answer') }}</el-button>
      </div>
    </section>

    <section v-if="answer" class="panel answer-panel">
      <div class="grid grid-4">
        <MetricCard :label="bi('可回答', 'Answerable')" :value="yesNo(answer.answerable)" />
        <MetricCard :label="bi('可信度', 'Confidence')" :value="answer.confidence ?? 0" />
        <MetricCard :label="bi('模型', 'Model')" :value="answer.model || '-'" />
        <MetricCard :label="bi('总耗时', 'Total latency')" :value="`${answer.totalLatencyMs || 0} ms`" />
      </div>
      <el-alert class="answer-box" :type="answer.answerable ? 'success' : 'warning'" :closable="false">
        <MarkdownAnswer :content="answer.answer" />
      </el-alert>
      <el-descriptions border :column="2">
        <el-descriptions-item label="ragMode">{{ answer.ragMode }}</el-descriptions-item>
        <el-descriptions-item label="llmProvider">{{ answer.llmProvider }}</el-descriptions-item>
        <el-descriptions-item label="generationBackend">{{ answer.generationBackend }}</el-descriptions-item>
        <el-descriptions-item label="llmFallbackApplied">{{ yesNo(answer.llmFallbackApplied) }}</el-descriptions-item>
        <el-descriptions-item label="retrievalLatencyMs">{{ answer.retrievalLatencyMs }}</el-descriptions-item>
        <el-descriptions-item label="generationLatencyMs">{{ answer.generationLatencyMs }}</el-descriptions-item>
      </el-descriptions>

      <h3>{{ bi('引用', 'Citations') }}</h3>
      <div class="tag-row">
        <el-tag v-for="citation in answer.citations || []" :key="citation">{{ citation }}</el-tag>
      </div>
      <h3>{{ bi('证据', 'Evidence') }}</h3>
      <EvidenceCard v-for="item in answer.evidence || []" :key="`${item.resourceId}-${item.rank}`" :evidence="item" />
      <h3>{{ bi('限制与追问', 'Limitations and follow-ups') }}</h3>
      <div class="tag-row">
        <el-tag v-for="item in answer.limitations || []" :key="item" type="warning">{{ item }}</el-tag>
        <el-tag v-for="item in answer.followUpSuggestions || answer.followUps || []" :key="item" type="success">{{ item }}</el-tag>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { ElMessage } from 'element-plus';
import MetricCard from '../components/MetricCard.vue';
import EvidenceCard from '../components/EvidenceCard.vue';
import MarkdownAnswer from '../components/MarkdownAnswer.vue';
import { ragApi } from '../services/domain';
import { errorMessage } from '../services/api';
import type { QaResponse } from '../types';
import { bi, yesNo } from '../i18n';

const question = ref(bi('想看关于个人成长的书，应该从哪本开始？', 'Which personal-growth book should I start with?'));
const mode = ref('standard');
const provider = ref('ollama');
const limit = ref(8);
const loading = ref(false);
const answer = ref<QaResponse | null>(null);

async function ask() {
  if (!question.value.trim()) return;
  loading.value = true;
  try {
    answer.value = await ragApi.ask({
      question: question.value,
      mode: mode.value,
      provider: provider.value,
      limit: limit.value
    });
  } catch (error) {
    ElMessage.error(errorMessage(error));
  } finally {
    loading.value = false;
  }
}
</script>
