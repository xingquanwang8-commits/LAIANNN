<template>
  <div class="page-shell" v-loading="loading">
    <section class="page-card page-card--section">
      <el-form ref="formRef" :model="form" :rules="rules" label-position="top">
        <div class="page-grid relic-form-grid">
          <el-form-item label="文物编号">
            <el-input :model-value="isEdit ? form.relicNo : '保存后自动生成'" disabled />
          </el-form-item>
          <el-form-item label="文物名称" prop="name">
            <el-input v-model="form.name" placeholder="请输入文物名称" />
          </el-form-item>
          <el-form-item label="文物类别" prop="categoryCode">
            <div class="inline-action-field">
              <el-select v-model="form.categoryCode" placeholder="请选择文物类别">
                <el-option
                  v-for="item in categoryOptions"
                  :key="item.itemValue"
                  :label="item.itemLabel"
                  :value="item.itemValue"
                />
              </el-select>
              <el-button plain @click="categoryDialogVisible = true">新增分类</el-button>
            </div>
          </el-form-item>
          <el-form-item label="文物材质" prop="materialCode">
            <div class="inline-action-field">
              <el-select v-model="form.materialCode" placeholder="请选择文物材质">
                <el-option
                  v-for="item in materialOptions"
                  :key="item.itemValue"
                  :label="item.itemLabel"
                  :value="item.itemValue"
                />
              </el-select>
              <el-button plain @click="materialDialogVisible = true">新增材质</el-button>
            </div>
          </el-form-item>
          <el-form-item label="藏品库位" prop="storageLocationCode">
            <el-select
              v-model="form.storageLocationCode"
              :placeholder="locationPlaceholder"
              :disabled="locationSelectDisabled"
              clearable
            >
              <el-option
                v-for="item in availableLocationOptions"
                :key="item.itemValue"
                :label="item.itemLabel"
                :value="item.itemValue"
              />
            </el-select>
            <div class="field-hint">{{ currentStatusHints.location }}</div>
          </el-form-item>
          <el-form-item label="当前状态" prop="currentStatus">
            <el-select v-model="form.currentStatus" placeholder="请选择当前状态">
              <el-option
                v-for="item in statusOptions"
                :key="item.itemValue"
                :label="item.itemLabel"
                :value="item.itemValue"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="保存状态" prop="preservationStatusCode">
            <el-select v-model="form.preservationStatusCode" :placeholder="preservationPlaceholder" clearable>
              <el-option
                v-for="item in availablePreservationOptions"
                :key="item.itemValue"
                :label="item.itemLabel"
                :value="item.itemValue"
              />
            </el-select>
            <div class="field-hint">{{ currentStatusHints.preservation }}</div>
          </el-form-item>
          <el-form-item label="年代">
            <el-input v-model="form.era" placeholder="如：明代 / 商周时期" />
          </el-form-item>
          <el-form-item label="来源">
            <el-input v-model="form.source" placeholder="如：考古发掘 / 社会捐赠" />
          </el-form-item>
          <el-form-item label="保护级别" prop="protectionLevel">
            <el-select v-model="form.protectionLevel" placeholder="请选择保护级别" clearable>
              <el-option
                v-for="item in protectionLevelOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              />
            </el-select>
          </el-form-item>
        </div>

        <div class="page-grid upload-grid">
          <div class="upload-card">
            <div class="upload-card__header">文物主图</div>
            <div class="upload-card__body">
              <img v-if="form.imageUrl" :src="form.imageUrl" alt="文物主图" class="upload-preview">
              <div v-else class="upload-placeholder">暂无主图</div>
              <el-upload :show-file-list="false" :http-request="handleImageUpload">
                <el-button>上传主图</el-button>
              </el-upload>
            </div>
          </div>

          <div class="upload-card">
            <div class="upload-card__header">鉴定报告</div>
            <div class="upload-card__body upload-card__body--left">
              <a v-if="form.appraisalReportUrl" :href="form.appraisalReportUrl" target="_blank" rel="noreferrer">
                查看当前鉴定报告
              </a>
              <span v-else class="upload-placeholder upload-placeholder--inline">暂无鉴定报告</span>
              <el-upload :show-file-list="false" :http-request="handleReportUpload">
                <el-button>上传报告</el-button>
              </el-upload>
            </div>
          </div>
        </div>

        <el-form-item label="业务附件">
          <div class="attachment-panel">
            <div class="attachment-panel__header">
              <div>
                <div class="attachment-panel__title">业务资料附件</div>
                <div class="attachment-panel__hint">可上传交接资料、清单、说明文档或扫描件，统一归入文物档案。</div>
              </div>
              <el-upload :show-file-list="false" :http-request="handleAttachmentUpload">
                <el-button>上传附件</el-button>
              </el-upload>
            </div>
            <div v-if="form.attachments.length" class="attachment-list">
              <div v-for="item in form.attachments" :key="item.fileUrl" class="attachment-item">
                <div class="attachment-item__content">
                  <div class="attachment-item__name">{{ item.fileName }}</div>
                  <div class="attachment-item__remark">{{ item.remark || '业务附件' }}</div>
                </div>
                <div class="attachment-item__actions">
                  <a :href="item.fileUrl" target="_blank" rel="noreferrer">查看附件</a>
                  <el-button text type="danger" @click="removeAttachment(item.fileUrl)">移除</el-button>
                </div>
              </div>
            </div>
            <div v-else class="attachment-empty">
              <div class="attachment-empty__title">尚未上传业务附件</div>
              <div class="attachment-empty__desc">上传后会在这里展示附件名称与操作入口，和整页档案信息保持一致。</div>
            </div>
          </div>
        </el-form-item>

        <el-form-item label="保存条件">
          <el-input v-model="form.storageCondition" type="textarea" :rows="2" />
        </el-form-item>
        <el-form-item label="注意事项">
          <el-input v-model="form.attentionNote" type="textarea" :rows="2" />
        </el-form-item>
        <el-form-item label="文物描述">
          <el-input v-model="form.description" type="textarea" :rows="4" />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="form.note" type="textarea" :rows="2" />
        </el-form-item>

        <div class="relic-form__actions">
          <el-button @click="router.back()">取消</el-button>
          <el-button type="primary" :loading="submitting" @click="handleSubmit">
            {{ isEdit ? '保存修改' : '提交新增' }}
          </el-button>
        </div>
      </el-form>
    </section>

    <el-dialog v-model="categoryDialogVisible" title="新增文物分类" width="420px">
      <el-form ref="categoryFormRef" :model="categoryForm" :rules="categoryRules" label-width="88px">
        <el-form-item label="分类名称" prop="categoryName">
          <el-input v-model="categoryForm.categoryName" maxlength="20" show-word-limit />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="categoryDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="creatingCategory" @click="handleCreateCategory">保存分类</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="materialDialogVisible" title="新增文物材质" width="420px">
      <el-form ref="materialFormRef" :model="materialForm" :rules="materialRules" label-width="88px">
        <el-form-item label="材质名称" prop="materialName">
          <el-input v-model="materialForm.materialName" maxlength="20" show-word-limit />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="materialDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="creatingMaterial" @click="handleCreateMaterial">保存材质</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { computed, reactive, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { uploadFileApi } from '@/api/file'
