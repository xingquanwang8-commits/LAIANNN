<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="query-toolbar">
        <el-form :inline="true" :model="queryForm" class="query-form query-form--single-line">
          <el-form-item label="关键词" class="query-form__keyword">
            <el-input v-model="queryForm.keyword" placeholder="文物编号 / 名称" clearable @keyup.enter="handleSearch" />
          </el-form-item>
          <el-form-item label="文物类别">
            <el-select v-model="queryForm.categoryCode" clearable placeholder="全部类别">
              <el-option
                v-for="item in categoryOptions"
                :key="item.itemValue"
                :label="item.itemLabel"
                :value="item.itemValue"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="当前库位">
            <el-select v-model="queryForm.storageLocationCode" clearable placeholder="全部库位">
              <el-option
                v-for="item in locationOptions"
                :key="item.itemValue"
                :label="item.itemLabel"
                :value="item.itemValue"
              />
            </el-select>
          </el-form-item>
          <el-form-item class="query-form__actions">
            <el-button type="primary" @click="handleSearch">查询</el-button>
            <el-button @click="handleReset">重置</el-button>
          </el-form-item>
        </el-form>

        <div class="query-toolbar__actions">
          <el-button :type="multipleMode ? 'primary' : 'default'" plain @click="toggleMultipleMode">
            {{ multipleMode ? '退出多选' : '多选转存' }}
          </el-button>
          <el-button
            v-if="multipleMode"
            type="primary"
            :disabled="!selectedRows.length"
            @click="openBatchTransferDialog"
          >
            一键转存{{ selectedRows.length ? `（${selectedRows.length}）` : '' }}
          </el-button>
        </div>
      </div>
    </section>

    <section class="page-card page-card--section">
      <el-table
        ref="tableRef"
        :data="pageData.records"
        v-loading="loading"
        row-key="id"
        @selection-change="handleSelectionChange"
      >
        <el-table-column v-if="multipleMode" type="selection" width="54" reserve-selection />
        <el-table-column prop="relicNo" label="文物编号" min-width="150" />
        <el-table-column prop="name" label="文物名称" min-width="180" />
        <el-table-column label="类别" min-width="120">
          <template #default="{ row }">{{ resolveDictLabel(categoryOptions, row.categoryCode) }}</template>
        </el-table-column>
        <el-table-column label="当前库位" min-width="130">
          <template #default="{ row }">{{ resolveDictLabel(locationOptions, row.storageLocationCode) }}</template>
        </el-table-column>
        <el-table-column label="保存状态" min-width="120">
          <template #default="{ row }">{{ resolveDictLabel(preservationOptions, row.preservationStatusCode) }}</template>
        </el-table-column>
        <el-table-column label="更新时间" min-width="150">
          <template #default="{ row }">{{ formatDateTime(row.updateTime) }}</template>
        </el-table-column>
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="{ row }">
            <el-button text type="primary" @click="router.push(`/relic/detail/${row.id}`)">详情</el-button>
            <el-button text type="primary" @click="openTransferDialog(row)">发起转存</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="table-footer">
        <div v-if="multipleMode" class="table-selection-tip">
          已选中文物 {{ selectedRows.length }} 件，可直接发起一键转存
        </div>
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

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="620px">
      <el-form ref="formRef" :model="formData" :rules="rules" label-width="96px">
        <el-form-item label="转存对象">
          <div v-if="selectedRelics.length === 1" class="selected-relic">
            <div>{{ selectedRelics[0]?.relicNo }} / {{ selectedRelics[0]?.name }}</div>
            <div class="text-secondary">
              当前库位：{{ resolveDictLabel(locationOptions, selectedRelics[0]?.storageLocationCode) || '--' }}
            </div>
          </div>
          <div v-else class="selected-batch">
            <div>已选择 {{ selectedRelics.length }} 件文物</div>
            <div class="selected-batch__list">
              <span v-for="item in selectedRelicPreview" :key="item.id">{{ item.relicNo }} / {{ item.name }}</span>
              <span v-if="selectedRelics.length > selectedRelicPreview.length">等 {{ selectedRelics.length }} 件</span>
            </div>
          </div>
        </el-form-item>
        <el-form-item label="目标库位" prop="storageLocationCode">
          <el-select v-model="formData.storageLocationCode" placeholder="请选择目标库位">
            <el-option
              v-for="item in locationOptions"
              :key="item.itemValue"
              :label="item.itemLabel"
              :value="item.itemValue"
            />
          </el-select>
        </el-form-item>
        <el-form-item v-if="transferCheck.totalCount" label="业务校验">
          <div
            class="business-check transfer-check"
            :class="transferCheck.allPassed ? 'business-check--pass' : 'business-check--warn'"
          >
            <div class="business-check__header">
              <div class="business-check__title">{{ transferCheckTitle }}</div>
            </div>
            <div class="business-check__summary">{{ transferCheckSummary }}</div>
            <ul v-if="transferCheck.invalidItems.length" class="business-check__list">
              <li
                v-for="item in transferCheck.invalidItems.slice(0, 4)"
                :key="`${item.identity}-${item.message}`"
                class="business-check__item"
              >
                {{ item.identity }}：{{ item.message }}
              </li>
            </ul>
          </div>
        </el-form-item>
        <el-form-item label="转存原因">
          <el-input v-model="formData.transferReason" type="textarea" :rows="3" placeholder="请输入本次转存说明" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleSubmit">提交</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { computed, nextTick, reactive, ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { useRoute, useRouter } from 'vue-router'
