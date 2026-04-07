<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="query-toolbar">
        <el-form :inline="true" :model="queryForm" class="query-form query-form--single-line">
          <el-form-item label="关键词" class="query-form__keyword">
            <el-input v-model="queryForm.keyword" placeholder="单号 / 批次 / 来源" clearable @keyup.enter="handleSearch" />
          </el-form-item>
          <el-form-item label="状态">
            <el-select v-model="queryForm.status" clearable placeholder="全部状态">
              <el-option label="已完成" value="COMPLETED" />
            </el-select>
          </el-form-item>
          <el-form-item class="query-form__actions">
            <el-button type="primary" @click="handleSearch">查询</el-button>
            <el-button @click="handleReset">重置</el-button>
          </el-form-item>
        </el-form>

        <div v-if="authStore.hasPermission('inventory:inbound:add')" class="query-toolbar__actions">
          <el-button type="primary" @click="openCreate">新建文物入库</el-button>
        </div>
      </div>
    </section>

    <section class="page-card page-card--section">
      <el-table :data="pageData.records" v-loading="loading">
        <el-table-column prop="orderNo" label="入库单号" min-width="150" />
        <el-table-column prop="batchNo" label="批次号" min-width="130" />
        <el-table-column prop="source" label="来源" min-width="150" />
        <el-table-column prop="handlerName" label="经手人" min-width="120" />
        <el-table-column prop="totalCount" label="数量" width="90" />
        <el-table-column label="入库时间" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.inboundTime) }}</template>
        </el-table-column>
        <el-table-column label="状态" width="120">
          <template #default="{ row }">
            <StatusTag :status="row.status" :label="row.status === 'COMPLETED' ? '已完成' : row.status" />
          </template>
        </el-table-column>
        <el-table-column label="操作" width="100">
          <template #default="{ row }">
            <el-button text type="primary" @click="openDetail(row.id)">详情</el-button>
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

    <el-dialog v-model="dialogVisible" title="文物入库" width="680px">
      <el-form ref="formRef" :model="formData" :rules="rules" label-width="96px">
        <el-row :gutter="14">
          <el-col :span="12">
            <el-form-item label="入库批次">
              <el-input model-value="保存后自动生成" disabled />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="来源" prop="source">
              <el-input v-model="formData.source" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="经手人" prop="handlerName">
              <el-input v-model="formData.handlerName" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="入库时间" prop="inboundTime">
              <el-date-picker
                v-model="formData.inboundTime"
                type="datetime"
                value-format="YYYY-MM-DDTHH:mm:ss"
                placeholder="请选择时间"
              />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="入库文物" prop="relicIds">
              <el-select v-model="formData.relicIds" multiple filterable placeholder="请选择文物">
                <el-option
                  v-for="item in relicOptions"
                  :key="item.id"
                  :label="`${item.relicNo} / ${item.name}`"
                  :value="item.id"
                />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col v-if="inboundSelection.totalCount" :span="24">
            <div
              class="business-check"
              :class="inboundSelection.allPassed ? 'business-check--pass' : 'business-check--warn'"
            >
              <div class="business-check__header">
                <div class="business-check__title">{{ inboundSelectionTitle }}</div>
              </div>
              <div class="business-check__summary">{{ inboundSelectionSummary }}</div>
              <ul v-if="inboundSelection.invalidItems.length" class="business-check__list">
                <li
                  v-for="item in inboundSelection.invalidItems.slice(0, 3)"
                  :key="`${item.identity}-${item.message}`"
                  class="business-check__item"
                >
                  {{ item.identity }}：{{ item.message }}
                </li>
              </ul>
            </div>
          </el-col>
          <el-col :span="24">
            <el-form-item label="备注">
              <el-input v-model="formData.remark" type="textarea" :rows="3" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleSave">提交</el-button>
      </template>
    </el-dialog>

    <el-drawer v-model="drawerVisible" title="文物入库详情" size="46%">
      <el-descriptions :column="1" border>
        <el-descriptions-item label="入库单号">{{ detail.orderNo || '--' }}</el-descriptions-item>
        <el-descriptions-item label="批次号">{{ detail.batchNo || '--' }}</el-descriptions-item>
        <el-descriptions-item label="来源">{{ detail.source || '--' }}</el-descriptions-item>
        <el-descriptions-item label="经手人">{{ detail.handlerName || '--' }}</el-descriptions-item>
        <el-descriptions-item label="入库时间">{{ formatDateTime(detail.inboundTime) }}</el-descriptions-item>
        <el-descriptions-item label="备注">{{ detail.remark || '--' }}</el-descriptions-item>
      </el-descriptions>

      <el-table :data="detail.details || []" class="drawer-table">
        <el-table-column prop="relicNo" label="文物编号" min-width="140" />
        <el-table-column prop="relicName" label="文物名称" min-width="160" />
        <el-table-column prop="quantity" label="数量" width="90" />
        <el-table-column prop="remark" label="备注" min-width="140" />
      </el-table>
    </el-drawer>
  </div>
