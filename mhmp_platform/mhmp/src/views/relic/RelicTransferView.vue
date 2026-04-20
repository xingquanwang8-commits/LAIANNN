<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="overview-panel overview-panel--compact">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">MHMP Transfer Dispatch</div>
            <h2 class="overview-panel__title">发起转存</h2>
            <p class="overview-panel__desc">
              由系统管理员或高级研究员发起馆内转存任务，选择目标库位并指派研究员执行。任务下发后，研究员需在“我的转存”中确认完成，系统才会真正更新文物库位。
            </p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">可派发文物 {{ pageData.total }} 件</span>
            <span class="overview-chip overview-chip--accent">批量已选 {{ selectedRows.length }} 件</span>
          </div>
        </div>

        <div class="metric-grid transfer-metrics">
          <article class="metric-card">
            <span class="metric-card__label">当前页文物</span>
            <strong class="metric-card__value">{{ currentPageCount }}</strong>
            <div class="metric-card__meta">当前筛选结果中的在库文物，可直接发起转存任务。</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">涉及库位</span>
            <strong class="metric-card__value">{{ currentLocationCount }}</strong>
            <div class="metric-card__meta">用于快速判断本页待派发文物覆盖的馆内库位范围。</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">保存状态类型</span>
            <strong class="metric-card__value">{{ preservationCoverageCount }}</strong>
            <div class="metric-card__meta">便于识别是否涉及需重点关注的文物对象。</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">可选研究员</span>
            <strong class="metric-card__value">{{ principalOptions.length }}</strong>
            <div class="metric-card__meta">管理员和高级研究员可将转存任务派发给研究员执行。</div>
          </article>
        </div>
      </div>
    </section>

    <section class="page-card page-card--section">
      <PageHeader
        title="转存对象检索"
        description="按文物编号、类别和当前库位筛选可发起转存的文物，支持单件派发和批量派发。"
      >
        <template #extra>
          <div class="query-toolbar__actions">
            <el-button :type="multipleMode ? 'primary' : 'default'" plain @click="toggleMultipleMode">
              {{ multipleMode ? '退出多选' : '多选派发' }}
            </el-button>
            <el-button
              v-if="multipleMode"
              type="primary"
              :disabled="!selectedRows.length"
              @click="openBatchTransferDialog"
            >
              一键派发{{ selectedRows.length ? `（${selectedRows.length}）` : '' }}
            </el-button>
          </div>
        </template>
      </PageHeader>

      <div class="query-toolbar">
        <el-form :inline="true" :model="queryForm" class="query-form query-form--single-line">
          <el-form-item label="关键字" class="query-form__keyword">
            <el-input v-model="queryForm.keyword" placeholder="文物编号 / 名称" clearable @keyup.enter="handleSearch" />
          </el-form-item>
          <el-form-item label="文物类别">
            <el-select v-model="queryForm.categoryCode" clearable placeholder="全部类别">
              <el-option
                v-for="item in categoryOptions"
                :key="item.itemValue"
                :label="item.itemLabel"
                :value="item.itemValue"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="当前库位">
            <el-select v-model="queryForm.storageLocationCode" clearable placeholder="全部库位">
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
          <div class="list-section__title">可派发转存文物</div>
          <div class="list-section__desc">
            当前展示 {{ currentPageCount }} 件文物，既可逐件发起转存，也可开启批量模式统一派发给同一位研究员。
          </div>
        </div>
      </div>

      <el-table
        ref="tableRef"
        :data="pageData.records"
        v-loading="loading"
        row-key="id"
        @selection-change="handleSelectionChange"
      >
        <template #empty>
          <el-empty class="empty-block" description="未检索到符合条件的可转存文物，请调整筛选条件后重试。" />
        </template>
        <el-table-column v-if="multipleMode" type="selection" width="54" reserve-selection />
        <el-table-column prop="relicNo" label="文物编号" min-width="150" />
        <el-table-column label="文物名称" min-width="220">
          <template #default="{ row }">
            <div class="transfer-name-cell">
              <div class="transfer-name-cell__title">{{ row.name || '--' }}</div>
              <div class="transfer-name-cell__meta">
                保存状态：{{ resolveDictLabel(preservationOptions, row.preservationStatusCode) || '--' }}
              </div>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="类别" min-width="120">
          <template #default="{ row }">{{ resolveDictLabel(categoryOptions, row.categoryCode) }}</template>
        </el-table-column>
        <el-table-column label="当前库位" min-width="130">
          <template #default="{ row }">{{ resolveDictLabel(locationOptions, row.storageLocationCode) }}</template>
        </el-table-column>
        <el-table-column label="更新时间" min-width="150">
          <template #default="{ row }">{{ formatDateTime(row.updateTime) }}</template>
        </el-table-column>
        <el-table-column label="操作" class-name="table-action-column" width="180" fixed="right">
          <template #default="{ row }">
            <el-button text type="primary" @click="router.push(`/relic/detail/${row.id}`)">详情</el-button>
            <el-button text type="primary" @click="openTransferDialog(row)">发起转存</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="table-footer">
        <div v-if="multipleMode" class="table-selection-tip">
          已选中文物 {{ selectedRows.length }} 件，可统一派发转存任务。
        </div>
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

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="720px">
      <div class="detail-stack">
        <div class="overview-panel overview-panel--compact transfer-dialog-overview">
          <div class="overview-panel__top">
            <div>
              <div class="overview-panel__eyebrow">Transfer Dispatch</div>
              <h3 class="overview-panel__title transfer-dialog-overview__title">{{ dialogTitle }}</h3>
              <p class="overview-panel__desc">
                选择目标库位和负责人后提交，系统会创建转存任务并下发给研究员。只有研究员在“我的转存”中确认完成后，文物库位才会正式更新。
              </p>
            </div>
            <div class="overview-panel__meta">
              <span class="overview-chip">待派发 {{ selectedRelics.length }} 件</span>
              <span class="overview-chip overview-chip--accent">
                负责人 {{ selectedPrincipalLabel || '待选择' }}
              </span>
            </div>
          </div>
        </div>

        <div class="soft-note soft-note--accent">
          <div class="soft-note__title">派发说明</div>
          <div class="soft-note__desc">
            转存任务适用于馆内库位调整，不改变文物归属和档案编号。若系统提示校验未通过，请先处理当前业务状态后再发起。
          </div>
        </div>

        <el-form ref="formRef" :model="formData" :rules="rules" label-width="96px">
          <el-form-item label="转存对象">
            <div v-if="selectedRelics.length === 1" class="selected-relic">
              <div>{{ selectedRelics[0]?.relicNo }} / {{ selectedRelics[0]?.name }}</div>
              <div class="text-secondary">
                当前库位：{{ resolveDictLabel(locationOptions, selectedRelics[0]?.storageLocationCode) || '--' }}
              </div>
            </div>
            <div v-else class="selected-batch">
              <div>已选择 {{ selectedRelics.length }} 件文物</div>
              <div class="selected-batch__list">
                <span v-for="item in selectedRelicPreview" :key="item.id">{{ item.relicNo }} / {{ item.name }}</span>
                <span v-if="selectedRelics.length > selectedRelicPreview.length">共 {{ selectedRelics.length }} 件</span>
              </div>
            </div>
          </el-form-item>
          <el-form-item label="负责人" prop="principalUserId">
            <el-select
              v-model="formData.principalUserId"
              placeholder="请选择负责执行转存的研究员"
              :loading="principalLoading"
            >
              <el-option
                v-for="item in principalOptions"
                :key="item.id"
                :label="item.displayName"
                :value="item.id"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="目标库位" prop="targetLocationCode">
            <el-select v-model="formData.targetLocationCode" placeholder="请选择目标库位">
              <el-option
                v-for="item in locationOptions"
                :key="item.itemValue"
                :label="item.itemLabel"
                :value="item.itemValue"
              />
            </el-select>
          </el-form-item>
          <el-form-item v-if="transferCheck.totalCount" label="业务校验">
            <div
              class="business-check transfer-check"
              :class="transferCheck.allPassed ? 'business-check--pass' : 'business-check--warn'"
            >
              <div class="business-check__header">
                <div class="business-check__title">{{ transferCheckTitle }}</div>
              </div>
              <div class="business-check__summary">{{ transferCheckSummary }}</div>
              <ul v-if="transferCheck.invalidItems.length" class="business-check__list">
                <li
                  v-for="item in transferCheck.invalidItems.slice(0, 4)"
                  :key="`${item.identity}-${item.message}`"
                  class="business-check__item"
                >
                  {{ item.identity }}：{{ item.message }}
                </li>
              </ul>
            </div>
          </el-form-item>
          <el-form-item label="转存说明">
            <el-input
              v-model="formData.transferReason"
              type="textarea"
              :rows="3"
              placeholder="请输入本次馆内转存的原因、背景或保管说明"
            />
          </el-form-item>
        </el-form>
      </div>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleSubmit">提交</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { computed, nextTick, reactive, ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { useRoute, useRouter } from 'vue-router'
