<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="overview-panel overview-panel--compact">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">MHMP Repair Apply</div>
            <h2 class="overview-panel__title">修复申请</h2>
            <p class="overview-panel__desc">
              从可申请修复的馆藏文物中快速发起修复任务，系统会在提交前校验当前文物状态与保存状态是否满足修复条件。
            </p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">候选文物 {{ pageData.total }} 件</span>
            <span class="overview-chip overview-chip--accent">当前页 {{ currentPageCount }} 件</span>
          </div>
        </div>

        <div class="metric-grid pending-metrics">
          <article class="metric-card">
            <span class="metric-card__label">当前页可申请修复</span>
            <strong class="metric-card__value">{{ currentPageCount }}</strong>
            <div class="metric-card__meta">按当前检索条件筛选出的候选文物</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">涉及分类</span>
            <strong class="metric-card__value">{{ categoryCount }}</strong>
            <div class="metric-card__meta">当前页候选文物所属分类数量</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">涉及库位</span>
            <strong class="metric-card__value">{{ locationCount }}</strong>
            <div class="metric-card__meta">当前页候选文物所在库位数量</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前申请目标</span>
            <strong class="metric-card__value pending-metric-text">{{ currentRelic?.name || '--' }}</strong>
            <div class="metric-card__meta">可在表格中选择任意候选文物发起修复</div>
          </article>
        </div>
      </div>
    </section>

    <section class="page-card page-card--section">
      <PageHeader
        title="候选文物检索"
        description="按文物编号、名称、类别和库位筛选可申请修复的候选文物，支持从文物详情页快捷带入。"
      />

      <div class="query-toolbar">
        <el-form :inline="true" :model="queryForm" class="query-form query-form--single-line">
          <el-form-item label="关键字" class="query-form__keyword">
            <el-input v-model="queryForm.keyword" placeholder="文物编号 / 文物名称" clearable @keyup.enter="handleSearch" />
          </el-form-item>
          <el-form-item label="类别">
            <el-select v-model="queryForm.categoryCode" clearable placeholder="全部类别">
              <el-option
                v-for="item in categoryOptions"
                :key="item.itemValue"
                :label="item.itemLabel"
                :value="item.itemValue"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="库位">
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
          <div class="list-section__title">候选文物列表</div>
          <div class="list-section__desc">
            当前展示 {{ currentPageCount }} 件候选文物，可进入详情页或直接发起修复申请。
          </div>
        </div>
      </div>

      <el-table :data="pageData.records" v-loading="loading">
        <template #empty>
          <el-empty class="empty-block" description="未检索到符合条件的可申请修复文物，请调整筛选条件后重试。" />
        </template>
        <el-table-column prop="relicNo" label="文物编号" min-width="150" />
        <el-table-column prop="name" label="文物名称" min-width="180" />
        <el-table-column label="类别" min-width="120">
          <template #default="{ row }">{{ resolveDictLabel(categoryOptions, row.categoryCode) }}</template>
        </el-table-column>
        <el-table-column label="库位" min-width="130">
          <template #default="{ row }">{{ resolveDictLabel(locationOptions, row.storageLocationCode) }}</template>
        </el-table-column>
        <el-table-column label="当前状态" min-width="120">
          <template #default="{ row }">
            <StatusTag :status="row.currentStatus" :label="resolveDictLabel(statusOptions, row.currentStatus)" />
          </template>
        </el-table-column>
        <el-table-column label="保存状态" min-width="130">
          <template #default="{ row }">{{ resolveDictLabel(preservationOptions, row.preservationStatusCode) }}</template>
        </el-table-column>
        <el-table-column label="更新时间" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.updateTime) }}</template>
        </el-table-column>
        <el-table-column label="操作" class-name="table-action-column" width="180">
          <template #default="{ row }">
            <el-button text type="primary" @click="router.push(`/relic/detail/${row.id}`)">详情</el-button>
            <el-button
              v-if="authStore.hasPermission('repair:apply:submit')"
              text
              type="primary"
              @click="openApplyDialog(row)"
            >
              申请修复
            </el-button>
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

    <el-dialog v-model="dialogVisible" title="提交修复申请" width="680px">
      <div class="detail-stack">
        <div class="overview-panel overview-panel--compact dialog-overview">
          <div class="overview-panel__top">
            <div>
              <div class="overview-panel__eyebrow">Repair Request</div>
              <h3 class="overview-panel__title dialog-overview__title">发起修复任务</h3>
              <p class="overview-panel__desc">
                提交后将进入修复审批流程。请结合当前文物状态、保存状态和业务背景，填写明确的修复原因。
              </p>
            </div>
            <div class="overview-panel__meta">
              <span class="overview-chip">{{ currentRelic?.relicNo || '--' }}</span>
              <span class="overview-chip overview-chip--accent">{{ currentRelic?.name || '未选择文物' }}</span>
            </div>
          </div>
        </div>

        <div class="soft-note">
          <div class="soft-note__title">当前文物状态</div>
          <div class="soft-note__desc">
            当前状态：{{ currentRelicStatusLabel }}；保存状态：{{ currentRelicPreservationLabel }}；所在库位：{{ currentRelicLocationLabel }}。
          </div>
        </div>

        <el-form ref="formRef" :model="formData" :rules="rules" label-width="96px">
          <el-form-item label="文物">
            <div>{{ currentRelic?.relicNo }} / {{ currentRelic?.name }}</div>
          </el-form-item>
          <el-form-item v-if="repairCheckResult" label="业务校验">
            <div
              class="business-check repair-check"
              :class="repairCheckResult.passed ? 'business-check--pass' : 'business-check--warn'"
            >
              <div class="business-check__header">
                <div class="business-check__title">{{ repairCheckTitle }}</div>
              </div>
              <div class="business-check__summary">{{ repairCheckSummary }}</div>
            </div>
          </el-form-item>
          <el-form-item label="申请原因" prop="applyReason">
            <el-input
              v-model="formData.applyReason"
              type="textarea"
              :rows="4"
              placeholder="请填写病害情况、修复必要性和预期修复目标"
            />
          </el-form-item>
          <el-form-item label="备注">
            <el-input
              v-model="formData.remark"
              type="textarea"
              :rows="3"
              placeholder="可填写来源补充、保管建议或审批关注点"
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
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { createRepairApplyApi, getPendingRepairRelicPageApi } from '@/api/repair'
import { getRelicDetailApi } from '@/api/relic'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { useAuthStore } from '@/stores/auth'
import { useDictStore } from '@/stores/dict'
import { validateElForm } from '@/utils/form'
import { formatDateTime, resolveDictLabel } from '@/utils/format'
import {
  checkRepairRelicEligibility,
  pickRelicBusinessFields
} from '@/utils/relicBusinessRules'

