<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="overview-panel overview-panel--compact">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">MHMP Dictionary Center</div>
            <h2 class="overview-panel__title">业务字典管理</h2>
            <p class="overview-panel__desc">
              统一维护文物类别、材质、库位、保存状态和流程状态等基础业务编码，
              为馆藏台账、流转审批、修复业务和统计分析提供统一取值来源。
            </p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">字典类型 {{ typePage.total }} 个</span>
            <span class="overview-chip overview-chip--accent">
              当前字典 {{ currentType?.dictName || '未选择' }}
            </span>
          </div>
        </div>

        <div class="metric-grid dict-metrics">
          <article class="metric-card">
            <span class="metric-card__label">当前页启用类型</span>
            <strong class="metric-card__value">{{ enabledTypeCount }}</strong>
            <div class="metric-card__meta">当前筛选结果中可供系统正常调用的字典类型数量。</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页类型数</span>
            <strong class="metric-card__value">{{ currentPageCount }}</strong>
            <div class="metric-card__meta">当前筛选结果中的字典类型记录数量。</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前字典项数</span>
            <strong class="metric-card__value">{{ currentTypeItemCount }}</strong>
            <div class="metric-card__meta">当前选中字典下维护的全部字典项数量。</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前字典启用项</span>
            <strong class="metric-card__value">{{ enabledItemCount }}</strong>
            <div class="metric-card__meta">当前字典中处于启用状态、可参与前后端展示的字典项数量。</div>
          </article>
        </div>
      </div>
    </section>

    <section class="page-grid dict-grid">
      <article class="page-card page-card--section">
        <PageHeader
          title="字典类型检索"
          description="按名称、编码和状态筛选基础字典类型，支持直接新增、编辑和删除。"
        >
          <template #extra>
            <el-button type="primary" @click="openTypeDialog()">新增字典类型</el-button>
          </template>
        </PageHeader>

        <div class="query-toolbar">
          <el-form :inline="true" :model="typeQuery" class="query-form query-form--single-line">
            <el-form-item label="关键词" class="query-form__keyword">
              <el-input v-model="typeQuery.keyword" placeholder="名称 / 编码" clearable @keyup.enter="loadTypes" />
            </el-form-item>
            <el-form-item label="状态">
              <el-select v-model="typeQuery.status" clearable placeholder="全部状态">
                <el-option label="启用" value="ENABLED" />
                <el-option label="停用" value="DISABLED" />
              </el-select>
            </el-form-item>
            <el-form-item class="query-form__actions">
              <el-button type="primary" @click="loadTypes">查询</el-button>
            </el-form-item>
          </el-form>
        </div>

        <el-table
          :data="typePage.records"
          v-loading="loadingTypes"
          highlight-current-row
          @current-change="handleTypeChange"
        >
          <template #empty>
            <el-empty class="empty-block" description="未检索到符合条件的字典类型，请调整筛选条件后重试。" />
          </template>
          <el-table-column prop="dictName" label="字典名称" min-width="130" />
          <el-table-column prop="dictTypeCode" label="编码" min-width="140" />
          <el-table-column label="状态" width="100">
            <template #default="{ row }">
              <StatusTag :status="row.status" :label="row.status === 'ENABLED' ? '启用' : '停用'" />
            </template>
          </el-table-column>
          <el-table-column label="操作" class-name="table-action-column" width="170">
            <template #default="{ row }">
              <el-button text type="primary" @click.stop="openTypeDialog(row)">编辑</el-button>
              <el-button text type="danger" @click.stop="handleDeleteType(row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </article>

      <article class="page-card page-card--section">
        <PageHeader
          title="字典项维护"
          description="基于当前选中字典类型维护显示名称、值、排序、状态和样式类，支持文本批量导入。"
        >
          <template #extra>
            <div class="query-toolbar__actions">
              <el-button :disabled="!currentType" @click="openImportDialog">文本导入</el-button>
              <el-button type="primary" :disabled="!currentType" @click="openItemDialog()">新增字典项</el-button>
            </div>
          </template>
        </PageHeader>

        <div class="soft-note dict-current-note" :class="{ 'dict-current-note--empty': !currentType }">
          <div class="soft-note__title">
            {{ currentType ? `当前字典：${currentType.dictName}` : '当前未选择字典类型' }}
          </div>
          <div class="soft-note__desc">
            {{
              currentType
                ? `编码 ${currentType.dictTypeCode}，可在右侧维护与该业务编码相关的全部字典项。`
                : '请先在左侧选择字典类型，再维护对应的字典项内容。'
            }}
          </div>
        </div>

        <el-table :data="items" v-loading="loadingItems">
          <template #empty>
            <el-empty class="empty-block" description="当前字典下暂无字典项，请先新增或导入数据。" />
          </template>
          <el-table-column prop="itemLabel" label="显示名称" min-width="140" />
          <el-table-column prop="itemValue" label="值" min-width="130" />
          <el-table-column prop="itemSort" label="排序" width="90" />
          <el-table-column label="状态" width="100">
            <template #default="{ row }">
              <StatusTag :status="row.status" :label="row.status === 'ENABLED' ? '启用' : '停用'" />
            </template>
          </el-table-column>
          <el-table-column prop="cssClass" label="样式类" min-width="120" />
          <el-table-column label="操作" class-name="table-action-column" width="170">
            <template #default="{ row }">
              <el-button text type="primary" @click="openItemDialog(row)">编辑</el-button>
              <el-button text type="danger" @click="handleDeleteItem(row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </article>
    </section>

    <el-dialog v-model="typeDialogVisible" :title="editingTypeId ? '编辑字典类型' : '新增字典类型'" width="520px">
      <div class="detail-stack">
        <div class="soft-note">
          <div class="soft-note__title">类型维护说明</div>
          <div class="soft-note__desc">
            字典编码建议保持稳定，便于前后端按编码长期引用；若涉及已投产字段，请谨慎修改编码值。
          </div>
        </div>

        <el-form ref="typeFormRef" :model="typeForm" :rules="typeRules" label-width="96px">
          <el-form-item label="字典名称" prop="dictName">
            <el-input v-model="typeForm.dictName" />
          </el-form-item>
          <el-form-item label="字典编码" prop="dictTypeCode">
            <el-input v-model="typeForm.dictTypeCode" :disabled="Boolean(editingTypeId)" />
          </el-form-item>
          <el-form-item label="状态">
            <el-select v-model="typeForm.status">
              <el-option label="启用" value="ENABLED" />
              <el-option label="停用" value="DISABLED" />
            </el-select>
          </el-form-item>
          <el-form-item label="备注">
            <el-input v-model="typeForm.remark" type="textarea" :rows="3" />
          </el-form-item>
        </el-form>
      </div>
      <template #footer>
        <el-button @click="typeDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="savingType" @click="handleSaveType">保存</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="itemDialogVisible" :title="editingItemId ? '编辑字典项' : '新增字典项'" width="540px">
      <div class="detail-stack">
        <div class="soft-note soft-note--accent">
          <div class="soft-note__title">字典项维护说明</div>
          <div class="soft-note__desc">
            {{
              currentType
                ? `当前操作对象为 ${currentType.dictName}，请保持显示名称和值的业务含义稳定，避免影响前端展示和后端判断。`
                : '请先选择字典类型，再维护对应字典项。'
            }}
          </div>
        </div>

        <el-form ref="itemFormRef" :model="itemForm" :rules="itemRules" label-width="96px">
          <el-form-item label="显示名称" prop="itemLabel">
            <el-input v-model="itemForm.itemLabel" />
          </el-form-item>
          <el-form-item label="值" prop="itemValue">
            <el-input v-model="itemForm.itemValue" />
          </el-form-item>
          <el-form-item label="排序">
            <el-input-number v-model="itemForm.itemSort" :min="0" />
          </el-form-item>
          <el-form-item label="状态">
            <el-select v-model="itemForm.status">
              <el-option label="启用" value="ENABLED" />
              <el-option label="停用" value="DISABLED" />
            </el-select>
          </el-form-item>
          <el-form-item label="样式类">
            <el-input v-model="itemForm.cssClass" />
          </el-form-item>
          <el-form-item label="备注">
            <el-input v-model="itemForm.remark" type="textarea" :rows="3" />
          </el-form-item>
        </el-form>
      </div>
      <template #footer>
        <el-button @click="itemDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="savingItem" @click="handleSaveItem">保存</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="importDialogVisible" title="文本导入字典项" width="580px">
      <div class="detail-stack">
        <div class="soft-note soft-note--accent">
          <div class="soft-note__title">导入格式说明</div>
          <div class="soft-note__desc">
            每行按“显示名称,值,排序,状态,样式类,备注”填写。导入前请确认当前选中的字典类型正确。
          </div>
        </div>
        <el-alert type="info" :closable="false" show-icon title="每行格式：显示名称,值,排序,状态,样式类,备注" />
        <el-input v-model="importContent" type="textarea" :rows="10" class="import-textarea" />
      </div>
      <template #footer>
        <el-button @click="importDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="importing" @click="handleImport">导入</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { computed, nextTick, reactive, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  createDictItemApi,
  createDictTypeApi,
  deleteDictItemApi,
  deleteDictTypeApi,
  getDictTypePageApi,
  getSystemDictItemsApi,
  importDictItemsApi,
  updateDictItemApi,
  updateDictTypeApi
} from '@/api/system'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'

