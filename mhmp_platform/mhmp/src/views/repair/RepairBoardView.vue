<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <PageHeader :title="config.title" :description="config.description">
        <template v-if="config.showCreate" #extra>
          <el-button type="primary" @click="openApplyDialog">发起修复申请</el-button>
        </template>
      </PageHeader>
    </section>

    <section class="page-card page-card--section">
      <el-form :inline="true" :model="queryForm">
        <el-form-item label="关键词">
          <el-input v-model="queryForm.keyword" placeholder="任务编号 / 文物编号 / 文物名称" clearable @keyup.enter="handleSearch" />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="queryForm.taskStatus" clearable placeholder="全部状态">
            <el-option v-for="item in taskStatusOptions" :key="item.value" :label="item.label" :value="item.value" />
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
        <el-table-column prop="relicNo" label="文物编号" min-width="130" />
        <el-table-column prop="relicName" label="文物名称" min-width="160" />
        <el-table-column label="状态" width="120">
          <template #default="{ row }">
            <StatusTag :status="row.taskStatus" :label="taskStatusLabelMap[row.taskStatus] || row.taskStatus" />
          </template>
        </el-table-column>
        <el-table-column prop="applyUserName" label="申请人" min-width="110" />
        <el-table-column label="申请时间" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.applyTime) }}</template>
        </el-table-column>
        <el-table-column label="操作" width="210">
          <template #default="{ row }">
            <el-button text type="primary" @click="openDetail(row.id)">详情</el-button>
            <el-button
              v-if="mode === 'approve' && authStore.hasPermission('repair:plan:approve') && row.taskStatus === 'APPLIED'"
              text
              @click="openApproveDialog(row.id)"
            >
              审批
            </el-button>
            <el-button
              v-if="mode === 'process' && authStore.hasPermission('repair:log:add') && ['APPROVED', 'IN_PROGRESS', 'COMPLETED'].includes(row.taskStatus)"
              text
              @click="openLogDialog(row.id)"
            >
              记录过程
            </el-button>
            <el-button
              v-if="mode === 'acceptance' && authStore.hasPermission('repair:acceptance:add') && ['COMPLETED', 'ACCEPTED'].includes(row.taskStatus)"
              text
              @click="openAcceptanceDialog(row.id)"
            >
              验收
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

    <el-dialog v-model="applyDialogVisible" title="发起修复申请" width="620px">
      <el-form ref="applyFormRef" :model="applyForm" :rules="applyRules" label-width="96px">
        <el-form-item label="文物" prop="relicId">
          <el-select v-model="applyForm.relicId" filterable placeholder="请选择文物">
            <el-option
              v-for="item in relicOptions"
              :key="item.id"
              :label="`${item.relicNo} / ${item.name}`"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="申请原因" prop="applyReason">
          <el-input v-model="applyForm.applyReason" type="textarea" :rows="4" />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="applyForm.remark" type="textarea" :rows="3" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="applyDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleSaveApply">提交</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="approveDialogVisible" title="修复审批" width="680px">
      <el-form ref="approveFormRef" :model="approveForm" :rules="approveRules" label-width="96px">
        <el-form-item label="审批结果" prop="approveResult">
          <el-radio-group v-model="approveForm.approveResult">
            <el-radio label="APPROVED">通过</el-radio>
            <el-radio label="REJECTED">驳回</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="审批意见">
          <el-input v-model="approveForm.approveRemark" type="textarea" :rows="3" />
        </el-form-item>
        <template v-if="approveForm.approveResult === 'APPROVED'">
          <el-form-item label="方案标题" prop="planTitle">
            <el-input v-model="approveForm.planTitle" />
          </el-form-item>
          <el-form-item label="方案内容" prop="planContent">
            <el-input v-model="approveForm.planContent" type="textarea" :rows="4" />
          </el-form-item>
          <el-form-item label="材料">
            <el-input v-model="approveForm.materials" />
          </el-form-item>
          <el-form-item label="风险提示">
            <el-input v-model="approveForm.riskNote" type="textarea" :rows="3" />
          </el-form-item>
        </template>
      </el-form>
      <template #footer>
        <el-button @click="approveDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleSaveApprove">提交</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="logDialogVisible" title="修复过程记录" width="620px">
      <el-form ref="logFormRef" :model="logForm" :rules="logRules" label-width="96px">
        <el-form-item label="步骤名称" prop="stepName">
          <el-input v-model="logForm.stepName" />
        </el-form-item>
        <el-form-item label="处理内容" prop="operationContent">
          <el-input v-model="logForm.operationContent" type="textarea" :rows="4" />
        </el-form-item>
        <el-form-item label="使用材料">
          <el-input v-model="logForm.materialsUsed" />
        </el-form-item>
        <el-form-item label="操作人" prop="operatorName">
          <el-input v-model="logForm.operatorName" />
        </el-form-item>
        <el-form-item label="记录时间" prop="logTime">
          <el-date-picker v-model="logForm.logTime" type="datetime" value-format="YYYY-MM-DDTHH:mm:ss" />
        </el-form-item>
        <el-form-item label="进度" prop="progressStatus">
          <el-radio-group v-model="logForm.progressStatus">
            <el-radio label="IN_PROGRESS">进行中</el-radio>
            <el-radio label="COMPLETED">已完成</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="logForm.remark" type="textarea" :rows="3" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="logDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleSaveLog">提交</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="acceptanceDialogVisible" title="修复验收" width="620px">
      <el-form ref="acceptanceFormRef" :model="acceptanceForm" :rules="acceptanceRules" label-width="108px">
        <el-form-item label="验收结果" prop="acceptanceResult">
          <el-radio-group v-model="acceptanceForm.acceptanceResult">
            <el-radio label="PASS">通过</el-radio>
            <el-radio label="REJECTED">不通过</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="验收时间" prop="acceptanceTime">
          <el-date-picker v-model="acceptanceForm.acceptanceTime" type="datetime" value-format="YYYY-MM-DDTHH:mm:ss" />
        </el-form-item>
        <el-form-item label="保存状态">
          <el-select v-model="acceptanceForm.preservationStatusCode" clearable placeholder="请选择">
            <el-option
              v-for="item in preservationOptions"
              :key="item.itemValue"
              :label="item.itemLabel"
              :value="item.itemValue"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="馆藏位置">
          <el-select v-model="acceptanceForm.storageLocationCode" clearable placeholder="请选择">
            <el-option
              v-for="item in locationOptions"
              :key="item.itemValue"
              :label="item.itemLabel"
              :value="item.itemValue"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="验收意见">
          <el-input v-model="acceptanceForm.acceptanceRemark" type="textarea" :rows="3" />
        </el-form-item>
        <el-form-item label="后续建议">
          <el-input v-model="acceptanceForm.followUpSuggestion" type="textarea" :rows="3" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="acceptanceDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleSaveAcceptance">提交</el-button>
      </template>
    </el-dialog>

    <el-drawer v-model="drawerVisible" title="修复任务详情" size="58%">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="任务编号">{{ detail.taskNo || '--' }}</el-descriptions-item>
        <el-descriptions-item label="文物编号">{{ detail.relicNo || '--' }}</el-descriptions-item>
        <el-descriptions-item label="文物名称">{{ detail.relicName || '--' }}</el-descriptions-item>
        <el-descriptions-item label="任务状态">
          {{ taskStatusLabelMap[detail.taskStatus] || detail.taskStatus || '--' }}
        </el-descriptions-item>
        <el-descriptions-item label="申请人">{{ detail.applyUserName || '--' }}</el-descriptions-item>
        <el-descriptions-item label="申请时间">{{ formatDateTime(detail.applyTime) }}</el-descriptions-item>
        <el-descriptions-item label="审批人">{{ detail.approveUserName || '--' }}</el-descriptions-item>
        <el-descriptions-item label="审批时间">{{ formatDateTime(detail.approveTime) }}</el-descriptions-item>
        <el-descriptions-item label="申请原因" :span="2">{{ detail.applyReason || '--' }}</el-descriptions-item>
        <el-descriptions-item label="审批意见" :span="2">{{ detail.approveRemark || '--' }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ detail.remark || '--' }}</el-descriptions-item>
      </el-descriptions>

      <div v-if="detail.plan" class="detail-section">
        <div class="detail-section__title">修复方案</div>
        <el-descriptions :column="1" border>
          <el-descriptions-item label="方案标题">{{ detail.plan.planTitle || '--' }}</el-descriptions-item>
          <el-descriptions-item label="方案内容">{{ detail.plan.planContent || '--' }}</el-descriptions-item>
          <el-descriptions-item label="材料">{{ detail.plan.materials || '--' }}</el-descriptions-item>
          <el-descriptions-item label="风险提示">{{ detail.plan.riskNote || '--' }}</el-descriptions-item>
        </el-descriptions>
      </div>

      <div class="detail-section">
        <div class="detail-section__title">修复日志</div>
        <el-timeline>
          <el-timeline-item
            v-for="log in detail.logs || []"
            :key="log.id"
            :timestamp="formatDateTime(log.logTime)"
          >
            <div class="timeline-title">
              {{ log.stepName }} / {{ progressStatusLabelMap[log.progressStatus] || log.progressStatus }}
            </div>
            <div class="text-secondary">{{ log.operationContent }}</div>
          </el-timeline-item>
        </el-timeline>
      </div>

      <div v-if="detail.acceptance" class="detail-section">
        <div class="detail-section__title">验收记录</div>
        <el-descriptions :column="1" border>
          <el-descriptions-item label="验收结果">
            {{ detail.acceptance.acceptanceResult === 'PASS' ? '通过' : '不通过' }}
          </el-descriptions-item>
          <el-descriptions-item label="验收时间">
            {{ formatDateTime(detail.acceptance.acceptanceTime) }}
          </el-descriptions-item>
          <el-descriptions-item label="验收意见">{{ detail.acceptance.acceptanceRemark || '--' }}</el-descriptions-item>
          <el-descriptions-item label="后续建议">{{ detail.acceptance.followUpSuggestion || '--' }}</el-descriptions-item>
        </el-descriptions>
      </div>
    </el-drawer>
  </div>