import { getRelicDetailApi, getRelicPageApi } from '@/api/relic'
import {
  createTransferBatchTasksApi,
  createTransferTaskApi,
  getTransferTaskPrincipalOptionsApi
} from '@/api/inventory'
import PageHeader from '@/components/common/PageHeader.vue'
import { useDictStore } from '@/stores/dict'
import { validateElForm } from '@/utils/form'
import { formatDateTime, resolveDictLabel } from '@/utils/format'
import {
  analyzeRelicSelection,
  checkTransferRelicEligibility,
  pickRelicBusinessFields
} from '@/utils/relicBusinessRules'

const route = useRoute()
const router = useRouter()
const dictStore = useDictStore()

const tableRef = ref()
const formRef = ref()
const loading = ref(false)
const saving = ref(false)
const principalLoading = ref(false)
const dialogVisible = ref(false)
const multipleMode = ref(false)
const selectedRows = ref([])
const selectedRelics = ref([])
const principalOptions = ref([])
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
  categoryCode: '',
  storageLocationCode: '',
  currentStatus: 'IN_STOCK'
})

const formData = reactive({
  principalUserId: null,
  targetLocationCode: '',
  transferReason: ''
})

const rules = {
  principalUserId: [{ required: true, message: '请选择负责人', trigger: 'change' }],
  targetLocationCode: [{ required: true, message: '请选择目标库位', trigger: 'change' }]
}

