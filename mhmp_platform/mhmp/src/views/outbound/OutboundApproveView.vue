<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="overview-panel overview-panel--compact">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">MHMP Approval Desk</div>
            <h2 class="overview-panel__title">文物出库审批</h2>
            <p class="overview-panel__desc">
              集中处理出库审批、驳回和归还登记，实时查看当前页审批分布，并在抽屉中核对完整业务明细和文物状态快照。
            </p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">当前筛选 {{ pageData.total }} 条</span>
            <span class="overview-chip overview-chip--accent">默认聚焦待审批业务</span>
          </div>
        </div>

        <div class="metric-grid approve-metrics">
          <article class="metric-card">
            <span class="metric-card__label">当前页待审批</span>
            <strong class="metric-card__value">{{ pendingCount }}</strong>
            <div class="metric-card__meta">优先处理尚未形成审批结论的出库申请</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页待归还</span>
            <strong class="metric-card__value">{{ approvedCount }}</strong>
            <div class="metric-card__meta">业务完成后需要登记归还，形成闭环</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页已闭环</span>
            <strong class="metric-card__value">{{ returnedCount }}</strong>
            <div class="metric-card__meta">已完成归还登记，可作为审批留痕记录</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页驳回</span>
            <strong class="metric-card__value">{{ rejectedCount }}</strong>
            <div class="metric-card__meta">便于核查驳回原因和重新发起情况</div>
          </article>
        </div>
      </div>
    </section>

    <section class="page-card page-card--section">
      <PageHeader
        title="审批任务检索"
        description="通过状态切换和关键词检索快速锁定待审批、待归还或已闭环的出库业务记录。"
      />

      <div class="query-toolbar query-toolbar--approval">
        <el-radio-group v-model="queryForm.approveStatus" @change="handleSearch">
          <el-radio-button label="PENDING">待审批</el-radio-button>
          <el-radio-button label="APPROVED">待归还</el-radio-button>
          <el-radio-button label="RETURNED">已归还</el-radio-button>
          <el-radio-button label="REJECTED">已驳回</el-radio-button>
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
          <div class="list-section__title">审批记录</div>
          <div class="list-section__desc">
            当前展示 {{ currentPageCount }} 条审批记录，可直接在列表或详情抽屉内完成审批通过、驳回和归还登记。
          </div>
        </div>
      </div>

      <el-table :data="pageData.records" v-loading="loading" row-key="id">
        <template #empty>
          <el-empty class="empty-block" description="未检索到符合条件的出库审批记录，请调整筛选条件后重试。" />
        </template>
        <el-table-column prop="orderNo" label="出库单号" min-width="160" />
        <el-table-column prop="purpose" label="用途" min-width="160" show-overflow-tooltip />
        <el-table-column prop="destination" label="去向" min-width="180" show-overflow-tooltip />
        <el-table-column prop="handlerName" label="经手人" min-width="110" />
        <el-table-column label="申请时间" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.outboundTime) }}</template>
        </el-table-column>
        <el-table-column label="审批状态" min-width="120">
          <template #default="{ row }">
            <StatusTag :status="row.approveStatus" :label="resolveStatusLabel(row.approveStatus)" />
          </template>
        </el-table-column>
        <el-table-column prop="detailCount" label="文物数量" min-width="90" />
        <el-table-column label="操作" class-name="table-action-column" fixed="right" width="320">
          <template #default="{ row }">
            <el-button text type="primary" @click="handleView(row.id)">详情</el-button>
            <el-button
              v-if="row.approveStatus === 'PENDING' && authStore.hasPermission('inventory:outbound:approve')"
              text
              type="primary"
              @click="handleApprove(row.id)"
            >
              通过
            </el-button>
            <el-button
              v-if="row.approveStatus === 'PENDING' && authStore.hasPermission('inventory:outbound:reject')"
              text
              type="danger"
              @click="handleReject(row.id)"
            >
              驳回
            </el-button>
            <el-button
              v-if="row.approveStatus === 'APPROVED' && authStore.hasPermission('inventory:outbound:approve')"
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
            :type="detail.approveStatus === 'PENDING' ? 'warning' : detail.approveStatus === 'APPROVED' ? 'success' : 'info'"
            :closable="false"
          />

          <div class="overview-panel overview-panel--compact drawer-overview">
            <div class="overview-panel__top">
              <div>
                <div class="overview-panel__eyebrow">Approval Detail</div>
                <h3 class="overview-panel__title drawer-overview__title">{{ detail.orderNo }}</h3>
                <p class="overview-panel__desc">
                  查看本次出库的审批状态、用途、去向、审批意见与文物明细，并在当前抽屉直接完成关键审批动作。
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
                <h3 class="info-section__title">审批信息</h3>
                <p class="info-section__desc">汇总用途、去向、经手人、申请时间、审批时间和归还时间，作为审批决策和业务留痕依据。</p>
              </div>
            </div>

            <el-descriptions :column="2" border>
              <el-descriptions-item label="出库单号">{{ detail.orderNo }}</el-descriptions-item>
              <el-descriptions-item label="审批状态">
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
                v-if="detail.approveStatus === 'PENDING' && authStore.hasPermission('inventory:outbound:approve')"
                type="primary"
                @click="handleApprove(detail.id)"
              >
                审批通过
              </el-button>
              <el-button
                v-if="detail.approveStatus === 'PENDING' && authStore.hasPermission('inventory:outbound:reject')"
                type="danger"
                plain
                @click="handleReject(detail.id)"
              >
                驳回申请
              </el-button>
              <el-button
                v-if="detail.approveStatus === 'APPROVED' && authStore.hasPermission('inventory:outbound:approve')"
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
import { computed, reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  approveOutboundApi,
  getOutboundDetailApi,
  getOutboundPageApi,
  rejectOutboundApi,
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

const queryForm = reactive({
  pageNum: 1,
  pageSize: 10,
  keyword: '',
  approveStatus: typeof route.query.approveStatus === 'string' ? route.query.approveStatus : 'PENDING'
})

const statusOptions = computed(() => dictStore.itemsMap.outbound_status || [])
const relicStatusOptions = computed(() => dictStore.itemsMap.relic_status || [])

const statusLabelMap = {
  PENDING: '待审批',
  APPROVED: '待归还',
  RETURNED: '已归还',
  REJECTED: '已驳回'
}

const currentPageCount = computed(() => pageData.value.records.length)
const pendingCount = computed(() => pageData.value.records.filter((item) => item.approveStatus === 'PENDING').length)
const approvedCount = computed(() => pageData.value.records.filter((item) => item.approveStatus === 'APPROVED').length)
const returnedCount = computed(() => pageData.value.records.filter((item) => item.approveStatus === 'RETURNED').length)
const rejectedCount = computed(() => pageData.value.records.filter((item) => item.approveStatus === 'REJECTED').length)

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
    approveStatus: 'PENDING'
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

async function handleApprove(id) {
  try {
    const { value } = await ElMessageBox.prompt('可填写审批意见，留空则直接通过。', '审批通过', {
      confirmButtonText: '确认通过',
      cancelButtonText: '取消',
      inputPlaceholder: '请输入审批意见'
    })
    await approveOutboundApi(id, { approveRemark: value })
    ElMessage.success('出库申请已审批通过')
    await refreshAfterAction(id)
  } catch (error) {
    if (error !== 'cancel' && error !== 'close') {
      throw error
    }
  }
}

async function handleReject(id) {
  try {
    const { value } = await ElMessageBox.prompt('请输入驳回原因。', '驳回申请', {
      confirmButtonText: '确认驳回',
      cancelButtonText: '取消',
      inputPlaceholder: '请输入驳回原因',
      inputPattern: /.+/,
      inputErrorMessage: '驳回原因不能为空'
    })
    await rejectOutboundApi(id, { approveRemark: value })
    ElMessage.success('出库申请已驳回')
    await refreshAfterAction(id)
  } catch (error) {
    if (error !== 'cancel' && error !== 'close') {
      throw error
    }
  }
}

async function handleReturn(id) {
  try {
    await ElMessageBox.confirm('确认登记该出库单已归还吗？', '归还登记', {
      type: 'warning'
    })
    await returnOutboundApi(id, {
      returnTime: currentDateTime(),
      remark: '出库审批页登记归还'
    })
    ElMessage.success('已完成归还登记')
    await refreshAfterAction(id)
  } catch (error) {
    if (error !== 'cancel' && error !== 'close') {
      throw error
    }
  }
}

dictStore.ensureMultipleItems(['outbound_status', 'relic_status'])
loadData()
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
