<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="overview-panel overview-panel--compact">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">MHMP Repair Archive</div>
            <h2 class="overview-panel__title">修复归档记录</h2>
            <p class="overview-panel__desc">
              集中查看已完成并验收通过的修复任务，便于后续归档、答辩展示和馆内修复履历追踪。
            </p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">归档任务 {{ pageData.total }} 条</span>
            <span class="overview-chip overview-chip--accent">当前页 {{ currentPageCount }} 条</span>
          </div>
        </div>

        <div class="metric-grid history-metrics">
          <article class="metric-card">
            <span class="metric-card__label">当前页归档任务</span>
            <strong class="metric-card__value">{{ currentPageCount }}</strong>
            <div class="metric-card__meta">本页已归档修复任务总数</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">涉及文物</span>
            <strong class="metric-card__value">{{ uniqueRelicCount }}</strong>
            <div class="metric-card__meta">本页任务关联的唯一文物数量</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">最新归档时间</span>
            <strong class="metric-card__value history-metric-text">{{ latestEndTime }}</strong>
            <div class="metric-card__meta">按当前页记录计算的最近完成时间</div>
          </article>
        </div>
      </div>
    </section>

    <section class="page-card page-card--section">
      <PageHeader
        title="归档任务检索"
        description="按任务编号、文物编号和文物名称筛选已完成修复任务，支持进入详情抽屉查看完整修复履历。"
      />

      <div class="query-toolbar">
        <el-form :inline="true" :model="queryForm" class="query-form query-form--single-line">
          <el-form-item label="关键字" class="query-form__keyword query-form__keyword--wide">
            <el-input
              v-model="queryForm.keyword"
              placeholder="任务编号 / 文物编号 / 文物名称"
              clearable
              @keyup.enter="loadPage"
            />
          </el-form-item>
          <el-form-item class="query-form__actions">
            <el-button type="primary" @click="handleSearch">查询</el-button>
            <el-button @click="handleReset">重置</el-button>
          </el-form-item>
        </el-form>
      </div>
    </section>

    <section class="page-card page-card--section">
      <div class="list-section__header">
        <div>
          <div class="list-section__title">归档记录</div>
          <div class="list-section__desc">
            当前展示 {{ currentPageCount }} 条已归档修复任务，可用于核查验收结果和修复过程资料。
          </div>
        </div>
      </div>

      <el-table :data="pageData.records" v-loading="loading">
        <template #empty>
          <el-empty class="empty-block" description="未检索到符合条件的修复归档记录，请调整筛选条件后重试。" />
        </template>
        <el-table-column prop="taskNo" label="任务编号" min-width="150" />
        <el-table-column prop="relicNo" label="文物编号" min-width="140" />
        <el-table-column prop="relicName" label="文物名称" min-width="180" />
        <el-table-column label="验收状态" width="120">
          <template #default="{ row }">
            <StatusTag :status="row.acceptanceStatus" :label="acceptanceStatusLabelMap[row.acceptanceStatus] || row.acceptanceStatus || '--'" />
          </template>
        </el-table-column>
        <el-table-column label="完成时间" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.endTime) }}</template>
        </el-table-column>
        <el-table-column label="申请时间" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.applyTime) }}</template>
        </el-table-column>
        <el-table-column label="操作" class-name="table-action-column" width="100">
          <template #default="{ row }">
            <el-button text type="primary" @click="openDetail(row.id)">详情</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="table-footer">
        <el-pagination
          :current-page="queryForm.pageNum"
          :page-size="queryForm.pageSize"
          :page-sizes="[10, 20, 30]"
          :total="pageData.total"
          layout="total, sizes, prev, pager, next"
          @current-change="handleCurrentChange"
          @size-change="handleSizeChange"
        />
      </div>
    </section>

    <RepairTaskDrawer v-model="drawerVisible" :detail="detail" />
  </div>
</template>

<script setup>
import { computed, reactive, ref } from 'vue'
import { getRepairedRepairPageApi, getRepairDetailApi } from '@/api/repair'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import RepairTaskDrawer from './components/RepairTaskDrawer.vue'
import { formatDateTime } from '@/utils/format'

const loading = ref(false)
const drawerVisible = ref(false)
const detail = ref({})
const pageData = ref({
  total: 0,
  pageNum: 1,
  pageSize: 10,
  records: []
})

const queryForm = reactive({
  pageNum: 1,
  pageSize: 10,
  keyword: ''
})

const acceptanceStatusLabelMap = {
  SUCCESS: '验收成功'
}

const currentPageCount = computed(() => pageData.value.records.length)
const uniqueRelicCount = computed(() => new Set(pageData.value.records.map((item) => item.relicNo).filter(Boolean)).size)
const latestEndTime = computed(() => {
  const timestamps = pageData.value.records
    .map((item) => item.endTime)
    .filter(Boolean)
    .map((item) => new Date(item).getTime())
    .filter((item) => !Number.isNaN(item))

  if (!timestamps.length) {
    return '--'
  }
  return formatDateTime(new Date(Math.max(...timestamps)))
})

async function loadPage() {
  loading.value = true
  try {
    pageData.value = await getRepairedRepairPageApi(queryForm)
  } finally {
    loading.value = false
  }
}

async function openDetail(id) {
  detail.value = await getRepairDetailApi(id)
  drawerVisible.value = true
}

function handleSearch() {
  queryForm.pageNum = 1
  loadPage()
}

function handleReset() {
  Object.assign(queryForm, {
    pageNum: 1,
    pageSize: 10,
    keyword: ''
  })
  loadPage()
}

function handleCurrentChange(pageNum) {
  queryForm.pageNum = pageNum
  loadPage()
}

function handleSizeChange(pageSize) {
  queryForm.pageSize = pageSize
  queryForm.pageNum = 1
  loadPage()
}

loadPage()
</script>

<style scoped>
.history-metrics {
  grid-template-columns: repeat(3, minmax(0, 1fr));
}

.history-metric-text {
  font-size: 20px;
  line-height: 1.4;
}

.list-section__header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 16px;
}

.list-section__title {
  font-size: 17px;
  font-weight: 700;
}

.list-section__desc {
  margin-top: 8px;
  color: var(--text-second);
  font-size: 13px;
  line-height: 1.8;
}

.table-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}

@media (max-width: 960px) {
  .history-metrics {
    grid-template-columns: 1fr;
  }
}
</style>
