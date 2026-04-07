<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="overview-panel overview-panel--compact">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">MHMP Repair Acceptance</div>
            <h2 class="overview-panel__title">修复验收</h2>
            <p class="overview-panel__desc">
              对已完成修复的任务进行验收确认或驳回，回写返库位置与保存状态，确保修复业务形成完整闭环。
            </p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">当前筛选 {{ pageData.total }} 条</span>
            <span class="overview-chip overview-chip--accent">默认聚焦待验收任务</span>
          </div>
        </div>

        <div class="metric-grid acceptance-metrics">
          <article class="metric-card">
            <span class="metric-card__label">当前页等待验收</span>
            <strong class="metric-card__value">{{ pendingCount }}</strong>
            <div class="metric-card__meta">已完成修复并提交验收的任务</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页验收成功</span>
            <strong class="metric-card__value">{{ acceptedCount }}</strong>
            <div class="metric-card__meta">已确认验收并完成返库登记的任务</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页任务总数</span>
            <strong class="metric-card__value">{{ currentPageCount }}</strong>
            <div class="metric-card__meta">便于快速评估本页验收负荷</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">涉及申请人</span>
            <strong class="metric-card__value">{{ applyUserCount }}</strong>
            <div class="metric-card__meta">当前页修复任务申请人数量</div>
          </article>
        </div>
      </div>
    </section>

    <section class="page-card page-card--section">
      <PageHeader
        title="验收任务检索"
        description="通过验收状态和关键词快速筛选待验收或已验收的修复任务，并结合详情抽屉完成最终确认。"
      />

      <div class="query-toolbar query-toolbar--approval">
        <el-radio-group v-model="queryForm.acceptanceStatus" @change="handleSearch">
          <el-radio-button label="WAITING">等待验收</el-radio-button>
          <el-radio-button label="SUCCESS">验收成功</el-radio-button>
          <el-radio-button label="">全部</el-radio-button>
        </el-radio-group>

        <el-form :inline="true" :model="queryForm" class="query-form query-form--single-line">
          <el-form-item label="关键字" class="query-form__keyword query-form__keyword--wide">
            <el-input
              v-model="queryForm.keyword"
              placeholder="任务编号 / 文物编号 / 文物名称"
              clearable
              @keyup.enter="handleSearch"
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
          <div class="list-section__title">验收记录</div>
          <div class="list-section__desc">
            当前展示 {{ currentPageCount }} 条修复验收任务，可在详情抽屉中查看过程资料并完成确认验收或驳回。
          </div>
        </div>
      </div>

      <el-table :data="pageData.records" v-loading="loading">
        <template #empty>
          <el-empty class="empty-block" description="未检索到符合条件的修复验收任务，请调整筛选条件后重试。" />
        </template>
        <el-table-column prop="taskNo" label="任务编号" min-width="150" />
        <el-table-column prop="relicNo" label="文物编号" min-width="140" />
        <el-table-column prop="relicName" label="文物名称" min-width="180" />
        <el-table-column prop="applyUserName" label="申请人" min-width="110" />
        <el-table-column label="任务状态" min-width="120">
          <template #default="{ row }">
            <StatusTag :status="row.taskStatus" :label="taskStatusLabelMap[row.taskStatus] || row.taskStatus || '--'" />
          </template>
        </el-table-column>
        <el-table-column label="验收状态" min-width="120">
          <template #default="{ row }">
            <StatusTag
              :status="row.acceptanceStatus"
              :label="acceptanceStatusLabelMap[row.acceptanceStatus] || row.acceptanceStatus || '--'"
            />
          </template>
        </el-table-column>
        <el-table-column label="修复完成时间" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.endTime) }}</template>
        </el-table-column>
        <el-table-column label="申请时间" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.applyTime) }}</template>
        </el-table-column>
        <el-table-column label="操作" class-name="table-action-column" fixed="right" width="300">
          <template #default="{ row }">
            <el-button text type="primary" @click="openDetail(row.id)">详情</el-button>
            <template
              v-if="row.taskStatus === 'COMPLETED' && row.acceptanceStatus === 'WAITING' && authStore.hasPermission('repair:acceptance:add')"
            >
              <el-button text type="primary" @click="openAcceptance(row.id, 'PASS')">确认验收</el-button>
              <el-button text type="danger" @click="openAcceptance(row.id, 'REJECTED')">驳回</el-button>
            </template>
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

    <RepairAcceptanceDialog
      v-model="acceptanceVisible"
      :task-id="currentTaskId"
      :default-action="acceptanceAction"
      @success="handleAcceptanceSuccess"
    />
  </div>