import { batchTransferRelicApi, getRelicDetailApi, getRelicPageApi, transferRelicApi } from '@/api/relic'
import { useDictStore } from '@/stores/dict'
import { formatDateTime, resolveDictLabel } from '@/utils/format'
import {
  analyzeRelicSelection,
  checkTransferRelicEligibility,
  pickRelicBusinessFields
} from '@/utils/relicBusinessRules'

const route = useRoute()
const router = useRouter()
const dictStore = useDictStore()

const tableRef = ref()
const formRef = ref()
const loading = ref(false)
const saving = ref(false)
const dialogVisible = ref(false)
const multipleMode = ref(false)
const selectedRows = ref([])
const selectedRelics = ref([])
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
  categoryCode: '',
  storageLocationCode: '',
  currentStatus: 'IN_STOCK'
})

const formData = reactive({
  storageLocationCode: '',
  transferReason: ''
})

const rules = {
  storageLocationCode: [{ required: true, message: '请选择目标库位', trigger: 'change' }]
}

const categoryOptions = computed(() => dictStore.itemsMap.relic_category || [])
const locationOptions = computed(() => dictStore.itemsMap.storage_location || [])
const preservationOptions = computed(() => dictStore.itemsMap.preservation_status || [])
const dialogTitle = computed(() => selectedRelics.value.length > 1 ? `馆内转存（已选 ${selectedRelics.value.length} 件）` : '馆内转存')
const selectedRelicPreview = computed(() => selectedRelics.value.slice(0, 4))
const transferCheck = computed(() =>
  analyzeRelicSelection(
    selectedRelics.value,
    (relic) => checkTransferRelicEligibility(relic, formData.storageLocationCode)
  )
)
const transferCheckTitle = computed(() => (
  transferCheck.value.allPassed
    ? '馆内转存前置校验已通过'
    : '馆内转存前置校验未通过'
))
const transferCheckSummary = computed(() => {
  if (!transferCheck.value.totalCount) {
    return ''
  }
  if (transferCheck.value.allPassed) {
    return `已选 ${transferCheck.value.totalCount} 件文物，均符合馆内转存条件，可直接提交本次转存。`
  }
  if (!formData.storageLocationCode) {
    return `已选 ${transferCheck.value.totalCount} 件文物，请先选择目标库位，系统会同步校验是否与当前库位冲突。`
  }
  return `已选 ${transferCheck.value.totalCount} 件文物，其中 ${transferCheck.value.invalidItems.length} 件暂不符合转存条件，请先调整后再提交。`
})

async function loadPage() {
  loading.value = true
  try {
    pageData.value = await getRelicPageApi(queryForm)
  } finally {
    loading.value = false
  }
}

function resetTransferForm() {
  formData.storageLocationCode = ''
  formData.transferReason = ''
}

