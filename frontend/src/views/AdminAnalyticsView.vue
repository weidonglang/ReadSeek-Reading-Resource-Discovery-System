<template>
  <div class="page">
    <div class="page-header">
      <div>
        <h1 class="page-title">{{ bi('管理分析', 'Admin Analytics') }}</h1>
        <p class="page-subtitle">{{ bi('搜索、推荐漏斗、RAG 质量、用户行为和最近事件。', 'Search, recommendation funnel, RAG quality, user behavior, and recent events.') }}</p>
      </div>
      <el-button :loading="loading" @click="load">{{ bi('刷新', 'Refresh') }}</el-button>
    </div>

    <div class="grid grid-4">
      <MetricCard :label="bi('曝光', 'Exposure')" :value="recAnalytics?.exposureCount || 0" />
      <MetricCard :label="bi('点击', 'Clicks')" :value="recAnalytics?.clickCount || 0" />
      <MetricCard :label="bi('反馈', 'Feedback')" :value="recAnalytics?.feedbackCount || 0" />
      <MetricCard :label="bi('QA 请求', 'QA requests')" :value="qaAnalytics?.requestCount || 0" />
    </div>

    <div class="grid grid-2 dashboard-grid">
      <section class="panel">
        <h2>{{ bi('推荐漏斗', 'Recommendation funnel') }}</h2>
        <div ref="funnelRef" class="chart"></div>
      </section>
      <section class="panel">
        <h2>{{ bi('RAG 质量', 'RAG quality') }}</h2>
        <el-descriptions border :column="1">
          <el-descriptions-item label="answerable">{{ qaAnalytics?.answerableCount || 0 }}</el-descriptions-item>
          <el-descriptions-item label="refusal">{{ qaAnalytics?.refusalCount || 0 }}</el-descriptions-item>
          <el-descriptions-item label="citation click">{{ qaAnalytics?.citationClickCount || 0 }}</el-descriptions-item>
          <el-descriptions-item label="avg latency">{{ qaAnalytics?.averageLatencyMs || 0 }} ms</el-descriptions-item>
        </el-descriptions>
      </section>
    </div>

    <section class="panel">
      <h2>{{ bi('最近事件', 'Recent events') }}</h2>
      <el-table :data="recentEvents" height="360" stripe>
        <el-table-column prop="eventType" label="type" width="180" />
        <el-table-column prop="question" label="question" min-width="260" />
        <el-table-column prop="resourceTitle" label="resource" min-width="220" />
        <el-table-column prop="createdDate" label="created" width="220" />
      </el-table>
    </section>
  </div>
</template>

<script setup lang="ts">
import { nextTick, onMounted, ref } from 'vue';
import * as echarts from 'echarts';
import MetricCard from '../components/MetricCard.vue';
import { analyticsApi } from '../services/domain';
import { bi } from '../i18n';

const loading = ref(false);
const recAnalytics = ref<any>(null);
const qaAnalytics = ref<any>(null);
const recentEvents = ref<any[]>([]);
const funnelRef = ref<HTMLDivElement | null>(null);

async function load() {
  loading.value = true;
  const [rec, qa, recent] = await Promise.allSettled([
    analyticsApi.recAnalytics(),
    analyticsApi.qaAnalytics(),
    analyticsApi.recentBehavior()
  ]);
  if (rec.status === 'fulfilled') recAnalytics.value = rec.value;
  if (qa.status === 'fulfilled') {
    qaAnalytics.value = qa.value;
    recentEvents.value = qa.value.recentEvents || [];
  }
  if (recent.status === 'fulfilled' && !recentEvents.value.length) recentEvents.value = recent.value || [];
  loading.value = false;
  await nextTick();
  renderChart();
}

function renderChart() {
  if (!funnelRef.value) return;
  const chart = echarts.init(funnelRef.value);
  chart.setOption({
    tooltip: {},
    grid: { left: 40, right: 20, top: 20, bottom: 40 },
    xAxis: { type: 'category', data: ['Exposure', 'Click', 'Feedback'] },
    yAxis: { type: 'value' },
    series: [{
      type: 'bar',
      data: [
        recAnalytics.value?.exposureCount || 0,
        recAnalytics.value?.clickCount || 0,
        recAnalytics.value?.feedbackCount || 0
      ],
      itemStyle: { color: '#1f7a68' }
    }]
  });
}

onMounted(load);
</script>
