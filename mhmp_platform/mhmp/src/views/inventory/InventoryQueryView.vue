<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="overview-panel overview-panel--compact">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">MHMP Inventory Snapshot</div>
            <h2 class="overview-panel__title">库存查询</h2>
            <p class="overview-panel__desc">
              面向馆藏文物库存台账的综合查询入口，可按类别、材质、保存状态、当前状态和库位组合筛查，
              用于支撑流转判断、盘点核验和修复联动。
            </p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">馆藏总量 {{ summary.totalCount || 0 }} 件</span>
            <span class="overview-chip overview-chip--accent">在库文物 {{ summary.inStockCount || 0 }} 件</span>
          </div>
        </div>

        <div class="metric-grid inventory-summary-grid">
          <article class="metric-card">
            <span class="metric-card__label">待出库处理</span>
            <strong class="metric-card__value">{{ summary.outboundPendingCount || 0 }}</strong>
            <div class="metric-card__meta">待审批或待归还登记的出库业务，可从库存视角快速定位。</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">修复进行中</span>
            <strong class="metric-card__value">{{ summary.inRepairCount || 0 }}</strong>
            <div class="metric-card__meta">当前处于修复流程中的文物，需同步关注保存状态和返库安排。</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页在库</span>
            <strong class="metric-card__value">{{ pageInStockCount }}</strong>
            <div class="metric-card__meta">本页结果中可直接参与转存、盘点和出库申请的文物数量。</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">涉及库位</span>
            <strong class="metric-card__value">{{ uniqueLocationCount }}</strong>
            <div class="metric-card__meta">当前筛查结果覆盖的馆内库位数量，便于掌握分布范围。</div>
          </article>
        </div>
      </div>
    </section>

    <section class="page-card page-card--section">
      <PageHeader
        title="库存台账筛查"
        description="按馆藏属性和业务状态组合筛选库存文物，用于定位待流转、待修复跟踪或待盘点核验的馆藏对象。"
      />

      <div class="query-toolbar">
        <el-form :inline="true" :model="queryForm" class="query-form query-form--single-line">
          <el-form-item label="关键字" class="query-form__keyword">
            <el-input v-model="queryForm.keyword" placeholder="文物编号 / 名称" clearable @keyup.enter="handleSearch" />
          </el-form-item>
          <el-form-item label="类别">
            <el-select v-model="queryForm.categoryCode" clearable placeholder="全部类别">
              <el-option
                v-for="item in categoryOptions"
                :key="item.itemValue"
                :label="item.itemLabel"
                :value="item.itemValue"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="材质">
            <el-select v-model="queryForm.materialCode" clearable placeholder="全部材质">
              <el-option
                v-for="item in materialOptions"
                :key="item.itemValue"
                :label="item.itemLabel"
                :value="item.itemValue"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="馆藏库位">
            <el-select v-model="queryForm.storageLocationCode" clearable placeholder="全部库位">
              <el-option
                v-for="item in locationOptions"
                :key="item.itemValue"
                :label="item.itemLabel"
                :value="item.itemValue"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="当前状态">
            <el-select v-model="queryForm.currentStatus" clearable placeholder="全部状态">
              <el-option
                v-for="item in statusOptions"
                :key="item.itemValue"
                :label="item.itemLabel"
                :value="item.itemValue"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="保存状态">
            <el-select v-model="queryForm.preservationStatusCode" clearable placeholder="全部保存状态">
              <el-option
                v-for="item in preservationOptions"
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
      </div>
    </section>

    <section class="page-card page-card--section">
      <div class="list-section__header">
        <div>
          <div class="list-section__title">库存台账结果</div>
          <div class="list-section__desc">
            当前展示 {{ currentPageCount }} 条库存记录，可用于核对文物档案、业务状态、保存状态和馆藏库位。
          </div>
        </div>
      </div>

      <el-table :data="pageData.records" v-loading="loading" class="inventory-query-table">
        <template #empty>
          <el-empty class="empty-block" description="未检索到符合条件的库存记录，请调整筛选条件后重试。" />
        </template>
        <el-table-column prop="relicNo" label="文物编号" min-width="140" />
        <el-table-column label="文物名称" min-width="220">
          <template #default="{ row }">
            <div class="inventory-name-cell">
              <div class="inventory-name-cell__title">{{ row.name || '--' }}</div>
              <div class="inventory-name-cell__meta">
                保存状态：{{ resolveDictLabel(preservationOptions, row.preservationStatusCode) || '--' }}
              </div>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="类别" min-width="120">
          <template #default="{ row }">{{ resolveDictLabel(categoryOptions, row.categoryCode) }}</template>
        </el-table-column>
        <el-table-column label="材质" min-width="120">
          <template #default="{ row }">{{ resolveDictLabel(materialOptions, row.materialCode) }}</template>
        </el-table-column>
        <el-table-column label="馆藏库位" min-width="120">
          <template #default="{ row }">{{ resolveDictLabel(locationOptions, row.storageLocationCode) }}</template>
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
const currentPageCount = computed(() => pageData.value.records.length)
const pageInStockCount = computed(() => pageData.value.records.filter((item) => item.currentStatus === 'IN_STOCK').length)
const uniqueLocationCount = computed(() =>
  new Set(pageData.value.records.map((item) => item.storageLocationCode).filter(Boolean)).size
)

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
.inventory-summary-grid {
  grid-template-columns: repeat(4, minmax(0, 1fr));
}

.inventory-name-cell {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  text-align: center;
}

.inventory-name-cell__title {
  font-size: 14px;
  font-weight: 700;
  color: var(--text-main);
}

.inventory-name-cell__meta {
  color: var(--text-second);
  font-size: 12px;
  line-height: 1.6;
}

@media (max-width: 960px) {
  .inventory-summary-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 640px) {
  .inventory-summary-grid {
    grid-template-columns: 1fr;
  }
}
</style>
