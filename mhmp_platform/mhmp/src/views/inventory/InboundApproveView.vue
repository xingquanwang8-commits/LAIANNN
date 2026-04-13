<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="overview-panel overview-panel--compact">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">MHMP Inbound Approval</div>
            <h2 class="overview-panel__title">入库审批</h2>
            <p class="overview-panel__desc">
              集中处理文物入库审批，核对来源、批次、经手人和入库文物明细。审批通过后，相关文物状态将由“入库待审批”转为“在库”。
            </p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">当前筛选 {{ pageData.total }} 条</span>
            <span class="overview-chip overview-chip--accent">默认聚焦待审批入库单</span>
          </div>
        </div>

        <div class="metric-grid approve-metrics">
          <article class="metric-card">
            <span class="metric-card__label">当前页待审批</span>
            <strong class="metric-card__value">{{ pendingCount }}</strong>
            <div class="metric-card__meta">可直接在列表或详情抽屉完成审批</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页已审批</span>
            <strong class="metric-card__value">{{ approvedCount }}</strong>
            <div class="metric-card__meta">审批通过后文物已正式纳入库存</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页文物件数</span>
            <strong class="metric-card__value">{{ totalRelicCount }}</strong>
            <div class="metric-card__meta">按入库单汇总统计本页涉及的文物数量</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页单据数</span>
            <strong class="metric-card__value">{{ currentPageCount }}</strong>
            <div class="metric-card__meta">便于快速评估本页审批工作量</div>
          </article>
        </div>
      </div>
    </section>

    <section class="page-card page-card--section">
      <PageHeader
        title="审批任务检索"
        description="按审批状态与关键词筛选入库单，支持在列表页或详情抽屉中直接完成审批。"
      />

      <div class="query-toolbar query-toolbar--approval">
        <el-radio-group v-model="queryForm.status" @change="handleSearch">
          <el-radio-button label="PENDING">待审批</el-radio-button>
          <el-radio-button label="APPROVED">已审批</el-radio-button>
          <el-radio-button label="">全部</el-radio-button>
        </el-radio-group>

        <el-form :inline="true" :model="queryForm" class="query-form query-form--single-line">
          <el-form-item label="关键字" class="query-form__keyword query-form__keyword--wide">
            <el-input
              v-model="queryForm.keyword"
              placeholder="入库单号 / 批次号 / 来源"
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
          <div class="list-section__title">入库审批记录</div>
          <div class="list-section__desc">
            当前展示 {{ currentPageCount }} 条入库业务记录，可先查看详情，再决定是否审批通过。
          </div>
        </div>
      </div>

      <el-table :data="pageData.records" v-loading="loading">
        <template #empty>
          <el-empty class="empty-block" description="未检索到符合条件的入库审批记录，请调整筛选条件后重试。" />
        </template>
        <el-table-column prop="orderNo" label="入库单号" min-width="150" />
        <el-table-column prop="batchNo" label="批次号" min-width="130" />
        <el-table-column prop="source" label="来源" min-width="160" show-overflow-tooltip />
        <el-table-column prop="handlerName" label="经手人" min-width="120" />
        <el-table-column label="入库时间" min-width="170">
          <template #default="{ row }">{{ formatDateTime(row.inboundTime) }}</template>
        </el-table-column>
        <el-table-column prop="totalCount" label="文物数量" width="100" />
        <el-table-column label="审批状态" width="120">
          <template #default="{ row }">
            <StatusTag :status="row.status" :label="resolveInboundStatusLabel(row.status)" />
          </template>
        </el-table-column>
        <el-table-column label="操作" class-name="table-action-column" width="220" fixed="right">
          <template #default="{ row }">
            <el-button text type="primary" @click="openDetail(row.id)">详情</el-button>
            <el-button
              v-if="row.status === 'PENDING' && authStore.hasPermission('inventory:inbound:approve')"
              text
              type="primary"
              @click="handleApprove(row.id)"
            >
              审批通过
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

    <el-drawer v-model="drawerVisible" title="入库审批详情" size="52%">
      <div class="detail-stack">
        <el-alert
          v-if="detail"
          :title="detail.status === 'PENDING' ? '当前入库单处于待审批状态，审批通过后相关文物将正式转为在库。' : '当前入库单已审批通过，可用于后续台账追溯。'"
          :type="detail.status === 'PENDING' ? 'warning' : 'success'"
          :closable="false"
        />

        <div class="overview-panel overview-panel--compact drawer-overview">
          <div class="overview-panel__top">
            <div>
              <div class="overview-panel__eyebrow">Inbound Approval Detail</div>
              <h3 class="overview-panel__title drawer-overview__title">{{ detail?.orderNo || '入库审批详情' }}</h3>
              <p class="overview-panel__desc">
                查看本次入库的来源、批次、经手人、状态和文物明细，并在当前抽屉直接完成审批。
              </p>
            </div>
            <div class="overview-panel__meta">
              <span class="overview-chip">状态 {{ resolveInboundStatusLabel(detail?.status) }}</span>
              <span class="overview-chip overview-chip--accent">文物 {{ detailRelicCount }} 件</span>
            </div>
          </div>
        </div>

        <section class="info-section">
          <div class="info-section__header">
            <div>
              <h3 class="info-section__title">单据信息</h3>
              <p class="info-section__desc">汇总入库来源、批次、经手人和审批状态，便于馆内复核。</p>
            </div>
          </div>

          <el-descriptions v-if="detail" :column="2" border>
            <el-descriptions-item label="入库单号">{{ detail.orderNo || '--' }}</el-descriptions-item>
            <el-descriptions-item label="审批状态">{{ resolveInboundStatusLabel(detail.status) }}</el-descriptions-item>
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
            description="核对本次入库涉及的文物编号、名称和数量，确认无误后再提交审批。"
          />
          <el-table :data="detail?.details || []" class="drawer-table">
            <template #empty>
              <el-empty class="empty-block" description="当前入库单暂无文物明细。" />
            </template>
            <el-table-column prop="relicNo" label="文物编号" min-width="140" />
            <el-table-column prop="relicName" label="文物名称" min-width="170" />
            <el-table-column prop="quantity" label="数量" width="90" />
            <el-table-column prop="remark" label="备注" min-width="140" />
          </el-table>
        </section>

        <div v-if="detail?.status === 'PENDING' && authStore.hasPermission('inventory:inbound:approve')" class="drawer-actions">
          <el-button type="primary" @click="handleApprove(detail.id)">审批通过</el-button>
        </div>
      </div>
    </el-drawer>
  </div>
