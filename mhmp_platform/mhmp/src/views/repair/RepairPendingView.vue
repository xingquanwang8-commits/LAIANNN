<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <el-form :inline="true" :model="queryForm" class="query-form query-form--single-line">
        <el-form-item label="关键词" class="query-form__keyword">
          <el-input v-model="queryForm.keyword" placeholder="文物编号 / 文物名称" clearable @keyup.enter="handleSearch" />
        </el-form-item>
        <el-form-item label="类别">
          <el-select v-model="queryForm.categoryCode" clearable placeholder="全部类别">
            <el-option v-for="item in categoryOptions" :key="item.itemValue" :label="item.itemLabel" :value="item.itemValue" />
          </el-select>
        </el-form-item>
        <el-form-item label="库位">
          <el-select v-model="queryForm.storageLocationCode" clearable placeholder="全部库位">
            <el-option v-for="item in locationOptions" :key="item.itemValue" :label="item.itemLabel" :value="item.itemValue" />
          </el-select>
        </el-form-item>
        <el-form-item class="query-form__actions">
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </section>

    <section class="page-card page-card--section">
      <el-table :data="pageData.records" v-loading="loading">
        <el-table-column prop="relicNo" label="文物编号" min-width="150" />
        <el-table-column prop="name" label="文物名称" min-width="180" />
        <el-table-column label="类别" min-width="120">
          <template #default="{ row }">{{ resolveDictLabel(categoryOptions, row.categoryCode) }}</template>
        </el-table-column>
        <el-table-column label="库位" min-width="130">
          <template #default="{ row }">{{ resolveDictLabel(locationOptions, row.storageLocationCode) }}</template>
        </el-table-column>
        <el-table-column label="保存状态" min-width="130">
          <template #default="{ row }">{{ resolveDictLabel(preservationOptions, row.preservationStatusCode) }}</template>
        </el-table-column>
        <el-table-column label="更新时间" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.updateTime) }}</template>
        </el-table-column>
        <el-table-column label="操作" width="180">
          <template #default="{ row }">
            <el-button text type="primary" @click="router.push(`/relic/detail/${row.id}`)">详情</el-button>
            <el-button
              v-if="authStore.hasPermission('repair:apply:submit')"
              text
              type="primary"
              @click="openApplyDialog(row)"
            >
              申请修复
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

    <el-dialog v-model="dialogVisible" title="提交修复申请" width="620px">
      <el-form ref="formRef" :model="formData" :rules="rules" label-width="96px">
        <el-form-item label="文物">
          <div>{{ currentRelic?.relicNo }} / {{ currentRelic?.name }}</div>
        </el-form-item>
        <el-form-item v-if="repairCheckResult" label="业务校验">
          <div
            class="business-check repair-check"
            :class="repairCheckResult.passed ? 'business-check--pass' : 'business-check--warn'"
          >
            <div class="business-check__header">
              <div class="business-check__title">{{ repairCheckTitle }}</div>
            </div>
            <div class="business-check__summary">{{ repairCheckSummary }}</div>
          </div>
        </el-form-item>
        <el-form-item label="申请原因" prop="applyReason">
          <el-input v-model="formData.applyReason" type="textarea" :rows="4" />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="formData.remark" type="textarea" :rows="3" />
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
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { createRepairApplyApi, getPendingRepairRelicPageApi } from '@/api/repair'
import { getRelicDetailApi } from '@/api/relic'
import { useAuthStore } from '@/stores/auth'
import { useDictStore } from '@/stores/dict'
import { formatDateTime, resolveDictLabel } from '@/utils/format'
import {
  checkRepairRelicEligibility,
  pickRelicBusinessFields
} from '@/utils/relicBusinessRules'

const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()
const dictStore = useDictStore()

const loading = ref(false)
const saving = ref(false)
const dialogVisible = ref(false)
const formRef = ref()
const currentRelic = ref(null)
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
  storageLocationCode: ''
})

