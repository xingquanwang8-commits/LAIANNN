<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <PageHeader title="文物列表" description="支持按编号、名称、类别、状态、保存状态与库位筛选文物档案。">
        <template #extra>
          <el-button
            v-if="authStore.hasPermission('relic:add')"
            type="primary"
            @click="router.push('/relic/create')"
          >
            新增文物
          </el-button>
        </template>
      </PageHeader>
    </section>

    <section class="page-card page-card--section">
      <el-form :inline="true" :model="queryForm" class="relic-filter">
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
        <el-form-item label="状态">
          <el-select v-model="queryForm.currentStatus" clearable placeholder="全部状态">
            <el-option v-for="item in statusOptions" :key="item.itemValue" :label="item.itemLabel" :value="item.itemValue" />
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
        <el-form-item label="位置">
          <el-select v-model="queryForm.storageLocationCode" clearable placeholder="全部位置">
            <el-option v-for="item in locationOptions" :key="item.itemValue" :label="item.itemLabel" :value="item.itemValue" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </section>

    <section class="page-card page-card--section">
      <el-table :data="pageData.records" v-loading="loading" row-key="id">
        <el-table-column label="主图" width="96">
          <template #default="{ row }">
            <img v-if="row.imageUrl" :src="row.imageUrl" alt="文物图片" class="table-image">
            <div v-else class="table-image relic-image__empty">无图</div>
          </template>
        </el-table-column>
        <el-table-column prop="relicNo" label="文物编号" min-width="150" />
        <el-table-column prop="name" label="文物名称" min-width="180" />
        <el-table-column label="类别" min-width="120">
          <template #default="{ row }">{{ resolveDictLabel(categoryOptions, row.categoryCode) }}</template>
        </el-table-column>
        <el-table-column label="材质" min-width="110">
          <template #default="{ row }">{{ resolveDictLabel(materialOptions, row.materialCode) }}</template>
        </el-table-column>
        <el-table-column label="馆藏位置" min-width="120">
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
        <el-table-column label="操作" fixed="right" width="220">
          <template #default="{ row }">
            <el-button text type="primary" @click="router.push(`/relic/detail/${row.id}`)">详情</el-button>
            <el-button v-if="authStore.hasPermission('relic:edit')" text @click="router.push(`/relic/edit/${row.id}`)">编辑</el-button>
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
.relic-filter {
  display: flex;
  flex-wrap: wrap;
}

.relic-image__empty {
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--text-second);
  font-size: 12px;
}

.relic-pagination {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}
</style>
