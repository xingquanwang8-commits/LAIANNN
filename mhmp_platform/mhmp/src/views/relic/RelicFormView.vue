<template>
  <div class="page-shell" v-loading="loading">
    <section class="page-card page-card--section">
      <div class="overview-panel">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">MHMP Archive Workspace</div>
            <h2 class="overview-panel__title">{{ formOverviewTitle }}</h2>
            <p class="overview-panel__desc">{{ formOverviewDesc }}</p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">{{ isEdit ? `档案编号 ${form.relicNo || '--'}` : '编号保存后自动生成' }}</span>
            <span class="overview-chip overview-chip--accent">当前状态 {{ currentStatusLabel }}</span>
          </div>
        </div>

        <div class="metric-grid relic-form__metrics">
          <article class="metric-card">
            <span class="metric-card__label">当前状态</span>
            <strong class="metric-card__value">{{ currentStatusLabel }}</strong>
            <div class="metric-card__meta">业务校验与库位约束会随状态联动更新</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前库位</span>
            <strong class="metric-card__value relic-form__metric-text">{{ currentLocationLabel }}</strong>
            <div class="metric-card__meta">已出库状态下系统自动清空馆内库位</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">保存状态</span>
            <strong class="metric-card__value relic-form__metric-text">{{ currentPreservationLabel }}</strong>
            <div class="metric-card__meta">修复中仅允许选择病害类保存状态</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">数字化资料</span>
            <strong class="metric-card__value">{{ digitalAssetCount }}</strong>
            <div class="metric-card__meta">含主图、鉴定报告和业务附件</div>
          </article>
        </div>
      </div>
    </section>

    <section class="page-card page-card--section">
      <el-form ref="formRef" :model="form" :rules="rules" label-position="top">
        <div class="detail-stack">
          <section class="info-section">
            <div class="info-section__header">
              <div>
                <h3 class="info-section__title">基础档案信息</h3>
                <p class="info-section__desc">
                  完整录入文物名称、类别、材质、年代、来源和保护级别，形成可用于台账展示和后续业务流转的基础档案。
                </p>
              </div>
            </div>

            <div class="page-grid relic-form-grid">
              <el-form-item label="文物编号">
                <el-input :model-value="isEdit ? form.relicNo : '保存后自动生成'" disabled />
              </el-form-item>
              <el-form-item label="文物名称" prop="name">
                <el-input v-model="form.name" placeholder="请输入文物名称" />
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
              <el-form-item label="年代">
                <el-input v-model="form.era" placeholder="如：明代 / 商周时期" />
              </el-form-item>
              <el-form-item class="relic-form-grid__wide" label="来源">
                <el-input v-model="form.source" placeholder="如：考古发掘 / 社会捐赠 / 馆际调拨" />
              </el-form-item>
            </div>
          </section>

          <section class="info-section">
            <div class="info-section__header">
              <div>
                <h3 class="info-section__title">状态与保管信息</h3>
                <p class="info-section__desc">
                  根据文物所处业务阶段维护当前状态、保存状态和馆内库位，系统会在出库、修复等场景中自动校验填写合法性。
                </p>
              </div>
            </div>

            <div class="soft-note soft-note--accent">
              <div class="soft-note__title">当前状态填写提示</div>
              <div class="soft-note__desc">{{ statusRuleSummary }}</div>
            </div>

            <div class="page-grid relic-status-grid">
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
              <el-form-item label="保存条件" class="relic-status-grid__wide">
                <el-input v-model="form.storageCondition" type="textarea" :rows="3" placeholder="记录温湿度、光照、防震等保管条件" />
              </el-form-item>
              <el-form-item label="注意事项" class="relic-status-grid__wide">
                <el-input v-model="form.attentionNote" type="textarea" :rows="3" placeholder="填写搬运、展示、修复或盘点时的重点注意事项" />
              </el-form-item>
            </div>
          </section>

          <section class="info-section">
            <div class="info-section__header">
              <div>
                <h3 class="info-section__title">图像与鉴定资料</h3>
                <p class="info-section__desc">
                  维护主图与鉴定报告，保证文物档案具备基础展示能力，也便于业务审核和资料调阅。
                </p>
              </div>
            </div>

            <div class="page-grid upload-grid">
              <div class="upload-card">
                <div class="upload-card__header">文物主图</div>
                <div class="upload-card__body">
                  <img v-if="form.imageUrl" :src="form.imageUrl" alt="文物主图" class="upload-preview">
                  <div v-else class="upload-placeholder">暂无主图</div>
                  <el-upload :show-file-list="false" accept="image/*" :http-request="handleImageUpload">
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

            <div class="relic-image-panel">
              <div class="attachment-panel__header">
                <div>
                  <div class="attachment-panel__title">文物影像资料</div>
                  <div class="attachment-panel__hint">
                    支持连续上传多张文物影像，适合维护六面图、局部病害图和修补痕迹照片，并与主图共同构成完整数字档案。
                  </div>
                  <div class="upload-spec-note">
                    请依次上传为文物的正面、背面、左侧、右侧、顶面、底面六面图，若有瑕疵、裂痕、病害、修补痕迹也请按规定拍照上传。
                  </div>
                </div>
                <el-upload :show-file-list="false" accept="image/*" multiple :http-request="handleRelicImageUpload">
                  <el-button>上传文物影像</el-button>
                </el-upload>
              </div>

              <div v-if="relicImageAttachments.length" class="relic-image-list">
                <div v-for="item in relicImageAttachments" :key="item.fileUrl" class="relic-image-item">
                  <img :src="item.fileUrl" :alt="item.fileName || '文物影像'" class="relic-image-item__thumb">
                  <div class="relic-image-item__content">
                    <div class="relic-image-item__name">{{ item.fileName || '文物影像资料' }}</div>
                    <div class="relic-image-item__remark">
                      {{ form.imageUrl === item.fileUrl ? '当前已设为主图' : (item.remark || '文物影像资料') }}
                    </div>
                  </div>
                  <div class="relic-image-item__actions">
                    <el-button v-if="form.imageUrl !== item.fileUrl" text type="primary" @click="setCoverImage(item.fileUrl)">
                      设为主图
                    </el-button>
                    <el-button text type="danger" @click="removeRelicImage(item.fileUrl)">移除</el-button>
                  </div>
                </div>
              </div>
              <el-empty v-else class="empty-block" description="当前尚未上传文物影像资料，可先维护主图或一次上传多张影像。" />
            </div>
          </section>

          <section class="info-section">
            <div class="info-section__header">
              <div>
                <h3 class="info-section__title">业务附件</h3>
                <p class="info-section__desc">
                  可上传交接资料、说明文档、扫描件等业务附件，统一归档到文物档案下，便于后续查验与交接。
                </p>
              </div>
            </div>

            <div class="attachment-panel">
              <div class="attachment-panel__header">
                <div>
                  <div class="attachment-panel__title">业务资料附件</div>
                  <div class="attachment-panel__hint">上传后的附件将与文物主档案一并保存，适合存放清单、说明材料和补充证明文件。</div>
                </div>
                <el-upload :show-file-list="false" :http-request="handleAttachmentUpload">
                  <el-button>上传附件</el-button>
                </el-upload>
              </div>

              <div v-if="documentAttachments.length" class="attachment-list">
                <div v-for="item in documentAttachments" :key="item.fileUrl" class="attachment-item">
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
                <div class="attachment-empty__desc">上传后会在这里展示附件名称与操作入口，并与整页档案信息保持统一。</div>
              </div>
            </div>
          </section>

          <section class="info-section">
            <div class="info-section__header">
              <div>
                <h3 class="info-section__title">说明与备注</h3>
                <p class="info-section__desc">
                  补充文物描述、业务说明和备注，提升档案完整度，便于首页展示、详情页说明和业务台账导出。
                </p>
              </div>
            </div>

            <div class="page-grid relic-description-grid">
              <el-form-item label="文物描述">
                <el-input v-model="form.description" type="textarea" :rows="5" placeholder="填写文物背景、器型特征、保存情况等描述信息" />
              </el-form-item>
              <el-form-item label="备注">
                <el-input v-model="form.note" type="textarea" :rows="5" placeholder="填写需要保留给业务人员的补充说明" />
              </el-form-item>
            </div>
          </section>

          <div class="relic-form__actions">
            <div class="relic-form__actions-hint">
              提交后将同步更新文物档案，并作为后续出入库、盘点、修复等业务的基础数据来源。
            </div>
            <div class="relic-form__actions-buttons">
              <el-button @click="router.back()">取消</el-button>
              <el-button type="primary" :loading="submitting" @click="handleSubmit">
                {{ isEdit ? '保存修改' : '提交新增' }}
              </el-button>
            </div>
          </div>
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
import { validateElForm } from '@/utils/form'
import { resolveDictLabel } from '@/utils/format'

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
  TO_BE_INBOUND: {
    location: '待入库文物应先明确拟入库库位，便于后续提交入库并进入审批流程。',
    preservation: '建议按接收入馆时的真实保存状态建档，便于审批时核对实物情况。'
  },
  IN_STOCK: {
    location: '在库文物需要保留馆内库位，便于盘点、出库和业务追踪。',
    preservation: '可按文物当前实际保存情况选择完整或病害状态。'
  },
  INBOUND_PENDING: {
    location: '入库待审批阶段需要先确定拟入库库位，审批通过后可直接衔接入库流程。',
    preservation: '建议按文物接收入馆时的真实保存状态建档。'
  },
  OUTBOUND_PENDING: {
    location: '出库待审批期间文物仍在馆内，需要继续保留当前库位信息。',
    preservation: '保持文物真实保存状态，便于审批前复核。'
  },
  OUT_STOCK: {
    location: '已出库文物不再保留馆内库位，系统会自动清空库位信息。',
    preservation: '保存状态继续记录文物实体情况，方便归还后衔接业务。'
  },
  IN_REPAIR: {
    location: '修复中文物仅允许放在修复库位，便于研究员统一管理。',
    preservation: '修复中仅允许选择病害类保存状态，避免与完整文物混淆。'
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
  currentStatus: 'TO_BE_INBOUND',
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
  if (!shouldEditStorageLocation.value || form.currentStatus === 'OUT_STOCK') {
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
const shouldEditStorageLocation = computed(() => isEdit.value && form.currentStatus !== 'TO_BE_INBOUND')
const locationSelectDisabled = computed(() => !shouldEditStorageLocation.value || form.currentStatus === 'OUT_STOCK')
const locationPlaceholder = computed(() =>
  !shouldEditStorageLocation.value
    ? '鏂板缓妗ｆ鏃朵笉濉啓搴撲綅锛屽叆搴撴椂鍐嶅綍鍏?'
    :
  form.currentStatus === 'OUT_STOCK' ? '已出库状态无需选择库位' : '请选择藏品库位'
)
const preservationPlaceholder = computed(() =>
  form.currentStatus === 'IN_REPAIR' ? '修复中仅可选择病害类保存状态' : '请选择保存状态'
)
const currentStatusHints = computed(() => STATUS_RULE_HINTS[form.currentStatus] || STATUS_RULE_HINTS.IN_STOCK)
const currentStatusLabel = computed(() => resolveDictLabel(statusOptions.value, form.currentStatus) || '待设置')
const currentLocationLabel = computed(() => {
  if (!shouldEditStorageLocation.value) {
    return '鍏ュ簱鏃跺～鍐?'
  }
  if (form.currentStatus === 'OUT_STOCK') {
    return '系统自动清空'
  }
  return resolveDictLabel(locationOptions.value, form.storageLocationCode) || '待选择'
})
const currentPreservationLabel = computed(() =>
  resolveDictLabel(preservationOptions.value, form.preservationStatusCode) || '待选择'
)
const relicImageAttachments = computed(() =>
  form.attachments.filter((item) => item.attachmentType === 'RELIC_IMAGE')
)
const documentAttachments = computed(() =>
  form.attachments.filter((item) => item.attachmentType !== 'RELIC_IMAGE')
)
const digitalAssetCount = computed(() => {
  const assetUrls = new Set()
  if (form.imageUrl) {
    assetUrls.add(form.imageUrl)
  }
  if (form.appraisalReportUrl) {
    assetUrls.add(form.appraisalReportUrl)
  }
  form.attachments.forEach((item) => {
    if (item?.fileUrl) {
      assetUrls.add(item.fileUrl)
    }
  })
  return assetUrls.size
})
const formOverviewTitle = computed(() => (isEdit.value ? '完善文物档案' : '新建文物档案'))
const formOverviewDesc = computed(() => (
  isEdit.value
    ? '在不改变现有业务逻辑的前提下补全文物档案、保管状态和数字资料，保证详情页、台账导出与后续业务流转展示一致。'
    : '录入新入藏文物的基础档案、保管状态和数字资料，形成可直接投入演示与业务流转的标准文物档案。'
))
const statusRuleSummary = computed(() => `${currentStatusHints.value.location} ${currentStatusHints.value.preservation}`)

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
  if (!shouldEditStorageLocation.value) {
    if (value) {
      callback(new Error('鏂板缓鏂囩墿妗ｆ鏃朵笉闇€濉啓搴撲綅锛岃鍦ㄥ叆搴撴椂鍐嶅綍鍏?'))
      return
    }
    callback()
    return
  }
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
    currentStatus: detail.currentStatus || 'TO_BE_INBOUND',
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

async function handleRelicImageUpload(option) {
  const result = await handleUpload(option.file, 'relic-image')
  if (!form.attachments.some((item) => item.fileUrl === result.fileUrl)) {
    form.attachments.push({
      ...result,
      attachmentType: 'RELIC_IMAGE',
      remark: '文物影像资料'
    })
  }
  if (!form.imageUrl) {
    form.imageUrl = result.fileUrl
  }
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

function removeRelicImage(fileUrl) {
  const nextRelicImage = relicImageAttachments.value.find((item) => item.fileUrl !== fileUrl)
  removeAttachment(fileUrl)
  if (form.imageUrl === fileUrl) {
    form.imageUrl = nextRelicImage?.fileUrl || ''
  }
}

function setCoverImage(fileUrl) {
  form.imageUrl = fileUrl
  ElMessage.success('已设为文物主图')
}

async function handleCreateCategory() {
  const valid = await validateElForm(categoryFormRef, '璇峰厛杈撳叆鏂囩墿鍒嗙被鍚嶇О')
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
  const valid = await validateElForm(materialFormRef, '璇峰厛杈撳叆鏂囩墿鏉愯川鍚嶇О')
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
  const valid = await validateElForm(formRef, '璇峰厛瀹屽杽鏂囩墿妗ｆ淇℃伅鍚庡啀鎻愪氦')
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
.relic-form__metrics {
  grid-template-columns: repeat(4, minmax(0, 1fr));
}

.relic-form__metric-text {
  font-size: 22px;
  line-height: 1.3;
}

.relic-form-grid {
  grid-template-columns: repeat(3, minmax(0, 1fr));
}

.relic-form-grid__wide {
  grid-column: span 2;
}

.inline-action-field {
  display: grid;
  grid-template-columns: minmax(0, 1fr) auto;
  gap: 12px;
  width: 100%;
}

.relic-status-grid,
.relic-description-grid {
  grid-template-columns: repeat(2, minmax(0, 1fr));
}

.relic-status-grid__wide {
  grid-column: span 2;
}

.field-hint {
  margin-top: 8px;
  color: var(--text-second);
  font-size: 12px;
  line-height: 1.7;
}

.upload-grid {
  grid-template-columns: repeat(2, minmax(0, 1fr));
}

.upload-card {
  padding: 18px;
  border: 1px solid rgba(123, 44, 42, 0.08);
  border-radius: 18px;
  background:
    radial-gradient(circle at top right, rgba(184, 138, 68, 0.1), transparent 28%),
    linear-gradient(180deg, rgba(255, 255, 255, 0.98), rgba(248, 242, 236, 0.94));
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

.upload-spec-note {
  margin-top: 8px;
  color: var(--text-second);
  font-size: 12px;
  line-height: 1.7;
}

.upload-preview {
  width: 100%;
  max-width: 280px;
  height: 220px;
  object-fit: contain;
  border-radius: 14px;
  border: 1px solid rgba(123, 44, 42, 0.08);
  background: linear-gradient(180deg, #faf8f6, #f2f4f7);
}

.upload-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  min-height: 220px;
  border: 1px dashed rgba(123, 44, 42, 0.18);
  border-radius: 14px;
  color: var(--text-second);
  background: rgba(255, 255, 255, 0.68);
}

.upload-placeholder--inline {
  min-height: auto;
  border: none;
  padding: 0;
  background: transparent;
}

.attachment-panel {
  width: 100%;
  padding: 18px;
  border: 1px solid rgba(123, 44, 42, 0.08);
  border-radius: 18px;
  background:
    linear-gradient(180deg, rgba(255, 255, 255, 0.98), rgba(248, 243, 236, 0.94)),
    #fff;
}

.relic-image-panel {
  width: 100%;
  padding: 18px;
  border: 1px solid rgba(123, 44, 42, 0.08);
  border-radius: 18px;
  background:
    radial-gradient(circle at top right, rgba(184, 138, 68, 0.08), transparent 24%),
    linear-gradient(180deg, rgba(255, 255, 255, 0.98), rgba(248, 243, 236, 0.94));
}

.relic-image-list {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 14px;
}

.relic-image-item {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 14px;
  border: 1px solid rgba(123, 44, 42, 0.08);
  border-radius: 16px;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.96), rgba(249, 244, 238, 0.94));
}

.relic-image-item__thumb {
  width: 88px;
  height: 88px;
  flex-shrink: 0;
  object-fit: cover;
  border-radius: 14px;
  border: 1px solid rgba(123, 44, 42, 0.08);
  background: linear-gradient(180deg, #faf8f6, #f2f4f7);
}

.relic-image-item__content {
  flex: 1;
  min-width: 0;
}

.relic-image-item__name {
  font-weight: 700;
  word-break: break-all;
}

.relic-image-item__remark {
  margin-top: 6px;
  color: var(--text-second);
  font-size: 12px;
  line-height: 1.6;
}

.relic-image-item__actions {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 8px;
  flex-shrink: 0;
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
  border-top: 1px solid rgba(123, 44, 42, 0.08);
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
  border-top: 1px solid rgba(123, 44, 42, 0.08);
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
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  padding: 18px 20px;
  border: 1px solid rgba(123, 44, 42, 0.08);
  border-radius: 18px;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.98), rgba(246, 239, 231, 0.96));
}

.relic-form__actions-hint {
  color: var(--text-second);
  font-size: 13px;
  line-height: 1.8;
}

.relic-form__actions-buttons {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-shrink: 0;
}

@media (max-width: 1100px) {
  .relic-form__metrics,
  .relic-form-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 960px) {
  .upload-grid,
  .relic-image-list,
  .relic-status-grid,
  .relic-description-grid {
    grid-template-columns: 1fr;
  }

  .relic-form-grid__wide,
  .relic-status-grid__wide {
    grid-column: span 1;
  }

  .inline-action-field,
  .attachment-panel__header,
  .attachment-item,
  .relic-image-item,
  .relic-form__actions {
    grid-template-columns: 1fr;
    flex-direction: column;
    align-items: stretch;
  }

  .attachment-item__actions,
  .relic-image-item__actions,
  .relic-form__actions-buttons {
    justify-content: flex-end;
  }
}

@media (max-width: 640px) {
  .relic-form__metrics,
  .relic-form-grid {
    grid-template-columns: 1fr;
  }
}
</style>
