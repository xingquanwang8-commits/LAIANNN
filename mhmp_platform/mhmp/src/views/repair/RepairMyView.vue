<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="overview-panel overview-panel--compact">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">MHMP Repair Process</div>
            <h2 class="overview-panel__title">修复过程管理</h2>
            <p class="overview-panel__desc">
              研究人员可在这里持续记录修复步骤、处理内容、材料与附件，并在修复完成后提交验收，形成完整的修复过程档案。
            </p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">我的任务 {{ pageData.total }} 条</span>
            <span class="overview-chip overview-chip--accent">当前页 {{ currentPageCount }} 条</span>
          </div>
        </div>

        <div class="metric-grid process-metrics">
          <article class="metric-card">
            <span class="metric-card__label">待开始 / 已审批</span>
            <strong class="metric-card__value">{{ approvedCount }}</strong>
            <div class="metric-card__meta">已通过审批，待录入修复过程</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">修复进行中</span>
            <strong class="metric-card__value">{{ progressCount }}</strong>
            <div class="metric-card__meta">可继续补充修复步骤与材料记录</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">已完成待验收</span>
            <strong class="metric-card__value">{{ readyForAcceptanceCount }}</strong>
            <div class="metric-card__meta">已满足提交验收条件的修复任务</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前可操作任务</span>
            <strong class="metric-card__value">{{ actionableCount }}</strong>
            <div class="metric-card__meta">可更新进度或提交验收的任务数量</div>
          </article>
        </div>
      </div>
    </section>

    <section class="page-card page-card--section">
      <PageHeader
        title="修复任务检索"
        description="按任务编号、文物编号、名称和任务状态筛选我的修复任务，支持在列表页直接记录过程和提交验收。"
      />

      <div class="query-toolbar">
        <el-form :inline="true" :model="queryForm" class="query-form query-form--single-line">
          <el-form-item label="关键字" class="query-form__keyword query-form__keyword--wide">
            <el-input
              v-model="queryForm.keyword"
              placeholder="任务编号 / 文物编号 / 文物名称"
              clearable
              @keyup.enter="handleSearch"
            />
          </el-form-item>
          <el-form-item label="状态">
            <el-select v-model="queryForm.taskStatus" clearable placeholder="全部状态">
              <el-option label="已审批" value="APPROVED" />
              <el-option label="修复中" value="IN_PROGRESS" />
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
          <div class="list-section__title">修复过程任务</div>
          <div class="list-section__desc">
            当前展示 {{ currentPageCount }} 条任务，可查看详情、补充过程记录，或在任务完成后提交验收。
          </div>
        </div>
      </div>

      <el-table :data="pageData.records" v-loading="loading">
        <template #empty>
          <el-empty class="empty-block" description="未检索到符合条件的修复任务，请调整筛选条件后重试。" />
        </template>
        <el-table-column prop="taskNo" label="任务编号" min-width="150" />
        <el-table-column prop="relicNo" label="文物编号" min-width="140" />
        <el-table-column prop="relicName" label="文物名称" min-width="180" />
        <el-table-column label="任务状态" width="120">
          <template #default="{ row }">
            <StatusTag :status="row.taskStatus" :label="taskStatusLabelMap[row.taskStatus] || row.taskStatus || '--'" />
          </template>
        </el-table-column>
        <el-table-column label="验收状态" width="120">
          <template #default="{ row }">
            <StatusTag
              :status="row.acceptanceStatus"
              :label="acceptanceStatusLabelMap[row.acceptanceStatus] || row.acceptanceStatus || '--'"
            />
          </template>
        </el-table-column>
        <el-table-column label="申请时间" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.applyTime) }}</template>
        </el-table-column>
        <el-table-column label="开始时间" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.startTime) }}</template>
        </el-table-column>
        <el-table-column label="操作" class-name="table-action-column" width="320" fixed="right">
          <template #default="{ row }">
            <el-button text type="primary" @click="openDetail(row.id)">详情</el-button>
            <el-button
              v-if="canUpdateProgress(row)"
              text
              type="primary"
              @click="openLogDialog(row)"
            >
              更新进度
            </el-button>
            <el-button
              text
              :type="canSubmitAcceptance(row) ? 'primary' : 'info'"
              :disabled="!canSubmitAcceptance(row)"
              @click="handleSubmitAcceptance(row.id)"
            >
              提交验收
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

    <el-dialog v-model="dialogVisible" title="更新修复进度" width="720px">
      <div class="detail-stack">
        <div class="overview-panel overview-panel--compact dialog-overview">
          <div class="overview-panel__top">
            <div>
              <div class="overview-panel__eyebrow">Repair Progress</div>
              <h3 class="overview-panel__title dialog-overview__title">{{ currentTask?.taskNo || '更新修复进度' }}</h3>
              <p class="overview-panel__desc">
                记录本次修复步骤、处理内容、材料与附件。若本次记录标记为已完成，任务将进入可提交验收状态。
              </p>
            </div>
            <div class="overview-panel__meta">
              <span class="overview-chip">{{ currentTask?.relicNo || '--' }}</span>
              <span class="overview-chip overview-chip--accent">{{ currentTask?.relicName || '未选择任务' }}</span>
            </div>
          </div>
        </div>

        <div class="soft-note soft-note--accent">
          <div class="soft-note__title">填写提示</div>
          <div class="soft-note__desc">
            建议每次记录聚焦一个明确修复步骤，并同步上传过程图片或附件，便于后续验收与档案归集。
          </div>
        </div>

        <el-form ref="formRef" :model="formData" :rules="rules" label-width="98px">
          <el-form-item label="步骤名称" prop="stepName">
            <el-input v-model="formData.stepName" placeholder="如：病害清理 / 结构加固 / 表面修复" />
          </el-form-item>
          <el-form-item label="处理内容" prop="operationContent">
            <el-input
              v-model="formData.operationContent"
              type="textarea"
              :rows="4"
              placeholder="请描述本次修复操作、处理方法和阶段性结果"
            />
          </el-form-item>
          <el-form-item label="使用材料">
            <el-input v-model="formData.materialsUsed" placeholder="可填写胶料、纸浆、支撑材料等" />
          </el-form-item>
          <el-form-item label="操作人" prop="operatorName">
            <el-input v-model="formData.operatorName" disabled />
          </el-form-item>
          <el-form-item label="记录时间" prop="logTime">
            <el-date-picker v-model="formData.logTime" type="datetime" value-format="YYYY-MM-DDTHH:mm:ss" />
          </el-form-item>
          <el-form-item label="进度状态" prop="progressStatus">
            <el-radio-group v-model="formData.progressStatus">
              <el-radio label="IN_PROGRESS">进行中</el-radio>
              <el-radio label="COMPLETED">已完成</el-radio>
            </el-radio-group>
          </el-form-item>

          <div class="page-grid progress-upload-grid">
            <section class="info-section">
              <div class="info-section__header">
                <div>
                  <h3 class="info-section__title">过程图片</h3>
                  <p class="info-section__desc">上传修复关键节点图片，便于展示修复前后差异和验收核验。</p>
                </div>
              </div>
              <el-upload :show-file-list="false" accept="image/*" multiple :http-request="handleImageUpload">
                <el-button>上传图片</el-button>
              </el-upload>
              <div v-if="imageAttachments.length" class="upload-list">
                <div v-for="item in imageAttachments" :key="item.fileUrl" class="upload-item upload-item--image">
                  <img :src="item.fileUrl" alt="修复过程图片" class="upload-thumb">
                  <span>{{ item.fileName }}</span>
                  <el-button text type="danger" @click="removeAttachment(item.fileUrl)">移除</el-button>
                </div>
              </div>
              <el-empty v-else class="upload-empty" description="暂未上传过程图片，可在本次进度更新中补充。" />
            </section>

            <section class="info-section">
              <div class="info-section__header">
                <div>
                  <h3 class="info-section__title">过程附件</h3>
                  <p class="info-section__desc">上传补充说明、扫描件或实验记录等附件资料。</p>
                </div>
              </div>
              <el-upload :show-file-list="false" :http-request="handleFileUpload">
                <el-button>上传附件</el-button>
              </el-upload>
              <div v-if="fileAttachments.length" class="upload-list">
                <div v-for="item in fileAttachments" :key="item.fileUrl" class="upload-item">
                  <span>{{ item.fileName }}</span>
                  <el-button text type="danger" @click="removeAttachment(item.fileUrl)">移除</el-button>
                </div>
              </div>
              <el-empty v-else class="upload-empty" description="暂未上传过程附件，可在本次进度更新中补充。" />
            </section>
          </div>

          <el-form-item label="备注">
            <el-input
              v-model="formData.remark"
              type="textarea"
              :rows="3"
              placeholder="可填写补充说明、风险点或下一步计划"
            />
          </el-form-item>
        </el-form>
      </div>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleSubmitProgress">提交</el-button>
      </template>
    </el-dialog>

    <RepairTaskDrawer v-model="drawerVisible" :detail="detail" />
  </div>
