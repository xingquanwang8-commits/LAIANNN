<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <el-form :inline="true" :model="queryForm" class="query-form query-form--single-line">
        <el-form-item label="关键词" class="query-form__keyword query-form__keyword--wide">
          <el-input v-model="queryForm.keyword" placeholder="任务编号 / 文物编号 / 文物名称" clearable @keyup.enter="loadPage" />
        </el-form-item>
        <el-form-item class="query-form__actions">
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </section>

    <section class="page-card page-card--section">
      <el-table :data="pageData.records" v-loading="loading">
        <el-table-column prop="taskNo" label="任务编号" min-width="150" />
        <el-table-column prop="relicNo" label="文物编号" min-width="140" />
        <el-table-column prop="relicName" label="文物名称" min-width="180" />
        <el-table-column label="验收状态" width="120">
          <template #default="{ row }">
            <StatusTag :status="row.acceptanceStatus" :label="acceptanceStatusLabelMap[row.acceptanceStatus] || row.acceptanceStatus || '--'" />
          </template>
        </el-table-column>
        <el-table-column label="完成时间" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.endTime) }}</template>
        </el-table-column>
        <el-table-column label="申请时间" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.applyTime) }}</template>
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

    <RepairTaskDrawer v-model="drawerVisible" :detail="detail" />
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { getRepairedRepairPageApi, getRepairDetailApi } from '@/api/repair'
import StatusTag from '@/components/common/StatusTag.vue'
import RepairTaskDrawer from './components/RepairTaskDrawer.vue'
import { formatDateTime } from '@/utils/format'

const loading = ref(false)
const drawerVisible = ref(false)
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
  keyword: ''
})

const acceptanceStatusLabelMap = {
  SUCCESS: '验收成功'
}

async function loadPage() {
  loading.value = true
  try {
    pageData.value = await getRepairedRepairPageApi(queryForm)
  } finally {
    loading.value = false
  }
}

async function openDetail(id) {
  detail.value = await getRepairDetailApi(id)
  drawerVisible.value = true
}

function handleSearch() {
  queryForm.pageNum = 1
  loadPage()
}

function handleReset() {
  Object.assign(queryForm, {
    pageNum: 1,
    pageSize: 10,
    keyword: ''
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

loadPage()
</script>

<style scoped>
.table-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}
</style>
