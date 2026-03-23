<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <PageHeader title="操作日志" description="查询各模块新增、修改、审批和登录登出等关键操作记录。" />
    </section>

    <section class="page-card page-card--section">
      <el-form :inline="true" :model="queryForm">
        <el-form-item label="用户名">
          <el-input v-model="queryForm.username" clearable />
        </el-form-item>
        <el-form-item label="模块">
          <el-input v-model="queryForm.moduleName" clearable />
        </el-form-item>
        <el-form-item label="业务类型">
          <el-input v-model="queryForm.businessType" clearable />
        </el-form-item>
        <el-form-item label="结果">
          <el-select v-model="queryForm.operationStatus" clearable placeholder="全部结果">
            <el-option label="成功" value="SUCCESS" />
            <el-option label="失败" value="FAIL" />
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
        <el-table-column prop="username" label="用户名" min-width="120" />
        <el-table-column prop="moduleName" label="模块" min-width="120" />
        <el-table-column prop="businessType" label="业务类型" min-width="120" />
        <el-table-column prop="requestMethod" label="请求方式" width="110" />
        <el-table-column prop="requestUri" label="请求地址" min-width="180" show-overflow-tooltip />
        <el-table-column label="执行结果" width="110">
          <template #default="{ row }">
            <StatusTag :status="row.operationStatus" :label="row.operationStatus === 'SUCCESS' ? '成功' : '失败'" />
          </template>
        </el-table-column>
        <el-table-column label="耗时(ms)" width="100">
          <template #default="{ row }">{{ row.costTime || 0 }}</template>
        </el-table-column>
        <el-table-column label="操作时间" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.operationTime) }}</template>
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

    <el-drawer v-model="drawerVisible" title="日志详情" size="46%">
      <el-descriptions :column="1" border>
        <el-descriptions-item label="用户名">{{ detail.username || '--' }}</el-descriptions-item>
        <el-descriptions-item label="模块">{{ detail.moduleName || '--' }}</el-descriptions-item>
        <el-descriptions-item label="业务类型">{{ detail.businessType || '--' }}</el-descriptions-item>
        <el-descriptions-item label="执行结果">
          {{ detail.operationStatus === 'SUCCESS' ? '成功' : '失败' }}
        </el-descriptions-item>
        <el-descriptions-item label="请求方式">{{ detail.requestMethod || '--' }}</el-descriptions-item>
        <el-descriptions-item label="请求地址">{{ detail.requestUri || '--' }}</el-descriptions-item>
        <el-descriptions-item label="操作说明">{{ detail.operationDesc || '--' }}</el-descriptions-item>
        <el-descriptions-item label="操作 IP">{{ detail.operationIp || '--' }}</el-descriptions-item>
        <el-descriptions-item label="请求参数">
          <pre class="log-block">{{ detail.requestParam || '--' }}</pre>
        </el-descriptions-item>
        <el-descriptions-item label="返回结果">
          <pre class="log-block">{{ detail.responseResult || '--' }}</pre>
        </el-descriptions-item>
      </el-descriptions>
    </el-drawer>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { getLogDetailApi, getLogPageApi } from '@/api/system'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
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
  username: '',
  moduleName: '',
  businessType: '',
  operationStatus: ''
})

async function loadLogs() {
  loading.value = true
  try {
    pageData.value = await getLogPageApi(queryForm)
  } finally {
    loading.value = false
  }
}

async function openDetail(id) {
  detail.value = await getLogDetailApi(id)
  drawerVisible.value = true
}

function handleSearch() {
  queryForm.pageNum = 1
  loadLogs()
}

function handleReset() {
  Object.assign(queryForm, {
    pageNum: 1,
    pageSize: 10,
    username: '',
    moduleName: '',
    businessType: '',
    operationStatus: ''
  })
  loadLogs()
}

function handleCurrentChange(pageNum) {
  queryForm.pageNum = pageNum
  loadLogs()
}

function handleSizeChange(pageSize) {
  queryForm.pageSize = pageSize
  queryForm.pageNum = 1
  loadLogs()
}

loadLogs()
</script>

<style scoped>
.table-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}

.log-block {
  margin: 0;
  white-space: pre-wrap;
  word-break: break-all;
  font-family: Consolas, Monaco, monospace;
}
</style>