const loadingTypes = ref(false)
const loadingItems = ref(false)
const savingType = ref(false)
const savingItem = ref(false)
const importing = ref(false)
const typeDialogVisible = ref(false)
const itemDialogVisible = ref(false)
const importDialogVisible = ref(false)
const editingTypeId = ref(null)
const editingItemId = ref(null)
const typeFormRef = ref()
const itemFormRef = ref()

const typePage = ref({
  total: 0,
  pageNum: 1,
  pageSize: 50,
  records: []
})
const items = ref([])
const currentType = ref(null)
const importContent = ref('')

const typeQuery = reactive({
  pageNum: 1,
  pageSize: 50,
  keyword: '',
  status: ''
})

const typeForm = reactive({
  dictName: '',
  dictTypeCode: '',
  status: 'ENABLED',
  remark: ''
})

const itemForm = reactive({
  dictTypeCode: '',
  itemLabel: '',
  itemValue: '',
  itemSort: 0,
  status: 'ENABLED',
  cssClass: '',
  remark: ''
})

const typeRules = {
  dictName: [{ required: true, message: '请输入字典名称', trigger: 'blur' }],
  dictTypeCode: [{ required: true, message: '请输入字典编码', trigger: 'blur' }]
}

const itemRules = {
  itemLabel: [{ required: true, message: '请输入显示名称', trigger: 'blur' }],
  itemValue: [{ required: true, message: '请输入值', trigger: 'blur' }]
}

