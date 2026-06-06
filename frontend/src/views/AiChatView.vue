<template>
  <div class="chat-layout">
    <aside class="chat-sidebar panel">
      <div v-if="technicalMode" class="copilot-card">
        <span>Reading Copilot</span>
        <strong>{{ bi('馆藏问答 + 自由闲聊', 'Grounded QA + open chat') }}</strong>
        <p>{{ bi('找书会走证据检索，闲聊会直接调用本地或在线 AI。', 'Book tasks use evidence retrieval; casual chat uses the selected AI model directly.') }}</p>
      </div>
      <el-button type="primary" class="wide-button" @click="newSession">
        {{ bi('新建对话', 'New chat') }}
      </el-button>
      <el-input v-model="sessionKeyword" :placeholder="bi('搜索会话', 'Search sessions')" clearable />
      <div class="session-list">
        <button
          v-for="session in filteredSessions"
          :key="session.id"
          :class="['session-item', { active: session.id === sessionId }]"
          @click="openSession(session)"
        >
          <strong>{{ session.title || bi('阅读对话', 'Reading chat') }}</strong>
          <span>{{ formatDateTime(session.updatedAt || session.createdAt) }}</span>
        </button>
      </div>
    </aside>

    <main class="chat-main panel">
      <header class="chat-header">
        <div>
          <div class="eyebrow">ReadSeek Copilot</div>
          <h1>{{ bi('AI 阅读助手', 'AI Reading Assistant') }}</h1>
          <p v-if="technicalMode">{{ bi('像 ChatGPT 一样对话，但回答必须优先基于馆藏元数据、简介、标签、分类、作者和 RAG 证据。', 'A ChatGPT-style assistant grounded in catalog metadata, descriptions, tags, categories, authors, and RAG evidence.') }}</p>
        </div>
        <div v-if="technicalMode" class="chat-controls">
          <el-segmented v-model="mode" :options="modeOptions" />
          <el-select v-model="provider" style="width: 150px">
            <el-option label="Ollama" value="ollama" />
            <el-option label="Online API" value="online" />
            <el-option label="Deterministic" value="deterministic" />
          </el-select>
        </div>
      </header>

      <section ref="messageScroll" class="chat-stream">
        <div v-if="!messages.length" class="chat-empty">
          <h2>{{ bi('可以这样问', 'Try asking') }}</h2>
          <div class="prompt-grid">
            <button v-for="prompt in prompts" :key="prompt" @click="draft = prompt">
              <strong>{{ prompt.split(' / ')[0] }}</strong>
              <span>{{ prompt.includes(' / ') ? prompt.split(' / ')[1] : bi('点击填入输入框', 'Click to fill') }}</span>
            </button>
          </div>
        </div>
        <article v-for="message in messages" :key="message.id" :class="['message-row', message.role]">
          <div class="avatar">{{ message.role === 'user' ? 'U' : 'R' }}</div>
          <div class="message-bubble">
            <strong>{{ message.role === 'user' ? bi('你', 'You') : 'ReadSeek AI' }}</strong>
            <p v-if="message.role === 'user'">{{ message.content }}</p>
            <MarkdownAnswer v-else :content="message.content" />
          </div>
        </article>
        <article v-if="loading" class="message-row assistant">
          <div class="avatar">R</div>
          <div class="message-bubble typing">{{ bi('正在检索证据并生成回答...', 'Retrieving evidence and generating an answer...') }}</div>
        </article>
      </section>

      <section v-if="lastResponse && technicalMode" class="chat-evidence">
        <div class="grid grid-4">
          <MetricCard :label="bi('策略', 'Strategy')" :value="lastResponse.strategy || '-'" />
          <MetricCard :label="bi('模型', 'Model')" :value="lastResponse.model || lastResponse.generationBackend || '-'" />
          <MetricCard :label="bi('可回答', 'Answerable')" :value="yesNo(lastResponse.answerable)" />
          <MetricCard :label="bi('总耗时', 'Latency')" :value="`${lastResponse.totalLatencyMs || 0} ms`" />
        </div>
        <el-collapse>
          <el-collapse-item :title="bi('证据、引用与推荐', 'Evidence, citations, and recommendations')" name="evidence">
            <div class="grid grid-2">
              <div>
                <h3>{{ bi('证据卡片', 'Evidence cards') }}</h3>
                <EvidenceCard v-for="item in lastResponse.evidence || []" :key="`${item.resourceId}-${item.rank}`" :evidence="item" />
                <el-empty v-if="!lastResponse.evidence?.length" :description="emptyText()" />
              </div>
              <div>
                <h3>{{ bi('推荐图书', 'Recommended resources') }}</h3>
                <el-card v-for="item in lastResponse.recommendations || []" :key="`${item.resourceId}-${item.rank}`" shadow="never" class="mini-card">
                  <strong>{{ item.rank }}. {{ item.title }}</strong>
                  <div class="muted">{{ item.author }} / {{ item.category }}</div>
                  <p>{{ item.reason }}</p>
                </el-card>
                <h3>{{ bi('限制与追问', 'Limitations and follow-ups') }}</h3>
                <el-tag v-for="item in lastResponse.limitations || []" :key="item" type="warning">{{ item }}</el-tag>
                <el-tag v-for="item in lastResponse.followUps || []" :key="item" type="success" @click="draft = item">{{ item }}</el-tag>
              </div>
            </div>
          </el-collapse-item>
        </el-collapse>
      </section>

      <footer class="chat-composer">
        <el-input
          v-model="draft"
          type="textarea"
          :rows="3"
          resize="none"
          :placeholder="bi('输入阅读目标、图书比较、阅读路径或推荐需求...', 'Ask about goals, comparisons, reading paths, or recommendations...')"
          @keydown="handleComposerKeydown"
        />
        <el-button type="primary" :loading="loading" @click="send">{{ bi('发送', 'Send') }}</el-button>
      </footer>
    </main>
  </div>