const categoryOptions = computed(() => dictStore.itemsMap.relic_category || [])
const locationOptions = computed(() => dictStore.itemsMap.storage_location || [])
const preservationOptions = computed(() => dictStore.itemsMap.preservation_status || [])
const currentPageCount = computed(() => pageData.value.records.length)
const currentLocationCount = computed(() =>
  new Set(pageData.value.records.map((item) => item.storageLocationCode).filter(Boolean)).size
)
const preservationCoverageCount = computed(() =>
  new Set(pageData.value.records.map((item) => item.preservationStatusCode).filter(Boolean)).size
)
const dialogTitle = computed(() => (
  selectedRelics.value.length > 1 ? `发起转存（已选 ${selectedRelics.value.length} 件）` : '发起转存'
))
const selectedRelicPreview = computed(() => selectedRelics.value.slice(0, 4))
const selectedPrincipalLabel = computed(() =>
  principalOptions.value.find((item) => item.id === formData.principalUserId)?.displayName || ''
)
const transferCheck = computed(() =>
  analyzeRelicSelection(
    selectedRelics.value,
    (relic) => checkTransferRelicEligibility(relic, formData.targetLocationCode)
  )
)
const transferCheckTitle = computed(() => (
  transferCheck.value.allPassed ? '转存任务前置校验已通过' : '转存任务前置校验未通过'
))
const transferCheckSummary = computed(() => {
  if (!transferCheck.value.totalCount) {
    return ''
  }
  if (transferCheck.value.allPassed) {
    return `已选 ${transferCheck.value.totalCount} 件文物，均符合馆内转存条件，可直接创建转存任务。`
  }
  if (!formData.targetLocationCode) {
    return `已选 ${transferCheck.value.totalCount} 件文物，请先选择目标库位，系统会同步校验是否与当前库位冲突。`
  }
  return `已选 ${transferCheck.value.totalCount} 件文物，其中 ${transferCheck.value.invalidItems.length} 件暂不符合转存条件，请先调整后再提交。`
})

async function loadPage() {
  loading.value = true
  try {
    pageData.value = await getRelicPageApi(queryForm)
  } finally {
    loading.value = false
  }
}

async function loadPrincipalOptions() {
  if (principalOptions.value.length) {
    return
  }
  principalLoading.value = true
  try {
    principalOptions.value = await getTransferTaskPrincipalOptionsApi()
  } finally {
    principalLoading.value = false
  }
}

function resetTransferForm() {
  formData.principalUserId = null
  formData.targetLocationCode = ''
  formData.transferReason = ''
}

function normalizeRelicSelection(row) {
  return {
    ...row,
    ...pickRelicBusinessFields(row)
  }
}

async function openTransferDialog(row, options = {}) {
  await loadPrincipalOptions()
  const relic = normalizeRelicSelection(row)
  const checkResult = checkTransferRelicEligibility(relic)
  if (!checkResult.passed) {
    ElMessage.warning(checkResult.message)
    return
  }
  selectedRelics.value = [relic]
  resetTransferForm()
  if (options.quickCreate) {
    formData.transferReason = '由文物详情页快捷发起'
  }
  dialogVisible.value = true
  nextTick(() => {
    formRef.value?.clearValidate()
  })
}

