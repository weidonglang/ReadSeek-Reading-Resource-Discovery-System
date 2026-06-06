<template>
  <el-card class="evidence-card" shadow="never">
    <template #header>
      <div class="evidence-head">
        <div>
          <strong>{{ evidence.citation || `[${evidence.rank || '-'}]` }} {{ evidence.title }}</strong>
          <div class="muted">{{ evidence.author || '-' }} / {{ evidence.category || '-' }}</div>
        </div>
        <el-tag :type="evidence.reranked ? 'success' : 'info'">
          {{ evidence.reranked ? 'reranked' : 'candidate' }}
        </el-tag>
      </div>
    </template>
    <p>{{ evidence.description || bi('暂无简介。', 'No description.') }}</p>
    <div class="tag-row">
      <el-tag size="small">{{ evidence.matchType || 'match' }}</el-tag>
      <el-tag size="small">{{ evidence.source || 'search' }}</el-tag>
      <el-tag size="small">rank {{ evidence.rank || '-' }}</el-tag>
      <el-tag v-if="evidence.score !== undefined" size="small">score {{ evidence.score }}</el-tag>
    </div>
    <p v-if="evidence.reason" class="muted">{{ evidence.reason }}</p>
  </el-card>
</template>

<script setup lang="ts">
import type { EvidenceSnippet } from '../types';
import { bi } from '../i18n';

defineProps<{ evidence: EvidenceSnippet }>();
</script>
