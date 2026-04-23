<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="overview-panel overview-panel--compact">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">MHMP Outbound Ledger</div>
            <h2 class="overview-panel__title">文物出库申请</h2>
            <p class="overview-panel__desc">
              统一发起文物出库申请，登记用途、去向、经手研究员和申请时间，并在详情抽屉中追踪审批、归还和状态快照。
            </p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">累计申请 {{ pageData.total }} 条</span>
            <span class="overview-chip overview-chip--accent">当前页 {{ currentPageCount }} 条</span>
          </div>
        </div>

        <div class="metric-grid outbound-metrics">
          <article class="metric-card">
            <span class="metric-card__label">待审批</span>
            <strong class="metric-card__value">{{ pendingCount }}</strong>
            <div class="metric-card__meta">等待高级研究员或管理员完成出库审批。</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">待归还</span>
            <strong class="metric-card__value">{{ approvedCount }}</strong>
            <div class="metric-card__meta">已审批通过，后续仍需在“出库归还”页面登记归还。</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">已闭环</span>
            <strong class="metric-card__value">{{ returnedCount }}</strong>
            <div class="metric-card__meta">已完成归还登记，可作为业务追溯依据。</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页文物件数</span>
            <strong class="metric-card__value">{{ totalRelicCount }}</strong>
            <div class="metric-card__meta">按申请单合计统计本页涉及的文物数量。</div>
          </article>
        </div>
      </div>
    </section>

    <section class="page-card page-card--section">
      <PageHeader
        title="出库申请检索"
        description="按单号、用途、去向、经手人和审批状态筛选出库申请，支持直接发起新建并在抽屉中查看完整业务详情。"
      >
        <template #extra>
          <el-button
            v-if="authStore.hasPermission('inventory:outbound:submit')"
            type="primary"
            @click="openCreate"
          >
            新建文物出库
          </el-button>
        </template>
      </PageHeader>

      <div class="query-toolbar">
        <el-form :inline="true" :model="queryForm" class="query-form query-form--single-line">
          <el-form-item label="关键词" class="query-form__keyword">
            <el-input
              v-model="queryForm.keyword"
              placeholder="单号 / 用途 / 去向 / 经手人"
              clearable
              @keyup.enter="loadOrders"
            />
          </el-form-item>
          <el-form-item label="状态">
            <el-select v-model="queryForm.approveStatus" clearable placeholder="全部状态">
              <el-option
                v-for="item in statusOptions"
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
          <div class="list-section__title">出库申请记录</div>
          <div class="list-section__desc">
            当前展示 {{ currentPageCount }} 条出库申请记录，可在详情抽屉中查看审批、归还时间和文物状态快照。
          </div>
        </div>
      </div>

      <el-table :data="pageData.records" v-loading="loading" class="outbound-table">
        <template #empty>
          <el-empty class="empty-block" description="未检索到符合条件的出库申请，请调整筛选条件后重试。" />
        </template>
        <el-table-column prop="orderNo" label="出库单号" min-width="150" />
        <el-table-column prop="purpose" label="用途" min-width="180" show-overflow-tooltip />
        <el-table-column prop="destination" label="去向" min-width="180" show-overflow-tooltip />
        <el-table-column prop="handlerName" label="经手人" min-width="120" />
        <el-table-column label="申请时间" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.outboundTime) }}</template>
        </el-table-column>
        <el-table-column label="审批状态" min-width="120">
          <template #default="{ row }">
            <StatusTag :status="row.approveStatus" :label="resolveDictLabel(statusOptions, row.approveStatus) || '--'" />
          </template>
        </el-table-column>
        <el-table-column prop="detailCount" label="文物数量" width="100" />
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

    <el-dialog v-model="dialogVisible" title="文物出库" width="780px">
      <div class="detail-stack">
        <div class="overview-panel overview-panel--compact dialog-overview">
          <div class="overview-panel__top">
            <div>
              <div class="overview-panel__eyebrow">Outbound Request</div>
              <h3 class="overview-panel__title dialog-overview__title">新建文物出库申请</h3>
              <p class="overview-panel__desc">
                填写用途、去向、经手研究员和申请时间后即可提交出库申请，系统会自动校验当前文物是否满足出库条件。
              </p>
            </div>
            <div class="overview-panel__meta">
              <span class="overview-chip">审批状态默认待审批</span>
              <span class="overview-chip">经手人 {{ selectedHandler?.displayName || '待选择' }}</span>
              <span class="overview-chip overview-chip--accent">已选文物 {{ outboundSelection.totalCount }} 件</span>
            </div>
          </div>
        </div>

        <el-form ref="formRef" :model="form" :rules="rules" label-width="96px">
          <el-row :gutter="14">
            <el-col :span="12">
              <el-form-item label="用途" prop="purpose">
                <el-input v-model="form.purpose" placeholder="如：专题展览 / 学术研究" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="去向" prop="destination">
                <el-input v-model="form.destination" placeholder="请输入去向单位或地点" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="经手人" prop="handlerUserId">
                <el-select
                  v-model="form.handlerUserId"
                  filterable
                  placeholder="请选择负责经手的研究员"
                  :loading="handlerLoading"
                >
                  <el-option
                    v-for="item in handlerOptions"
                    :key="item.id"
                    :label="item.displayName"
                    :value="item.id"
                  >
                    <div class="principal-option">
                      <span class="principal-option__name">{{ item.displayName }}</span>
                      <span class="principal-option__meta">{{ item.username }}</span>
                    </div>
                  </el-option>
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="申请时间" prop="outboundTime">
                <el-date-picker v-model="form.outboundTime" type="datetime" value-format="YYYY-MM-DDTHH:mm:ss" />
              </el-form-item>
            </el-col>
            <el-col :span="24">
              <el-form-item label="文物选择" prop="relicIds">
                <el-select v-model="form.relicIds" multiple filterable placeholder="请选择在库文物">
                  <el-option
                    v-for="item in relicOptions"
                    :key="item.id"
                    :label="`${item.relicNo} / ${item.name}`"
                    :value="item.id"
                  />
                </el-select>
              </el-form-item>
            </el-col>
            <el-col v-if="outboundSelection.totalCount" :span="24">
              <div
                class="business-check"
                :class="outboundSelection.allPassed ? 'business-check--pass' : 'business-check--warn'"
              >
                <div class="business-check__header">
                  <div class="business-check__title">{{ outboundSelectionTitle }}</div>
                </div>
                <div class="business-check__summary">{{ outboundSelectionSummary }}</div>
                <ul v-if="outboundSelection.invalidItems.length" class="business-check__list">
                  <li
                    v-for="item in outboundSelection.invalidItems.slice(0, 3)"
                    :key="`${item.identity}-${item.message}`"
                    class="business-check__item"
                  >
                    {{ item.identity }}：{{ item.message }}
                  </li>
                </ul>
              </div>
            </el-col>
            <el-col :span="24">
              <el-form-item label="备注">
                <el-input v-model="form.remark" type="textarea" :rows="3" placeholder="可填写展览背景、研究需求或交接说明" />
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
      </div>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleSave">提交</el-button>
      </template>
    </el-dialog>

    <el-drawer v-model="drawerVisible" title="文物出库详情" size="56%">
      <div class="detail-stack">
        <el-alert
          v-if="detail"
          :title="resolveBusinessHint(detail.approveStatus)"
          :type="detail.approveStatus === 'PENDING' ? 'warning' : detail.approveStatus === 'APPROVED' ? 'success' : 'info'"
          :closable="false"
        />

        <div class="overview-panel overview-panel--compact drawer-overview">
          <div class="overview-panel__top">
            <div>
              <div class="overview-panel__eyebrow">Outbound Detail</div>
              <h3 class="overview-panel__title drawer-overview__title">{{ detail?.orderNo || '出库详情' }}</h3>
              <p class="overview-panel__desc">
                汇总出库用途、去向、经手人、审批状态、归还时间和文物状态快照，便于馆内审核与业务闭环追踪。
              </p>
            </div>
            <div class="overview-panel__meta">
              <span class="overview-chip">状态 {{ resolveDictLabel(statusOptions, detail?.approveStatus) || '--' }}</span>
              <span class="overview-chip overview-chip--accent">文物 {{ detailRelicCount }} 件</span>
            </div>
          </div>
        </div>

        <section class="info-section">
          <div class="info-section__header">
            <div>
              <h3 class="info-section__title">申请信息</h3>
              <p class="info-section__desc">查看出库用途、去向、申请与审批时间，以及当前业务处理结论。</p>
            </div>
          </div>

          <el-descriptions v-if="detail" :column="2" border>
            <el-descriptions-item label="出库单号">{{ detail.orderNo || '--' }}</el-descriptions-item>
            <el-descriptions-item label="审批状态">
              <StatusTag :status="detail.approveStatus" :label="resolveDictLabel(statusOptions, detail.approveStatus) || '--'" />
            </el-descriptions-item>
            <el-descriptions-item label="用途">{{ detail.purpose || '--' }}</el-descriptions-item>
            <el-descriptions-item label="去向">{{ detail.destination || '--' }}</el-descriptions-item>
            <el-descriptions-item label="经手人">{{ detail.handlerName || '--' }}</el-descriptions-item>
            <el-descriptions-item label="申请时间">{{ formatDateTime(detail.outboundTime) }}</el-descriptions-item>
            <el-descriptions-item label="审批时间">{{ formatDateTime(detail.approveTime) }}</el-descriptions-item>
            <el-descriptions-item label="归还时间">{{ formatDateTime(detail.returnTime) }}</el-descriptions-item>
            <el-descriptions-item label="审批意见" :span="2">{{ detail.approveRemark || '--' }}</el-descriptions-item>
            <el-descriptions-item label="备注" :span="2">{{ detail.remark || '--' }}</el-descriptions-item>
          </el-descriptions>
        </section>

        <section class="info-section">
          <PageHeader
            title="文物明细"
            description="查看本次出库涉及的文物编号、名称、数量和状态快照，便于审批与归还核验。"
          />
          <el-table :data="detail?.details || []" class="drawer-table">
            <template #empty>
              <el-empty class="empty-block" description="当前出库单暂无文物明细。" />
            </template>
            <el-table-column prop="relicNo" label="文物编号" min-width="130" />
            <el-table-column prop="relicName" label="文物名称" min-width="160" />
            <el-table-column prop="quantity" label="数量" width="90" />
            <el-table-column label="状态快照" min-width="120">
              <template #default="{ row }">
                <StatusTag
                  :status="row.currentStatusSnapshot"
                  :label="resolveDictLabel(relicStatusOptions, row.currentStatusSnapshot) || '--'"
                />
              </template>
            </el-table-column>
          </el-table>
        </section>
      </div>
    </el-drawer>
  </div>