</template>

<script setup lang="ts">
import { computed, nextTick, onMounted, ref } from 'vue';
import { useRoute } from 'vue-router';
import { ElMessage } from 'element-plus';
import MetricCard from '../components/MetricCard.vue';
import EvidenceCard from '../components/EvidenceCard.vue';
import MarkdownAnswer from '../components/MarkdownAnswer.vue';
import { chatApi } from '../services/domain';
import { useAuthStore } from '../stores/auth';
import { errorMessage } from '../services/api';
import type { ChatResponse } from '../types';
import { bi, emptyText, formatDateTime, isDemoModeEnabled, yesNo } from '../i18n';

interface UiMessage {
  id: string;
  role: 'user' | 'assistant';
  content: string;
  createdAt?: string;
}

const route = useRoute();
const auth = useAuthStore();
const technicalMode = computed(() => auth.isAdmin || isDemoModeEnabled());
const sessionId = ref('');
const sessions = ref<any[]>([]);
const sessionKeyword = ref('');
const messages = ref<UiMessage[]>([]);
const lastResponse = ref<ChatResponse | null>(null);
const draft = ref('');
const mode = ref('standard');
const provider = ref('ollama');
const loading = ref(false);
const messageScroll = ref<HTMLElement | null>(null);

const modeOptions = [
  { label: 'fast', value: 'fast' },
  { label: 'standard', value: 'standard' },
  { label: 'expert', value: 'expert' }
];

const prompts = [
  bi('随便聊两句 / Casual chat', 'Casual chat / 随便聊两句'),
  bi('讲个和读书有关的笑话 / Tell me a reading joke', 'Tell me a reading joke / 讲个读书笑话'),
  bi('我想系统学习人工智能，先读哪几本？', 'I want to learn AI systematically. Which books should I start with?'),
  bi('帮我比较几本 Java 和系统设计相关的书。', 'Compare books about Java and system design.'),
  bi('给我一个提升专注力和自我管理的阅读路径。', 'Build a reading path for focus and self-management.'),
  bi('推荐适合考研复习阶段的阅读资源。', 'Recommend resources for postgraduate exam preparation.')
];

const filteredSessions = computed(() => {
  const keyword = sessionKeyword.value.trim().toLowerCase();
  if (!keyword) return sessions.value;
  return sessions.value.filter((item) => String(item.title || '').toLowerCase().includes(keyword));
});

function newSession() {
  sessionId.value = '';
  messages.value = [];
  lastResponse.value = null;
  draft.value = '';
}

function openSession(session: any) {
  sessionId.value = session.id;
  messages.value = (session.messages || []).map((item: any) => ({
    id: item.id,
    role: item.role,
    content: item.content,
    createdAt: item.createdAt
  }));
}

async function loadSessions() {
  sessions.value = await chatApi.sessions().catch(() => []);
}

async function send() {
  if (!draft.value.trim()) return;
  const content = draft.value.trim();
  draft.value = '';
  loading.value = true;
  try {
    const response = await chatApi.send({
      sessionId: sessionId.value || null,
      message: content,
      mode: mode.value,
      provider: provider.value,
      limit: mode.value === 'expert' ? 12 : 8
    });
    sessionId.value = response.sessionId;
    if (response.userMessage) messages.value.push(response.userMessage as UiMessage);
    if (response.assistantMessage) messages.value.push(response.assistantMessage as UiMessage);
    lastResponse.value = response;
    await loadSessions();
    await nextTick();
    messageScroll.value?.scrollTo({ top: messageScroll.value.scrollHeight, behavior: 'smooth' });
  } catch (error) {
    draft.value = content;
    ElMessage.error(errorMessage(error));
  } finally {
    loading.value = false;
  }
}

function handleComposerKeydown(event: KeyboardEvent) {
  if (event.isComposing || event.key !== 'Enter' || event.shiftKey) {
    return;
  }
  event.preventDefault();
  if (!loading.value) {
    void send();
  }
}

onMounted(async () => {
  const prompt = typeof route.query.prompt === 'string' ? route.query.prompt : '';
  if (prompt) draft.value = prompt;
  await loadSessions();
});
</script>
