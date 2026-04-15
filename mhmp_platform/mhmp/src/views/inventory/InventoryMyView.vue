<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="overview-panel overview-panel--compact">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">MHMP My Inventory</div>
            <h2 class="overview-panel__title">我的盘点</h2>
            <p class="overview-panel__desc">
              展示当前登录用户负责的盘点任务，便于研究员持续登记实盘结果、补充差异说明并提交盘点结论。
            </p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">我的任务 {{ pageData.total }} 条</span>
            <span class="overview-chip overview-chip--accent">当前页 {{ currentPageCount }} 条</span>
          </div>
        </div>

        <div class="metric-grid inventory-metrics">
          <article class="metric-card">
            <span class="metric-card__label">待开始</span>
            <strong class="metric-card__value">{{ createdCount }}</strong>
            <div class="metric-card__meta">已接收但尚未录入盘点明细的任务</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">进行中</span>
            <strong class="metric-card__value">{{ progressCount }}</strong>
            <div class="metric-card__meta">正在盘点并记录差异的任务</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">已完成</span>
            <strong class="metric-card__value">{{ completedCount }}</strong>
            <div class="metric-card__meta">已提交盘点结果的任务</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页差异</span>
            <strong class="metric-card__value">{{ diffTotal }}</strong>
            <div class="metric-card__meta">当前页任务中已识别的差异项数量</div>
          </article>
        </div>
      </div>
    </section>

    <section class="page-card page-card--section">
      <PageHeader
        title="我的盘点检索"
        description="按任务编号、名称、库位和任务状态筛选我负责的盘点任务，支持直接进入抽屉录入实盘结果。"
      />

      <div class="query-toolbar query-toolbar--approval">
        <el-radio-group v-model="queryForm.taskStatus" @change="handleSearch">
          <el-radio-button label="CREATED">未开始</el-radio-button>
          <el-radio-button label="IN_PROGRESS">进行中</el-radio-button>
          <el-radio-button label="COMPLETED">已完成</el-radio-button>
          <el-radio-button label="">全部</el-radio-button>
        </el-radio-group>

        <el-form :inline="true" :model="queryForm" class="query-form query-form--single-line">
          <el-form-item label="关键字" class="query-form__keyword query-form__keyword--wide">
            <el-input v-model="queryForm.keyword" placeholder="任务编号 / 名称" clearable @keyup.enter="handleSearch" />
          </el-form-item>
          <el-form-item label="库位">
            <el-select v-model="queryForm.locationCode" clearable placeholder="全部库位">
              <el-option
                v-for="item in locationOptions"
                :key="item.itemValue"
                :label="item.itemLabel"
                :value="item.itemValue"
              />
            </el-select>
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
          <div class="list-section__title">我的盘点任务</div>
          <div class="list-section__desc">
            当前展示 {{ currentPageCount }} 条任务，可查看任务详情、保存盘点明细，并在核对完成后提交盘点结果。
          </div>
        </div>
      </div>

      <el-table :data="pageData.records" v-loading="loading">
        <template #empty>
          <el-empty class="empty-block" description="当前没有匹配的负责盘点任务，请调整筛选条件后重试。" />
        </template>
        <el-table-column prop="taskNo" label="任务编号" min-width="150" />
        <el-table-column prop="taskName" label="任务名称" min-width="170" />
        <el-table-column label="库位" min-width="130">
          <template #default="{ row }">{{ resolveDictLabel(locationOptions, row.locationCode) }}</template>
        </el-table-column>
        <el-table-column label="状态" width="120">
          <template #default="{ row }">
            <StatusTag :status="row.taskStatus" :label="taskStatusLabelMap[row.taskStatus] || row.taskStatus" />
          </template>
        </el-table-column>
        <el-table-column prop="totalCount" label="文物数" width="100" />
        <el-table-column prop="diffCount" label="差异数" width="100" />
        <el-table-column label="开始时间" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.startTime) }}</template>
        </el-table-column>
        <el-table-column label="操作" class-name="table-action-column" width="120">
          <template #default="{ row }">
            <el-button text type="primary" @click="openDetail(row.id)">进入盘点</el-button>
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

    <InventoryTaskDrawer
      v-model="drawerVisible"
      :detail="detail"
      :location-options="locationOptions"
      :task-status-label-map="taskStatusLabelMap"
      :result-label-map="resultLabelMap"
      :can-edit="authStore.hasPermission('inventory:task:submit')"
      :can-submit="authStore.hasPermission('inventory:task:submit')"
      @save-detail="handleSaveDetail"
      @submit-task="handleSubmitTask"
    />
  </div>
