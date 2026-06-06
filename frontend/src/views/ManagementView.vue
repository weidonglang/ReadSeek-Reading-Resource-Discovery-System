<template>
  <div class="page">
    <div class="page-header">
      <div>
        <h1 class="page-title">{{ bi('资源管理', 'Resource Management') }}</h1>
        <p class="page-subtitle">{{ bi('用统一表格和 JSON 编辑器覆盖旧前端作者、分类、出版社、标签和图书管理能力。', 'A unified table and JSON editor cover legacy author, category, publisher, tag, and book management.') }}</p>
      </div>
      <el-button type="primary" @click="openCreate">{{ bi('新增', 'Create') }}</el-button>
    </div>

    <section class="panel">
      <el-tabs v-model="active" @tab-change="switchEntity">
        <el-tab-pane v-for="entity in entities" :key="entity.key" :label="entity.label" :name="entity.key" />
      </el-tabs>
      <div class="management-toolbar">
        <el-input v-model="keyword" :placeholder="bi('按名称分页查询', 'Paged search by name')" clearable @keyup.enter="load(1)" />
        <el-button :loading="loading" @click="load(1)">{{ bi('查询', 'Search') }}</el-button>
      </div>
      <el-table :data="rows" v-loading="loading" stripe>
        <el-table-column prop="id" label="ID" width="90" />
        <el-table-column :label="bi('名称', 'Name')" min-width="220">
          <template #default="{ row }">{{ row.name || row.title || row.email || '-' }}</template>
        </el-table-column>
        <el-table-column :label="bi('摘要', 'Summary')" min-width="300">
          <template #default="{ row }">{{ row.description || row.address || row.role || row.category?.name || '-' }}</template>
        </el-table-column>
        <el-table-column :label="bi('操作', 'Actions')" width="220">
          <template #default="{ row }">
            <el-button size="small" @click="openEdit(row)">{{ bi('编辑', 'Edit') }}</el-button>
            <el-popconfirm :title="bi('确认删除？', 'Delete this item?')" @confirm="remove(row)">
              <template #reference>
                <el-button size="small" type="danger">{{ bi('删除', 'Delete') }}</el-button>
              </template>
            </el-popconfirm>
          </template>
        </el-table-column>
      </el-table>
      <div class="pagination-bar">
        <el-pagination
          background
          layout="prev, pager, next, sizes, total"
          :current-page="page"
          :page-size="pageSize"
          :total="total"
          @current-change="load"
          @size-change="changeSize"
        />
      </div>
    </section>

    <el-dialog v-model="visible" :title="dialogTitle" width="760px">
      <p class="muted">{{ bi('请按后端 DTO 结构编辑 JSON。', 'Edit JSON according to the backend DTO structure.') }}</p>
      <el-input v-model="json" type="textarea" :rows="18" spellcheck="false" />
      <template #footer>
        <el-button @click="visible = false">{{ bi('取消', 'Cancel') }}</el-button>
        <el-button type="primary" :loading="saving" @click="save">{{ bi('保存', 'Save') }}</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue';
import { ElMessage } from 'element-plus';
import { catalogApi, entityApi, normalizePage } from '../services/domain';
import { errorMessage } from '../services/api';
import { bi } from '../i18n';

const entities = [
  { key: 'books', label: bi('图书', 'Books'), api: null },
  { key: 'authors', label: bi('作者', 'Authors'), api: entityApi('/api/author', true) },
  { key: 'categories', label: bi('分类', 'Categories'), api: entityApi('/api/category') },
  { key: 'publishers', label: bi('出版社', 'Publishers'), api: entityApi('/api/publisher') },
  { key: 'tags', label: bi('标签', 'Tags'), api: entityApi('/api/tag') }
];

const active = ref('books');
const rows = ref<any[]>([]);
const loading = ref(false);
const saving = ref(false);
const visible = ref(false);
const mode = ref<'create' | 'edit'>('create');
const json = ref('');
const keyword = ref('');
const page = ref(1);
const pageSize = ref(12);
const total = ref(0);

const currentEntity = computed(() => entities.find((item) => item.key === active.value) || entities[0]);
const dialogTitle = computed(() => `${mode.value === 'create' ? bi('新增', 'Create') : bi('编辑', 'Edit')} ${currentEntity.value.label}`);

async function load(targetPage = page.value) {
  loading.value = true;
  try {
    if (active.value === 'books') {
      const normalized = normalizePage<any>(await catalogApi.searchResources(
        { name: keyword.value || null },
        targetPage,
        pageSize.value
      ));
      rows.value = normalized.items;
      total.value = normalized.total;
    } else {
      const list = await currentEntity.value.api!.list();
      const filtered = keyword.value
        ? list.filter((item: any) => String(item.name || item.title || item.email || '').toLowerCase().includes(keyword.value.toLowerCase()))
        : list;
      total.value = filtered.length;
      const start = (targetPage - 1) * pageSize.value;
      rows.value = filtered.slice(start, start + pageSize.value);
    }
    page.value = targetPage;
  } catch (error) {
    ElMessage.error(errorMessage(error));
  } finally {
    loading.value = false;
  }
}

function changeSize(size: number) {
  pageSize.value = size;
  load(1);
}

function switchEntity() {
  page.value = 1;
  load(1);
}

function openCreate() {
  mode.value = 'create';
  json.value = JSON.stringify(active.value === 'books' ? { name: '', totalCopies: 1, availableCopies: 1 } : { name: '' }, null, 2);
  visible.value = true;
}

function openEdit(row: any) {
  mode.value = 'edit';
  json.value = JSON.stringify(row, null, 2);
  visible.value = true;
}

async function save() {
  saving.value = true;
  try {
    const payload = JSON.parse(json.value);
    if (active.value === 'books') {
      if (mode.value === 'create') await catalogApi.createBook(payload);
      else await catalogApi.updateBook(payload);
    } else if (mode.value === 'create') {
      await currentEntity.value.api!.create(payload);
    } else {
      await currentEntity.value.api!.update(payload);
    }
    ElMessage.success(bi('保存成功', 'Saved'));
    visible.value = false;
    await load();
  } catch (error) {
    ElMessage.error(errorMessage(error));
  } finally {
    saving.value = false;
  }
}

async function remove(row: any) {
  try {
    if (active.value === 'books') await catalogApi.deleteBook(row.id);
    else await currentEntity.value.api!.remove(row.id);
    ElMessage.success(bi('删除成功', 'Deleted'));
    await load();
  } catch (error) {
    ElMessage.error(errorMessage(error));
  }
}

onMounted(load);
</script>
