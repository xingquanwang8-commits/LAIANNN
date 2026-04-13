<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="overview-panel overview-panel--compact">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">MHMP Collection Ledger</div>
            <h2 class="overview-panel__title">馆藏文物列表</h2>
            <p class="overview-panel__desc">
              统一查看馆藏文物的档案、状态、库位与数字化资料，便于在盘点、修复、出入库和转存流程中快速定位业务对象。
            </p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">馆藏台账 {{ pageData.total }} 条</span>
            <span class="overview-chip overview-chip--accent">当前页 {{ currentPageCount }} 条</span>
          </div>
        </div>

        <div class="metric-grid relic-list__metrics">
          <article class="metric-card">
            <span class="metric-card__label">当前页在库文物</span>
            <strong class="metric-card__value">{{ inStockCount }}</strong>
            <div class="metric-card__meta">可直接进入盘点、转存和出库业务</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页修复中</span>
            <strong class="metric-card__value">{{ repairCount }}</strong>
            <div class="metric-card__meta">重点关注修复验收与保管状态联动</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页待流转业务</span>
            <strong class="metric-card__value">{{ pendingFlowCount }}</strong>
            <div class="metric-card__meta">包含待入库、入库待审与出库待审文物</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页已配图档案</span>
            <strong class="metric-card__value">{{ illustratedCount }}</strong>
            <div class="metric-card__meta">支持台账浏览、核验与答辩展示</div>
          </article>
        </div>
      </div>
    </section>

    <section class="page-card page-card--section">
      <PageHeader
        title="文物台账检索"
        description="按类别、材质、当前状态、保存状态和库位组合筛选，快速定位需要办理业务的文物档案。"
      >
        <template #extra>
          <el-button
            v-if="authStore.hasPermission('relic:add')"
            type="primary"
            @click="router.push('/relic/create')"
          >
            新建文物档案
          </el-button>
        </template>
      </PageHeader>

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
          <el-form-item label="库位">
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
      </div>
    </section>

    <section class="page-card page-card--section">
      <div class="list-section__header">
        <div>
          <div class="list-section__title">检索结果</div>
          <div class="list-section__desc">
            当前展示 {{ currentPageCount }} 条文物档案，可直接进入详情、编辑或删除操作。
          </div>
        </div>
      </div>

      <el-table :data="pageData.records" v-loading="loading" row-key="id" class="relic-list-table">
        <template #empty>
          <el-empty class="empty-block" description="未检索到符合条件的文物档案，请调整筛选条件后重试。" />
        </template>

        <el-table-column label="主图" width="108">
          <template #default="{ row }">
            <el-popover
              v-if="row.imageUrl"
              placement="right"
              trigger="hover"
              :width="280"
              popper-class="artifact-preview-popover"
            >
              <template #reference>
                <div class="artifact-preview-frame artifact-preview-frame--table artifact-preview-frame--interactive">
                  <img :src="row.imageUrl" alt="文物图片" class="artifact-preview-frame__image artifact-preview-frame__image--cover">
                  <div class="artifact-preview-frame__badge">预览</div>
                </div>
              </template>

              <div class="artifact-preview-panel">
                <img
                  :src="row.imageUrl"
                  :alt="row.name || '文物主图预览'"
                  class="artifact-preview-panel__image artifact-preview-panel__image--table"
                >
                <div class="artifact-preview-panel__name">{{ row.name || '文物主图' }}</div>
                <div class="artifact-preview-panel__meta">{{ row.relicNo || '未生成编号' }}</div>
              </div>
            </el-popover>

            <div v-else class="artifact-preview-frame artifact-preview-frame--table">
              <div class="artifact-preview-frame__empty">未上传主图</div>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="relicNo" label="文物编号" min-width="150" />
        <el-table-column label="文物名称" min-width="220">
          <template #default="{ row }">
            <div class="relic-name-cell">
              <div class="relic-name-cell__title">{{ row.name || '--' }}</div>
              <div class="relic-name-cell__meta">{{ row.era || '年代信息待补充' }}</div>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="类别" min-width="120">
          <template #default="{ row }">{{ resolveDictLabel(categoryOptions, row.categoryCode) }}</template>
        </el-table-column>
        <el-table-column label="材质" min-width="110">
          <template #default="{ row }">{{ resolveDictLabel(materialOptions, row.materialCode) }}</template>
        </el-table-column>
        <el-table-column label="藏品库位" min-width="120">
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
        <el-table-column label="更新时间" min-width="150">
          <template #default="{ row }">{{ formatDateTime(row.updateTime) }}</template>
        </el-table-column>
        <el-table-column label="操作" class-name="table-action-column" fixed="right" width="220">
          <template #default="{ row }">
            <el-button text type="primary" @click="router.push(`/relic/detail/${row.id}`)">详情</el-button>
            <el-button v-if="authStore.hasPermission('relic:edit')" text @click="router.push(`/relic/edit/${row.id}`)">
              编辑
            </el-button>
            <el-button
              v-if="authStore.hasPermission('relic:delete')"
              text
              type="danger"
              @click="handleDelete(row)"
            >
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="relic-pagination">
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
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { deleteRelicApi, getRelicPageApi } from '@/api/relic'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { useAuthStore } from '@/stores/auth'
import { useDictStore } from '@/stores/dict'
import { formatDateTime, resolveDictLabel } from '@/utils/format'