import {
  createRelicApi,
  createRelicCategoryApi,
  createRelicMaterialApi,
  getRelicDetailApi,
  updateRelicApi
} from '@/api/relic'
import { useDictStore } from '@/stores/dict'

const PROTECTION_LEVEL_OPTIONS = [
  { label: '国家一级文物', value: '国家一级文物' },
  { label: '国家二级文物', value: '国家二级文物' },
  { label: '国家三级文物', value: '国家三级文物' },
  { label: '一般文物', value: '一般文物' },
  { label: '未定级文物', value: '未定级文物' }
]

const DAMAGE_PRESERVATION_CODES = [
  'INCOMPLETE',
  'SEVERE_INCOMPLETE',
  'FRAGMENTED',
  'PHYSICAL_DAMAGE',
  'CHEMICAL_DEGRADATION',
  'BIOLOGICAL_DISEASE'
]

const STATUS_RULE_HINTS = {
  IN_STOCK: {
    location: '在库文物需要保留馆内库位，便于盘点、出库和业务追踪。',
    preservation: '可按文物当前实际保存情况选择完整或病害状态。'
  },
  INBOUND_PENDING: {
    location: '入库待审批阶段需先确定拟入库库位，审批通过后可直接衔接入库流程。',
    preservation: '建议按文物接收入馆时的真实保存状态建档。'
  },
  OUTBOUND_PENDING: {
    location: '出库待审批期间文物仍在馆内，需继续保留当前库位信息。',
    preservation: '保持文物真实保存状态，便于审批前复核。'
  },
  OUT_STOCK: {
    location: '已出库文物不再保留馆内库位，系统会自动清空库位信息。',
    preservation: '保存状态继续记录文物实物情况，方便归还后衔接业务。'
  },
  IN_REPAIR: {
    location: '修复中文物仅允许放在修复库位，便于研究员统一管理。',
    preservation: '修复中仅允许选择病害类保存状态，避免和完整文物混淆。'
  }
}

