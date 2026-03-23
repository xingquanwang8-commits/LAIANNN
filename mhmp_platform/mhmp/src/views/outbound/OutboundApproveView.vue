<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <PageHeader
        title="出库审批"
        description="集中查看出库申请记录，支持查看明细、审批通过与驳回。"
      />
    </section>

    <section class="page-card page-card--section">
      <el-form :inline="true" :model="queryForm" class="outbound-filter">
        <el-form-item label="关键词">
          <el-input
            v-model="queryForm.keyword"
            placeholder="单号 / 用途 / 去向"
            clearable
            @keyup.enter="handleSearch"
          />
        </el-form-item>
        <el-form-item label="审批状态">
          <el-select v-model="queryForm.approveStatus" placeholder="全部状态" clearable>
            <el-option
              v-for="item in statusOptions"
              :key="item.itemValue"
              :label="item.itemLabel"
              :value="item.itemValue"
            />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>

      <el-table :data="pageData.records" v-loading="loading" row-key="id">
        <el-table-column prop="orderNo" label="出库单号" min-width="160" />
        <el-table-column prop="purpose" label="用途" min-width="180" />
        <el-table-column prop="destination" label="去向" min-width="180" />
        <el-table-column prop="handlerName" label="经手人" min-width="120" />
        <el-table-column label="申请时间" min-width="150">
          <template #default="{ row }">
            {{ formatDateTime(row.outboundTime) }}
          </template>
        </el-table-column>
        <el-table-column label="审批状态" min-width="120">
          <template #default="{ row }">
            <StatusTag
              :status="row.approveStatus"
              :label="resolveDictLabel(statusOptions, row.approveStatus)"
            />
          </template>
        </el-table-column>
        <el-table-column prop="detailCount" label="文物数量" min-width="90" />
        <el-table-column label="操作" fixed="right" width="240">
          <template #default="{ row }">
            <el-button text type="primary" @click="handleView(row)">查看</el-button>
            <el-button
              v-if="row.approveStatus === 'PENDING' && authStore.hasPermission('inventory:outbound:approve')"
              text
              @click="handleApprove(row)"
            >
              通过
            </el-button>
            <el-button
              v-if="row.approveStatus === 'PENDING' && authStore.hasPermission('inventory:outbound:reject')"
              text
              style="color: var(--danger)"
              @click="handleReject(row)"
            >
              驳回
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="relic-pagination">
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

    <el-drawer v-model="drawerVisible" title="出库单详情" size="780px">
      <div v-loading="drawerLoading">
        <template v-if="detail">
          <el-descriptions :column="2" border>
            <el-descriptions-item label="出库单号">{{ detail.orderNo }}</el-descriptions-item>
            <el-descriptions-item label="审批状态">
              <StatusTag
                :status="detail.approveStatus"
                :label="resolveDictLabel(statusOptions, detail.approveStatus)"
              />
            </el-descriptions-item>
            <el-descriptions-item label="用途">{{ detail.purpose }}</el-descriptions-item>
            <el-descriptions-item label="去向">{{ detail.destination }}</el-descriptions-item>
            <el-descriptions-item label="经手人">{{ detail.handlerName }}</el-descriptions-item>
            <el-descriptions-item label="申请时间">{{ formatDateTime(detail.outboundTime) }}</el-descriptions-item>
            <el-descriptions-item label="审批时间">{{ formatDateTime(detail.approveTime) }}</el-descriptions-item>
            <el-descriptions-item label="归还时间">{{ formatDateTime(detail.returnTime) }}</el-descriptions-item>
            <el-descriptions-item label="审批意见" :span="2">{{ detail.approveRemark || '--' }}</el-descriptions-item>
            <el-descriptions-item label="备注" :span="2">{{ detail.remark || '--' }}</el-descriptions-item>
          </el-descriptions>

          <div class="outbound-drawer__table">
            <PageHeader
              title="文物明细"
              description="展示当前出库申请对应的文物清单与申请时状态快照。"
            />
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
              <el-table-column prop="remark" label="备注" min-width="160" />
            </el-table>
          </div>
        </template>
      </div>
    </el-drawer>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { approveOutboundApi, getOutboundDetailApi, getOutboundPageApi, rejectOutboundApi } from '@/api/outbound'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { useAuthStore } from '@/stores/auth'
import { useDictStore } from '@/stores/dict'
import { formatDateTime, resolveDictLabel } from '@/utils/format'

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
  approveStatus: ''
})

const statusOptions = computed(() => dictStore.itemsMap.outbound_status || [])
const relicStatusOptions = computed(() => dictStore.itemsMap.relic_status || [])

async function loadData() {
  loading.value = true
  try {
    pageData.value = await getOutboundPageApi(queryForm)
  } finally {
    loading.value = false
  }
}

async function handleView(row) {
  drawerVisible.value = true
  drawerLoading.value = true
  try {
    detail.value = await getOutboundDetailApi(row.id)
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
    approveStatus: ''
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

async function handleApprove(row) {
  try {
    const { value } = await ElMessageBox.prompt('可填写审批意见（选填）', '审批通过', {
      confirmButtonText: '确认通过',
      cancelButtonText: '取消',
      inputPlaceholder: '请输入审批意见'
    })
    await approveOutboundApi(row.id, {
      approveRemark: value
    })
    ElMessage.success('出库申请已审批通过')
    await loadData()
  } catch (error) {
    // 取消输入时不提示。
  }
}

async function handleReject(row) {
  try {
    const { value } = await ElMessageBox.prompt('请输入驳回原因', '驳回申请', {
      confirmButtonText: '确认驳回',
      cancelButtonText: '取消',
      inputPlaceholder: '请输入驳回原因',
      inputPattern: /.+/,
      inputErrorMessage: '驳回原因不能为空'
    })
    await rejectOutboundApi(row.id, {
      approveRemark: value
    })
    ElMessage.success('出库申请已驳回')
    await loadData()
  } catch (error) {
    // 取消输入时不提示。
  }
}

onMounted(async () => {
  await dictStore.ensureMultipleItems(['outbound_status', 'relic_status'])
  await loadData()
})
</script>

<style scoped>
.outbound-filter {
  display: flex;
  flex-wrap: wrap;
}

.outbound-drawer__table {
  margin-top: 20px;
}
</style>
