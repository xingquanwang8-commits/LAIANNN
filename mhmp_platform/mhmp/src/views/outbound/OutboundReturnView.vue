<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="overview-panel overview-panel--compact">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">MHMP Return Desk</div>
            <h2 class="overview-panel__title">出库归还</h2>
            <p class="overview-panel__desc">
              集中处理当前经手人负责的已审批出库单归还登记，实时查看待归还与已归还分布，
              并在详情抽屉中核对用途、去向、审批意见和文物状态快照，保证出库业务形成完整闭环。
            </p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">当前筛选 {{ pageData.total }} 条</span>
            <span class="overview-chip overview-chip--accent">默认仅展示本人负责的归还业务</span>
          </div>
        </div>

        <div class="metric-grid return-metrics">
          <article class="metric-card">
            <span class="metric-card__label">当前页待归还</span>
            <strong class="metric-card__value">{{ approvedCount }}</strong>
            <div class="metric-card__meta">已审批通过、待登记归还的出库单据。</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页已归还</span>
            <strong class="metric-card__value">{{ returnedCount }}</strong>
            <div class="metric-card__meta">已完成归还登记，可作为业务闭环留痕。</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页记录</span>
            <strong class="metric-card__value">{{ currentPageCount }}</strong>
            <div class="metric-card__meta">当前筛选条件下的归还记录总数。</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页文物数</span>
            <strong class="metric-card__value">{{ totalRelicCount }}</strong>
            <div class="metric-card__meta">按出库单合计统计当前页涉及的文物数量。</div>
          </article>
        </div>
      </div>
    </section>

    <section class="page-card page-card--section">
      <PageHeader
        title="归还任务检索"
        description="通过状态切换和关键字检索快速定位当前经手人负责的待归还或已归还出库业务记录。"
      />

      <div class="query-toolbar query-toolbar--approval">
        <el-radio-group v-model="queryForm.approveStatus" @change="handleSearch">
          <el-radio-button label="APPROVED">待归还</el-radio-button>
          <el-radio-button label="RETURNED">已归还</el-radio-button>
          <el-radio-button label="">全部</el-radio-button>
        </el-radio-group>

        <el-form :inline="true" :model="queryForm" class="query-form query-form--single-line">
          <el-form-item label="关键字" class="query-form__keyword query-form__keyword--wide">
            <el-input
              v-model="queryForm.keyword"
              placeholder="单号 / 用途 / 去向 / 经手人"
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
          <div class="list-section__title">归还记录</div>
          <div class="list-section__desc">
            当前展示 {{ currentPageCount }} 条本人经手的归还记录，可直接在列表或详情抽屉内完成归还登记。
          </div>
        </div>
      </div>

      <el-table :data="pageData.records" v-loading="loading" row-key="id">
        <template #empty>
          <el-empty class="empty-block" description="未检索到符合条件的出库归还记录，请调整筛选条件后重试。" />
        </template>
        <el-table-column prop="orderNo" label="出库单号" min-width="160" />
        <el-table-column prop="purpose" label="用途" min-width="160" show-overflow-tooltip />
        <el-table-column prop="destination" label="去向" min-width="180" show-overflow-tooltip />
        <el-table-column prop="handlerName" label="经手人" min-width="110" />
        <el-table-column label="申请时间" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.outboundTime) }}</template>
        </el-table-column>
        <el-table-column label="归还状态" min-width="120">
          <template #default="{ row }">
            <StatusTag :status="row.approveStatus" :label="resolveStatusLabel(row.approveStatus)" />
          </template>
        </el-table-column>
        <el-table-column prop="detailCount" label="文物数量" min-width="90" />
        <el-table-column label="操作" class-name="table-action-column" fixed="right" width="240">
          <template #default="{ row }">
            <el-button text type="primary" @click="handleView(row.id)">详情</el-button>
            <el-button
              v-if="row.approveStatus === 'APPROVED' && authStore.hasPermission('inventory:outbound:return')"
              text
              type="primary"
              @click="handleReturn(row.id)"
            >
              归还登记
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

    <el-drawer v-model="drawerVisible" title="出库业务详情" size="860px">
      <div v-loading="drawerLoading" class="detail-stack">
        <template v-if="detail">
          <el-alert
            :title="resolveBusinessHint(detail.approveStatus)"
            :type="resolveAlertType(detail.approveStatus)"
            :closable="false"
          />

          <div class="overview-panel overview-panel--compact drawer-overview">
            <div class="overview-panel__top">
              <div>
                <div class="overview-panel__eyebrow">Return Detail</div>
                <h3 class="overview-panel__title drawer-overview__title">{{ detail.orderNo }}</h3>
                <p class="overview-panel__desc">
                  查看本次出库的审批状态、用途、去向、归还时间与文物明细，
                  并在当前抽屉中直接完成归还登记。
                </p>
              </div>
              <div class="overview-panel__meta">
                <span class="overview-chip">状态 {{ resolveStatusLabel(detail.approveStatus) }}</span>
                <span class="overview-chip overview-chip--accent">文物 {{ detail.details?.length || 0 }} 件</span>
              </div>
            </div>
          </div>

          <section class="info-section">
            <div class="info-section__header">
              <div>
                <h3 class="info-section__title">归还信息</h3>
                <p class="info-section__desc">
                  汇总用途、去向、经手人、审批时间与归还时间，作为归还登记和业务留痕依据。
                </p>
              </div>
            </div>

            <el-descriptions :column="2" border>
              <el-descriptions-item label="出库单号">{{ detail.orderNo }}</el-descriptions-item>
              <el-descriptions-item label="归还状态">
                <StatusTag :status="detail.approveStatus" :label="resolveStatusLabel(detail.approveStatus)" />
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

            <div class="drawer-actions">
              <el-button
                v-if="detail.approveStatus === 'APPROVED' && authStore.hasPermission('inventory:outbound:return')"
                type="primary"
                @click="handleReturn(detail.id)"
              >
                登记归还
              </el-button>
            </div>
          </section>

          <section class="info-section">
            <PageHeader
              title="文物明细"
              description="查看本次出库涉及的文物清单、数量和状态快照，并可跳转文物详情继续核查业务时间线。"
            />
            <el-table :data="detail.details || []">
              <template #empty>
                <el-empty class="empty-block" description="当前出库记录暂无文物明细。" />
              </template>
              <el-table-column prop="relicNo" label="文物编号" min-width="140" />
              <el-table-column prop="relicName" label="文物名称" min-width="180" />
              <el-table-column prop="quantity" label="数量" min-width="80" />
              <el-table-column label="状态快照" min-width="120">
                <template #default="{ row }">
                  <StatusTag
                    :status="row.currentStatusSnapshot"
                    :label="resolveDictLabel(relicStatusOptions, row.currentStatusSnapshot)"
                  />
                </template>
              </el-table-column>
              <el-table-column label="操作" class-name="table-action-column" width="120">
                <template #default="{ row }">
                  <el-button text type="primary" @click="router.push(`/relic/detail/${row.relicId}`)">文物详情</el-button>
                </template>
              </el-table-column>
            </el-table>
          </section>
        </template>
      </div>
    </el-drawer>
  </div>