const route = useRoute()
const router = useRouter()
const dictStore = useDictStore()

const formRef = ref(null)
const categoryFormRef = ref(null)
const materialFormRef = ref(null)
const loading = ref(false)
const submitting = ref(false)
const categoryDialogVisible = ref(false)
const materialDialogVisible = ref(false)
const creatingCategory = ref(false)
const creatingMaterial = ref(false)
const isEdit = computed(() => Boolean(route.params.id))

const form = reactive({
  relicNo: '',
  name: '',
  categoryCode: '',
  materialCode: '',
  era: '',
  source: '',
  storageLocationCode: '',
  preservationStatusCode: '',
  currentStatus: 'IN_STOCK',
  protectionLevel: '',
  storageCondition: '',
  attentionNote: '',
  description: '',
  note: '',
  imageUrl: '',
  appraisalReportUrl: '',
  attachments: []
})

const categoryForm = reactive({
  categoryName: ''
})

const materialForm = reactive({
  materialName: ''
})

const categoryRules = {
  categoryName: [{ required: true, message: '请输入分类名称', trigger: 'blur' }]
}

const materialRules = {
  materialName: [{ required: true, message: '请输入材质名称', trigger: 'blur' }]
}

const categoryOptions = computed(() => dictStore.itemsMap.relic_category || [])
const materialOptions = computed(() => dictStore.itemsMap.relic_material || [])
const statusOptions = computed(() => dictStore.itemsMap.relic_status || [])
const locationOptions = computed(() => dictStore.itemsMap.storage_location || [])
const preservationOptions = computed(() => dictStore.itemsMap.preservation_status || [])
const protectionLevelOptions = computed(() => PROTECTION_LEVEL_OPTIONS)
const repairLocationOptions = computed(() =>
  locationOptions.value.filter(
    (item) => item.itemValue === 'LOC_D' || item.itemLabel?.includes('修复')
  )
)
const availableLocationOptions = computed(() => {
  if (form.currentStatus === 'OUT_STOCK') {
    return []
  }
  if (form.currentStatus === 'IN_REPAIR' && repairLocationOptions.value.length) {
    return repairLocationOptions.value
  }
  return locationOptions.value
})
const availablePreservationOptions = computed(() => {
  if (form.currentStatus === 'IN_REPAIR') {
    return preservationOptions.value.filter((item) => DAMAGE_PRESERVATION_CODES.includes(item.itemValue))
  }
  return preservationOptions.value
})
const locationSelectDisabled = computed(() => form.currentStatus === 'OUT_STOCK')
const locationPlaceholder = computed(() =>
  form.currentStatus === 'OUT_STOCK' ? '已出库状态无需选择库位' : '请选择藏品库位'
)
const preservationPlaceholder = computed(() =>
  form.currentStatus === 'IN_REPAIR' ? '修复中仅可选择病害类保存状态' : '请选择保存状态'
)
const currentStatusHints = computed(() => STATUS_RULE_HINTS[form.currentStatus] || STATUS_RULE_HINTS.IN_STOCK)

function hasAvailableOption(options, value) {
  return options.some((item) => item.itemValue === value)
}

function getRepairPreservationFallback() {
  return (
    availablePreservationOptions.value.find((item) => item.itemValue === 'PHYSICAL_DAMAGE')?.itemValue
    || availablePreservationOptions.value[0]?.itemValue
    || ''
  )
}

function normalizeFormByStatus() {
  if (form.currentStatus === 'OUT_STOCK') {
    form.storageLocationCode = ''
  } else if (form.currentStatus === 'IN_REPAIR' && availableLocationOptions.value.length) {
    if (!hasAvailableOption(availableLocationOptions.value, form.storageLocationCode)) {
      form.storageLocationCode = availableLocationOptions.value[0].itemValue
    }
  }

  if (form.currentStatus === 'IN_REPAIR' && availablePreservationOptions.value.length) {
    if (!hasAvailableOption(availablePreservationOptions.value, form.preservationStatusCode)) {
      form.preservationStatusCode = getRepairPreservationFallback()
    }
    return
  }

  if (
    form.preservationStatusCode
    && preservationOptions.value.length
    && !hasAvailableOption(availablePreservationOptions.value, form.preservationStatusCode)
  ) {
    form.preservationStatusCode = ''
  }
}

