<template>
  <el-dialog v-model="dialogVisible" :title="dialogTitle" width="660px" @closed="handleClosed">
    <div class="detail-stack">
      <div class="overview-panel overview-panel--compact dialog-overview">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">MHMP Acceptance Review</div>
            <h3 class="overview-panel__title dialog-overview__title">{{ dialogTitle }}</h3>
            <p class="overview-panel__desc">{{ dialogDesc }}</p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">任务 {{ props.taskId || '--' }}</span>
            <span class="overview-chip overview-chip--accent">{{ isRejectMode ? '当前动作：驳回' : '当前动作：确认验收' }}</span>
          </div>
        </div>
      </div>

      <div class="soft-note" :class="isRejectMode ? '' : 'soft-note--accent'">
        <div class="soft-note__title">{{ isRejectMode ? '驳回说明' : '验收填写要求' }}</div>
        <div class="soft-note__desc">
          {{ isRejectMode ? '驳回时必须填写原因，任务会退回修复过程页继续处理。' : '确认验收时需要填写验收时间，并补全返库位置和修复后的保存状态。' }}
        </div>
      </div>

      <el-form ref="formRef" :model="formData" :rules="rules" label-width="108px">
        <el-form-item label="验收时间" prop="acceptanceTime">
          <el-date-picker v-model="formData.acceptanceTime" type="datetime" value-format="YYYY-MM-DDTHH:mm:ss" />
        </el-form-item>
        <el-form-item v-if="!isRejectMode" label="保存状态">
          <el-select v-model="formData.preservationStatusCode" clearable placeholder="请选择修复后的保存状态">
            <el-option
              v-for="item in preservationOptions"
              :key="item.itemValue"
              :label="item.itemLabel"
              :value="item.itemValue"
            />
          </el-select>
        </el-form-item>
        <el-form-item v-if="!isRejectMode" label="返库位置">
          <el-select v-model="formData.storageLocationCode" clearable placeholder="请选择返库位置">
            <el-option
              v-for="item in locationOptions"
              :key="item.itemValue"
              :label="item.itemLabel"
              :value="item.itemValue"
            />
          </el-select>
        </el-form-item>
        <el-form-item :label="isRejectMode ? '驳回原因' : '验收意见'">
          <el-input
            v-model="formData.acceptanceRemark"
            type="textarea"
            :rows="3"
            :placeholder="isRejectMode ? '请填写驳回原因' : '可填写验收意见，留空则直接通过'"
          />
        </el-form-item>
        <el-form-item label="后续建议">
          <el-input
            v-model="formData.followUpSuggestion"
            type="textarea"
            :rows="3"
            placeholder="可填写返库后的保管建议、后续观察建议等"
          />
        </el-form-item>
      </el-form>
    </div>

    <template #footer>
      <el-button @click="dialogVisible = false">取消</el-button>
      <template v-if="isRejectMode">
        <el-button @click="switchAction('PASS')">返回确认验收</el-button>
        <el-button
          type="danger"
          :loading="submittingAction === 'REJECTED'"
          @click="handleSubmit('REJECTED')"
        >
          确认驳回
        </el-button>
      </template>
      <template v-else>
        <el-button type="danger" plain @click="switchAction('REJECTED')">驳回</el-button>
        <el-button
          type="primary"
          :loading="submittingAction === 'PASS'"
          @click="handleSubmit('PASS')"
        >
          确认验收
        </el-button>
      </template>
    </template>
  </el-dialog>
</template>

<script setup>
import { computed, reactive, ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { acceptRepairApi } from '@/api/repair'
import { useDictStore } from '@/stores/dict'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  taskId: {
    type: Number,
    default: null
  },
  defaultLocationCode: {
    type: String,
    default: ''
  },
  defaultPreservationStatusCode: {
    type: String,
    default: 'BASIC_COMPLETE'
  },
  defaultAction: {
    type: String,
    default: 'PASS'
  }
})

const emit = defineEmits(['update:modelValue', 'success'])

const dictStore = useDictStore()
const formRef = ref()
const actionMode = ref('PASS')
const submittingAction = ref('')

const dialogVisible = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value)
})

const dialogTitle = computed(() => (actionMode.value === 'REJECTED' ? '驳回验收' : '确认验收'))
const isRejectMode = computed(() => actionMode.value === 'REJECTED')
const dialogDesc = computed(() => (
  isRejectMode.value
    ? '填写驳回原因后，当前任务会退回修复过程页继续补充处理记录或调整修复结果。'
    : '确认验收后，系统会记录验收时间、返库位置和修复后的保存状态，并将任务归档。'
))

const formData = reactive({
  acceptanceTime: '',
  acceptanceRemark: '',
  followUpSuggestion: '',
  preservationStatusCode: 'BASIC_COMPLETE',
  storageLocationCode: ''
})

const rules = {
  acceptanceTime: [{ required: true, message: '请选择验收时间', trigger: 'change' }]
}

const preservationOptions = computed(() => dictStore.itemsMap.preservation_status || [])
const locationOptions = computed(() => dictStore.itemsMap.storage_location || [])

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
  actionMode.value = props.defaultAction === 'REJECTED' ? 'REJECTED' : 'PASS'
  Object.assign(formData, {
    acceptanceTime: currentDateTime(),
    acceptanceRemark: '',
    followUpSuggestion: '',
    preservationStatusCode: props.defaultPreservationStatusCode || 'BASIC_COMPLETE',
    storageLocationCode: props.defaultLocationCode || ''
  })
}

function switchAction(action) {
  actionMode.value = action
}

async function handleSubmit(action) {
  await formRef.value.validate()
  if (!props.taskId) {
    return
  }

  const acceptanceRemark = formData.acceptanceRemark?.trim() || ''
  if (action === 'PASS') {
    if (!formData.preservationStatusCode || !formData.storageLocationCode) {
      ElMessage.warning('确认验收时请填写保存状态和返库位置')
      return
    }
  } else if (!acceptanceRemark) {
    ElMessage.warning('请输入驳回原因')
    return
  }

  submittingAction.value = action
  try {
    await acceptRepairApi(props.taskId, {
      ...formData,
      acceptanceRemark,
      acceptanceResult: action
    })
    ElMessage.success(action === 'PASS' ? '验收已确认' : '验收已驳回')
    dialogVisible.value = false
    emit('success')
  } finally {
    submittingAction.value = ''
  }
}

function handleClosed() {
  formRef.value?.clearValidate()
}

watch(
  () => props.modelValue,
  (visible) => {
    if (visible) {
      resetForm()
    }
  }
)

watch(
  () => props.defaultAction,
  (value) => {
    if (props.modelValue) {
      actionMode.value = value === 'REJECTED' ? 'REJECTED' : 'PASS'
    }
  }
)

dictStore.ensureMultipleItems(['storage_location', 'preservation_status'])
</script>

<style scoped>
.dialog-overview__title {
  font-size: 22px;
}
</style>