</template>

<script setup>
import { computed, nextTick, reactive, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import {
  createOutboundApi,
  getOutboundDetailApi,
  getOutboundHandlerOptionsApi,
  getOutboundPageApi
} from '@/api/outbound'
import { getRelicDetailApi, getRelicPageApi } from '@/api/relic'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { useAuthStore } from '@/stores/auth'
import { useDictStore } from '@/stores/dict'
import { validateElForm } from '@/utils/form'
import { formatDateTime, resolveDictLabel } from '@/utils/format'
import {
  analyzeRelicSelection,
  checkOutboundRelicEligibility,
  pickRelicBusinessFields
} from '@/utils/relicBusinessRules'

const dictStore = useDictStore()
const authStore = useAuthStore()
const route = useRoute()

const loading = ref(false)
const saving = ref(false)
const handlerLoading = ref(false)
const dialogVisible = ref(false)
const drawerVisible = ref(false)
const formRef = ref()
const detail = ref(null)
const relicOptions = ref([])
const handlerOptions = ref([])
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
  approveStatus: ''
})

const form = reactive({
  purpose: '',
  destination: '',
  handlerUserId: null,
  outboundTime: '',
  remark: '',
  relicIds: []
})

const rules = {
  purpose: [{ required: true, message: '请输入用途', trigger: 'blur' }],
  destination: [{ required: true, message: '请输入去向', trigger: 'blur' }],
  handlerUserId: [{ required: true, message: '请选择经手人', trigger: 'change' }],
  outboundTime: [{ required: true, message: '请选择申请时间', trigger: 'change' }],
  relicIds: [{ required: true, type: 'array', message: '请选择文物', trigger: 'change' }]
}