function validateStorageLocation(_rule, value, callback) {
  if (form.currentStatus === 'OUT_STOCK') {
    if (value) {
      callback(new Error('已出库文物不应保留馆内库位'))
      return
    }
    callback()
    return
  }
  if (!value) {
    callback(new Error('请选择符合当前状态的藏品库位'))
    return
  }
  if (!hasAvailableOption(availableLocationOptions.value, value)) {
    callback(new Error('当前状态下不可选择该库位'))
    return
  }
  callback()
}

function validatePreservationStatus(_rule, value, callback) {
  if (!value) {
    callback(new Error('请选择保存状态'))
    return
  }
  if (!hasAvailableOption(availablePreservationOptions.value, value)) {
    callback(new Error('当前状态下不可选择该保存状态'))
    return
  }
  callback()
}

const rules = {
  name: [{ required: true, message: '请输入文物名称', trigger: 'blur' }],
  categoryCode: [{ required: true, message: '请选择文物类别', trigger: 'change' }],
  materialCode: [{ required: true, message: '请选择文物材质', trigger: 'change' }],
  currentStatus: [{ required: true, message: '请选择当前状态', trigger: 'change' }],
  storageLocationCode: [{ validator: validateStorageLocation, trigger: 'change' }],
  preservationStatusCode: [{ validator: validatePreservationStatus, trigger: 'change' }]
}

function fillForm(detail) {
  Object.assign(form, {
    relicNo: detail.relicNo || '',
    name: detail.name || '',
    categoryCode: detail.categoryCode || '',
    materialCode: detail.materialCode || '',
    era: detail.era || '',
    source: detail.source || '',
    storageLocationCode: detail.storageLocationCode || '',
    preservationStatusCode: detail.preservationStatusCode || '',
    currentStatus: detail.currentStatus || 'IN_STOCK',
    protectionLevel: detail.protectionLevel || '',
    storageCondition: detail.storageCondition || '',
    attentionNote: detail.attentionNote || '',
    description: detail.description || '',
    note: detail.note || '',
    imageUrl: detail.imageUrl || '',
    appraisalReportUrl: detail.appraisalReportUrl || '',
    attachments: detail.attachments || []
  })
}

async function loadDetail() {
  if (!isEdit.value) {
    return
  }
  loading.value = true
  try {
    const detail = await getRelicDetailApi(route.params.id)
    fillForm(detail)
  } finally {
    loading.value = false
  }
}

async function handleUpload(file, bizType) {
  const result = await uploadFileApi(file, bizType)
  ElMessage.success('文件上传成功')
  return result
}

async function handleImageUpload(option) {
  const result = await handleUpload(option.file, 'relic-image')
  form.imageUrl = result.fileUrl
}

async function handleReportUpload(option) {
  const result = await handleUpload(option.file, 'relic-report')
  form.appraisalReportUrl = result.fileUrl
}

async function handleAttachmentUpload(option) {
  const result = await handleUpload(option.file, 'relic-attachment')
  form.attachments.push({
    ...result,
    attachmentType: 'DOCUMENT',
    remark: '档案附件'
  })
}

function removeAttachment(fileUrl) {
  form.attachments = form.attachments.filter((item) => item.fileUrl !== fileUrl)
}

async function handleCreateCategory() {
  const valid = await categoryFormRef.value?.validate().catch(() => false)
  if (!valid) {
    return
  }
  creatingCategory.value = true
  try {
    const categoryName = categoryForm.categoryName.trim()
    await createRelicCategoryApi({ categoryName })
    const items = await dictStore.refreshItems('relic_category')
    const createdItem = items.find((item) => item.itemLabel === categoryName)
    if (createdItem) {
      form.categoryCode = createdItem.itemValue
    }
    categoryForm.categoryName = ''
    categoryDialogVisible.value = false
    ElMessage.success('文物分类已新增')
  } finally {
    creatingCategory.value = false
  }
}

async function handleCreateMaterial() {
  const valid = await materialFormRef.value?.validate().catch(() => false)
  if (!valid) {
    return
  }
  creatingMaterial.value = true
  try {
    const materialName = materialForm.materialName.trim()
    await createRelicMaterialApi({ materialName })
    const items = await dictStore.refreshItems('relic_material')
    const createdItem = items.find((item) => item.itemLabel === materialName)
    if (createdItem) {
      form.materialCode = createdItem.itemValue
    }
    materialForm.materialName = ''
    materialDialogVisible.value = false
    ElMessage.success('文物材质已新增')
  } finally {
    creatingMaterial.value = false
  }
}