</template>

<script setup>
import { computed, reactive, ref } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { addRepairLogApi, applyRepairAcceptanceApi, getMyRepairPageApi, getRepairDetailApi } from '@/api/repair'
import { uploadFileApi } from '@/api/file'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { useAuthStore } from '@/stores/auth'
import { validateElForm } from '@/utils/form'
import RepairTaskDrawer from './components/RepairTaskDrawer.vue'
import { formatDateTime } from '@/utils/format'

const route = useRoute()
const authStore = useAuthStore()
const loading = ref(false)
const saving = ref(false)
const dialogVisible = ref(false)
const drawerVisible = ref(false)
const formRef = ref()
const currentTaskId = ref(null)
const currentTask = ref(null)
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
  taskStatus: typeof route.query.taskStatus === 'string' ? route.query.taskStatus : ''
})

const formData = reactive({
  stepName: '',
  operationContent: '',
  materialsUsed: '',
  operatorName: '',
  logTime: '',
  progressStatus: 'IN_PROGRESS',
  remark: '',
  attachments: []
})

const rules = {
  stepName: [{ required: true, message: '请输入步骤名称', trigger: 'blur' }],
  operationContent: [{ required: true, message: '请输入处理内容', trigger: 'blur' }],
  operatorName: [{ required: true, message: '请输入操作人', trigger: 'blur' }],
  logTime: [{ required: true, message: '请选择记录时间', trigger: 'change' }],
  progressStatus: [{ required: true, message: '请选择进度状态', trigger: 'change' }]
}