</template>

<script setup>
import { computed, reactive, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  getOutboundDetailApi,
  getOutboundPageApi,
  returnOutboundApi
} from '@/api/outbound'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { useAuthStore } from '@/stores/auth'
import { useDictStore } from '@/stores/dict'
import { formatDateTime, resolveDictLabel } from '@/utils/format'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()
const dictStore = useDictStore()

const loading = ref(false)
const drawerLoading = ref(false)
const drawerVisible = ref(false)
const detail = ref(null)
const pageData = ref({
  total: 0,
  records: []
})

const statusLabelMap = {
  APPROVED: '待归还',
  RETURNED: '已归还',
  PENDING: '待审批',
  REJECTED: '已驳回'
}

function normalizeApproveStatus(value) {
  if (value === 'RETURNED' || value === '') {
    return value
  }
  return 'APPROVED'
}

const queryForm = reactive({
  pageNum: 1,
  pageSize: 10,
  keyword: '',
  approveStatus: normalizeApproveStatus(typeof route.query.approveStatus === 'string' ? route.query.approveStatus : 'APPROVED'),
  onlyCurrentHandler: true
})

const statusOptions = computed(() => dictStore.itemsMap.outbound_status || [])
const relicStatusOptions = computed(() => dictStore.itemsMap.relic_status || [])

