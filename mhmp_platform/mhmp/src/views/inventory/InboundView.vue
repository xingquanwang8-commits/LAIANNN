<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="overview-panel overview-panel--compact">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">MHMP Inbound Ledger</div>
            <h2 class="overview-panel__title">文物入库台账</h2>
            <p class="overview-panel__desc">
              统一登记文物入库批次、来源、经手人和入库时间，形成可追踪的入库业务记录，并与文物档案联动。
            </p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">累计入库单 {{ pageData.total }} 条</span>
            <span class="overview-chip overview-chip--accent">当前页 {{ currentPageCount }} 条</span>
          </div>
        </div>

        <div class="metric-grid inbound-metrics">
          <article class="metric-card">
            <span class="metric-card__label">当前页已完成</span>
            <strong class="metric-card__value">{{ completedCount }}</strong>
            <div class="metric-card__meta">已完成的入库单可作为后续业务追溯依据</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页涉及文物</span>
            <strong class="metric-card__value">{{ totalRelicCount }}</strong>
            <div class="metric-card__meta">按入库单合计统计本页入库文物数量</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">来源类型数</span>
            <strong class="metric-card__value">{{ sourceCount }}</strong>
            <div class="metric-card__meta">便于快速识别本页入库来源分布</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">快速入库准备</span>
            <strong class="metric-card__value">{{ inboundSelection.totalCount }}</strong>
            <div class="metric-card__meta">弹窗中已选文物会同步显示前置校验结果</div>
          </article>
        </div>
      </div>
    </section>

    <section class="page-card page-card--section">
      <PageHeader
        title="入库业务检索"
        description="按单号、批次、来源和状态筛选入库记录，支持直接发起新建入库并在抽屉中查看完整明细。"
      >
        <template #extra>
          <el-button
            v-if="authStore.hasPermission('inventory:inbound:add')"
            type="primary"
            @click="openCreate"
          >
            新建文物入库
          </el-button>
        </template>
      </PageHeader>

      <div class="query-toolbar">
        <el-form :inline="true" :model="queryForm" class="query-form query-form--single-line">
          <el-form-item label="关键字" class="query-form__keyword">
            <el-input v-model="queryForm.keyword" placeholder="单号 / 批次 / 来源" clearable @keyup.enter="handleSearch" />
          </el-form-item>
          <el-form-item label="状态">
            <el-select v-model="queryForm.status" clearable placeholder="全部状态">
              <el-option label="已完成" value="COMPLETED" />
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
          <div class="list-section__title">入库记录</div>
          <div class="list-section__desc">当前展示 {{ currentPageCount }} 条入库业务记录，可进入抽屉查看来源、经手人和文物明细。</div>
        </div>
      </div>

      <el-table :data="pageData.records" v-loading="loading" class="inbound-table">
        <template #empty>
          <el-empty class="empty-block" description="未检索到符合条件的入库记录，请调整筛选条件后重试。" />
        </template>
        <el-table-column prop="orderNo" label="入库单号" min-width="150" />
        <el-table-column prop="batchNo" label="批次号" min-width="130" />
        <el-table-column prop="source" label="来源" min-width="150" show-overflow-tooltip />
        <el-table-column prop="handlerName" label="经手人" min-width="120" />
        <el-table-column prop="totalCount" label="数量" width="90" />
        <el-table-column label="入库时间" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.inboundTime) }}</template>
        </el-table-column>
        <el-table-column label="状态" width="120">
          <template #default="{ row }">
            <StatusTag :status="row.status" :label="resolveInboundStatusLabel(row.status)" />
          </template>
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

    <el-dialog v-model="dialogVisible" title="文物入库" width="720px">
      <div class="detail-stack">
        <div class="overview-panel overview-panel--compact dialog-overview">
          <div class="overview-panel__top">
            <div>
              <div class="overview-panel__eyebrow">Inbound Request</div>
              <h3 class="overview-panel__title dialog-overview__title">新建文物入库单</h3>
              <p class="overview-panel__desc">
                录入来源、经手人、入库时间和涉及文物后即可提交入库单，系统会在提交前自动校验当前文物是否满足入库条件。
              </p>
            </div>
            <div class="overview-panel__meta">
              <span class="overview-chip">入库批次保存后生成</span>
              <span class="overview-chip overview-chip--accent">已选文物 {{ inboundSelection.totalCount }} 件</span>
            </div>
          </div>
        </div>

        <el-form ref="formRef" :model="formData" :rules="rules" label-width="96px">
          <el-row :gutter="14">
            <el-col :span="12">
              <el-form-item label="入库批次">
                <el-input model-value="保存后自动生成" disabled />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="来源" prop="source">
                <el-input v-model="formData.source" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="经手人" prop="handlerName">
                <el-input v-model="formData.handlerName" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="入库时间" prop="inboundTime">
                <el-date-picker
                  v-model="formData.inboundTime"
                  type="datetime"
                  value-format="YYYY-MM-DDTHH:mm:ss"
                  placeholder="请选择时间"
                />
              </el-form-item>
            </el-col>
            <el-col :span="24">
              <el-form-item label="入库文物" prop="relicIds">
                <el-select v-model="formData.relicIds" multiple filterable placeholder="请选择文物">
                  <el-option
                    v-for="item in relicOptions"
                    :key="item.id"
                    :label="`${item.relicNo} / ${item.name}`"
                    :value="item.id"
                  />
                </el-select>
              </el-form-item>
            </el-col>
            <el-col v-if="inboundSelection.totalCount" :span="24">
              <div
                class="business-check"
                :class="inboundSelection.allPassed ? 'business-check--pass' : 'business-check--warn'"
              >
                <div class="business-check__header">
                  <div class="business-check__title">{{ inboundSelectionTitle }}</div>
                </div>
                <div class="business-check__summary">{{ inboundSelectionSummary }}</div>
                <ul v-if="inboundSelection.invalidItems.length" class="business-check__list">
                  <li
                    v-for="item in inboundSelection.invalidItems.slice(0, 3)"
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
                <el-input v-model="formData.remark" type="textarea" :rows="3" placeholder="可记录来源说明、入库背景或交接备注" />
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

    <el-drawer v-model="drawerVisible" title="文物入库详情" size="52%">
      <div class="detail-stack">
        <div class="overview-panel overview-panel--compact drawer-overview">
          <div class="overview-panel__top">
            <div>
              <div class="overview-panel__eyebrow">Inbound Detail</div>
              <h3 class="overview-panel__title drawer-overview__title">{{ detail.orderNo || '入库详情' }}</h3>
              <p class="overview-panel__desc">
                查看本次入库的批次、来源、经手人、时间和明细文物，便于对接档案登记与后续业务追踪。
              </p>
            </div>
            <div class="overview-panel__meta">
              <span class="overview-chip">批次 {{ detail.batchNo || '--' }}</span>
              <span class="overview-chip overview-chip--accent">文物 {{ detailRelicCount }} 件</span>
            </div>
          </div>
        </div>

        <section class="info-section">
          <div class="info-section__header">
            <div>
              <h3 class="info-section__title">单据信息</h3>
              <p class="info-section__desc">汇总入库单号、批次、来源和经手人等关键字段，作为馆内入库登记依据。</p>
            </div>
          </div>

          <el-descriptions :column="2" border>
            <el-descriptions-item label="入库单号">{{ detail.orderNo || '--' }}</el-descriptions-item>
            <el-descriptions-item label="状态">{{ resolveInboundStatusLabel(detail.status) }}</el-descriptions-item>
            <el-descriptions-item label="批次号">{{ detail.batchNo || '--' }}</el-descriptions-item>
            <el-descriptions-item label="来源">{{ detail.source || '--' }}</el-descriptions-item>
            <el-descriptions-item label="经手人">{{ detail.handlerName || '--' }}</el-descriptions-item>
            <el-descriptions-item label="入库时间">{{ formatDateTime(detail.inboundTime) }}</el-descriptions-item>
            <el-descriptions-item label="备注" :span="2">{{ detail.remark || '--' }}</el-descriptions-item>
          </el-descriptions>
        </section>

        <section class="info-section">
          <PageHeader
            title="入库文物明细"
            description="展示本次入库单中涉及的文物编号、名称、数量和备注，用于入库交接和后续业务核验。"
          />
          <el-table :data="detail.details || []" class="drawer-table">
            <template #empty>
              <el-empty class="empty-block" description="当前入库单暂无文物明细。" />
            </template>
            <el-table-column prop="relicNo" label="文物编号" min-width="140" />
            <el-table-column prop="relicName" label="文物名称" min-width="160" />
            <el-table-column prop="quantity" label="数量" width="90" />
            <el-table-column prop="remark" label="备注" min-width="140" />
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
import { createInboundApi, getInboundDetailApi, getInboundPageApi } from '@/api/inbound'
import { getRelicDetailApi, getRelicPageApi } from '@/api/relic'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { useAuthStore } from '@/stores/auth'
import { formatDateTime } from '@/utils/format'
import {
  analyzeRelicSelection,
  checkInboundRelicEligibility,
  pickRelicBusinessFields
} from '@/utils/relicBusinessRules'

