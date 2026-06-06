<template>
  <div class="page">
    <div class="page-header">
      <div>
        <h1 class="page-title">{{ bi('借阅与预约', 'Loans and Reservations') }}</h1>
        <p class="page-subtitle">{{ bi('覆盖旧前端我的借阅、历史借阅、当前预约和预约历史。', 'Covers active loans, loan history, active reservations, and reservation history.') }}</p>
      </div>
      <el-button type="primary" :loading="loading" @click="load">{{ bi('刷新', 'Refresh') }}</el-button>
    </div>

    <el-tabs v-model="tab" class="panel">
      <el-tab-pane :label="bi('当前借阅', 'Active loans')" name="activeLoans">
        <loan-list :items="activeLoans" type="loan" active @refresh="load" />
      </el-tab-pane>
      <el-tab-pane :label="bi('借阅历史', 'Loan history')" name="loanHistory">
        <loan-list :items="loanHistory" type="loan" />
      </el-tab-pane>
      <el-tab-pane :label="bi('当前预约', 'Active reservations')" name="activeReservations">
        <loan-list :items="activeReservations" type="reservation" active @refresh="load" />
      </el-tab-pane>
      <el-tab-pane :label="bi('预约历史', 'Reservation history')" name="reservationHistory">
        <loan-list :items="reservationHistory" type="reservation" />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script setup lang="ts">
import { defineComponent, h, onMounted, ref } from 'vue';
import { ElButton, ElCard, ElEmpty, ElMessage, ElTag } from 'element-plus';
import { RouterLink } from 'vue-router';
import { loanApi, reservationApi } from '../services/domain';
import { errorMessage } from '../services/api';
import { bi, formatDateTime } from '../i18n';

const tab = ref('activeLoans');
const loading = ref(false);
const activeLoans = ref<any[]>([]);
const loanHistory = ref<any[]>([]);
const activeReservations = ref<any[]>([]);
const reservationHistory = ref<any[]>([]);

const LoanList = defineComponent({
  props: {
    items: { type: Array, default: () => [] },
    type: { type: String, required: true },
    active: { type: Boolean, default: false }
  },
  emits: ['refresh'],
  setup(props, { emit }) {
    async function renew(id: number) {
      try {
        await loanApi.renew(id);
        ElMessage.success(bi('续借成功', 'Renewed'));
        emit('refresh');
      } catch (error) {
        ElMessage.error(errorMessage(error));
      }
    }
    async function returnBook(id: number) {
      try {
        await loanApi.returnBook(id);
        ElMessage.success(bi('归还成功', 'Returned'));
        emit('refresh');
      } catch (error) {
        ElMessage.error(errorMessage(error));
      }
    }
    async function cancel(id: number) {
      try {
        await reservationApi.cancel(id);
        ElMessage.success(bi('预约已取消', 'Reservation cancelled'));
        emit('refresh');
      } catch (error) {
        ElMessage.error(errorMessage(error));
      }
    }

    return () => {
      if (!props.items.length) return h(ElEmpty, { description: bi('暂无记录', 'No records') });
      return h('div', { class: 'loan-grid' }, props.items.map((item: any) => {
        const book = item.book || {};
        return h(ElCard, { class: 'loan-card-vue', shadow: 'never' }, () => [
          h('div', { class: 'loan-card-head' }, [
            h('div', [
              h('strong', book.name || bi('未知图书', 'Unknown book')),
              h('div', { class: 'muted' }, `${book.author?.name || '-'} / ${book.category?.name || '-'}`)
            ]),
            h(ElTag, { type: item.status === 'RETURNED' || item.status === 'FULFILLED' ? 'success' : 'warning' }, () => item.status || '-')
          ]),
          h('div', { class: 'tag-row' }, [
            h(ElTag, { size: 'small' }, () => props.type === 'loan'
              ? `${bi('借出', 'Borrowed')}: ${formatDateTime(item.borrowedAt)}`
              : `${bi('预约', 'Requested')}: ${formatDateTime(item.requestedAt)}`),
            props.type === 'loan' ? h(ElTag, { size: 'small' }, () => `${bi('到期', 'Due')}: ${formatDateTime(item.dueDate)}`) : null
          ]),
          h('div', { class: 'action-row' }, [
            h(RouterLink, { to: `/books/${book.id}` }, () => h(ElButton, { size: 'small' }, () => bi('查看图书', 'View book'))),
            props.active && props.type === 'loan' ? h(ElButton, { size: 'small', onClick: () => renew(item.id) }, () => bi('续借', 'Renew')) : null,
            props.active && props.type === 'loan' ? h(ElButton, { size: 'small', type: 'primary', onClick: () => returnBook(item.id) }, () => bi('归还', 'Return')) : null,
            props.active && props.type === 'reservation' ? h(ElButton, { size: 'small', type: 'danger', onClick: () => cancel(item.id) }, () => bi('取消预约', 'Cancel')) : null
          ])
        ]);
      }));
    };
  }
});

async function load() {
  loading.value = true;
  try {
    const [a, h, r, rh] = await Promise.all([
      loanApi.active(),
      loanApi.history(),
      reservationApi.active(),
      reservationApi.history()
    ]);
    activeLoans.value = a || [];
    loanHistory.value = h || [];
    activeReservations.value = r || [];
    reservationHistory.value = rh || [];
  } catch (error) {
    ElMessage.error(errorMessage(error));
  } finally {
    loading.value = false;
  }
}

onMounted(load);
</script>