const statusOptions = computed(() => dictStore.itemsMap.outbound_status || [])
const relicStatusOptions = computed(() => dictStore.itemsMap.relic_status || [])
const selectedRelics = computed(() =>
  form.relicIds
    .map((id) => relicOptions.value.find((item) => String(item.id) === String(id)))
    .filter(Boolean)
)
const selectedHandler = computed(() =>
  handlerOptions.value.find((item) => item.id === form.handlerUserId) || null
)
const outboundSelection = computed(() =>
  analyzeRelicSelection(selectedRelics.value, checkOutboundRelicEligibility)
)
const outboundSelectionTitle = computed(() => (
  outboundSelection.value.allPassed
    ? '出库前置校验已通过'
    : '出库前置校验未通过'
))
const outboundSelectionSummary = computed(() => {
  if (!outboundSelection.value.totalCount) {
    return ''
  }
  if (outboundSelection.value.allPassed) {
    return `已选 ${outboundSelection.value.totalCount} 件文物，均符合出库发起条件，可直接提交出库申请。`
  }
  return `已选 ${outboundSelection.value.totalCount} 件文物，其中 ${outboundSelection.value.invalidItems.length} 件不符合出库条件，请先处理状态或库位信息。`
})
const currentPageCount = computed(() => pageData.value.records.length)
const pendingCount = computed(() => pageData.value.records.filter((item) => item.approveStatus === 'PENDING').length)
const approvedCount = computed(() => pageData.value.records.filter((item) => item.approveStatus === 'APPROVED').length)
const returnedCount = computed(() => pageData.value.records.filter((item) => item.approveStatus === 'RETURNED').length)
const totalRelicCount = computed(() =>
  pageData.value.records.reduce((sum, item) => sum + Number(item.detailCount || 0), 0)
)
const detailRelicCount = computed(() => detail.value?.details?.length || 0)

