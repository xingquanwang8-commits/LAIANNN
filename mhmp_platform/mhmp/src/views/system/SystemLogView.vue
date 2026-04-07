<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="overview-panel overview-panel--compact">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">MHMP Audit Trail</div>
            <h2 class="overview-panel__title">操作日志</h2>
            <p class="overview-panel__desc">
              统一审计平台内的关键操作、接口请求和执行结果，用于复盘权限使用、异常排查和业务留痕，
              支撑博物馆文物综合管理平台的可追溯运行要求。
            </p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">筛选结果 {{ pageData.total }} 条</span>
            <span class="overview-chip overview-chip--accent">异常日志 {{ failCount }} 条</span>
          </div>
        </div>

        <div class="metric-grid log-metrics">
          <article class="metric-card">
            <span class="metric-card__label">当前页日志</span>
            <strong class="metric-card__value">{{ currentPageCount }}</strong>
            <div class="metric-card__meta">本页返回的审计日志记录数量。</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">执行成功</span>
            <strong class="metric-card__value">{{ successCount }}</strong>
            <div class="metric-card__meta">当前页执行成功的接口或业务操作记录。</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">执行失败</span>
            <strong class="metric-card__value">{{ failCount }}</strong>
            <div class="metric-card__meta">当前页执行失败或返回异常的日志记录。</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">平均耗时</span>
            <strong class="metric-card__value">{{ averageCostTimeText }}</strong>
            <div class="metric-card__meta">用于观察当前筛选范围内接口执行耗时表现。</div>
          </article>
        </div>
      </div>
    </section>

    <section class="page-card page-card--section">
      <PageHeader
        title="日志检索"
        description="按用户名、模块、业务类型和执行结果筛选审计日志，支持进入详情查看请求参数和返回结果。"
      />

      <div class="query-toolbar">
        <el-form :inline="true" :model="queryForm" class="query-form query-form--single-line">
          <el-form-item label="用户名" class="query-form__keyword">
            <el-select v-model="queryForm.username" clearable filterable placeholder="全部账号">
              <el-option
                v-for="item in usernameOptions"
                :key="item"
                :label="item"
                :value="item"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="模块">
            <el-select v-model="queryForm.moduleName" clearable filterable placeholder="全部模块">
              <el-option
                v-for="item in moduleOptions"
                :key="item"
                :label="item"
                :value="item"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="业务类型">
            <el-select v-model="queryForm.businessType" clearable filterable placeholder="全部业务类型">
              <el-option
                v-for="item in businessTypeOptions"
                :key="item"
                :label="item"
                :value="item"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="结果">
            <el-select v-model="queryForm.operationStatus" clearable placeholder="全部结果">
              <el-option label="成功" value="SUCCESS" />
              <el-option label="失败" value="FAIL" />
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
          <div class="list-section__title">日志结果</div>
          <div class="list-section__desc">
            当前展示 {{ currentPageCount }} 条日志记录，可快速定位系统模块、执行状态、请求地址和耗时表现。
          </div>
        </div>
      </div>

      <el-table :data="pageData.records" v-loading="loading">
        <template #empty>
          <el-empty class="empty-block" description="未检索到符合条件的日志记录，请调整筛选条件后重试。" />
        </template>
        <el-table-column prop="username" label="用户名" min-width="120" />
        <el-table-column prop="moduleName" label="模块" min-width="120" />
        <el-table-column prop="businessType" label="业务类型" min-width="120" />
        <el-table-column prop="requestMethod" label="请求方式" width="110" />
        <el-table-column prop="requestUri" label="请求地址" min-width="220" show-overflow-tooltip />
        <el-table-column label="执行结果" width="110">
          <template #default="{ row }">
            <StatusTag :status="row.operationStatus" :label="row.operationStatus === 'SUCCESS' ? '成功' : '失败'" />
          </template>
        </el-table-column>
        <el-table-column label="耗时(ms)" width="110">
          <template #default="{ row }">{{ row.costTime || 0 }}</template>
        </el-table-column>
        <el-table-column label="操作时间" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.operationTime) }}</template>
        </el-table-column>
        <el-table-column label="操作" class-name="table-action-column" width="100">
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

    <el-drawer v-model="drawerVisible" title="日志详情" size="48%">
      <div class="detail-stack">
        <div class="overview-panel overview-panel--compact log-drawer-overview">
          <div class="overview-panel__top">
            <div>
              <div class="overview-panel__eyebrow">Operation Detail</div>
              <h3 class="overview-panel__title log-drawer-overview__title">{{ detail.moduleName || '日志详情' }}</h3>
              <p class="overview-panel__desc">
                {{ detail.operationDesc || '查看当前操作的执行结果、请求信息、请求参数和返回结果。' }}
              </p>
            </div>
            <div class="overview-panel__meta">
              <span class="overview-chip">操作账号 {{ detail.username || '--' }}</span>
              <span class="overview-chip overview-chip--accent">执行结果 {{ detailStatusLabel }}</span>
            </div>
          </div>
        </div>

        <section class="info-section">
          <div class="info-section__header">
            <div>
              <h3 class="info-section__title">执行摘要</h3>
              <p class="info-section__desc">汇总当前日志的模块、业务类型、请求地址、执行状态和耗时信息。</p>
            </div>
          </div>

          <el-descriptions :column="2" border>
            <el-descriptions-item label="用户名">{{ detail.username || '--' }}</el-descriptions-item>
            <el-descriptions-item label="模块">{{ detail.moduleName || '--' }}</el-descriptions-item>
            <el-descriptions-item label="业务类型">{{ detail.businessType || '--' }}</el-descriptions-item>
            <el-descriptions-item label="执行结果">{{ detailStatusLabel }}</el-descriptions-item>
            <el-descriptions-item label="请求方式">{{ detail.requestMethod || '--' }}</el-descriptions-item>
            <el-descriptions-item label="请求地址">{{ detail.requestUri || '--' }}</el-descriptions-item>
            <el-descriptions-item label="耗时(ms)">{{ detail.costTime || 0 }}</el-descriptions-item>
            <el-descriptions-item label="操作时间">{{ formatDateTime(detail.operationTime) }}</el-descriptions-item>
            <el-descriptions-item label="操作 IP" :span="2">{{ detail.operationIp || '--' }}</el-descriptions-item>
            <el-descriptions-item label="操作说明" :span="2">{{ detail.operationDesc || '--' }}</el-descriptions-item>
          </el-descriptions>
        </section>

        <section class="info-section">
          <div class="info-section__header">
            <div>
              <h3 class="info-section__title">请求参数</h3>
              <p class="info-section__desc">记录接口调用时的原始请求内容，便于复盘提交参数和定位问题。</p>
            </div>
          </div>
          <pre class="detail-code-block">{{ detail.requestParam || '--' }}</pre>
        </section>

        <section class="info-section">
          <div class="info-section__header">
            <div>
              <h3 class="info-section__title">返回结果</h3>
              <p class="info-section__desc">记录接口返回结果或异常响应，用于核对执行表现和后端处理结果。</p>
            </div>
          </div>
          <pre class="detail-code-block">{{ detail.responseResult || '--' }}</pre>
        </section>
      </div>
    </el-drawer>
  </div>