</template>

<script setup>
import { computed, reactive, ref } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { approveInboundApi, getInboundDetailApi, getInboundPageApi } from '@/api/inbound'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { useAuthStore } from '@/stores/auth'
import { formatDateTime } from '@/utils/format'

const route = useRoute()
const authStore = useAuthStore()

const loading = ref(false)
const drawerVisible = ref(false)
const detail = ref(null)
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
  status: typeof route.query.status === 'string' ? route.query.status : 'PENDING'
})

const currentPageCount = computed(() => pageData.value.records.length)
const pendingCount = computed(() => pageData.value.records.filter((item) => item.status === 'PENDING').length)
const approvedCount = computed(() =>
  pageData.value.records.filter((item) => ['APPROVED', 'COMPLETED'].includes(item.status)).length
)
const totalRelicCount = computed(() =>
  pageData.value.records.reduce((sum, item) => sum + Number(item.totalCount || 0), 0)
)
const detailRelicCount = computed(() => detail.value?.details?.length || 0)

function resolveInboundStatusLabel(status) {
  if (status === 'PENDING') {
    return '待审批'
  }
  if (['APPROVED', 'COMPLETED'].includes(status)) {
    return '已审批'
  }
  return status || '--'
}

async function loadPage() {
  loading.value = true
  try {
    pageData.value = await getInboundPageApi(queryForm)
  } finally {
    loading.value = false
  }
}

async function openDetail(id) {
  detail.value = await getInboundDetailApi(id)
  drawerVisible.value = true
}

async function refreshCurrentDetail(id) {
  if (drawerVisible.value && detail.value?.id === id) {
    detail.value = await getInboundDetailApi(id)
  }
}

async function handleApprove(id) {
  try {
    await ElMessageBox.confirm('确认审批通过该入库单吗？通过后相关文物将正式转为在库状态。', '入库审批', {
      type: 'warning'
    })
    await approveInboundApi(id)
    ElMessage.success('入库审批已通过')
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
    status: 'PENDING'
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

.drawer-overview__title {
  font-size: 22px;
}

.drawer-table {
  margin-top: 18px;
}

.drawer-actions {
  display: flex;
  justify-content: flex-end;
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