const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()
const dictStore = useDictStore()

const loading = ref(false)
const saving = ref(false)
const dialogVisible = ref(false)
const formRef = ref()
const currentRelic = ref(null)
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
  storageLocationCode: ''
})

const formData = reactive({
  applyReason: '',
  remark: ''
})

const rules = {
  applyReason: [{ required: true, message: '请输入申请原因', trigger: 'blur' }]
}

const categoryOptions = computed(() => dictStore.itemsMap.relic_category || [])
const locationOptions = computed(() => dictStore.itemsMap.storage_location || [])
const preservationOptions = computed(() => dictStore.itemsMap.preservation_status || [])
const statusOptions = computed(() => dictStore.itemsMap.relic_status || [])
const repairCheckResult = computed(() => (
  currentRelic.value ? checkRepairRelicEligibility(currentRelic.value) : null
))
const repairCheckTitle = computed(() => (
  repairCheckResult.value?.passed
    ? '修复前置校验已通过'
    : '修复前置校验未通过'
))
const repairCheckSummary = computed(() => {
  if (!currentRelic.value || !repairCheckResult.value) {
    return ''
  }
  const statusLabel = resolveDictLabel(statusOptions.value, currentRelic.value.currentStatus) || '--'
  const preservationLabel = resolveDictLabel(
    preservationOptions.value,
    currentRelic.value.preservationStatusCode
  ) || '--'
  return `当前状态：${statusLabel}；保存状态：${preservationLabel}；${repairCheckResult.value.message}。`
})
const currentPageCount = computed(() => pageData.value.records.length)
const categoryCount = computed(() => new Set(pageData.value.records.map((item) => item.categoryCode).filter(Boolean)).size)
const locationCount = computed(() => new Set(pageData.value.records.map((item) => item.storageLocationCode).filter(Boolean)).size)
const currentRelicStatusLabel = computed(() =>
  resolveDictLabel(statusOptions.value, currentRelic.value?.currentStatus) || '--'
)
const currentRelicPreservationLabel = computed(() =>
  resolveDictLabel(preservationOptions.value, currentRelic.value?.preservationStatusCode) || '--'
)
const currentRelicLocationLabel = computed(() =>
  resolveDictLabel(locationOptions.value, currentRelic.value?.storageLocationCode) || '--'
)