function normalizeRelicSelection(row) {
  return {
    ...row,
    ...pickRelicBusinessFields(row)
  }
}

function openTransferDialog(row, options = {}) {
  const relic = normalizeRelicSelection(row)
  const checkResult = checkTransferRelicEligibility(relic)
  if (!checkResult.passed) {
    ElMessage.warning(checkResult.message)
    return
  }
  selectedRelics.value = [relic]
  resetTransferForm()
  if (options.quickCreate) {
    formData.transferReason = '由文物详情快捷发起'
  }
  dialogVisible.value = true
  nextTick(() => {
    formRef.value?.clearValidate()
  })
}

function openBatchTransferDialog() {
  if (!selectedRows.value.length) {
    ElMessage.warning('请先选择要批量转存的文物')
    return
  }
  selectedRelics.value = selectedRows.value.map((item) => normalizeRelicSelection(item))
  resetTransferForm()
  dialogVisible.value = true
  nextTick(() => {
    formRef.value?.clearValidate()
  })
}

async function handleSubmit() {
  await formRef.value?.validate()
  if (!transferCheck.value.allPassed) {
    ElMessage.warning(transferCheck.value.invalidItems[0]?.message || '当前选中文物不符合馆内转存条件')
    return
  }
  saving.value = true
  try {
    if (selectedRelics.value.length > 1) {
      await batchTransferRelicApi({
        relicIds: selectedRelics.value.map((item) => item.id),
        ...formData
      })
      ElMessage.success(`已完成 ${selectedRelics.value.length} 件文物的馆内转存`)
    } else if (selectedRelics.value[0]) {
      await transferRelicApi(selectedRelics.value[0].id, formData)
      ElMessage.success('馆内转存已提交')
    }
    dialogVisible.value = false
    selectedRelics.value = []
    await loadPage()
    clearSelection()
  } finally {
    saving.value = false
  }
}

function handleSelectionChange(rows) {
  selectedRows.value = rows
}

function toggleMultipleMode() {
  multipleMode.value = !multipleMode.value
  if (!multipleMode.value) {
    clearSelection()
  }
}

function clearSelection() {
  selectedRows.value = []
  tableRef.value?.clearSelection()
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
    categoryCode: '',
    storageLocationCode: '',
    currentStatus: 'IN_STOCK'
  })
  clearSelection()
  loadPage()
}

function handleCurrentChange(pageNum) {
  queryForm.pageNum = pageNum
  clearSelection()
  loadPage()
}

function handleSizeChange(pageSize) {
  queryForm.pageSize = pageSize
  queryForm.pageNum = 1
  clearSelection()
  loadPage()
}

async function ensureQuickRelic(relicId) {
  if (!relicId) {
    return null
  }
  const pageRelic = pageData.value.records.find((item) => String(item.id) === String(relicId))
  if (pageRelic) {
    return normalizeRelicSelection(pageRelic)
  }
  const detail = await getRelicDetailApi(relicId).catch(() => null)
  return detail ? normalizeRelicSelection(detail) : null
}

async function handleQuickCreateFromRoute() {
  if (route.query.quickCreate !== '1' || !route.query.relicId) {
    return
  }
  if (dialogVisible.value && String(selectedRelics.value[0]?.id) === String(route.query.relicId)) {
    return
  }
  const relic = await ensureQuickRelic(route.query.relicId)
  if (!relic) {
    ElMessage.warning('未找到当前文物档案，请刷新后重试')
    return
  }
  openTransferDialog(relic, { quickCreate: true })
}

dictStore.ensureMultipleItems(['relic_category', 'storage_location', 'preservation_status'])
watch(
  () => route.fullPath,
  () => {
    handleQuickCreateFromRoute()
  },
  { immediate: true }
)
loadPage()
</script>

<style scoped>
.transfer-check {
  width: 100%;
}

.selected-relic,
.selected-batch {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.selected-batch__list {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
  color: var(--text-second);
}

.table-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  margin-top: 18px;
  flex-wrap: wrap;
}

.table-selection-tip {
  color: var(--text-second);
  font-size: 13px;
}
</style>
