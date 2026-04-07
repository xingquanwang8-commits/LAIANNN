<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="overview-panel overview-panel--compact">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">MHMP Repair Approval</div>
            <h2 class="overview-panel__title">修复审批</h2>
            <p class="overview-panel__desc">
              集中处理修复申请的审批通过与驳回，结合任务详情抽屉核对申请原因、历史修复记录和过程资料。
            </p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">当前筛选 {{ pageData.total }} 条</span>
            <span class="overview-chip overview-chip--accent">默认聚焦待审批任务</span>
          </div>
        </div>

        <div class="metric-grid approve-metrics">
          <article class="metric-card">
            <span class="metric-card__label">当前页待审批</span>
            <strong class="metric-card__value">{{ pendingCount }}</strong>
            <div class="metric-card__meta">尚未形成审批结论的修复申请</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页已通过</span>
            <strong class="metric-card__value">{{ approvedCount }}</strong>
            <div class="metric-card__meta">已通过审批，可进入修复过程记录</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页已驳回</span>
            <strong class="metric-card__value">{{ rejectedCount }}</strong>
            <div class="metric-card__meta">已退回申请人重新处理的任务</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页任务总数</span>
            <strong class="metric-card__value">{{ currentPageCount }}</strong>
            <div class="metric-card__meta">便于快速评估本页审批负荷</div>
          </article>
        </div>
      </div>
    </section>

    <section class="page-card page-card--section">
      <PageHeader
        title="审批任务检索"
        description="按任务状态与关键词筛选修复申请，支持在列表页或详情抽屉中直接完成审批。"
      />

      <div class="query-toolbar query-toolbar--approval">
        <el-radio-group v-model="queryForm.taskStatus" @change="handleSearch">
          <el-radio-button label="APPLIED">待审批</el-radio-button>
          <el-radio-button label="APPROVED">已通过</el-radio-button>
          <el-radio-button label="REJECTED">已驳回</el-radio-button>
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
          <div class="list-section__title">修复审批记录</div>
          <div class="list-section__desc">
            当前展示 {{ currentPageCount }} 条修复申请记录，可在列表中直接审批，或先查看详情后再决策。
          </div>
        </div>
      </div>

      <el-table :data="pageData.records" v-loading="loading">
        <template #empty>
          <el-empty class="empty-block" description="未检索到符合条件的修复审批任务，请调整筛选条件后重试。" />
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
        <el-table-column label="申请时间" min-width="170">
          <template #default="{ row }">{{ formatDateTime(row.applyTime) }}</template>
        </el-table-column>
        <el-table-column label="操作" class-name="table-action-column" width="300" fixed="right">
          <template #default="{ row }">
            <el-button text type="primary" @click="openDetail(row.id)">详情</el-button>
            <template v-if="row.taskStatus === 'APPLIED' && authStore.hasPermission('repair:plan:approve')">
              <el-button text type="primary" @click="handleApprove(row.id)">通过</el-button>
              <el-button text type="danger" @click="handleReject(row.id)">驳回</el-button>
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
  </div>
</template>

<script setup>
import { computed, reactive, ref } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { approveRepairApi, getRepairApprovePageApi, getRepairDetailApi } from '@/api/repair'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { useAuthStore } from '@/stores/auth'
import RepairTaskDrawer from './components/RepairTaskDrawer.vue'
import { formatDateTime } from '@/utils/format'

defineProps({
  mode: {
    type: String,
    default: 'approve'
  }
})

const route = useRoute()
const authStore = useAuthStore()
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
  keyword: '',
  taskStatus: typeof route.query.taskStatus === 'string' ? route.query.taskStatus : 'APPLIED'
})

const taskStatusLabelMap = {
  APPLIED: '待审批',
  APPROVED: '已通过',
  REJECTED: '已驳回'
}

const acceptanceStatusLabelMap = {
  UNACCEPTED: '尚未验收',
  WAITING: '等待验收',
  SUCCESS: '验收成功',
  REJECTED: '验收被驳回'
}

const currentPageCount = computed(() => pageData.value.records.length)
const pendingCount = computed(() => pageData.value.records.filter((item) => item.taskStatus === 'APPLIED').length)
const approvedCount = computed(() => pageData.value.records.filter((item) => item.taskStatus === 'APPROVED').length)
const rejectedCount = computed(() => pageData.value.records.filter((item) => item.taskStatus === 'REJECTED').length)

async function loadPage() {
  loading.value = true
  try {
    pageData.value = await getRepairApprovePageApi(queryForm)
  } finally {
    loading.value = false
  }
}

async function openDetail(id) {
  detail.value = await getRepairDetailApi(id)
  drawerVisible.value = true
}

async function refreshCurrentDetail(id) {
  if (drawerVisible.value && detail.value?.id === id) {
    detail.value = await getRepairDetailApi(id)
  }
}

async function handleApprove(id) {
  try {
    const { value } = await ElMessageBox.prompt('可填写审批意见，留空则直接通过。', '修复审批通过', {
      confirmButtonText: '确认通过',
      cancelButtonText: '取消',
      inputPlaceholder: '请输入审批意见'
    })
    await approveRepairApi(id, {
      approveResult: 'APPROVED',
      approveRemark: value?.trim() || ''
    })
    ElMessage.success('审批已通过')
    await loadPage()
    await refreshCurrentDetail(id)
  } catch (error) {
    if (error !== 'cancel' && error !== 'close') {
      throw error
    }
  }
}

async function handleReject(id) {
  try {
    const { value } = await ElMessageBox.prompt('请填写驳回理由。', '驳回修复申请', {
      confirmButtonText: '确认驳回',
      cancelButtonText: '取消',
      inputPlaceholder: '请输入驳回理由',
      inputPattern: /.+/,
      inputErrorMessage: '驳回理由不能为空'
    })
    await approveRepairApi(id, {
      approveResult: 'REJECTED',
      approveRemark: value.trim()
    })
    ElMessage.success('修复申请已驳回')
    await loadPage()
    await refreshCurrentDetail(id)
  } catch (error) {
    if (error !== 'cancel' && error !== 'close') {
      throw error
    }
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
    taskStatus: 'APPLIED'
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
.approve-metrics {
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
  .approve-metrics {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 640px) {
  .approve-metrics {
    grid-template-columns: 1fr;
  }
}
</style>