</template>

<script setup>
import { computed, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import {
  acceptRepairApi,
  addRepairLogApi,
  approveRepairApi,
  createRepairApplyApi,
  getRepairAcceptancePageApi,
  getRepairApplyPageApi,
  getRepairApprovePageApi,
  getRepairDetailApi,
  getRepairHistoryPageApi,
  getRepairProcessPageApi
} from '@/api/repair'
import { getRelicPageApi } from '@/api/relic'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { useAuthStore } from '@/stores/auth'
import { useDictStore } from '@/stores/dict'
import { formatDateTime } from '@/utils/format'

const props = defineProps({
  mode: {
    type: String,
    required: true
  }
})

const authStore = useAuthStore()
const dictStore = useDictStore()

const configMap = {
  apply: {
    title: '修复申请',
    description: '选择文物并提交修复申请，作为修复流程的起点。',
    showCreate: true,
    loadPage: getRepairApplyPageApi
  },
  approve: {
    title: '修复审批',
    description: '审批修复申请并维护方案内容。',
    showCreate: false,
    loadPage: getRepairApprovePageApi
  },
  process: {
    title: '修复过程',
    description: '记录修复过程日志，跟踪修复进度。',
    showCreate: false,
    loadPage: getRepairProcessPageApi
  },
  acceptance: {
    title: '修复验收',
    description: '提交修复验收结果并回写文物状态。',
    showCreate: false,
    loadPage: getRepairAcceptancePageApi
  },
  history: {
    title: '修复历史',
    description: '查看修复任务的完整历史记录。',
    showCreate: false,
    loadPage: getRepairHistoryPageApi
  }
}

const config = computed(() => configMap[props.mode])
const loading = ref(false)
const saving = ref(false)
const drawerVisible = ref(false)
const applyDialogVisible = ref(false)
const approveDialogVisible = ref(false)
const logDialogVisible = ref(false)
const acceptanceDialogVisible = ref(false)
const applyFormRef = ref()
const approveFormRef = ref()
const logFormRef = ref()
const acceptanceFormRef = ref()
const currentTaskId = ref(null)
const detail = ref({})
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
  taskStatus: ''
})