const taskStatusLabelMap = {
  APPROVED: '已审批',
  IN_PROGRESS: '修复中',
  COMPLETED: '已完成'
}

const acceptanceStatusLabelMap = {
  UNACCEPTED: '尚未验收',
  WAITING: '等待验收',
  SUCCESS: '验收成功',
  REJECTED: '验收被驳回'
}

const currentOperatorName = computed(() => authStore.displayName || authStore.user?.username || '褰撳墠鐢ㄦ埛')
const imageAttachments = computed(() => formData.attachments.filter((item) => item.attachmentType === 'REPAIR_IMAGE'))
const fileAttachments = computed(() => formData.attachments.filter((item) => item.attachmentType === 'REPAIR_FILE'))
const currentPageCount = computed(() => pageData.value.records.length)
const approvedCount = computed(() => pageData.value.records.filter((item) => item.taskStatus === 'APPROVED').length)
const progressCount = computed(() => pageData.value.records.filter((item) => item.taskStatus === 'IN_PROGRESS').length)
const readyForAcceptanceCount = computed(() => pageData.value.records.filter((item) => canSubmitAcceptance(item)).length)
const actionableCount = computed(() =>
  pageData.value.records.filter((item) => canUpdateProgress(item) || canSubmitAcceptance(item)).length
)

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

