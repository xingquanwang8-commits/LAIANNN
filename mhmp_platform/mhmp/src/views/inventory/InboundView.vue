<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <PageHeader title="入库登记" description="选择现有文物生成入库单，并查看入库明细记录。">
        <template #extra>
          <el-button v-if="authStore.hasPermission('inventory:inbound:add')" type="primary" @click="openCreate">
            新增入库单
          </el-button>
        </template>
      </PageHeader>
    </section>

    <section class="page-card page-card--section">
      <el-form :inline="true" :model="queryForm">
        <el-form-item label="关键词">
          <el-input v-model="queryForm.keyword" placeholder="单号 / 批次 / 来源" clearable @keyup.enter="handleSearch" />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="queryForm.status" clearable placeholder="全部状态">
            <el-option label="已完成" value="COMPLETED" />
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
        <el-table-column prop="orderNo" label="入库单号" min-width="150" />
        <el-table-column prop="batchNo" label="批次号" min-width="130" />
        <el-table-column prop="source" label="来源" min-width="150" />
        <el-table-column prop="handlerName" label="经手人" min-width="120" />
        <el-table-column prop="totalCount" label="数量" width="90" />
        <el-table-column label="入库时间" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.inboundTime) }}</template>
        </el-table-column>
        <el-table-column label="状态" width="120">
          <template #default="{ row }">
            <StatusTag :status="row.status" :label="row.status === 'COMPLETED' ? '已完成' : row.status" />
          </template>
        </el-table-column>
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

    <el-dialog v-model="dialogVisible" title="新增入库单" width="680px">
      <el-form ref="formRef" :model="formData" :rules="rules" label-width="96px">
        <el-row :gutter="14">
          <el-col :span="12">
            <el-form-item label="批次号" prop="batchNo">
              <el-input v-model="formData.batchNo" />
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
          <el-col :span="24">
            <el-form-item label="备注">
              <el-input v-model="formData.remark" type="textarea" :rows="3" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleSave">提交</el-button>
      </template>
    </el-dialog>

    <el-drawer v-model="drawerVisible" title="入库单详情" size="46%">
      <el-descriptions :column="1" border>
        <el-descriptions-item label="入库单号">{{ detail.orderNo || '--' }}</el-descriptions-item>
        <el-descriptions-item label="批次号">{{ detail.batchNo || '--' }}</el-descriptions-item>
        <el-descriptions-item label="来源">{{ detail.source || '--' }}</el-descriptions-item>
        <el-descriptions-item label="经手人">{{ detail.handlerName || '--' }}</el-descriptions-item>
        <el-descriptions-item label="入库时间">{{ formatDateTime(detail.inboundTime) }}</el-descriptions-item>
        <el-descriptions-item label="备注">{{ detail.remark || '--' }}</el-descriptions-item>
      </el-descriptions>

      <el-table :data="detail.details || []" class="drawer-table">
        <el-table-column prop="relicNo" label="文物编号" min-width="140" />
        <el-table-column prop="relicName" label="文物名称" min-width="160" />
        <el-table-column prop="quantity" label="数量" width="90" />
        <el-table-column prop="remark" label="备注" min-width="140" />
      </el-table>
    </el-drawer>
  </div>
</template>

<script setup>
import { nextTick, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { createInboundApi, getInboundDetailApi, getInboundPageApi } from '@/api/inbound'
import { getRelicPageApi } from '@/api/relic'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { useAuthStore } from '@/stores/auth'
import { formatDateTime } from '@/utils/format'

const authStore = useAuthStore()

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
  batchNo: '',
  source: '',
  handlerName: '',
  inboundTime: '',
  remark: '',
  relicIds: []
})

const rules = {
  batchNo: [{ required: true, message: '请输入批次号', trigger: 'blur' }],
  source: [{ required: true, message: '请输入来源', trigger: 'blur' }],
  handlerName: [{ required: true, message: '请输入经手人', trigger: 'blur' }],
  inboundTime: [{ required: true, message: '请选择入库时间', trigger: 'change' }],
  relicIds: [{ required: true, type: 'array', message: '请选择文物', trigger: 'change' }]
}

function resetForm() {
  Object.assign(formData, {
    batchNo: '',
    source: '',
    handlerName: '',
    inboundTime: '',
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
    pageData.value = await getInboundPageApi(queryForm)
  } finally {
    loading.value = false
  }
}

function openCreate() {
  resetForm()
  dialogVisible.value = true
  nextTick(() => formRef.value?.clearValidate())
  loadRelicOptions()
}

async function handleSave() {
  await formRef.value.validate()
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

loadOrders()
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
