<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="overview-panel overview-panel--compact">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">MHMP Inventory Task</div>
            <h2 class="overview-panel__title">盘点任务</h2>
            <p class="overview-panel__desc">
              统一管理馆内盘点任务，记录盘点库位、负责人、盘点明细和差异结果，支持从文物详情页快捷发起。
            </p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">任务总数 {{ pageData.total }} 条</span>
            <span class="overview-chip overview-chip--accent">当前页 {{ currentPageCount }} 条</span>
          </div>
        </div>

        <div class="metric-grid inventory-metrics">
          <article class="metric-card">
            <span class="metric-card__label">待开始任务</span>
            <strong class="metric-card__value">{{ createdCount }}</strong>
            <div class="metric-card__meta">已创建但尚未进入盘点处理的任务</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">进行中任务</span>
            <strong class="metric-card__value">{{ progressCount }}</strong>
            <div class="metric-card__meta">正在登记盘点明细与差异的任务</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">已完成任务</span>
            <strong class="metric-card__value">{{ completedCount }}</strong>
            <div class="metric-card__meta">已提交盘点结果并形成闭环的任务</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页差异总数</span>
            <strong class="metric-card__value">{{ diffTotal }}</strong>
            <div class="metric-card__meta">按当前页任务汇总统计的差异数量</div>
          </article>
        </div>
      </div>
    </section>

    <section class="page-card page-card--section">
      <PageHeader
        title="盘点任务检索"
        description="按任务编号、名称、库位和任务状态筛选盘点任务，可直接发起新任务或进入明细抽屉处理盘点结果。"
      >
        <template #extra>
          <div v-if="authStore.hasPermission('inventory:task:add')" class="query-toolbar__actions">
            <el-button type="primary" @click="openCreate">新增任务</el-button>
          </div>
        </template>
      </PageHeader>

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
          <div class="list-section__title">盘点任务列表</div>
          <div class="list-section__desc">
            当前展示 {{ currentPageCount }} 条盘点任务，可进入抽屉查看盘点明细、登记实际数量并提交盘点结果。
          </div>
        </div>
      </div>

      <el-table :data="pageData.records" v-loading="loading">
        <template #empty>
          <el-empty class="empty-block" description="未检索到符合条件的盘点任务，请调整筛选条件后重试。" />
        </template>
        <el-table-column prop="taskNo" label="任务编号" min-width="150" />
        <el-table-column prop="taskName" label="任务名称" min-width="170" />
        <el-table-column label="库位" min-width="130">
          <template #default="{ row }">{{ resolveDictLabel(locationOptions, row.locationCode) }}</template>
        </el-table-column>
        <el-table-column prop="principalName" label="负责人" min-width="120" />
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
            <el-button text type="primary" @click="openDetail(row.id)">查看盘点</el-button>
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

    <el-dialog v-model="dialogVisible" title="新增盘点任务" width="660px">
      <div class="detail-stack">
        <div class="overview-panel overview-panel--compact dialog-overview">
          <div class="overview-panel__top">
            <div>
              <div class="overview-panel__eyebrow">Inventory Create</div>
              <h3 class="overview-panel__title dialog-overview__title">发起盘点任务</h3>
              <p class="overview-panel__desc">
                创建前系统会核对当前库位是否有可纳入盘点的在库文物，以及是否存在未完成盘点任务，避免重复发起。
              </p>
            </div>
            <div class="overview-panel__meta">
              <span class="overview-chip">任务编号保存后自动生成</span>
              <span class="overview-chip overview-chip--accent">{{ resolveDictLabel(locationOptions, formData.locationCode) || '未选择库位' }}</span>
            </div>
          </div>
        </div>

        <el-form ref="formRef" :model="formData" :rules="rules" label-width="96px">
          <el-form-item label="任务名称" prop="taskName">
            <el-input v-model="formData.taskName" />
          </el-form-item>
          <el-form-item label="任务编号">
            <el-input model-value="保存后自动生成" disabled />
          </el-form-item>
          <el-form-item label="库位" prop="locationCode">
            <el-select v-model="formData.locationCode" placeholder="请选择库位">
              <el-option
                v-for="item in locationOptions"
                :key="item.itemValue"
                :label="item.itemLabel"
                :value="item.itemValue"
              />
            </el-select>
          </el-form-item>
          <el-form-item v-if="inventoryCheckVisible" label="业务校验">
            <div
              class="business-check inventory-check"
              :class="inventoryCheckPassed ? 'business-check--pass' : 'business-check--warn'"
            >
              <div class="business-check__header">
                <div class="business-check__title">{{ inventoryCheckTitle }}</div>
              </div>
              <div class="business-check__summary">{{ inventoryCheckSummary }}</div>
              <ul v-if="inventoryCheckDetails.length" class="business-check__list">
                <li
                  v-for="item in inventoryCheckDetails"
                  :key="item"
                  class="business-check__item"
                >
                  {{ item }}
                </li>
              </ul>
            </div>
          </el-form-item>
          <el-form-item label="开始时间" prop="startTime">
            <el-date-picker v-model="formData.startTime" type="datetime" value-format="YYYY-MM-DDTHH:mm:ss" />
          </el-form-item>
          <el-form-item label="负责人" prop="principalName">
            <el-input v-model="formData.principalName" disabled />
          </el-form-item>
          <el-form-item label="备注">
            <el-input v-model="formData.remark" type="textarea" :rows="3" placeholder="可填写盘点范围、重点关注事项或交接说明" />
          </el-form-item>
        </el-form>
      </div>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleSave">提交</el-button>
      </template>
    </el-dialog>

    <el-drawer v-model="drawerVisible" title="盘点任务详情" size="60%">
      <div class="detail-stack">
        <div class="overview-panel overview-panel--compact drawer-overview">
          <div class="overview-panel__top">
            <div>
              <div class="overview-panel__eyebrow">Inventory Detail</div>
              <h3 class="overview-panel__title drawer-overview__title">{{ detail.taskNo || '盘点任务详情' }}</h3>
              <p class="overview-panel__desc">
                查看当前盘点任务的库位、负责人、任务状态和盘点明细，可在任务未完成前持续登记实际数量与差异备注。
              </p>
            </div>
            <div class="overview-panel__meta">
              <span class="overview-chip">{{ resolveDictLabel(locationOptions, detail.locationCode) || '--' }}</span>
              <span class="overview-chip overview-chip--accent">差异 {{ detail.diffCount || 0 }} 项</span>
            </div>
          </div>
        </div>

        <section class="info-section">
          <div class="info-section__header">
            <div>
              <h3 class="info-section__title">任务信息</h3>
              <p class="info-section__desc">汇总任务编号、任务名称、库位、负责人和开始时间，作为盘点主记录。</p>
            </div>
          </div>

          <el-descriptions :column="2" border>
            <el-descriptions-item label="任务编号">{{ detail.taskNo || '--' }}</el-descriptions-item>
            <el-descriptions-item label="任务名称">{{ detail.taskName || '--' }}</el-descriptions-item>
            <el-descriptions-item label="库位">{{ resolveDictLabel(locationOptions, detail.locationCode) }}</el-descriptions-item>
            <el-descriptions-item label="负责人">{{ detail.principalName || '--' }}</el-descriptions-item>
            <el-descriptions-item label="状态">{{ taskStatusLabelMap[detail.taskStatus] || detail.taskStatus || '--' }}</el-descriptions-item>
            <el-descriptions-item label="开始时间">{{ formatDateTime(detail.startTime) }}</el-descriptions-item>
          </el-descriptions>
        </section>

        <section class="info-section">
          <PageHeader
            title="盘点明细"
            description="录入实际盘点数量并补充差异说明，系统将自动回写正常、已核对或存在差异等结果状态。"
          />

          <el-table :data="detail.details || []" class="drawer-table">
            <template #empty>
              <el-empty class="empty-block" description="当前盘点任务暂无明细数据。" />
            </template>
            <el-table-column prop="relicNo" label="文物编号" min-width="130" />
            <el-table-column prop="relicName" label="文物名称" min-width="150" />
            <el-table-column prop="systemQuantity" label="系统数量" width="100" />
            <el-table-column label="实盘数量" width="130">
              <template #default="{ row }">
                <el-input-number
                  v-model="row.actualQuantity"
                  :min="0"
                  :disabled="detail.taskStatus === 'COMPLETED' || !authStore.hasPermission('inventory:task:submit')"
                />
              </template>
            </el-table-column>
            <el-table-column label="差异备注" min-width="150">
              <template #default="{ row }">
                <el-input
                  v-model="row.diffRemark"
                  :disabled="detail.taskStatus === 'COMPLETED' || !authStore.hasPermission('inventory:task:submit')"
                />
              </template>
            </el-table-column>
            <el-table-column label="结果" width="120">
              <template #default="{ row }">
                <StatusTag :status="row.resultStatus" :label="resultLabelMap[row.resultStatus] || row.resultStatus" />
              </template>
            </el-table-column>
            <el-table-column v-if="authStore.hasPermission('inventory:task:submit')" label="保存" width="100">
              <template #default="{ row }">
                <el-button
                  text
                  type="primary"
                  :disabled="detail.taskStatus === 'COMPLETED'"
                  @click="handleSaveDetail(row)"
                >
                  保存
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </section>

        <div class="drawer-footer">
          <el-button
            v-if="authStore.hasPermission('inventory:task:submit')"
            type="primary"
            :disabled="detail.taskStatus === 'COMPLETED'"
            @click="handleSubmitTask"
          >
            提交盘点结果
          </el-button>
        </div>
      </div>
    </el-drawer>
  </div>