const authStore = useAuthStore()
const route = useRoute()

const loading = ref(false)
const saving = ref(false)
const dialogVisible = ref(false)
const drawerVisible = ref(false)
const formRef = ref()
const relicOptions = ref([])
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
  status: ''
})

const formData = reactive({
  source: '',
  handlerName: '',
  inboundTime: '',
  remark: '',
  relicIds: []
})

const rules = {
  source: [{ required: true, message: '请输入来源', trigger: 'blur' }],
  handlerName: [{ required: true, message: '请输入经手人', trigger: 'blur' }],
  inboundTime: [{ required: true, message: '请选择入库时间', trigger: 'change' }],
  relicIds: [{ required: true, type: 'array', message: '请选择文物', trigger: 'change' }]
}

const selectedRelics = computed(() =>
  formData.relicIds
    .map((id) => relicOptions.value.find((item) => String(item.id) === String(id)))
    .filter(Boolean)
)

const inboundSelection = computed(() =>
  analyzeRelicSelection(selectedRelics.value, checkInboundRelicEligibility)
)

const inboundSelectionTitle = computed(() => (
  inboundSelection.value.allPassed
    ? '入库前置校验已通过'
    : '入库前置校验未通过'
))

const inboundSelectionSummary = computed(() => {
  if (!inboundSelection.value.totalCount) {
    return ''
  }
  if (inboundSelection.value.allPassed) {
    return `已选 ${inboundSelection.value.totalCount} 件文物，均符合入库发起条件，可直接提交入库申请。`
  }
  return `已选 ${inboundSelection.value.totalCount} 件文物，其中 ${inboundSelection.value.invalidItems.length} 件不符合入库条件，请先处理状态再提交。`
})