</template>

<script setup>
import { computed, nextTick, reactive, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { createInboundApi, getInboundDetailApi, getInboundPageApi } from '@/api/inbound'
import { getRelicDetailApi, getRelicPageApi } from '@/api/relic'
import StatusTag from '@/components/common/StatusTag.vue'
import { useAuthStore } from '@/stores/auth'
import { formatDateTime } from '@/utils/format'
import {
  analyzeRelicSelection,
  checkInboundRelicEligibility,
  pickRelicBusinessFields
} from '@/utils/relicBusinessRules'

const authStore = useAuthStore()
const route = useRoute()

const loading = ref(false)
const saving = ref(false)
const dialogVisible = ref(false)
const drawerVisible = ref(false)
const formRef = ref()
const relicOptions = ref([])
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
  status: ''
})

const formData = reactive({
  source: '',
  handlerName: '',
  inboundTime: '',
  remark: '',
  relicIds: []
})

const rules = {
  source: [{ required: true, message: '请输入来源', trigger: 'blur' }],
  handlerName: [{ required: true, message: '请输入经手人', trigger: 'blur' }],
  inboundTime: [{ required: true, message: '请选择入库时间', trigger: 'change' }],
  relicIds: [{ required: true, type: 'array', message: '请选择文物', trigger: 'change' }]
}

const selectedRelics = computed(() =>
  formData.relicIds
    .map((id) => relicOptions.value.find((item) => String(item.id) === String(id)))
    .filter(Boolean)
)

const inboundSelection = computed(() =>
  analyzeRelicSelection(selectedRelics.value, checkInboundRelicEligibility)
)

const inboundSelectionTitle = computed(() => (
  inboundSelection.value.allPassed
    ? '\u5165\u5e93\u524d\u7f6e\u6821\u9a8c\u5df2\u901a\u8fc7'
    : '\u5165\u5e93\u524d\u7f6e\u6821\u9a8c\u672a\u901a\u8fc7'
))

const inboundSelectionSummary = computed(() => {
  if (!inboundSelection.value.totalCount) {
    return ''
  }
  if (inboundSelection.value.allPassed) {
    return `\u5df2\u9009 ${inboundSelection.value.totalCount} \u4ef6\u6587\u7269\uff0c\u5747\u7b26\u5408\u5165\u5e93\u53d1\u8d77\u6761\u4ef6\uff0c\u53ef\u76f4\u63a5\u63d0\u4ea4\u5165\u5e93\u7533\u8bf7\u3002`
  }
  return `\u5df2\u9009 ${inboundSelection.value.totalCount} \u4ef6\u6587\u7269\uff0c\u5176\u4e2d ${inboundSelection.value.invalidItems.length} \u4ef6\u4e0d\u7b26\u5408\u5165\u5e93\u6761\u4ef6\uff0c\u8bf7\u5148\u5904\u7406\u72b6\u6001\u518d\u63d0\u4ea4\u3002`
})

