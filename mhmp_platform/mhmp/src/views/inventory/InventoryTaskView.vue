<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <PageHeader title="盘点任务" description="按库位创建盘点任务，录入实盘数量并提交盘点结果。">
        <template #extra>
          <el-button type="primary" @click="dialogVisible = true">新增任务</el-button>
        </template>
      </PageHeader>
    </section>

    <section class="page-card page-card--section">
      <el-form :inline="true" :model="queryForm">
        <el-form-item label="关键词">
          <el-input v-model="queryForm.keyword" placeholder="任务编号 / 名称" clearable @keyup.enter="handleSearch" />
        </el-form-item>
        <el-form-item label="库位">
          <el-select v-model="queryForm.locationCode" clearable placeholder="全部库位">
            <el-option v-for="item in locationOptions" :key="item.itemValue" :label="item.itemLabel" :value="item.itemValue" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="queryForm.taskStatus" clearable placeholder="全部状态">
            <el-option label="未开始" value="CREATED" />
            <el-option label="进行中" value="IN_PROGRESS" />
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
        <el-table-column prop="taskNo" label="任务编号" min-width="150" />
        <el-table-column prop="taskName" label="任务名称" min-width="170" />
        <el-table-column label="库位" min-width="130">
          <template #default="{ row }">{{ resolveDictLabel(locationOptions, row.locationCode) }}</template>
        </el-table-column>
        <el-table-column prop="principalName" label="负责人" min-width="120" />
        <el-table-column label="状态" width="120">
          <template #default="{ row }">
            <StatusTag :status="row.taskStatus" :label="taskStatusLabelMap[row.taskStatus] || row.taskStatus" />
          </template>
        </el-table-column>
        <el-table-column prop="totalCount" label="文物数" width="100" />
        <el-table-column prop="diffCount" label="差异数" width="100" />
        <el-table-column label="开始时间" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.startTime) }}</template>
        </el-table-column>
        <el-table-column label="操作" width="120">
          <template #default="{ row }">
            <el-button text type="primary" @click="openDetail(row.id)">查看盘点</el-button>
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

    <el-dialog v-model="dialogVisible" title="新增盘点任务" width="560px">
      <el-form ref="formRef" :model="formData" :rules="rules" label-width="96px">
        <el-form-item label="任务名称" prop="taskName">
          <el-input v-model="formData.taskName" />
        </el-form-item>
        <el-form-item label="库位" prop="locationCode">
          <el-select v-model="formData.locationCode" placeholder="请选择库位">
            <el-option v-for="item in locationOptions" :key="item.itemValue" :label="item.itemLabel" :value="item.itemValue" />
          </el-select>
        </el-form-item>
        <el-form-item label="开始时间" prop="startTime">
          <el-date-picker v-model="formData.startTime" type="datetime" value-format="YYYY-MM-DDTHH:mm:ss" />
        </el-form-item>
        <el-form-item label="负责人" prop="principalName">
          <el-input v-model="formData.principalName" />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="formData.remark" type="textarea" :rows="3" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleSave">提交</el-button>
      </template>
    </el-dialog>

    <el-drawer v-model="drawerVisible" title="盘点任务详情" size="58%">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="任务编号">{{ detail.taskNo || '--' }}</el-descriptions-item>
        <el-descriptions-item label="任务名称">{{ detail.taskName || '--' }}</el-descriptions-item>
        <el-descriptions-item label="库位">{{ resolveDictLabel(locationOptions, detail.locationCode) }}</el-descriptions-item>
        <el-descriptions-item label="负责人">{{ detail.principalName || '--' }}</el-descriptions-item>
        <el-descriptions-item label="状态">{{ taskStatusLabelMap[detail.taskStatus] || detail.taskStatus || '--' }}</el-descriptions-item>
        <el-descriptions-item label="开始时间">{{ formatDateTime(detail.startTime) }}</el-descriptions-item>
      </el-descriptions>

      <el-table :data="detail.details || []" class="drawer-table">
        <el-table-column prop="relicNo" label="文物编号" min-width="130" />
        <el-table-column prop="relicName" label="文物名称" min-width="150" />
        <el-table-column prop="systemQuantity" label="系统数量" width="100" />
        <el-table-column label="实盘数量" width="130">
          <template #default="{ row }">
            <el-input-number
              v-model="row.actualQuantity"
              :min="0"
              :disabled="detail.taskStatus === 'COMPLETED' || !authStore.hasPermission('inventory:task:submit')"
            />
          </template>
        </el-table-column>
        <el-table-column label="差异备注" min-width="150">
          <template #default="{ row }">
            <el-input
              v-model="row.diffRemark"
              :disabled="detail.taskStatus === 'COMPLETED' || !authStore.hasPermission('inventory:task:submit')"
            />
          </template>
        </el-table-column>
        <el-table-column label="结果" width="120">
          <template #default="{ row }">
            <StatusTag :status="row.resultStatus" :label="resultLabelMap[row.resultStatus] || row.resultStatus" />
          </template>
        </el-table-column>
        <el-table-column v-if="authStore.hasPermission('inventory:task:submit')" label="保存" width="100">
          <template #default="{ row }">
            <el-button
              text
              type="primary"
              :disabled="detail.taskStatus === 'COMPLETED'"
              @click="handleSaveDetail(row)"
            >
              保存
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="drawer-footer">
        <el-button
          v-if="authStore.hasPermission('inventory:task:submit')"
          type="primary"
          :disabled="detail.taskStatus === 'COMPLETED'"
          @click="handleSubmitTask"
        >
          提交盘点结果
        </el-button>
      </div>
    </el-drawer>
  </div>
