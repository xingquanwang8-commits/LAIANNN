<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="query-toolbar">
        <el-form :inline="true" :model="queryForm" class="query-form query-form--single-line">
          <el-form-item label="关键词" class="query-form__keyword query-form__keyword--wide">
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
      <el-table :data="pageData.records" v-loading="loading">
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
        <el-table-column label="操作" width="280" fixed="right">
          <template #default="{ row }">
            <el-button text type="primary" @click="openDetail(row.id)">详情</el-button>
            <el-button
              v-if="canUpdateProgress(row)"
              text
              type="primary"
              @click="openLogDialog(row.id)"
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

    <el-dialog v-model="dialogVisible" title="更新修复进度" width="680px">
      <el-form ref="formRef" :model="formData" :rules="rules" label-width="98px">
        <el-form-item label="步骤名称" prop="stepName">
          <el-input v-model="formData.stepName" />
        </el-form-item>
        <el-form-item label="处理内容" prop="operationContent">
          <el-input v-model="formData.operationContent" type="textarea" :rows="4" />
        </el-form-item>
        <el-form-item label="使用材料">
          <el-input v-model="formData.materialsUsed" />
        </el-form-item>
        <el-form-item label="操作人" prop="operatorName">
          <el-input v-model="formData.operatorName" />
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
        <el-form-item label="过程图片">
          <el-upload :show-file-list="false" :http-request="handleImageUpload">
            <el-button>上传图片</el-button>
          </el-upload>
          <div v-if="imageAttachments.length" class="upload-list">
            <div v-for="item in imageAttachments" :key="item.fileUrl" class="upload-item upload-item--image">
              <img :src="item.fileUrl" alt="修复过程图片" class="upload-thumb">
              <span>{{ item.fileName }}</span>
              <el-button text type="danger" @click="removeAttachment(item.fileUrl)">移除</el-button>
            </div>
          </div>
        </el-form-item>
        <el-form-item label="过程附件">
          <el-upload :show-file-list="false" :http-request="handleFileUpload">
            <el-button>上传附件</el-button>
          </el-upload>
          <div v-if="fileAttachments.length" class="upload-list">
            <div v-for="item in fileAttachments" :key="item.fileUrl" class="upload-item">
              <span>{{ item.fileName }}</span>
              <el-button text type="danger" @click="removeAttachment(item.fileUrl)">移除</el-button>
            </div>
          </div>
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="formData.remark" type="textarea" :rows="3" />
        </el-form-item>
      </el-form>
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
import StatusTag from '@/components/common/StatusTag.vue'
import RepairTaskDrawer from './components/RepairTaskDrawer.vue'
import { formatDateTime } from '@/utils/format'

const route = useRoute()
const loading = ref(false)
const saving = ref(false)
const dialogVisible = ref(false)
const drawerVisible = ref(false)
const formRef = ref()
const currentTaskId = ref(null)
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

const imageAttachments = computed(() => formData.attachments.filter((item) => item.attachmentType === 'REPAIR_IMAGE'))
const fileAttachments = computed(() => formData.attachments.filter((item) => item.attachmentType === 'REPAIR_FILE'))

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
    operatorName: '',
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

function openLogDialog(id) {
  currentTaskId.value = id
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
  formData.attachments = formData.attachments.filter((item) => item.fileUrl !== fileUrl)
}

async function refreshCurrentDetail(id) {
  if (drawerVisible.value && detail.value?.id === id) {
    await openDetail(id)
  }
}

async function handleSubmitProgress() {
  await formRef.value.validate()
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
    if (error !== 'cancel' && error !== 'close') {
      throw error
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
.table-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}

.upload-list {
  width: 100%;
  margin-top: 10px;
}

.upload-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 8px 0;
}

.upload-thumb {
  width: 52px;
  height: 52px;
  object-fit: cover;
  border-radius: 8px;
  border: 1px solid var(--border-line);
}
</style>