function resetForm() {
  Object.assign(formData, {
    source: '',
    handlerName: '',
    inboundTime: '',
    remark: '',
    relicIds: []
  })
}

function appendRelicOption(relic) {
  const option = pickRelicBusinessFields(relic)
  if (!relicOptions.value.some((item) => String(item.id) === String(option.id))) {
    relicOptions.value = [option, ...relicOptions.value]
  }
  return option
}

async function loadRelicOptions() {
  const page = await getRelicPageApi({
    pageNum: 1,
    pageSize: 200
  })
  relicOptions.value = (page.records || [])
    .map((item) => pickRelicBusinessFields(item))
    .filter((item) => checkInboundRelicEligibility(item).passed)
}

async function loadOrders() {
  loading.value = true
  try {
    pageData.value = await getInboundPageApi(queryForm)
  } finally {
    loading.value = false
  }
}

async function ensureQuickRelicOption(relicId) {
  if (!relicId) {
    return null
  }
  const currentOption = relicOptions.value.find((item) => String(item.id) === String(relicId))
  if (currentOption) {
    return currentOption
  }
  const relicDetail = await getRelicDetailApi(relicId).catch(() => null)
  if (!relicDetail) {
    return null
  }
  return appendRelicOption(relicDetail)
}

async function openCreate(prefill = {}) {
  resetForm()
  await loadRelicOptions()
  const quickRelic = await ensureQuickRelicOption(prefill.relicId)
  if (prefill.relicId) {
    if (!quickRelic) {
      ElMessage.warning('\u672a\u627e\u5230\u5f53\u524d\u6587\u7269\u6863\u6848\uff0c\u8bf7\u5237\u65b0\u540e\u91cd\u8bd5')
      return
    }
    const checkResult = checkInboundRelicEligibility(quickRelic)
    if (!checkResult.passed) {
      ElMessage.warning(checkResult.message)
      return
    }
  }
  dialogVisible.value = true
  if (prefill.relicId) {
    formData.relicIds = [Number(prefill.relicId)]
    formData.remark = '由文物详情快捷发起'
  }
  await nextTick()
  formRef.value?.clearValidate()
}

async function handleSave() {
  await formRef.value.validate()
  if (!inboundSelection.value.allPassed) {
    ElMessage.warning(inboundSelection.value.invalidItems[0]?.message || '\u5f53\u524d\u9009\u4e2d\u6587\u7269\u4e0d\u7b26\u5408\u5165\u5e93\u6761\u4ef6')
    return
  }
  saving.value = true
  try {
    await createInboundApi(formData)
    ElMessage.success('入库单已创建')
    dialogVisible.value = false
    await loadOrders()
  } finally {
    saving.value = false
  }
}

async function openDetail(id) {
  detail.value = await getInboundDetailApi(id)
  drawerVisible.value = true
}

function handleSearch() {
  queryForm.pageNum = 1
  loadOrders()
}

function handleReset() {
  Object.assign(queryForm, {
    pageNum: 1,
    pageSize: 10,
    keyword: '',
    status: ''
  })
  loadOrders()
}

function handleCurrentChange(pageNum) {
  queryForm.pageNum = pageNum
  loadOrders()
}

function handleSizeChange(pageSize) {
  queryForm.pageSize = pageSize
  queryForm.pageNum = 1
  loadOrders()
}

async function handleQuickCreateFromRoute() {
  if (route.query.quickCreate !== '1' || !route.query.relicId) {
    return
  }
  if (dialogVisible.value && formData.relicIds.includes(Number(route.query.relicId))) {
    return
  }
  await openCreate({ relicId: route.query.relicId })
}

watch(
  () => route.fullPath,
  () => {
    handleQuickCreateFromRoute()
  },
  { immediate: true }
)

loadOrders()
</script>

<style scoped>
.table-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}

.drawer-table {
  margin-top: 18px;
}
</style>
