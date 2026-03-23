<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <PageHeader title="库存查询" description="从库存总览和明细列表两个维度查看当前在库文物情况。" />
    </section>

    <section class="page-grid summary-grid">
      <article class="page-card page-card--section summary-card">
        <div class="summary-card__label">文物总量</div>
        <div class="summary-card__value">{{ summary.totalCount || 0 }}</div>
      </article>
      <article class="page-card page-card--section summary-card">
        <div class="summary-card__label">在库文物</div>
        <div class="summary-card__value">{{ summary.inStockCount || 0 }}</div>
      </article>
      <article class="page-card page-card--section summary-card">
        <div class="summary-card__label">待出库</div>
        <div class="summary-card__value">{{ summary.outboundPendingCount || 0 }}</div>
      </article>
      <article class="page-card page-card--section summary-card">
        <div class="summary-card__label">修复中</div>
        <div class="summary-card__value">{{ summary.inRepairCount || 0 }}</div>
      </article>
    </section>

    <section class="page-card page-card--section">
      <el-form :inline="true" :model="queryForm">
        <el-form-item label="关键词">
          <el-input v-model="queryForm.keyword" placeholder="文物编号 / 名称" clearable @keyup.enter="handleSearch" />
        </el-form-item>
        <el-form-item label="类别">
          <el-select v-model="queryForm.categoryCode" clearable placeholder="全部类别">
            <el-option v-for="item in categoryOptions" :key="item.itemValue" :label="item.itemLabel" :value="item.itemValue" />
          </el-select>
        </el-form-item>
        <el-form-item label="材质">
          <el-select v-model="queryForm.materialCode" clearable placeholder="全部材质">
            <el-option v-for="item in materialOptions" :key="item.itemValue" :label="item.itemLabel" :value="item.itemValue" />
          </el-select>
        </el-form-item>
        <el-form-item label="位置">
          <el-select v-model="queryForm.storageLocationCode" clearable placeholder="全部位置">
            <el-option v-for="item in locationOptions" :key="item.itemValue" :label="item.itemLabel" :value="item.itemValue" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="queryForm.currentStatus" clearable placeholder="全部状态">
            <el-option v-for="item in statusOptions" :key="item.itemValue" :label="item.itemLabel" :value="item.itemValue" />
          </el-select>
        </el-form-item>
        <el-form-item label="保存状态">
          <el-select v-model="queryForm.preservationStatusCode" clearable placeholder="全部保存状态">
            <el-option v-for="item in preservationOptions" :key="item.itemValue" :label="item.itemLabel" :value="item.itemValue" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </section>

    <section class="page-card page-card--section">
      <el-table :data="pageData.records" v-loading="loading">
        <el-table-column prop="relicNo" label="文物编号" min-width="140" />
        <el-table-column prop="name" label="文物名称" min-width="170" />
        <el-table-column label="类别" min-width="120">
          <template #default="{ row }">{{ resolveDictLabel(categoryOptions, row.categoryCode) }}</template>
        </el-table-column>
        <el-table-column label="材质" min-width="120">
          <template #default="{ row }">{{ resolveDictLabel(materialOptions, row.materialCode) }}</template>
        </el-table-column>
        <el-table-column label="位置" min-width="120">
          <template #default="{ row }">{{ resolveDictLabel(locationOptions, row.storageLocationCode) }}</template>
        </el-table-column>
        <el-table-column label="保存状态" min-width="120">
          <template #default="{ row }">{{ resolveDictLabel(preservationOptions, row.preservationStatusCode) }}</template>
        </el-table-column>
        <el-table-column label="当前状态" min-width="120">
          <template #default="{ row }">
            <StatusTag :status="row.currentStatus" :label="resolveDictLabel(statusOptions, row.currentStatus)" />
          </template>
        </el-table-column>
        <el-table-column label="更新时间" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.updateTime) }}</template>
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
  </div>
</template>

<script setup>
import { computed, reactive, ref } from 'vue'
import { getInventoryQueryPageApi, getInventorySummaryApi } from '@/api/inventory'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { useDictStore } from '@/stores/dict'
import { formatDateTime, resolveDictLabel } from '@/utils/format'

const dictStore = useDictStore()

const loading = ref(false)
const summary = ref({})
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
  materialCode: '',
  storageLocationCode: '',
  preservationStatusCode: '',
  currentStatus: ''
})

const categoryOptions = computed(() => dictStore.itemsMap.relic_category || [])
const materialOptions = computed(() => dictStore.itemsMap.relic_material || [])
const locationOptions = computed(() => dictStore.itemsMap.storage_location || [])
const preservationOptions = computed(() => dictStore.itemsMap.preservation_status || [])
const statusOptions = computed(() => dictStore.itemsMap.relic_status || [])

async function loadSummary() {
  summary.value = await getInventorySummaryApi()
}

async function loadPage() {
  loading.value = true
  try {
    pageData.value = await getInventoryQueryPageApi(queryForm)
  } finally {
    loading.value = false
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
    materialCode: '',
    storageLocationCode: '',
    preservationStatusCode: '',
    currentStatus: ''
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

dictStore.ensureMultipleItems([
  'relic_category',
  'relic_material',
  'storage_location',
  'preservation_status',
  'relic_status'
])
loadSummary()
loadPage()
</script>

<style scoped>
.summary-grid {
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
}

.summary-card__label {
  color: var(--text-second);
  font-size: 13px;
}

.summary-card__value {
  margin-top: 10px;
  font-size: 28px;
  font-weight: 700;
}

.table-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}
</style>
