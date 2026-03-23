<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <PageHeader
        title="出库申请"
        description="先填写出库用途与去向，再从当前在库文物中选择待申请对象。"
      />
    </section>

    <section class="page-card page-card--section">
      <el-form ref="formRef" :model="form" :rules="rules" label-position="top">
        <div class="page-grid outbound-form-grid">
          <el-form-item label="用途" prop="purpose">
            <el-input v-model="form.purpose" placeholder="如：馆际专题展 / 学术研究展示" />
          </el-form-item>
          <el-form-item label="去向" prop="destination">
            <el-input v-model="form.destination" placeholder="请输入去向单位或展陈地点" />
          </el-form-item>
          <el-form-item label="经手人" prop="handlerName">
            <el-input v-model="form.handlerName" placeholder="请输入经手人姓名" />
          </el-form-item>
          <el-form-item label="申请时间" prop="outboundTime">
            <el-date-picker
              v-model="form.outboundTime"
              type="datetime"
              placeholder="请选择申请时间"
              format="YYYY-MM-DD HH:mm"
              value-format="YYYY-MM-DDTHH:mm:ss"
            />
          </el-form-item>
        </div>
        <el-form-item label="备注">
          <el-input v-model="form.remark" type="textarea" :rows="3" placeholder="可补充审批说明或外借背景" />
        </el-form-item>
      </el-form>
    </section>

    <section class="page-card page-card--section">
      <PageHeader
        title="选择文物"
        description="只展示当前状态为“在库”的文物，勾选后将一并提交到出库申请。"
      >
        <template #extra>
          <el-tag type="info" effect="plain" round>已选 {{ selectedRows.length }} 件</el-tag>
        </template>
      </PageHeader>

      <el-form :inline="true" :model="relicQuery" class="outbound-filter">
        <el-form-item label="关键词">
          <el-input
            v-model="relicQuery.keyword"
            placeholder="文物编号 / 名称"
            clearable
            @keyup.enter="handleRelicSearch"
          />
        </el-form-item>
        <el-form-item label="类别">
          <el-select v-model="relicQuery.categoryCode" placeholder="全部类别" clearable>
            <el-option
              v-for="item in categoryOptions"
              :key="item.itemValue"
              :label="item.itemLabel"
              :value="item.itemValue"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="位置">
          <el-select v-model="relicQuery.storageLocationCode" placeholder="全部位置" clearable>
            <el-option
              v-for="item in locationOptions"
              :key="item.itemValue"
              :label="item.itemLabel"
              :value="item.itemValue"
            />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleRelicSearch">查询</el-button>
          <el-button @click="handleRelicReset">重置</el-button>
        </el-form-item>
      </el-form>

      <el-table
        ref="tableRef"
        v-loading="tableLoading"
        :data="pageData.records"
        row-key="id"
        @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" width="50" />
        <el-table-column prop="relicNo" label="文物编号" min-width="140" />
        <el-table-column prop="name" label="文物名称" min-width="180" />
        <el-table-column label="类别" min-width="120">
          <template #default="{ row }">
            {{ resolveDictLabel(categoryOptions, row.categoryCode) }}
          </template>
        </el-table-column>
        <el-table-column label="位置" min-width="120">
          <template #default="{ row }">
            {{ resolveDictLabel(locationOptions, row.storageLocationCode) }}
          </template>
        </el-table-column>
        <el-table-column label="状态" min-width="110">
          <template #default="{ row }">
            <StatusTag
              :status="row.currentStatus"
              :label="resolveDictLabel(statusOptions, row.currentStatus)"
            />
          </template>
        </el-table-column>
      </el-table>

      <div class="relic-pagination">
        <el-pagination
          :current-page="relicQuery.pageNum"
          :page-size="relicQuery.pageSize"
          :page-sizes="[8, 12, 20]"
          :total="pageData.total"
          layout="total, sizes, prev, pager, next"
          @current-change="handleCurrentChange"
          @size-change="handleSizeChange"
        />
      </div>

      <div class="outbound-submit">
        <el-button type="primary" :loading="submitting" @click="handleSubmit">
          提交出库申请
        </el-button>
      </div>
    </section>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { createOutboundApi } from '@/api/outbound'