const currentPageCount = computed(() => pageData.value.records.length)
const completedCount = computed(() => pageData.value.records.filter((item) => item.status === 'COMPLETED').length)
const totalRelicCount = computed(() =>
  pageData.value.records.reduce((sum, item) => sum + Number(item.totalCount || 0), 0)
)
const sourceCount = computed(() => new Set(pageData.value.records.map((item) => item.source).filter(Boolean)).size)
const detailRelicCount = computed(() => detail.value?.details?.length || 0)

function resolveInboundStatusLabel(status) {
  if (status === 'COMPLETED') {
    return '已完成'
  }
  return status || '--'
}

function resetForm() {
  Object.assign(formData, {
    source: '',
    handlerName: '',
    inboundTime: '',
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
    pageSize: 200
  })
  relicOptions.value = (page.records || [])
    .map((item) => pickRelicBusinessFields(item))
    .filter((item) => checkInboundRelicEligibility(item).passed)
}

async function loadOrders() {
  loading.value = true
  try {
    pageData.value = await getInboundPageApi(queryForm)
  } finally {
    loading.value = false
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
  resetForm()
  await loadRelicOptions()
  const quickRelic = await ensureQuickRelicOption(prefill.relicId)
  if (prefill.relicId) {
    if (!quickRelic) {
      ElMessage.warning('未找到当前文物档案，请刷新后重试')
      return
    }
    const checkResult = checkInboundRelicEligibility(quickRelic)
    if (!checkResult.passed) {
      ElMessage.warning(checkResult.message)
      return
    }
  }
  dialogVisible.value = true
  if (prefill.relicId) {
    formData.relicIds = [Number(prefill.relicId)]
    formData.remark = '由文物详情快捷发起'
  }
  await nextTick()
  formRef.value?.clearValidate()
}

async function handleSave() {
  await formRef.value.validate()
  if (!inboundSelection.value.allPassed) {
    ElMessage.warning(inboundSelection.value.invalidItems[0]?.message || '当前选中文物不符合入库条件')
    return
  }
  saving.value = true
  try {
    await createInboundApi(formData)
    ElMessage.success('入库单已创建')
    dialogVisible.value = false
    await loadOrders()
  } finally {
    saving.value = false
  }
}

async function openDetail(id) {
  detail.value = await getInboundDetailApi(id)
  drawerVisible.value = true
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
    status: ''
  })
  loadOrders()
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
  if (dialogVisible.value && formData.relicIds.includes(Number(route.query.relicId))) {
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

loadOrders()
</script>

<style scoped>
.inbound-metrics {
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

.table-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}

.drawer-table {
  margin-top: 18px;
}

@media (max-width: 960px) {
  .inbound-metrics {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 640px) {
  .inbound-metrics {
    grid-template-columns: 1fr;
  }
}
</style>
