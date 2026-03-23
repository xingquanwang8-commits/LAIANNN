<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <PageHeader title="字典管理" description="维护字典类型与字典项，并支持文本批量导入。">
        <template #extra>
          <el-button type="primary" @click="openTypeDialog()">新增字典类型</el-button>
        </template>
      </PageHeader>
    </section>

    <section class="page-grid dict-grid">
      <article class="page-card page-card--section">
        <div class="panel-title">字典类型</div>
        <el-form :inline="true" :model="typeQuery">
          <el-form-item label="关键词">
            <el-input v-model="typeQuery.keyword" placeholder="名称 / 编码" clearable @keyup.enter="loadTypes" />
          </el-form-item>
          <el-form-item label="状态">
            <el-select v-model="typeQuery.status" clearable placeholder="全部状态">
              <el-option label="启用" value="ENABLED" />
              <el-option label="停用" value="DISABLED" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="loadTypes">查询</el-button>
          </el-form-item>
        </el-form>
        <el-table :data="typePage.records" v-loading="loadingTypes" highlight-current-row @current-change="handleTypeChange">
          <el-table-column prop="dictName" label="字典名称" min-width="130" />
          <el-table-column prop="dictTypeCode" label="编码" min-width="140" />
          <el-table-column label="状态" width="100">
            <template #default="{ row }">
              <StatusTag :status="row.status" :label="row.status === 'ENABLED' ? '启用' : '停用'" />
            </template>
          </el-table-column>
          <el-table-column label="操作" width="170">
            <template #default="{ row }">
              <el-button text type="primary" @click.stop="openTypeDialog(row)">编辑</el-button>
              <el-button text type="danger" @click.stop="handleDeleteType(row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </article>

      <article class="page-card page-card--section">
        <div class="panel-header">
          <div class="panel-title">字典项</div>
          <div>
            <el-button :disabled="!currentType" @click="openImportDialog">文本导入</el-button>
            <el-button type="primary" :disabled="!currentType" @click="openItemDialog()">新增字典项</el-button>
          </div>
        </div>
        <div class="panel-subtitle text-secondary">
          当前字典：{{ currentType?.dictName || '请先选择左侧字典类型' }}
        </div>
        <el-table :data="items" v-loading="loadingItems">
          <el-table-column prop="itemLabel" label="显示名称" min-width="140" />
          <el-table-column prop="itemValue" label="值" min-width="130" />
          <el-table-column prop="itemSort" label="排序" width="90" />
          <el-table-column label="状态" width="100">
            <template #default="{ row }">
              <StatusTag :status="row.status" :label="row.status === 'ENABLED' ? '启用' : '停用'" />
            </template>
          </el-table-column>
          <el-table-column prop="cssClass" label="样式类" min-width="120" />
          <el-table-column label="操作" width="170">
            <template #default="{ row }">
              <el-button text type="primary" @click="openItemDialog(row)">编辑</el-button>
              <el-button text type="danger" @click="handleDeleteItem(row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </article>
    </section>

    <el-dialog v-model="typeDialogVisible" :title="editingTypeId ? '编辑字典类型' : '新增字典类型'" width="480px">
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
      <template #footer>
        <el-button @click="typeDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="savingType" @click="handleSaveType">保存</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="itemDialogVisible" :title="editingItemId ? '编辑字典项' : '新增字典项'" width="520px">
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
      <template #footer>
        <el-button @click="itemDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="savingItem" @click="handleSaveItem">保存</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="importDialogVisible" title="文本导入字典项" width="560px">
      <el-alert type="info" :closable="false" show-icon title="每行格式：显示名称,值,排序,状态,样式类,备注" />
      <el-input v-model="importContent" type="textarea" :rows="10" class="import-textarea" />
      <template #footer>
        <el-button @click="importDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="importing" @click="handleImport">导入</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { nextTick, reactive, ref } from 'vue'
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
    if (!currentType.value && typePage.value.records.length) {
      currentType.value = typePage.value.records[0]
      await loadItems()
    }
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
  currentType.value = row
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

.panel-title {
  margin-bottom: 14px;
  font-size: 16px;
  font-weight: 700;
}

.panel-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.panel-subtitle {
  margin-bottom: 16px;
  font-size: 13px;
}

.import-textarea {
  margin-top: 16px;
}

@media (max-width: 1100px) {
  .dict-grid {
    grid-template-columns: 1fr;
  }
}
</style>