async function openBatchTransferDialog() {
  if (!selectedRows.value.length) {
    ElMessage.warning('请先选择要批量派发的文物')
    return
  }
  await loadPrincipalOptions()
  selectedRelics.value = selectedRows.value.map((item) => normalizeRelicSelection(item))
  resetTransferForm()
  dialogVisible.value = true
  nextTick(() => {
    formRef.value?.clearValidate()
  })
}

async function handleSubmit() {
  const valid = await validateElForm(formRef, '请完善负责人和目标库位后再提交')
  if (!valid) {
    return
  }
  if (!transferCheck.value.allPassed) {
    ElMessage.warning(transferCheck.value.invalidItems[0]?.message || '当前选中文物不符合转存条件')
    return
  }
  saving.value = true
  try {
    if (selectedRelics.value.length > 1) {
      await createTransferBatchTasksApi({
        relicIds: selectedRelics.value.map((item) => item.id),
        principalUserId: formData.principalUserId,
        targetLocationCode: formData.targetLocationCode,
        transferReason: formData.transferReason
      })
      ElMessage.success(`已派发 ${selectedRelics.value.length} 条转存任务`)
    } else if (selectedRelics.value[0]) {
      await createTransferTaskApi({
        relicId: selectedRelics.value[0].id,
        principalUserId: formData.principalUserId,
        targetLocationCode: formData.targetLocationCode,
        transferReason: formData.transferReason
      })
      ElMessage.success('转存任务已派发')
    }
    dialogVisible.value = false
    selectedRelics.value = []
    await loadPage()
    clearSelection()
  } finally {
    saving.value = false
  }
}

function handleSelectionChange(rows) {
  selectedRows.value = rows
}

function toggleMultipleMode() {
  multipleMode.value = !multipleMode.value
  if (!multipleMode.value) {
    clearSelection()
  }
}

function clearSelection() {
  selectedRows.value = []
  tableRef.value?.clearSelection()
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
    categoryCode: '',
    storageLocationCode: '',
    currentStatus: 'IN_STOCK'
  })
  clearSelection()
  loadPage()
}

function handleCurrentChange(pageNum) {
  queryForm.pageNum = pageNum
  clearSelection()
  loadPage()
}

function handleSizeChange(pageSize) {
  queryForm.pageSize = pageSize
  queryForm.pageNum = 1
  clearSelection()
  loadPage()
}

async function ensureQuickRelic(relicId) {
  if (!relicId) {
    return null
  }
  const pageRelic = pageData.value.records.find((item) => String(item.id) === String(relicId))
  if (pageRelic) {
    return normalizeRelicSelection(pageRelic)
  }
  const detail = await getRelicDetailApi(relicId).catch(() => null)
  return detail ? normalizeRelicSelection(detail) : null
}

async function handleQuickCreateFromRoute() {
  if (route.query.quickCreate !== '1' || !route.query.relicId) {
    return
  }
  if (dialogVisible.value && String(selectedRelics.value[0]?.id) === String(route.query.relicId)) {
    return
  }
  const relic = await ensureQuickRelic(route.query.relicId)
  if (!relic) {
    ElMessage.warning('未找到当前文物档案，请刷新后重试')
    return
  }
  await openTransferDialog(relic, { quickCreate: true })
}

dictStore.ensureMultipleItems(['relic_category', 'storage_location', 'preservation_status'])
watch(
  () => route.fullPath,
  () => {
    handleQuickCreateFromRoute()
  },
  { immediate: true }
)
loadPrincipalOptions()
loadPage()
</script>

<style scoped>
.transfer-metrics {
  grid-template-columns: repeat(4, minmax(0, 1fr));
}

.transfer-name-cell {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  text-align: center;
}

.transfer-name-cell__title {
  font-size: 14px;
  font-weight: 700;
}

.transfer-name-cell__meta {
  color: var(--text-second);
  font-size: 12px;
  line-height: 1.6;
}

.transfer-dialog-overview__title {
  font-size: 22px;
}

.transfer-check {
  width: 100%;
}

.selected-relic,
.selected-batch {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.selected-batch__list {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
  color: var(--text-second);
}

.table-selection-tip {
  color: var(--text-second);
  font-size: 13px;
}

@media (max-width: 960px) {
  .transfer-metrics {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 640px) {
  .transfer-metrics {
    grid-template-columns: 1fr;
  }
}
</style>