async function loadPage() {
  loading.value = true
  try {
    pageData.value = await getPendingRepairRelicPageApi(queryForm)
  } finally {
    loading.value = false
  }
}

async function openApplyDialog(row, options = {}) {
  const relic = {
    ...row,
    ...pickRelicBusinessFields(row)
  }
  const checkResult = checkRepairRelicEligibility(relic)
  if (!checkResult.passed) {
    ElMessage.warning(checkResult.message)
    return
  }
  currentRelic.value = relic
  formData.applyReason = ''
  formData.remark = options.quickCreate ? '由文物详情快捷发起' : ''
  dialogVisible.value = true
  await nextTick()
  formRef.value?.clearValidate()
}

async function handleSubmit() {
  const valid = await validateElForm(formRef, '璇峰厛瀹屽杽淇鐢宠淇℃伅鍚庡啀鎻愪氦')
  if (!valid) {
    return
  }
  if (!repairCheckResult.value?.passed) {
    ElMessage.warning(repairCheckResult.value?.message || '当前文物不符合发起修复的条件')
    return
  }
  saving.value = true
  try {
    await createRepairApplyApi({
      relicId: currentRelic.value.id,
      applyReason: formData.applyReason,
      remark: formData.remark
    })
    ElMessage.success('修复申请已提交')
    dialogVisible.value = false
    await loadPage()
  } finally {
    saving.value = false
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
    categoryCode: '',
    storageLocationCode: ''
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

async function handleQuickCreateFromRoute() {
  if (route.query.quickCreate !== '1' || !route.query.relicId) {
    return
  }
  if (dialogVisible.value && String(currentRelic.value?.id) === String(route.query.relicId)) {
    return
  }

  const detail = await getRelicDetailApi(route.query.relicId).catch(() => null)
  if (!detail) {
    return
  }
  await openApplyDialog({
    ...detail,
    ...pickRelicBusinessFields(detail)
  }, {
    quickCreate: true
  })
}

watch(
  () => route.fullPath,
  () => {
    handleQuickCreateFromRoute()
  },
  { immediate: true }
)

dictStore.ensureMultipleItems(['relic_category', 'storage_location', 'preservation_status', 'relic_status'])
loadPage()
</script>

<style scoped>
.pending-metrics {
  grid-template-columns: repeat(4, minmax(0, 1fr));
}

.pending-metric-text {
  font-size: 20px;
  line-height: 1.35;
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

.dialog-overview__title {
  font-size: 22px;
}

.repair-check {
  width: 100%;
}

.table-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}

@media (max-width: 960px) {
  .pending-metrics {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 640px) {
  .pending-metrics {
    grid-template-columns: 1fr;
  }
}
</style>