import { getRelicPageApi } from '@/api/relic'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { useDictStore } from '@/stores/dict'
import { resolveDictLabel } from '@/utils/format'

const dictStore = useDictStore()
const formRef = ref(null)
const tableRef = ref(null)
const tableLoading = ref(false)
const submitting = ref(false)
const selectedRows = ref([])
const pageData = ref({
  total: 0,
  records: []
})

const form = reactive({
  purpose: '',
  destination: '',
  handlerName: '',
  outboundTime: getCurrentDateTime(),
  remark: ''
})

const rules = {
  purpose: [{ required: true, message: '请输入用途', trigger: 'blur' }],
  destination: [{ required: true, message: '请输入去向', trigger: 'blur' }],
  handlerName: [{ required: true, message: '请输入经手人', trigger: 'blur' }],
  outboundTime: [{ required: true, message: '请选择申请时间', trigger: 'change' }]
}

const relicQuery = reactive({
  pageNum: 1,
  pageSize: 8,
  keyword: '',
  categoryCode: '',
  storageLocationCode: '',
  currentStatus: 'IN_STOCK'
})

const categoryOptions = computed(() => dictStore.itemsMap.relic_category || [])
const locationOptions = computed(() => dictStore.itemsMap.storage_location || [])
const statusOptions = computed(() => dictStore.itemsMap.relic_status || [])

function getCurrentDateTime() {
  const now = new Date()
  const year = now.getFullYear()
  const month = `${now.getMonth() + 1}`.padStart(2, '0')
  const day = `${now.getDate()}`.padStart(2, '0')
  const hour = `${now.getHours()}`.padStart(2, '0')
  const minute = `${now.getMinutes()}`.padStart(2, '0')
  const second = `${now.getSeconds()}`.padStart(2, '0')
  return `${year}-${month}-${day}T${hour}:${minute}:${second}`
}

async function loadRelics() {
  tableLoading.value = true
  try {
    pageData.value = await getRelicPageApi(relicQuery)
  } finally {
    tableLoading.value = false
  }
}

function handleSelectionChange(rows) {
  selectedRows.value = rows
}

function handleRelicSearch() {
  relicQuery.pageNum = 1
  loadRelics()
}

function handleRelicReset() {
  Object.assign(relicQuery, {
    pageNum: 1,
    pageSize: 8,
    keyword: '',
    categoryCode: '',
    storageLocationCode: '',
    currentStatus: 'IN_STOCK'
  })
  loadRelics()
}

function handleCurrentChange(pageNum) {
  relicQuery.pageNum = pageNum
  loadRelics()
}

function handleSizeChange(pageSize) {
  relicQuery.pageSize = pageSize
  relicQuery.pageNum = 1
  loadRelics()
}

async function handleSubmit() {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) {
    return
  }
  if (!selectedRows.value.length) {
    ElMessage.warning('请先勾选至少一件文物')
    return
  }
  submitting.value = true
  try {
    await createOutboundApi({
      ...form,
      relicIds: selectedRows.value.map((item) => item.id)
    })
    ElMessage.success('出库申请已提交')
    Object.assign(form, {
      purpose: '',
      destination: '',
      handlerName: '',
      outboundTime: getCurrentDateTime(),
      remark: ''
    })
    tableRef.value?.clearSelection()
    selectedRows.value = []
    await loadRelics()
  } finally {
    submitting.value = false
  }
}

onMounted(async () => {
  await dictStore.ensureMultipleItems([
    'relic_category',
    'storage_location',
    'relic_status'
  ])
  await loadRelics()
})
</script>

<style scoped>
.outbound-form-grid {
  grid-template-columns: repeat(2, minmax(0, 1fr));
}

.outbound-filter {
  display: flex;
  flex-wrap: wrap;
  margin-top: 16px;
}

.outbound-submit {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}

@media (max-width: 960px) {
  .outbound-form-grid {
    grid-template-columns: 1fr;
  }
}
</style>