</template>

<script setup>
import { computed, reactive, ref } from 'vue'
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

const currentPageCount = computed(() => pageData.value.records.length)
const successCount = computed(() => pageData.value.records.filter((item) => item.operationStatus === 'SUCCESS').length)
const failCount = computed(() => pageData.value.records.filter((item) => item.operationStatus === 'FAIL').length)
const defaultUsernameOptions = []
const defaultModuleOptions = ['工作台', '文物管理', '库存管理', '出库管理', '修复管理', '系统管理', '个人中心']
const defaultBusinessTypeOptions = ['查询', '新增', '编辑', '删除', '审批', '驳回', '验收', '上传', '导出', '登录']
const usernameOptions = computed(() => {
  const values = new Set(defaultUsernameOptions)
  pageData.value.records.forEach((item) => {
    if (item.username) {
      values.add(item.username)
    }
  })
  return Array.from(values)
})
const moduleOptions = computed(() => {
  const values = new Set(defaultModuleOptions)
  pageData.value.records.forEach((item) => {
    if (item.moduleName) {
      values.add(item.moduleName)
    }
  })
  return Array.from(values)
})
const businessTypeOptions = computed(() => {
  const values = new Set(defaultBusinessTypeOptions)
  pageData.value.records.forEach((item) => {
    if (item.businessType) {
      values.add(item.businessType)
    }
  })
  return Array.from(values)
})
const averageCostTimeText = computed(() => {
  if (!pageData.value.records.length) {
    return '0 ms'
  }
  const total = pageData.value.records.reduce((sum, item) => sum + Number(item.costTime || 0), 0)
  const average = total / pageData.value.records.length
  return `${average.toFixed(average >= 100 ? 0 : 1)} ms`
})
const detailStatusLabel = computed(() => detail.value.operationStatus === 'SUCCESS' ? '成功' : detail.value.operationStatus === 'FAIL' ? '失败' : '--')

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
.log-metrics {
  grid-template-columns: repeat(4, minmax(0, 1fr));
}

.log-drawer-overview__title {
  font-size: 22px;
}

@media (max-width: 960px) {
  .log-metrics {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 640px) {
  .log-metrics {
    grid-template-columns: 1fr;
  }
}
</style>
