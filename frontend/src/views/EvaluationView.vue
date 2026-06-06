<template>
  <div class="page">
    <div class="page-header">
      <div>
        <h1 class="page-title">{{ bi('检索测评报告', 'Retrieval Evaluation Report') }}</h1>
        <p class="page-subtitle">{{ bi('展示 BM25 only、Vector only、Hybrid、Hybrid + Reranker 的测评结构。', 'Shows the evaluation structure for BM25 only, Vector only, Hybrid, and Hybrid + Reranker.') }}</p>
      </div>
      <el-tag type="warning">sample / placeholder</el-tag>
    </div>

    <el-alert type="warning" :closable="false" show-icon>
      {{ bi('当前页面使用 sample 数据结构，不代表最终实验结论。真实测评后替换 docs/evaluation/results.json。', 'This page uses sample data and does not represent final experimental conclusions. Replace docs/evaluation/results.json after real evaluation.') }}
    </el-alert>

    <section class="panel section-gap">
      <h2>{{ bi('总体结果表格', 'Overall result table') }}</h2>
      <el-table :data="rows">
        <el-table-column prop="method" label="Method" />
        <el-table-column prop="recallAt5" label="Recall@5" />
        <el-table-column prop="mrr" label="MRR" />
        <el-table-column prop="ndcgAt10" label="NDCG@10" />
        <el-table-column prop="avgLatencyMs" label="Avg Latency(ms)" />
      </el-table>
    </section>

    <section class="panel section-gap">
      <h2>{{ bi('分 query 案例分析', 'Per-query case analysis') }}</h2>
      <el-collapse>
        <el-collapse-item v-for="item in cases" :key="item.query" :title="item.query">
          <p><strong>{{ bi('设计目的', 'Intent') }}: </strong>{{ item.intent }}</p>
          <p><strong>{{ bi('期望观察', 'Expected') }}: </strong>{{ item.expected }}</p>
          <p><strong>{{ bi('失败风险', 'Failure risk') }}: </strong>{{ item.failureRisk }}</p>
        </el-collapse-item>
      </el-collapse>
    </section>

    <section class="panel section-gap">
      <h2>{{ bi('结论', 'Conclusion') }}</h2>
      <p class="muted">
        {{ bi('当前报告先固定测评口径、查询集和展示形式。正式答辩或作品集展示前，应使用真实 relevance judgment 和接口耗时替换 sample 数据。', 'This report first fixes the evaluation protocol, query set, and presentation format. Before formal defense or portfolio display, replace sample data with real relevance judgments and measured latency.') }}
      </p>
    </section>
  </div>
</template>

<script setup lang="ts">
import { bi } from '../i18n';

const rows = [
  { method: 'BM25 only', recallAt5: 'sample', mrr: 'sample', ndcgAt10: 'sample', avgLatencyMs: 'sample' },
  { method: 'Vector only', recallAt5: 'sample', mrr: 'sample', ndcgAt10: 'sample', avgLatencyMs: 'sample' },
  { method: 'Hybrid', recallAt5: 'sample', mrr: 'sample', ndcgAt10: 'sample', avgLatencyMs: 'sample' },
  { method: 'Hybrid + Reranker', recallAt5: 'sample', mrr: 'sample', ndcgAt10: 'sample', avgLatencyMs: 'sample' }
];

const cases = [
  {
    query: bi('个人成长 入门', 'personal growth beginner'),
    intent: bi('测试主题型中文查询能否命中 Self-Help / Psychology 资源。', 'Test whether topic-style Chinese queries retrieve Self-Help / Psychology resources.'),
    expected: bi('Hybrid + Reranker 应将语义相关资源提前。', 'Hybrid + Reranker should promote semantically relevant resources.'),
    failureRisk: bi('馆藏简介为空时，vector 和 reranker 可用证据不足。', 'When descriptions are empty, vector and reranker evidence can be weak.')
  },
  {
    query: 'Jane Austen representative works',
    intent: bi('测试作者与代表作精确匹配。', 'Test exact author and representative-work matching.'),
    expected: bi('Exact / BM25 应优先命中 Pride and Prejudice 等作品。', 'Exact / BM25 should prioritize works such as Pride and Prejudice.'),
    failureRisk: bi('作者名大小写和元数据缺失会影响召回。', 'Author case normalization and missing metadata can affect recall.')
  }
];
</script>