const applyForm = reactive({
  relicId: null,
  applyReason: '',
  remark: ''
})

const approveForm = reactive({
  approveResult: 'APPROVED',
  approveRemark: '',
  planTitle: '',
  planContent: '',
  materials: '',
  riskNote: ''
})

const logForm = reactive({
  stepName: '',
  operationContent: '',
  materialsUsed: '',
  operatorName: '',
  logTime: '',
  progressStatus: 'IN_PROGRESS',
  remark: ''
})

const acceptanceForm = reactive({
  acceptanceResult: 'PASS',
  acceptanceTime: '',
  acceptanceRemark: '',
  followUpSuggestion: '',
  preservationStatusCode: '',
  storageLocationCode: ''
})

const taskStatusLabelMap = {
  APPLIED: '待审批',
  APPROVED: '已审批',
  IN_PROGRESS: '修复中',
  COMPLETED: '待验收',
  ACCEPTED: '已验收',
  REJECTED: '已驳回'
}

const progressStatusLabelMap = {
  IN_PROGRESS: '进行中',
  COMPLETED: '已完成'
}

const taskStatusOptions = [
  { label: '待审批', value: 'APPLIED' },
  { label: '已审批', value: 'APPROVED' },
  { label: '修复中', value: 'IN_PROGRESS' },
  { label: '待验收', value: 'COMPLETED' },
  { label: '已验收', value: 'ACCEPTED' },
  { label: '已驳回', value: 'REJECTED' }
]

const locationOptions = computed(() => dictStore.itemsMap.storage_location || [])
const preservationOptions = computed(() => dictStore.itemsMap.preservation_status || [])

const applyRules = {
  relicId: [{ required: true, message: '请选择文物', trigger: 'change' }],
  applyReason: [{ required: true, message: '请输入申请原因', trigger: 'blur' }]
}