const currentPageCount = computed(() => typePage.value.records.length)
const enabledTypeCount = computed(() => typePage.value.records.filter((item) => item.status === 'ENABLED').length)
const currentTypeItemCount = computed(() => items.value.length)
const enabledItemCount = computed(() => items.value.filter((item) => item.status === 'ENABLED').length)

function resetTypeForm() {
  Object.assign(typeForm, {
    dictName: '',
    dictTypeCode: '',
    status: 'ENABLED',
    remark: ''
  })
}

function resetItemForm() {
  Object.assign(itemForm, {
    dictTypeCode: currentType.value?.dictTypeCode || '',
    itemLabel: '',
    itemValue: '',
    itemSort: 0,
    status: 'ENABLED',
    cssClass: '',
    remark: ''
  })
}

async function loadTypes() {
  loadingTypes.value = true
  try {
    typePage.value = await getDictTypePageApi(typeQuery)
    const matchedCurrent = typePage.value.records.find((item) => item.id === currentType.value?.id)
    currentType.value = matchedCurrent || typePage.value.records[0] || null
    await loadItems()
  } finally {
    loadingTypes.value = false
  }
}

async function loadItems() {
  if (!currentType.value?.dictTypeCode) {
    items.value = []
    return
  }
  loadingItems.value = true
  try {
    items.value = await getSystemDictItemsApi(currentType.value.dictTypeCode)
  } finally {
    loadingItems.value = false
  }
}