function resolveBusinessHint(status) {
  if (status === 'PENDING') {
    return '当前单据处于待审批状态，审批通过后文物将进入出库流程。'
  }
  if (status === 'APPROVED') {
    return '当前单据已通过审批，文物出库后应在业务完成时登记归还。'
  }
  if (status === 'RETURNED') {
    return '当前单据已完成归还登记，本次出库业务已闭环。'
  }
  return '当前单据已被驳回，本次出库申请未进入后续流转。'
}

function getCurrentDateTime() {
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
  Object.assign(form, {
    purpose: '',
    destination: '',
    handlerUserId: null,
    outboundTime: getCurrentDateTime(),
    remark: '',
    relicIds: []
  })
}

function appendRelicOption(relic) {
  const option = pickRelicBusinessFields(relic)
  if (!relicOptions.value.some((item) => String(item.id) === String(option.id))) {
    relicOptions.value = [option, ...relicOptions.value]
  }
  return option
}

async function loadRelicOptions() {
  const page = await getRelicPageApi({
    pageNum: 1,
    pageSize: 200,
    currentStatus: 'IN_STOCK'
  })
  relicOptions.value = (page.records || [])
    .map((item) => pickRelicBusinessFields(item))
    .filter((item) => checkOutboundRelicEligibility(item).passed)
}

async function loadHandlerOptions() {
  if (handlerOptions.value.length) {
    return
  }
  handlerLoading.value = true
  try {
    handlerOptions.value = await getOutboundHandlerOptionsApi()
  } finally {
    handlerLoading.value = false
  }
}

