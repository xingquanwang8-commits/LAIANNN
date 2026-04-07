<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="query-toolbar">
        <el-radio-group v-model="queryForm.taskStatus" @change="handleSearch">
          <el-radio-button label="APPLIED">待审批</el-radio-button>
          <el-radio-button label="APPROVED">已通过</el-radio-button>
          <el-radio-button label="REJECTED">已驳回</el-radio-button>
          <el-radio-button label="">全部</el-radio-button>
        </el-radio-group>

        <el-form :inline="true" :model="queryForm" class="query-form query-form--single-line">
          <el-form-item label="关键词" class="query-form__keyword query-form__keyword--wide">
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
      <div class="summary-grid">
        <article class="summary-card">
          <span class="summary-card__label">当前页待审批</span>
          <strong class="summary-card__value">{{ pendingCount }}</strong>
        </article>
        <article class="summary-card">
          <span class="summary-card__label">当前页已通过</span>
          <strong class="summary-card__value">{{ approvedCount }}</strong>
        </article>
        <article class="summary-card">
          <span class="summary-card__label">当前页已驳回</span>
          <strong class="summary-card__value">{{ rejectedCount }}</strong>
        </article>
        <article class="summary-card">
          <span class="summary-card__label">当前页任务总数</span>
          <strong class="summary-card__value">{{ pageData.records.length }}</strong>
        </article>
      </div>

      <el-table :data="pageData.records" v-loading="loading">
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
        <el-table-column label="操作" width="260" fixed="right">
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
.summary-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 14px;
  margin-bottom: 18px;
}

.summary-card {
  padding: 16px 18px;
  border: 1px solid var(--border-line);
  border-radius: 16px;
  background: linear-gradient(180deg, #ffffff, #f7faf5);
}

.summary-card__label {
  display: block;
  color: var(--text-second);
  font-size: 13px;
}

.summary-card__value {
  display: block;
  margin-top: 10px;
  font-size: 28px;
  line-height: 1;
}

.table-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}

@media (max-width: 1100px) {
  .summary-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 900px) {
  .summary-grid {
    grid-template-columns: 1fr;
  }
}
</style>