const currentPageCount = computed(() => pageData.value.records.length)
const approvedCount = computed(() => pageData.value.records.filter((item) => item.approveStatus === 'APPROVED').length)
const returnedCount = computed(() => pageData.value.records.filter((item) => item.approveStatus === 'RETURNED').length)
const totalRelicCount = computed(() =>
  pageData.value.records.reduce((sum, item) => sum + Number(item.detailCount || 0), 0)
)

async function loadData() {
  loading.value = true
  try {
    pageData.value = await getOutboundPageApi(queryForm)
  } finally {
    loading.value = false
  }
}

async function handleView(id) {
  drawerVisible.value = true
  drawerLoading.value = true
  try {
    detail.value = await getOutboundDetailApi(id)
  } finally {
    drawerLoading.value = false
  }
}

function handleSearch() {
  queryForm.pageNum = 1
  loadData()
}

function handleReset() {
  Object.assign(queryForm, {
    pageNum: 1,
    pageSize: 10,
    keyword: '',
    approveStatus: 'APPROVED',
    onlyCurrentHandler: true
  })
  loadData()
}

function handleCurrentChange(pageNum) {
  queryForm.pageNum = pageNum
  loadData()
}

function handleSizeChange(pageSize) {
  queryForm.pageSize = pageSize
  queryForm.pageNum = 1
  loadData()
}

function resolveStatusLabel(status) {
  const dictLabel = resolveDictLabel(statusOptions.value, status)
  if (dictLabel && dictLabel !== status) {
    return dictLabel
  }
  return statusLabelMap[status] || status || '--'
}

function resolveAlertType(status) {
  if (status === 'APPROVED') {
    return 'warning'
  }
  if (status === 'RETURNED') {
    return 'success'
  }
  if (status === 'PENDING') {
    return 'info'
  }
  return 'error'
}

function resolveBusinessHint(status) {
  if (status === 'APPROVED') {
    return '当前单据已审批通过，归还完成后请及时登记，系统将同步关闭本次出库业务。'
  }
  if (status === 'RETURNED') {
    return '当前单据已完成归还登记，本次出库业务已闭环。'
  }
  if (status === 'PENDING') {
    return '当前单据尚未完成审批，请先到“出库审批”页面完成审批。'
  }
  return '当前单据已被驳回，无需进入归还登记流程。'
}

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

async function refreshAfterAction(id) {
  await loadData()
  if (drawerVisible.value && detail.value?.id === id) {
    detail.value = await getOutboundDetailApi(id)
  }
}

async function handleReturn(id) {
  try {
    await ElMessageBox.confirm('确认登记该出库单已归还吗？', '归还登记', {
      confirmButtonText: '确认归还',
      cancelButtonText: '取消',
      type: 'warning'
    })
    await returnOutboundApi(id, {
      returnTime: currentDateTime(),
      remark: '出库归还页登记归还'
    })
    ElMessage.success('已完成归还登记')
    await refreshAfterAction(id)
  } catch (error) {
    if (error !== 'cancel' && error !== 'close') {
      throw error
    }
  }
}

watch(
  () => route.query.approveStatus,
  (status) => {
    const nextStatus = normalizeApproveStatus(typeof status === 'string' ? status : 'APPROVED')
    if (queryForm.approveStatus === nextStatus) {
      return
    }
    queryForm.approveStatus = nextStatus
    queryForm.pageNum = 1
    loadData()
  }
)

dictStore.ensureMultipleItems(['outbound_status', 'relic_status'])
loadData()
</script>

<style scoped>
.return-metrics {
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

.drawer-overview__title {
  font-size: 22px;
}

.table-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}

.drawer-actions {
  display: flex;
  gap: 12px;
  margin-top: 18px;
  flex-wrap: wrap;
}

@media (max-width: 960px) {
  .return-metrics {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 640px) {
  .return-metrics {
    grid-template-columns: 1fr;
  }
}
</style>