async function handleSubmit() {
  normalizeFormByStatus()
  const valid = await formRef.value?.validate().catch(() => false)
  if (!valid) {
    return
  }
  submitting.value = true
  try {
    if (isEdit.value) {
      await updateRelicApi(route.params.id, form)
      ElMessage.success('文物信息已更新')
      router.push(`/relic/detail/${route.params.id}`)
    } else {
      const id = await createRelicApi(form)
      ElMessage.success('文物已新增')
      router.push(`/relic/detail/${id}`)
    }
  } finally {
    submitting.value = false
  }
}

dictStore.ensureMultipleItems([
  'relic_category',
  'relic_material',
  'relic_status',
  'storage_location',
  'preservation_status'
])

watch(
  [() => form.currentStatus, locationOptions, preservationOptions],
  () => {
    normalizeFormByStatus()
    formRef.value?.clearValidate?.(['storageLocationCode', 'preservationStatusCode'])
  },
  { immediate: true }
)

loadDetail()
</script>

<style scoped>
.relic-form-grid {
  grid-template-columns: repeat(2, minmax(0, 1fr));
}

.inline-action-field {
  display: grid;
  grid-template-columns: minmax(0, 1fr) auto;
  gap: 12px;
  width: 100%;
}

.field-hint {
  margin-top: 8px;
  color: var(--text-second);
  font-size: 12px;
  line-height: 1.6;
}

.upload-grid {
  grid-template-columns: repeat(2, minmax(0, 1fr));
  margin-bottom: 18px;
}

.upload-card {
  padding: 18px;
  border: 1px solid var(--border-line);
  border-radius: 14px;
  background: #fff;
}

.upload-card__header {
  margin-bottom: 12px;
  font-weight: 700;
}

.upload-card__body {
  display: flex;
  flex-direction: column;
  gap: 12px;
  align-items: center;
}

.upload-card__body--left {
  align-items: flex-start;
}

.upload-preview {
  width: 100%;
  max-width: 280px;
  height: 220px;
  object-fit: contain;
  border-radius: 12px;
  border: 1px solid var(--border-line);
  background: #faf8f6;
}

.upload-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  min-height: 220px;
  border: 1px dashed var(--border-line);
  border-radius: 12px;
  color: var(--text-second);
}

.upload-placeholder--inline {
  min-height: auto;
  border: none;
  padding: 0;
}

.attachment-panel {
  width: 100%;
  padding: 18px;
  border: 1px solid var(--border-line);
  border-radius: 14px;
  background: #fff;
}

.attachment-panel__header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 14px;
}

.attachment-panel__title {
  font-weight: 700;
}

.attachment-panel__hint {
  margin-top: 6px;
  color: var(--text-second);
  font-size: 13px;
  line-height: 1.7;
}

.attachment-list {
  width: 100%;
  border-top: 1px solid var(--border-line);
}

.attachment-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  padding: 14px 0;
  border-bottom: 1px solid rgba(226, 225, 227, 0.9);
}

.attachment-item:last-child {
  border-bottom: none;
}

.attachment-item__content {
  flex: 1;
  min-width: 0;
}

.attachment-item__name {
  font-weight: 600;
  word-break: break-all;
}

.attachment-item__remark {
  margin-top: 4px;
  color: var(--text-second);
  font-size: 13px;
}

.attachment-item__actions {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-shrink: 0;
}

.attachment-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 120px;
  border-top: 1px solid var(--border-line);
  color: var(--text-second);
  text-align: center;
}

.attachment-empty__title {
  font-weight: 600;
  color: var(--text-main);
}

.attachment-empty__desc {
  margin-top: 8px;
  max-width: 420px;
  font-size: 13px;
  line-height: 1.7;
}

.relic-form__actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 16px;
}

@media (max-width: 960px) {
  .relic-form-grid,
  .upload-grid {
    grid-template-columns: 1fr;
  }

  .inline-action-field {
    grid-template-columns: 1fr;
  }

  .attachment-panel__header,
  .attachment-item {
    flex-direction: column;
    align-items: stretch;
  }

  .attachment-item__actions {
    justify-content: flex-end;
  }
}
</style>