const formData = reactive({
  applyReason: '',
  remark: ''
})

const rules = {
  applyReason: [{ required: true, message: '请输入申请原因', trigger: 'blur' }]
}

const categoryOptions = computed(() => dictStore.itemsMap.relic_category || [])
const locationOptions = computed(() => dictStore.itemsMap.storage_location || [])
const preservationOptions = computed(() => dictStore.itemsMap.preservation_status || [])
const statusOptions = computed(() => dictStore.itemsMap.relic_status || [])
const repairCheckResult = computed(() => (
  currentRelic.value ? checkRepairRelicEligibility(currentRelic.value) : null
))
const repairCheckTitle = computed(() => (
  repairCheckResult.value?.passed
    ? '\u4fee\u590d\u524d\u7f6e\u6821\u9a8c\u5df2\u901a\u8fc7'
    : '\u4fee\u590d\u524d\u7f6e\u6821\u9a8c\u672a\u901a\u8fc7'
))
const repairCheckSummary = computed(() => {
  if (!currentRelic.value || !repairCheckResult.value) {
    return ''
  }
  const statusLabel = resolveDictLabel(statusOptions.value, currentRelic.value.currentStatus) || '--'
  const preservationLabel = resolveDictLabel(
    preservationOptions.value,
    currentRelic.value.preservationStatusCode
  ) || '--'
  return `\u5f53\u524d\u72b6\u6001\uff1a${statusLabel}\uff1b\u4fdd\u5b58\u72b6\u6001\uff1a${preservationLabel}\uff1b${repairCheckResult.value.message}\u3002`
})

async function loadPage() {
  loading.value = true
  try {
    pageData.value = await getPendingRepairRelicPageApi(queryForm)
  } finally {
    loading.value = false
  }
}

async function openApplyDialog(row, options = {}) {
  const relic = {
    ...row,
    ...pickRelicBusinessFields(row)
  }
  const checkResult = checkRepairRelicEligibility(relic)
  if (!checkResult.passed) {
    ElMessage.warning(checkResult.message)
    return
  }
  currentRelic.value = relic
  formData.applyReason = ''
  formData.remark = options.quickCreate ? '由文物详情快捷发起' : ''
  dialogVisible.value = true
  await nextTick()
  formRef.value?.clearValidate()
}

async function handleSubmit() {
  await formRef.value.validate()
  if (!repairCheckResult.value?.passed) {
    ElMessage.warning(repairCheckResult.value?.message || '\u5f53\u524d\u6587\u7269\u4e0d\u7b26\u5408\u53d1\u8d77\u4fee\u590d\u7684\u6761\u4ef6')
    return
  }
  saving.value = true
  try {
    await createRepairApplyApi({
      relicId: currentRelic.value.id,
      applyReason: formData.applyReason,
      remark: formData.remark
    })
    ElMessage.success('修复申请已提交')
    dialogVisible.value = false
    await loadPage()
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
    categoryCode: '',
    storageLocationCode: ''
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

async function handleQuickCreateFromRoute() {
  if (route.query.quickCreate !== '1' || !route.query.relicId) {
    return
  }
  if (dialogVisible.value && String(currentRelic.value?.id) === String(route.query.relicId)) {
    return
  }

  const detail = await getRelicDetailApi(route.query.relicId).catch(() => null)
  if (!detail) {
    return
  }
  await openApplyDialog({
    ...detail,
    ...pickRelicBusinessFields(detail)
  }, {
    quickCreate: true
  })
}

watch(
  () => route.fullPath,
  () => {
    handleQuickCreateFromRoute()
  },
  { immediate: true }
)

dictStore.ensureMultipleItems(['relic_category', 'storage_location', 'preservation_status', 'relic_status'])
loadPage()
</script>

<style scoped>
.repair-check {
  width: 100%;
}

.table-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}
</style>
