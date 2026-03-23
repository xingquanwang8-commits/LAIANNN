<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <PageHeader title="出库申请" description="填写出库用途与去向，从在库文物中选择对象后提交申请。">
        <template #extra>
          <el-button type="primary" @click="dialogVisible = true">新建申请</el-button>
        </template>
      </PageHeader>
    </section>

    <section class="page-card page-card--section">
      <el-form :inline="true" :model="queryForm">
        <el-form-item label="关键词">
          <el-input v-model="queryForm.keyword" placeholder="单号 / 用途 / 去向" clearable @keyup.enter="loadOrders" />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="queryForm.approveStatus" clearable placeholder="全部状态">
            <el-option v-for="item in statusOptions" :key="item.itemValue" :label="item.itemLabel" :value="item.itemValue" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </section>

    <section class="page-card page-card--section">
      <el-table :data="pageData.records" v-loading="loading">
        <el-table-column prop="orderNo" label="出库单号" min-width="150" />
        <el-table-column prop="purpose" label="用途" min-width="180" />
        <el-table-column prop="destination" label="去向" min-width="180" />
        <el-table-column prop="handlerName" label="经手人" min-width="120" />
        <el-table-column label="申请时间" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.outboundTime) }}</template>
        </el-table-column>
        <el-table-column label="审批状态" min-width="120">
          <template #default="{ row }">
            <StatusTag :status="row.approveStatus" :label="resolveDictLabel(statusOptions, row.approveStatus)" />
          </template>
        </el-table-column>
        <el-table-column prop="detailCount" label="文物数量" width="100" />
        <el-table-column label="操作" width="100">
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

    <el-dialog v-model="dialogVisible" title="新建出库申请" width="760px">
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
            <el-form-item label="经手人" prop="handlerName">
              <el-input v-model="form.handlerName" />
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
          <el-col :span="24">
            <el-form-item label="备注">
              <el-input v-model="form.remark" type="textarea" :rows="3" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleSave">提交</el-button>
      </template>
    </el-dialog>

    <el-drawer v-model="drawerVisible" title="出库申请详情" size="52%">
      <el-descriptions v-if="detail" :column="2" border>
        <el-descriptions-item label="出库单号">{{ detail.orderNo || '--' }}</el-descriptions-item>
        <el-descriptions-item label="审批状态">
          <StatusTag :status="detail.approveStatus" :label="resolveDictLabel(statusOptions, detail.approveStatus)" />
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

      <el-table :data="detail?.details || []" class="drawer-table">
        <el-table-column prop="relicNo" label="文物编号" min-width="130" />
        <el-table-column prop="relicName" label="文物名称" min-width="160" />
        <el-table-column prop="quantity" label="数量" width="90" />
        <el-table-column label="状态快照" min-width="120">
          <template #default="{ row }">
            <StatusTag :status="row.currentStatusSnapshot" :label="resolveDictLabel(relicStatusOptions, row.currentStatusSnapshot)" />
          </template>
        </el-table-column>
      </el-table>
    </el-drawer>
  </div>
</template>

<script setup>
import { computed, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { createOutboundApi, getOutboundDetailApi, getOutboundPageApi } from '@/api/outbound'
import { getRelicPageApi } from '@/api/relic'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { useDictStore } from '@/stores/dict'
import { formatDateTime, resolveDictLabel } from '@/utils/format'

const dictStore = useDictStore()

const loading = ref(false)
const saving = ref(false)
const dialogVisible = ref(false)
const drawerVisible = ref(false)
const formRef = ref()
const detail = ref(null)
const relicOptions = ref([])
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
  handlerName: '',
  outboundTime: '',
  remark: '',
  relicIds: []
})

const rules = {
  purpose: [{ required: true, message: '请输入用途', trigger: 'blur' }],
  destination: [{ required: true, message: '请输入去向', trigger: 'blur' }],
  handlerName: [{ required: true, message: '请输入经手人', trigger: 'blur' }],
  outboundTime: [{ required: true, message: '请选择申请时间', trigger: 'change' }],
  relicIds: [{ required: true, type: 'array', message: '请选择文物', trigger: 'change' }]
}

const statusOptions = computed(() => dictStore.itemsMap.outbound_status || [])
const relicStatusOptions = computed(() => dictStore.itemsMap.relic_status || [])

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
    handlerName: '',
    outboundTime: getCurrentDateTime(),
    remark: '',
    relicIds: []
  })
}

async function loadRelicOptions() {
  const page = await getRelicPageApi({
    pageNum: 1,
    pageSize: 200,
    currentStatus: 'IN_STOCK'
  })
  relicOptions.value = page.records || []
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
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) {
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

resetForm()
dictStore.ensureMultipleItems(['outbound_status', 'relic_status'])
loadOrders()
loadRelicOptions()
</script>

<style scoped>
.table-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}

.drawer-table {
  margin-top: 18px;
}
</style>