const approveRules = {
  approveResult: [{ required: true, message: '请选择审批结果', trigger: 'change' }],
  planTitle: [
    {
      validator: (_rule, value, callback) => {
        if (approveForm.approveResult === 'APPROVED' && !value) {
          callback(new Error('请输入方案标题'))
          return
        }
        callback()
      },
      trigger: 'blur'
    }
  ],
  planContent: [
    {
      validator: (_rule, value, callback) => {
        if (approveForm.approveResult === 'APPROVED' && !value) {
          callback(new Error('请输入方案内容'))
          return
        }
        callback()
      },
      trigger: 'blur'
    }
  ]
}

const logRules = {
  stepName: [{ required: true, message: '请输入步骤名称', trigger: 'blur' }],
  operationContent: [{ required: true, message: '请输入处理内容', trigger: 'blur' }],
  operatorName: [{ required: true, message: '请输入操作人', trigger: 'blur' }],
  logTime: [{ required: true, message: '请选择记录时间', trigger: 'change' }],
  progressStatus: [{ required: true, message: '请选择进度', trigger: 'change' }]
}

const acceptanceRules = {
  acceptanceResult: [{ required: true, message: '请选择验收结果', trigger: 'change' }],
  acceptanceTime: [{ required: true, message: '请选择验收时间', trigger: 'change' }]
}

function resetApplyForm() {
  Object.assign(applyForm, {
    relicId: null,
    applyReason: '',
    remark: ''
  })
}

function resetApproveForm() {
  Object.assign(approveForm, {
    approveResult: 'APPROVED',
    approveRemark: '',
    planTitle: '',
    planContent: '',
    materials: '',
    riskNote: ''
  })
}

function resetLogForm() {
  Object.assign(logForm, {
    stepName: '',
    operationContent: '',
    materialsUsed: '',
    operatorName: '',
    logTime: '',
    progressStatus: 'IN_PROGRESS',
    remark: ''
  })
}

function resetAcceptanceForm() {
  Object.assign(acceptanceForm, {
    acceptanceResult: 'PASS',
    acceptanceTime: '',
    acceptanceRemark: '',
    followUpSuggestion: '',
    preservationStatusCode: '',
    storageLocationCode: ''
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

async function loadPage() {
  loading.value = true
  try {
    pageData.value = await config.value.loadPage(queryForm)
  } finally {
    loading.value = false
  }
}

async function openDetail(id) {
  detail.value = await getRepairDetailApi(id)
  drawerVisible.value = true
}

async function openApplyDialog() {
  resetApplyForm()
  await loadRelicOptions()
  applyDialogVisible.value = true
}

function openApproveDialog(id) {
  currentTaskId.value = id
  resetApproveForm()
  approveDialogVisible.value = true
}

function openLogDialog(id) {
  currentTaskId.value = id
  resetLogForm()
  logDialogVisible.value = true
}

function openAcceptanceDialog(id) {
  currentTaskId.value = id
  resetAcceptanceForm()
  acceptanceDialogVisible.value = true
}

async function handleSaveApply() {
  await applyFormRef.value.validate()
  saving.value = true
  try {
    await createRepairApplyApi(applyForm)
    ElMessage.success('修复申请已提交')
    applyDialogVisible.value = false
    await loadPage()
  } finally {
    saving.value = false
  }
}

async function handleSaveApprove() {
  await approveFormRef.value.validate()
  saving.value = true
  try {
    await approveRepairApi(currentTaskId.value, approveForm)
    ElMessage.success('审批结果已提交')
    approveDialogVisible.value = false
    await loadPage()
  } finally {
    saving.value = false
  }
}

async function handleSaveLog() {
  await logFormRef.value.validate()
  saving.value = true
  try {
    await addRepairLogApi(currentTaskId.value, logForm)
    ElMessage.success('修复日志已记录')
    logDialogVisible.value = false
    await loadPage()
  } finally {
    saving.value = false
  }
}

async function handleSaveAcceptance() {
  await acceptanceFormRef.value.validate()
  saving.value = true
  try {
    await acceptRepairApi(currentTaskId.value, acceptanceForm)
    ElMessage.success('验收结果已提交')
    acceptanceDialogVisible.value = false
    await loadPage()
  } finally {
    saving.value = false
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
    taskStatus: ''
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

dictStore.ensureMultipleItems(['storage_location', 'preservation_status'])
loadPage()
</script>

<style scoped>
.table-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}

.detail-section {
  margin-top: 20px;
}

.detail-section__title {
  margin-bottom: 12px;
  font-size: 15px;
  font-weight: 700;
}

.timeline-title {
  font-weight: 600;
}
</style>