</template>

<script setup>
import { computed, reactive, ref } from 'vue'
import { useRoute } from 'vue-router'
import { getRepairAcceptancePageApi, getRepairDetailApi } from '@/api/repair'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { useAuthStore } from '@/stores/auth'
import RepairTaskDrawer from './components/RepairTaskDrawer.vue'
import RepairAcceptanceDialog from './components/RepairAcceptanceDialog.vue'
import { formatDateTime } from '@/utils/format'

const route = useRoute()
const authStore = useAuthStore()
const loading = ref(false)
const drawerVisible = ref(false)
const acceptanceVisible = ref(false)
const currentTaskId = ref(null)
const acceptanceAction = ref('PASS')
const detail = ref({})
const pageData = ref({
  total: 0,
  pageNum: 1,
  pageSize: 10,
  records: []
})

function resolveDefaultAcceptanceStatus() {
  if (typeof route.query.acceptanceStatus === 'string') {
    return route.query.acceptanceStatus
  }
  if (route.query.taskStatus === 'ACCEPTED') {
    return 'SUCCESS'
  }
  return 'WAITING'
}

const queryForm = reactive({
  pageNum: 1,
  pageSize: 10,
  keyword: '',
  acceptanceStatus: resolveDefaultAcceptanceStatus()
})

const taskStatusLabelMap = {
  COMPLETED: '已完成',
  ACCEPTED: '已验收'
}

const acceptanceStatusLabelMap = {
  UNACCEPTED: '尚未验收',
  WAITING: '等待验收',
  SUCCESS: '验收成功',
  REJECTED: '验收被驳回'
}

const currentPageCount = computed(() => pageData.value.records.length)
const pendingCount = computed(() => pageData.value.records.filter((item) => item.acceptanceStatus === 'WAITING').length)
const acceptedCount = computed(() => pageData.value.records.filter((item) => item.acceptanceStatus === 'SUCCESS').length)
const applyUserCount = computed(() => new Set(pageData.value.records.map((item) => item.applyUserName).filter(Boolean)).size)

async function loadPage() {
  loading.value = true
  try {
    pageData.value = await getRepairAcceptancePageApi(queryForm)
  } finally {
    loading.value = false
  }
}

async function openDetail(id) {
  currentTaskId.value = id
  detail.value = await getRepairDetailApi(id)
  drawerVisible.value = true
}

function openAcceptance(id, action = 'PASS') {
  currentTaskId.value = id
  acceptanceAction.value = action
  acceptanceVisible.value = true
}

async function handleAcceptanceSuccess() {
  await loadPage()
  if (drawerVisible.value && detail.value?.id === currentTaskId.value) {
    detail.value = await getRepairDetailApi(currentTaskId.value)
  }
}

function handleSearch() {
  queryForm.pageNum = 1
  loadPage()
}

function handleReset() {
  Object.assign(queryForm, {
    pageNum: 1,
    pageSize: 10,
    keyword: '',
    acceptanceStatus: 'WAITING'
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
.acceptance-metrics {
  grid-template-columns: repeat(4, minmax(0, 1fr));
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
  .acceptance-metrics {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 640px) {
  .acceptance-metrics {
    grid-template-columns: 1fr;
  }
}
</style>
