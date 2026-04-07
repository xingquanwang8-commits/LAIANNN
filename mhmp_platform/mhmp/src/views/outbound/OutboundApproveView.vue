<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="query-toolbar">
        <el-radio-group v-model="queryForm.approveStatus" @change="handleSearch">
          <el-radio-button label="PENDING">待审批</el-radio-button>
          <el-radio-button label="APPROVED">待归还</el-radio-button>
          <el-radio-button label="RETURNED">已归还</el-radio-button>
          <el-radio-button label="REJECTED">已驳回</el-radio-button>
          <el-radio-button label="">全部</el-radio-button>
        </el-radio-group>

        <el-form :inline="true" :model="queryForm" class="query-form query-form--single-line">
          <el-form-item label="关键字" class="query-form__keyword">
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
      <div class="summary-grid">
        <article class="summary-card">
          <span class="summary-card__label">当前页待审批</span>
          <strong class="summary-card__value">{{ pendingCount }}</strong>
        </article>
        <article class="summary-card">
          <span class="summary-card__label">当前页待归还</span>
          <strong class="summary-card__value">{{ approvedCount }}</strong>
        </article>
        <article class="summary-card">
          <span class="summary-card__label">当前页已闭环</span>
          <strong class="summary-card__value">{{ returnedCount }}</strong>
        </article>
      </div>

      <el-table :data="pageData.records" v-loading="loading" row-key="id">
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
        <el-table-column label="操作" fixed="right" width="280">
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

    <el-drawer v-model="drawerVisible" title="出库业务详情" size="820px">
      <div v-loading="drawerLoading">
        <template v-if="detail">
          <el-alert
            :title="resolveBusinessHint(detail.approveStatus)"
            :type="detail.approveStatus === 'PENDING' ? 'warning' : detail.approveStatus === 'APPROVED' ? 'success' : 'info'"
            :closable="false"
            class="drawer-alert"
          />

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

          <div class="outbound-drawer__table">
            <PageHeader title="文物明细" description="查看本次出库涉及的文物清单，并可直接跳转到文物详情查看业务时间线。" />
            <el-table :data="detail.details || []">
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
              <el-table-column label="操作" width="120">
                <template #default="{ row }">
                  <el-button text type="primary" @click="router.push(`/relic/detail/${row.relicId}`)">文物详情</el-button>
                </template>
              </el-table-column>
            </el-table>
          </div>
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

const pendingCount = computed(() => pageData.value.records.filter((item) => item.approveStatus === 'PENDING').length)
const approvedCount = computed(() => pageData.value.records.filter((item) => item.approveStatus === 'APPROVED').length)
const returnedCount = computed(() => pageData.value.records.filter((item) => item.approveStatus === 'RETURNED').length)

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
  return '当前单据已驳回，本次出库申请未进入后续流转。'
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
.summary-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 14px;
  margin-bottom: 18px;
}

.summary-card {
  padding: 16px 18px;
  border: 1px solid var(--border-line);
  border-radius: 16px;
  background: linear-gradient(180deg, #ffffff, #f7f8fb);
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

.drawer-alert {
  margin-bottom: 18px;
}

.drawer-actions {
  display: flex;
  gap: 12px;
  margin-top: 18px;
}

.outbound-drawer__table {
  margin-top: 20px;
}

@media (max-width: 900px) {
  .summary-grid {
    grid-template-columns: 1fr;
  }
}
</style>