function fillDefaultHandler() {
  if (form.handlerUserId || !handlerOptions.value.length) {
    return
  }
  const currentUserId = authStore.user?.id
  if (currentUserId && handlerOptions.value.some((item) => String(item.id) === String(currentUserId))) {
    form.handlerUserId = currentUserId
  }
}

async function ensureQuickRelicOption(relicId) {
  if (!relicId) {
    return null
  }
  const currentOption = relicOptions.value.find((item) => String(item.id) === String(relicId))
  if (currentOption) {
    return currentOption
  }
  const relicDetail = await getRelicDetailApi(relicId).catch(() => null)
  if (!relicDetail) {
    return null
  }
  return appendRelicOption(relicDetail)
}

async function openCreate(prefill = {}) {
  if (!authStore.hasPermission('inventory:outbound:submit')) {
    ElMessage.warning('当前账号没有提交文物出库申请的权限')
    return
  }
  resetForm()
  await Promise.all([loadRelicOptions(), loadHandlerOptions()])
  fillDefaultHandler()
  const quickRelic = await ensureQuickRelicOption(prefill.relicId)
  if (prefill.relicId) {
    if (!quickRelic) {
      ElMessage.warning('未找到当前文物档案，请刷新后重试')
      return
    }
    const checkResult = checkOutboundRelicEligibility(quickRelic)
    if (!checkResult.passed) {
      ElMessage.warning(checkResult.message)
      return
    }
  }
  dialogVisible.value = true
  if (prefill.relicId) {
    form.relicIds = [Number(prefill.relicId)]
    form.remark = '由文物详情页快捷发起'
  }
  await nextTick()
  formRef.value?.clearValidate()
}

async function loadOrders() {
  loading.value = true
  try {
    pageData.value = await getOutboundPageApi(queryForm)
  } finally {
    loading.value = false
  }
}

function handleSearch() {
  queryForm.pageNum = 1
  loadOrders()
}

function handleReset() {
  Object.assign(queryForm, {
    pageNum: 1,
    pageSize: 10,
    keyword: '',
    approveStatus: ''
  })
  loadOrders()
}

async function handleSave() {
  const valid = await validateElForm(formRef, '请先完善出库申请信息后再提交')
  if (!valid) {
    return
  }
  if (!outboundSelection.value.allPassed) {
    ElMessage.warning(outboundSelection.value.invalidItems[0]?.message || '当前选中文物不符合出库条件')
    return
  }
  saving.value = true
  try {
    await createOutboundApi(form)
    ElMessage.success('出库申请已提交')
    dialogVisible.value = false
    resetForm()
    await loadOrders()
  } finally {
    saving.value = false
  }
}

async function openDetail(id) {
  detail.value = await getOutboundDetailApi(id)
  drawerVisible.value = true
}

function handleCurrentChange(pageNum) {
  queryForm.pageNum = pageNum
  loadOrders()
}

function handleSizeChange(pageSize) {
  queryForm.pageSize = pageSize
  queryForm.pageNum = 1
  loadOrders()
}

async function handleQuickCreateFromRoute() {
  if (route.query.quickCreate !== '1' || !route.query.relicId) {
    return
  }
  if (dialogVisible.value && form.relicIds.includes(Number(route.query.relicId))) {
    return
  }
  await openCreate({ relicId: route.query.relicId })
}

watch(
  () => route.fullPath,
  () => {
    handleQuickCreateFromRoute()
  },
  { immediate: true }
)

resetForm()
dictStore.ensureMultipleItems(['outbound_status', 'relic_status'])
loadOrders()
</script>

<style scoped>
.outbound-metrics {
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

.dialog-overview__title,
.drawer-overview__title {
  font-size: 22px;
}

.principal-option {
  display: flex;
  justify-content: space-between;
  gap: 12px;
}

.principal-option__name {
  font-weight: 600;
}

.principal-option__meta {
  color: var(--text-second);
  font-size: 12px;
}

.table-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}

.drawer-table {
  margin-top: 18px;
}

@media (max-width: 960px) {
  .outbound-metrics {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 640px) {
  .outbound-metrics {
    grid-template-columns: 1fr;
  }
}
</style>