const router = useRouter()
const authStore = useAuthStore()
const dictStore = useDictStore()

const loading = ref(false)
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
  currentStatus: '',
  storageLocationCode: '',
  preservationStatusCode: ''
})

const categoryOptions = computed(() => dictStore.itemsMap.relic_category || [])
const materialOptions = computed(() => dictStore.itemsMap.relic_material || [])
const statusOptions = computed(() => dictStore.itemsMap.relic_status || [])
const locationOptions = computed(() => dictStore.itemsMap.storage_location || [])
const preservationOptions = computed(() => dictStore.itemsMap.preservation_status || [])
const currentPageCount = computed(() => pageData.value.records.length)
const inStockCount = computed(() => pageData.value.records.filter((item) => item.currentStatus === 'IN_STOCK').length)
const repairCount = computed(() => pageData.value.records.filter((item) => item.currentStatus === 'IN_REPAIR').length)
const pendingFlowCount = computed(() =>
  pageData.value.records.filter((item) => ['TO_BE_INBOUND', 'INBOUND_PENDING', 'OUTBOUND_PENDING'].includes(item.currentStatus)).length
)
const illustratedCount = computed(() => pageData.value.records.filter((item) => item.imageUrl).length)

async function loadRelics() {
  loading.value = true
  try {
    pageData.value = await getRelicPageApi(queryForm)
  } finally {
    loading.value = false
  }
}

function handleSearch() {
  queryForm.pageNum = 1
  loadRelics()
}

function handleReset() {
  Object.assign(queryForm, {
    pageNum: 1,
    pageSize: 10,
    keyword: '',
    categoryCode: '',
    materialCode: '',
    currentStatus: '',
    storageLocationCode: '',
    preservationStatusCode: ''
  })
  loadRelics()
}

async function handleDelete(row) {
  await ElMessageBox.confirm(`确认删除文物“${row.name}”吗？`, '删除确认', {
    type: 'warning'
  })
  await deleteRelicApi(row.id)
  ElMessage.success('文物已删除')
  await loadRelics()
}

function handleCurrentChange(pageNum) {
  queryForm.pageNum = pageNum
  loadRelics()
}

function handleSizeChange(pageSize) {
  queryForm.pageSize = pageSize
  queryForm.pageNum = 1
  loadRelics()
}

dictStore.ensureMultipleItems([
  'relic_category',
  'relic_material',
  'relic_status',
  'storage_location',
  'preservation_status'
])
loadRelics()
</script>

<style scoped>
.relic-list__metrics {
  grid-template-columns: repeat(4, minmax(0, 1fr));
}

.list-section__header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 16px;
}

.list-section__title {
  font-size: 17px;
  font-weight: 700;
}

.list-section__desc {
  margin-top: 8px;
  color: var(--text-second);
  font-size: 13px;
  line-height: 1.8;
}

.relic-name-cell {
  width: 100%;
  text-align: center;
}

.relic-name-cell__title {
  font-size: 14px;
  font-weight: 700;
  color: var(--text-main);
}

.relic-name-cell__meta {
  margin-top: 6px;
  color: var(--text-second);
  font-size: 12px;
  line-height: 1.6;
}

.relic-pagination {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}

@media (max-width: 960px) {
  .relic-list__metrics {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 640px) {
  .relic-list__metrics {
    grid-template-columns: 1fr;
  }
}
</style>