function handleTypeChange(row) {
  currentType.value = row || null
  loadItems()
}

function openTypeDialog(row = null) {
  editingTypeId.value = row?.id || null
  resetTypeForm()
  if (row) {
    Object.assign(typeForm, {
      dictName: row.dictName || '',
      dictTypeCode: row.dictTypeCode || '',
      status: row.status || 'ENABLED',
      remark: row.remark || ''
    })
  }
  typeDialogVisible.value = true
  nextTick(() => typeFormRef.value?.clearValidate())
}

function openItemDialog(row = null) {
  if (!currentType.value) {
    ElMessage.warning('请先选择字典类型')
    return
  }
  editingItemId.value = row?.id || null
  resetItemForm()
  if (row) {
    Object.assign(itemForm, {
      dictTypeCode: row.dictTypeCode || currentType.value.dictTypeCode,
      itemLabel: row.itemLabel || '',
      itemValue: row.itemValue || '',
      itemSort: row.itemSort ?? 0,
      status: row.status || 'ENABLED',
      cssClass: row.cssClass || '',
      remark: row.remark || ''
    })
  }
  itemDialogVisible.value = true
  nextTick(() => itemFormRef.value?.clearValidate())
}

function openImportDialog() {
  if (!currentType.value) {
    ElMessage.warning('请先选择字典类型')
    return
  }
  importContent.value = ''
  importDialogVisible.value = true
}

async function handleSaveType() {
  await typeFormRef.value.validate()
  savingType.value = true
  try {
    if (editingTypeId.value) {
      await updateDictTypeApi(editingTypeId.value, typeForm)
      ElMessage.success('字典类型已更新')
    } else {
      await createDictTypeApi(typeForm)
      ElMessage.success('字典类型已创建')
    }
    typeDialogVisible.value = false
    await loadTypes()
  } finally {
    savingType.value = false
  }
}

async function handleSaveItem() {
  await itemFormRef.value.validate()
  savingItem.value = true
  try {
    itemForm.dictTypeCode = currentType.value.dictTypeCode
    if (editingItemId.value) {
      await updateDictItemApi(editingItemId.value, itemForm)
      ElMessage.success('字典项已更新')
    } else {
      await createDictItemApi(itemForm)
      ElMessage.success('字典项已创建')
    }
    itemDialogVisible.value = false
    await loadItems()
  } finally {
    savingItem.value = false
  }
}

async function handleDeleteType(row) {
  await ElMessageBox.confirm(`确认删除字典类型“${row.dictName}”吗？`, '删除确认', {
    type: 'warning'
  })
  await deleteDictTypeApi(row.id)
  ElMessage.success('字典类型已删除')
  if (currentType.value?.id === row.id) {
    currentType.value = null
    items.value = []
  }
  await loadTypes()
}

async function handleDeleteItem(row) {
  await ElMessageBox.confirm(`确认删除字典项“${row.itemLabel}”吗？`, '删除确认', {
    type: 'warning'
  })
  await deleteDictItemApi(row.id)
  ElMessage.success('字典项已删除')
  await loadItems()
}

async function handleImport() {
  if (!importContent.value.trim()) {
    ElMessage.warning('请输入导入内容')
    return
  }
  importing.value = true
  try {
    await importDictItemsApi({
      dictTypeCode: currentType.value.dictTypeCode,
      content: importContent.value
    })
    ElMessage.success('字典项已导入')
    importDialogVisible.value = false
    await loadItems()
  } finally {
    importing.value = false
  }
}

loadTypes()
</script>

<style scoped>
.dict-grid {
  grid-template-columns: 1fr 1.1fr;
}

.dict-metrics {
  grid-template-columns: repeat(4, minmax(0, 1fr));
}

.dict-current-note {
  margin-bottom: 16px;
}

.dict-current-note--empty {
  opacity: 0.9;
}

.import-textarea {
  margin-top: 0;
}

@media (max-width: 1100px) {
  .dict-grid {
    grid-template-columns: 1fr;
  }

  .dict-metrics {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 640px) {
  .dict-metrics {
    grid-template-columns: 1fr;
  }
}
</style>
