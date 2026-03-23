<template>
  <div class="page-shell" v-loading="loading">
    <section class="page-card page-card--section">
      <PageHeader
        :title="isEdit ? '编辑文物' : '新增文物'"
        :description="isEdit ? '直接维护现有文物档案字段并保存到后端。' : '新建文物档案，便于后续出入库、修复和盘点管理。'"
      >
        <template #extra>
          <el-button @click="router.back()">返回</el-button>
        </template>
      </PageHeader>
    </section>

    <section class="page-card page-card--section">
      <el-form ref="formRef" :model="form" :rules="rules" label-position="top">
        <div class="page-grid relic-form-grid">
          <el-form-item label="文物编号" prop="relicNo">
            <el-input v-model="form.relicNo" placeholder="请输入文物编号" />
          </el-form-item>
          <el-form-item label="文物名称" prop="name">
            <el-input v-model="form.name" placeholder="请输入文物名称" />
          </el-form-item>
          <el-form-item label="文物类别" prop="categoryCode">
            <el-select v-model="form.categoryCode" placeholder="请选择文物类别">
              <el-option v-for="item in categoryOptions" :key="item.itemValue" :label="item.itemLabel" :value="item.itemValue" />
            </el-select>
          </el-form-item>
          <el-form-item label="文物材质" prop="materialCode">
            <el-select v-model="form.materialCode" placeholder="请选择文物材质">
              <el-option v-for="item in materialOptions" :key="item.itemValue" :label="item.itemLabel" :value="item.itemValue" />
            </el-select>
          </el-form-item>
          <el-form-item label="馆藏位置">
            <el-select v-model="form.storageLocationCode" placeholder="请选择馆藏位置" clearable>
              <el-option v-for="item in locationOptions" :key="item.itemValue" :label="item.itemLabel" :value="item.itemValue" />
            </el-select>
          </el-form-item>
          <el-form-item label="当前状态" prop="currentStatus">
            <el-select v-model="form.currentStatus" placeholder="请选择当前状态">
              <el-option v-for="item in statusOptions" :key="item.itemValue" :label="item.itemLabel" :value="item.itemValue" />
            </el-select>
          </el-form-item>
          <el-form-item label="保存状态">
            <el-select v-model="form.preservationStatusCode" placeholder="请选择保存状态" clearable>
              <el-option
                v-for="item in preservationOptions"
                :key="item.itemValue"
                :label="item.itemLabel"
                :value="item.itemValue"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="年代">
            <el-input v-model="form.era" placeholder="如：明代 / 商周时期" />
          </el-form-item>
          <el-form-item label="来源">
            <el-input v-model="form.source" placeholder="如：考古发掘 / 社会捐赠" />
          </el-form-item>
          <el-form-item label="保护级别">
            <el-input v-model="form.protectionLevel" placeholder="请输入保护级别" />
          </el-form-item>
          <el-form-item label="主图地址">
            <el-input v-model="form.imageUrl" placeholder="请输入主图 URL" />
          </el-form-item>
          <el-form-item label="鉴定报告地址">
            <el-input v-model="form.appraisalReportUrl" placeholder="请输入鉴定报告 URL" />
          </el-form-item>
        </div>

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
  </div>
</template>

<script setup>
import { computed, reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { createRelicApi, getRelicDetailApi, updateRelicApi } from '@/api/relic'
import PageHeader from '@/components/common/PageHeader.vue'
import { useDictStore } from '@/stores/dict'

const route = useRoute()
const router = useRouter()
const dictStore = useDictStore()

const formRef = ref(null)
const loading = ref(false)
const submitting = ref(false)
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
  currentStatus: '',
  protectionLevel: '',
  storageCondition: '',
  attentionNote: '',
  description: '',
  note: '',
  imageUrl: '',
  appraisalReportUrl: ''
})

const rules = {
  relicNo: [{ required: true, message: '请输入文物编号', trigger: 'blur' }],
  name: [{ required: true, message: '请输入文物名称', trigger: 'blur' }],
  categoryCode: [{ required: true, message: '请选择文物类别', trigger: 'change' }],
  materialCode: [{ required: true, message: '请选择文物材质', trigger: 'change' }],
  currentStatus: [{ required: true, message: '请选择当前状态', trigger: 'change' }]
}

const categoryOptions = computed(() => dictStore.itemsMap.relic_category || [])
const materialOptions = computed(() => dictStore.itemsMap.relic_material || [])
const statusOptions = computed(() => dictStore.itemsMap.relic_status || [])
const locationOptions = computed(() => dictStore.itemsMap.storage_location || [])
const preservationOptions = computed(() => dictStore.itemsMap.preservation_status || [])

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
    currentStatus: detail.currentStatus || '',
    protectionLevel: detail.protectionLevel || '',
    storageCondition: detail.storageCondition || '',
    attentionNote: detail.attentionNote || '',
    description: detail.description || '',
    note: detail.note || '',
    imageUrl: detail.imageUrl || '',
    appraisalReportUrl: detail.appraisalReportUrl || ''
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

async function handleSubmit() {
  const valid = await formRef.value.validate().catch(() => false)
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
loadDetail()
</script>

<style scoped>
.relic-form-grid {
  grid-template-columns: repeat(2, minmax(0, 1fr));
}

.relic-form__actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 16px;
}

@media (max-width: 960px) {
  .relic-form-grid {
    grid-template-columns: 1fr;
  }
}
</style>