</template>

<script setup>
import { computed, reactive, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import {
  getInventoryTaskDetailApi,
  getInventoryTaskPageApi,
  submitInventoryTaskApi,
  updateInventoryTaskDetailApi
} from '@/api/inventory'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { useAuthStore } from '@/stores/auth'
import { useDictStore } from '@/stores/dict'
import { formatDateTime, resolveDictLabel } from '@/utils/format'
import InventoryTaskDrawer from './components/InventoryTaskDrawer.vue'

const route = useRoute()
const authStore = useAuthStore()
const dictStore = useDictStore()

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
  locationCode: '',
  taskStatus: typeof route.query.taskStatus === 'string' ? route.query.taskStatus : ''
})

const taskStatusLabelMap = {
  CREATED: '未开始',
  IN_PROGRESS: '进行中',
  COMPLETED: '已完成'
}

const resultLabelMap = {
  PENDING: '待录入',
  CHECKED: '已核对',
  DIFF_FOUND: '存在差异',
  NORMAL: '正常'
}

const locationOptions = computed(() => dictStore.itemsMap.storage_location || [])
const currentUserId = computed(() => authStore.user?.id || null)
const currentPageCount = computed(() => pageData.value.records.length)
const createdCount = computed(() => pageData.value.records.filter((item) => item.taskStatus === 'CREATED').length)
const progressCount = computed(() => pageData.value.records.filter((item) => item.taskStatus === 'IN_PROGRESS').length)
const completedCount = computed(() => pageData.value.records.filter((item) => item.taskStatus === 'COMPLETED').length)
const diffTotal = computed(() => pageData.value.records.reduce((sum, item) => sum + Number(item.diffCount || 0), 0))

async function loadTasks() {
  if (!currentUserId.value) {
    pageData.value = {
      total: 0,
      pageNum: queryForm.pageNum,
      pageSize: queryForm.pageSize,
      records: []
    }
    return
  }
  loading.value = true
  try {
    pageData.value = await getInventoryTaskPageApi({
      ...queryForm,
      principalUserId: currentUserId.value
    })
  } finally {
    loading.value = false
  }
}

async function openDetail(id) {
  detail.value = await getInventoryTaskDetailApi(id)
  drawerVisible.value = true
}

async function handleSaveDetail(row) {
  await updateInventoryTaskDetailApi(detail.value.id, row.id, {
    actualQuantity: row.actualQuantity,
    diffRemark: row.diffRemark
  })
  ElMessage.success('盘点明细已保存')
  await openDetail(detail.value.id)
}

async function handleSubmitTask() {
  await submitInventoryTaskApi(detail.value.id)
  ElMessage.success('盘点任务已提交')
  await openDetail(detail.value.id)
  await loadTasks()
}

function handleSearch() {
  queryForm.pageNum = 1
  loadTasks()
}

function handleReset() {
  Object.assign(queryForm, {
    pageNum: 1,
    pageSize: 10,
    keyword: '',
    locationCode: '',
    taskStatus: ''
  })
  loadTasks()
}

function handleCurrentChange(pageNum) {
  queryForm.pageNum = pageNum
  loadTasks()
}

function handleSizeChange(pageSize) {
  queryForm.pageSize = pageSize
  queryForm.pageNum = 1
  loadTasks()
}

dictStore.ensureItems('storage_location')

watch(
  () => currentUserId.value,
  () => {
    queryForm.pageNum = 1
    loadTasks()
  },
  { immediate: true }
)
</script>

<style scoped>
.inventory-metrics {
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
  .inventory-metrics {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 640px) {
  .inventory-metrics {
    grid-template-columns: 1fr;
  }
}
</style>