function resetForm() {
  Object.assign(formData, {
    stepName: '',
    operationContent: '',
    materialsUsed: '',
    operatorName: currentOperatorName.value,
    logTime: currentDateTime(),
    progressStatus: 'IN_PROGRESS',
    remark: '',
    attachments: []
  })
}

async function loadPage() {
  loading.value = true
  try {
    pageData.value = await getMyRepairPageApi(queryForm)
  } finally {
    loading.value = false
  }
}

async function openDetail(id) {
  detail.value = await getRepairDetailApi(id)
  drawerVisible.value = true
}

function openLogDialog(row) {
  currentTaskId.value = row.id
  currentTask.value = row
  resetForm()
  dialogVisible.value = true
}

function canUpdateProgress(row) {
  return !!row && ['APPROVED', 'IN_PROGRESS'].includes(row.taskStatus)
}

function canSubmitAcceptance(row) {
  return row?.taskStatus === 'COMPLETED' && row?.acceptanceStatus === 'UNACCEPTED'
}

async function handleUpload(file, attachmentType) {
  const result = await uploadFileApi(file, attachmentType === 'REPAIR_IMAGE' ? 'repair-image' : 'repair-file')
  formData.attachments.push({
    ...result,
    attachmentType
  })
  ElMessage.success('文件上传成功')
}

async function handleImageUpload(option) {
  await handleUpload(option.file, 'REPAIR_IMAGE')
}

async function handleFileUpload(option) {
  await handleUpload(option.file, 'REPAIR_FILE')
}

function removeAttachment(fileUrl) {
  const index = formData.attachments.findIndex((item) => item.fileUrl === fileUrl)
  if (index >= 0) {
    formData.attachments.splice(index, 1)
  }
}

async function refreshCurrentDetail(id) {
  if (drawerVisible.value && detail.value?.id === id) {
    await openDetail(id)
  }
}

async function handleSubmitProgress() {
  const valid = await validateElForm(formRef, '璇峰厛瀹屽杽淇杩涘害淇℃伅鍚庡啀鎻愪氦')
  if (!valid) {
    return
  }
  saving.value = true
  try {
    await addRepairLogApi(currentTaskId.value, formData)
    ElMessage.success(formData.progressStatus === 'COMPLETED' ? '修复已标记为完成' : '修复进度已更新')
    dialogVisible.value = false
    await loadPage()
    await refreshCurrentDetail(currentTaskId.value)
  } finally {
    saving.value = false
  }
}

async function handleSubmitAcceptance(id) {
  try {
    await ElMessageBox.confirm('确认提交该修复任务进行验收吗？提交后将进入等待管理员验收状态。', '提交验收', {
      confirmButtonText: '确认提交',
      cancelButtonText: '取消',
      type: 'warning'
    })
    saving.value = true
    await applyRepairAcceptanceApi(id)
    ElMessage.success('已提交验收，等待管理员验收')
    await loadPage()
    await refreshCurrentDetail(id)
  } catch (error) {
    if (error === 'cancel' || error === 'close') {
      return
    }
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

loadPage()
</script>

<style scoped>
.process-metrics {
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

.dialog-overview__title {
  font-size: 22px;
}

.progress-upload-grid {
  grid-template-columns: repeat(2, minmax(0, 1fr));
  margin-bottom: 18px;
}

.table-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}

.upload-list {
  width: 100%;
  margin-top: 14px;
}

.upload-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 0;
}

.upload-item span {
  min-width: 0;
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.upload-item--image {
  align-items: center;
}

.upload-thumb {
  width: 56px;
  height: 56px;
  object-fit: cover;
  border-radius: 10px;
  border: 1px solid var(--border-line);
}

.upload-empty {
  padding: 12px 0 0;
}

@media (max-width: 960px) {
  .process-metrics,
  .progress-upload-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 720px) {
  .process-metrics,
  .progress-upload-grid {
    grid-template-columns: 1fr;
  }
}
</style>