</template>

<script setup>
import { computed, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import {
  createInventoryTaskApi,
  getInventoryTaskDetailApi,
  getInventoryTaskPageApi,
  submitInventoryTaskApi,
  updateInventoryTaskDetailApi
} from '@/api/inventory'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { useAuthStore } from '@/stores/auth'
import { useDictStore } from '@/stores/dict'
import { formatDateTime, resolveDictLabel } from '@/utils/format'

const authStore = useAuthStore()
const dictStore = useDictStore()

const loading = ref(false)
const saving = ref(false)
const dialogVisible = ref(false)
const drawerVisible = ref(false)
const formRef = ref()
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
  locationCode: '',
  taskStatus: ''
})

const formData = reactive({
  taskName: '',
  locationCode: '',
  startTime: '',
  principalName: '',
  remark: ''
})

const rules = {
  taskName: [{ required: true, message: '请输入任务名称', trigger: 'blur' }],
  locationCode: [{ required: true, message: '请选择库位', trigger: 'change' }],
  startTime: [{ required: true, message: '请选择开始时间', trigger: 'change' }],
  principalName: [{ required: true, message: '请输入负责人', trigger: 'blur' }]
}

const taskStatusLabelMap = {
  CREATED: '未开始',
  IN_PROGRESS: '进行中',
  COMPLETED: '已完成'
}

const resultLabelMap = {
  PENDING: '待录入',
  CHECKED: '已核对',
  DIFF_FOUND: '存在差异',
  NORMAL: '正常'
}

const locationOptions = computed(() => dictStore.itemsMap.storage_location || [])

async function loadTasks() {
  loading.value = true
  try {
    pageData.value = await getInventoryTaskPageApi(queryForm)
  } finally {
    loading.value = false
  }
}

async function openDetail(id) {
  detail.value = await getInventoryTaskDetailApi(id)
  drawerVisible.value = true
}

async function handleSave() {
  await formRef.value.validate()
  saving.value = true
  try {
    await createInventoryTaskApi(formData)
    ElMessage.success('盘点任务已创建')
    dialogVisible.value = false
    await loadTasks()
  } finally {
    saving.value = false
  }
}

async function handleSaveDetail(row) {
  await updateInventoryTaskDetailApi(detail.value.id, row.id, {
    actualQuantity: row.actualQuantity,
    diffRemark: row.diffRemark
  })
  ElMessage.success('盘点明细已保存')
  await openDetail(detail.value.id)
}

async function handleSubmitTask() {
  await submitInventoryTaskApi(detail.value.id)
  ElMessage.success('盘点任务已提交')
  await openDetail(detail.value.id)
  await loadTasks()
}

function handleSearch() {
  queryForm.pageNum = 1
  loadTasks()
}

function handleReset() {
  Object.assign(queryForm, {
    pageNum: 1,
    pageSize: 10,
    keyword: '',
    locationCode: '',
    taskStatus: ''
  })
  loadTasks()
}

function handleCurrentChange(pageNum) {
  queryForm.pageNum = pageNum
  loadTasks()
}

function handleSizeChange(pageSize) {
  queryForm.pageSize = pageSize
  queryForm.pageNum = 1
  loadTasks()
}

dictStore.ensureItems('storage_location')
loadTasks()
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

.drawer-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}
</style>