</template>

<script setup>
import { computed, nextTick, reactive, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import {
  createInventoryTaskApi,
  getInventoryTaskDetailApi,
  getInventoryTaskPageApi,
  submitInventoryTaskApi,
  updateInventoryTaskDetailApi
} from '@/api/inventory'
import { getRelicDetailApi, getRelicPageApi } from '@/api/relic'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { useAuthStore } from '@/stores/auth'
import { useDictStore } from '@/stores/dict'
import { validateElForm } from '@/utils/form'
import { formatDateTime, resolveDictLabel } from '@/utils/format'
import {
  checkInventoryRelicEligibility,
  pickRelicBusinessFields
} from '@/utils/relicBusinessRules'

const route = useRoute()
const authStore = useAuthStore()
const dictStore = useDictStore()

const loading = ref(false)
const saving = ref(false)
const dialogVisible = ref(false)
const drawerVisible = ref(false)
const formRef = ref()
const detail = ref({})
const inventoryCheckLoading = ref(false)
const inventoryLocationStats = ref({
  eligibleCount: 0,
  previewRelics: [],
  activeTaskNames: []
})
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

const formData = reactive({
  taskName: '',
  locationCode: '',
  startTime: '',
  principalName: '',
  remark: ''
})

const rules = {
  taskName: [{ required: true, message: '请输入任务名称', trigger: 'blur' }],
  locationCode: [{ required: true, message: '请选择库位', trigger: 'change' }],
  startTime: [{ required: true, message: '请选择开始时间', trigger: 'change' }],
  principalName: [{ required: true, message: '请输入负责人', trigger: 'blur' }]
}

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
const currentOperatorName = computed(() => authStore.displayName || authStore.user?.username || '褰撳墠鐢ㄦ埛')
const inventoryCheckVisible = computed(() => dialogVisible.value && Boolean(formData.locationCode))
const inventoryCheckPassed = computed(() =>
  Boolean(formData.locationCode)
  && !inventoryCheckLoading.value
  && inventoryLocationStats.value.eligibleCount > 0
  && inventoryLocationStats.value.activeTaskNames.length === 0
)
const inventoryCheckTitle = computed(() => (
  inventoryCheckPassed.value
    ? '盘点发起前置校验已通过'
    : '盘点发起前置校验未通过'
))
const inventoryCheckSummary = computed(() => {
  if (!formData.locationCode) {
    return ''
  }
  if (inventoryCheckLoading.value) {
    return '正在核对当前库位的在库文物和未完成盘点任务，请稍候。'
  }
  if (inventoryCheckPassed.value) {
    return `当前库位共有 ${inventoryLocationStats.value.eligibleCount} 件在库文物可纳入盘点，且没有未完成盘点任务，可直接创建。`
  }
  if (inventoryLocationStats.value.activeTaskNames.length) {
    return '当前库位已存在未完成盘点任务，请先完成或结束现有任务后再重复发起。'
  }
  return '当前库位暂无可纳入盘点的在库文物，请检查文物状态或重新选择库位。'
})
const inventoryCheckDetails = computed(() => {
  if (!formData.locationCode || inventoryCheckLoading.value) {
    return []
  }
  const details = []
  const locationLabel = resolveDictLabel(locationOptions.value, formData.locationCode) || formData.locationCode
  details.push(`盘点库位：${locationLabel}`)
  details.push(`在库文物：${inventoryLocationStats.value.eligibleCount} 件`)
  if (inventoryLocationStats.value.previewRelics.length) {
    details.push(`库位文物示例：${inventoryLocationStats.value.previewRelics.join('、')}`)
  }
  if (inventoryLocationStats.value.activeTaskNames.length) {
    details.push(`未完成任务：${inventoryLocationStats.value.activeTaskNames.join('、')}`)
  }
  return details
})
const currentPageCount = computed(() => pageData.value.records.length)
const createdCount = computed(() => pageData.value.records.filter((item) => item.taskStatus === 'CREATED').length)
const progressCount = computed(() => pageData.value.records.filter((item) => item.taskStatus === 'IN_PROGRESS').length)
const completedCount = computed(() => pageData.value.records.filter((item) => item.taskStatus === 'COMPLETED').length)
const diffTotal = computed(() => pageData.value.records.reduce((sum, item) => sum + Number(item.diffCount || 0), 0))

function currentDateTime() {
  const now = new Date()
  const year = now.getFullYear()
  const month = `${now.getMonth() + 1}`.padStart(2, '0')
  const day = `${now.getDate()}`.padStart(2, '0')
  const hour = `${now.getHours()}`.padStart(2, '0')
  const minute = `${now.getMinutes()}`.padStart(2, '0')
  const second = `${now.getSeconds()}`.padStart(2, '0')
  return `${year}-${month}-${day}T${hour}:${minute}:${second}`
}

function resetForm() {
  Object.assign(formData, {
    taskName: '',
    locationCode: '',
    startTime: currentDateTime(),
    principalName: currentOperatorName.value,
    remark: ''
  })
}

async function loadInventoryLocationStats(locationCode) {
  if (!locationCode) {
    inventoryLocationStats.value = {
      eligibleCount: 0,
      previewRelics: [],
      activeTaskNames: []
    }
    return
  }
  inventoryCheckLoading.value = true
  try {
    const [relicPage, createdTasks, progressTasks] = await Promise.all([
      getRelicPageApi({
        pageNum: 1,
        pageSize: 5,
        storageLocationCode: locationCode,
        currentStatus: 'IN_STOCK'
      }),
      getInventoryTaskPageApi({
        pageNum: 1,
        pageSize: 5,
        locationCode,
        taskStatus: 'CREATED'
      }),
      getInventoryTaskPageApi({
        pageNum: 1,
        pageSize: 5,
        locationCode,
        taskStatus: 'IN_PROGRESS'
      })
    ])
    const activeTaskNames = [
      ...(createdTasks.records || []).map((item) => item.taskName || item.taskNo),
      ...(progressTasks.records || []).map((item) => item.taskName || item.taskNo)
    ]
    inventoryLocationStats.value = {
      eligibleCount: relicPage.total || 0,
      previewRelics: (relicPage.records || []).slice(0, 3).map((item) => item.name || item.relicNo),
      activeTaskNames
    }
  } finally {
    inventoryCheckLoading.value = false
  }
}

async function loadTasks() {
  loading.value = true
  try {
    pageData.value = await getInventoryTaskPageApi(queryForm)
  } finally {
    loading.value = false
  }
}

async function openDetail(id) {
  detail.value = await getInventoryTaskDetailApi(id)
  drawerVisible.value = true
}

function suggestTaskName(locationCode) {
  const locationLabel = resolveDictLabel(locationOptions.value, locationCode) || '当前库位'
  return `${locationLabel}盘点任务`
}

async function openCreate(prefill = {}) {
  if (!authStore.hasPermission('inventory:task:add')) {
    ElMessage.warning('当前账号没有新增盘点任务的权限')
    return
  }
  resetForm()
  if (prefill.locationCode) {
    formData.locationCode = prefill.locationCode
  }
  if (prefill.locationCode) {
    formData.taskName = suggestTaskName(prefill.locationCode)
  }
  if (prefill.quickCreate) {
    formData.remark = '由文物详情快捷发起，建议优先核对当前文物及同库位藏品'
  }
  dialogVisible.value = true
  await loadInventoryLocationStats(formData.locationCode)
  await nextTick()
  formRef.value?.clearValidate()
}

async function handleSave() {
  if (!authStore.hasPermission('inventory:task:add')) {
    ElMessage.warning('当前账号没有新增盘点任务的权限')
    return
  }
  const valid = await validateElForm(formRef, '璇峰厛瀹屽杽鐩樼偣浠诲姟淇℃伅鍚庡啀鎻愪氦')
  if (!valid) {
    return
  }
  if (inventoryCheckLoading.value) {
    ElMessage.warning('正在核对当前库位业务状态，请稍候后再提交')
    return
  }
  if (!inventoryCheckPassed.value) {
    ElMessage.warning(inventoryCheckSummary.value || '当前库位不符合发起盘点任务的条件')
    return
  }
  saving.value = true
  try {
    await createInventoryTaskApi(formData)
    ElMessage.success('盘点任务已创建')
    dialogVisible.value = false
    await loadTasks()
  } finally {
    saving.value = false
  }
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

async function handleQuickCreateFromRoute() {
  if (route.query.quickCreate !== '1' || !route.query.relicId) {
    return
  }
  if (dialogVisible.value && formData.locationCode === route.query.locationCode) {
    return
  }

  const detail = await getRelicDetailApi(route.query.relicId).catch(() => null)
  if (!detail) {
    ElMessage.warning('未找到当前文物档案，请刷新后重试')
    return
  }
  const checkResult = checkInventoryRelicEligibility(pickRelicBusinessFields(detail))
  if (!checkResult.passed) {
    ElMessage.warning(checkResult.message)
    return
  }
  await openCreate({
    quickCreate: true,
    locationCode: detail.storageLocationCode
  })
}

dictStore.ensureItems('storage_location')
watch(
  () => formData.locationCode,
  (value) => {
    if (!dialogVisible.value) {
      return
    }
    if (value && !formData.taskName) {
      formData.taskName = suggestTaskName(value)
    }
    loadInventoryLocationStats(value)
  }
)
watch(
  () => route.fullPath,
  () => {
    handleQuickCreateFromRoute()
  },
  { immediate: true }
)
loadTasks()
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

.inventory-check {
  width: 100%;
}

.dialog-overview__title,
.drawer-overview__title {
  font-size: 22px;
}

.table-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}

.drawer-table {
  margin-top: 18px;
}

.drawer-footer {
  display: flex;
  justify-content: flex-end;
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
