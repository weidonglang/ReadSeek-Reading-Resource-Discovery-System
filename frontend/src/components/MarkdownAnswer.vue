<template>
  <div class="markdown-answer">
    <template v-for="(block, index) in blocks" :key="index">
      <h3 v-if="block.type === 'heading'" class="markdown-answer-heading">
        <template v-for="(segment, segmentIndex) in block.segments" :key="segmentIndex">
          <strong v-if="segment.strong">{{ segment.text }}</strong>
          <span v-else>{{ segment.text }}</span>
        </template>
      </h3>

      <ol v-else-if="block.type === 'ordered-list'" class="markdown-answer-list">
        <li v-for="(item, itemIndex) in block.items" :key="itemIndex">
          <template v-for="(segment, segmentIndex) in item.segments" :key="segmentIndex">
            <strong v-if="segment.strong">{{ segment.text }}</strong>
            <span v-else>{{ segment.text }}</span>
          </template>
        </li>
      </ol>

      <ul v-else-if="block.type === 'unordered-list'" class="markdown-answer-list">
        <li v-for="(item, itemIndex) in block.items" :key="itemIndex">
          <template v-for="(segment, segmentIndex) in item.segments" :key="segmentIndex">
            <strong v-if="segment.strong">{{ segment.text }}</strong>
            <span v-else>{{ segment.text }}</span>
          </template>
        </li>
      </ul>

      <p v-else class="markdown-answer-paragraph">
        <template v-for="(segment, segmentIndex) in block.segments" :key="segmentIndex">
          <strong v-if="segment.strong">{{ segment.text }}</strong>
          <span v-else>{{ segment.text }}</span>
        </template>
      </p>
    </template>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';

interface InlineSegment {
  text: string;
  strong: boolean;
}

interface ListItem {
  segments: InlineSegment[];
}

interface MarkdownBlock {
  type: 'paragraph' | 'heading' | 'ordered-list' | 'unordered-list';
  segments: InlineSegment[];
  items: ListItem[];
}

const props = defineProps<{
  content?: string | null;
}>();

const blocks = computed(() => parseMarkdown(props.content || ''));

function normalizeMarkdown(value: string): string {
  return value
    .replace(/\r\n?/g, '\n')
    .replace(/[ \t]+(\d+[.)]\s+\*\*)/g, '\n$1')
    .replace(/[ \t]+([-*]\s+\*\*)/g, '\n$1')
    .replace(/[ \t]+(\*\*[^*]{1,36}[:：]\*\*)/g, '\n$1')
    .trim();
}

function parseMarkdown(value: string): MarkdownBlock[] {
  const lines = normalizeMarkdown(value).split('\n');
  const result: MarkdownBlock[] = [];
  let paragraph: string[] = [];
  let orderedItems: ListItem[] = [];
  let unorderedItems: ListItem[] = [];

  const flushParagraph = () => {
    if (!paragraph.length) return;
    result.push({
      type: 'paragraph',
      segments: parseInline(paragraph.join(' ').trim()),
      items: []
    });
    paragraph = [];
  };

  const flushLists = () => {
    if (orderedItems.length) {
      result.push({ type: 'ordered-list', segments: [], items: orderedItems });
      orderedItems = [];
    }
    if (unorderedItems.length) {
      result.push({ type: 'unordered-list', segments: [], items: unorderedItems });
      unorderedItems = [];
    }
  };

  for (const rawLine of lines) {
    const line = rawLine.trim();
    if (!line) {
      flushParagraph();
      flushLists();
      continue;
    }

    const heading = line.match(/^#{1,4}\s+(.+)$/);
    if (heading) {
      flushParagraph();
      flushLists();
      result.push({ type: 'heading', segments: parseInline(heading[1].trim()), items: [] });
      continue;
    }

    const ordered = line.match(/^\d+[.)]\s+(.+)$/);
    if (ordered) {
      flushParagraph();
      if (unorderedItems.length) flushLists();
      orderedItems.push({ segments: parseInline(ordered[1].trim()) });
      continue;
    }

    const unordered = line.match(/^[-*]\s+(.+)$/);
    if (unordered) {
      flushParagraph();
      if (orderedItems.length) flushLists();
      unorderedItems.push({ segments: parseInline(unordered[1].trim()) });
      continue;
    }

    flushLists();
    paragraph.push(line);
  }

  flushParagraph();
  flushLists();
  return result;
}

function parseInline(value: string): InlineSegment[] {
  const segments: InlineSegment[] = [];
  const pattern = /\*\*(.+?)\*\*/g;
  let lastIndex = 0;
  let match: RegExpExecArray | null;

  while ((match = pattern.exec(value)) !== null) {
    if (match.index > lastIndex) {
      segments.push({ text: value.slice(lastIndex, match.index), strong: false });
    }
    segments.push({ text: match[1], strong: true });
    lastIndex = match.index + match[0].length;
  }

  if (lastIndex < value.length) {
    segments.push({ text: value.slice(lastIndex), strong: false });
  }

  return segments.length ? segments : [{ text: value, strong: false }];
}
</script>
