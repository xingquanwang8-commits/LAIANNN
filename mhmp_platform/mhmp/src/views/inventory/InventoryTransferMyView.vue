<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="overview-panel overview-panel--compact">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">MHMP My Transfer</div>
            <h2 class="overview-panel__title">我的转存</h2>
            <p class="overview-panel__desc">
              展示当前登录研究员负责执行的转存任务。完成实际转存后，可在此确认完成，系统会同步更新文物库位并写入业务留痕。
            </p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">我的任务 {{ pageData.total }} 条</span>
            <span class="overview-chip overview-chip--accent">当前页 {{ currentPageCount }} 条</span>
          </div>
        </div>

        <div class="metric-grid transfer-metrics">
          <article class="metric-card">
            <span class="metric-card__label">待确认</span>
            <strong class="metric-card__value">{{ assignedCount }}</strong>
            <div class="metric-card__meta">已派发给当前研究员、尚未确认完成的转存任务。</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">已完成</span>
            <strong class="metric-card__value">{{ completedCount }}</strong>
            <div class="metric-card__meta">已经完成确认并正式更新库位的转存任务。</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页库位</span>
            <strong class="metric-card__value">{{ locationCount }}</strong>
            <div class="metric-card__meta">当前页任务覆盖的目标库位数量，便于集中安排执行。</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页文物</span>
            <strong class="metric-card__value">{{ currentPageCount }}</strong>
            <div class="metric-card__meta">可直接查看文物详情或进入确认流程。</div>
          </article>
        </div>
      </div>
    </section>

    <section class="page-card page-card--section">
      <PageHeader
        title="我的转存检索"
        description="按任务编号、文物编号、文物名称和任务状态筛选当前研究员负责的转存任务。"
      />

      <div class="query-toolbar query-toolbar--approval">
        <el-radio-group v-model="queryForm.taskStatus" @change="handleSearch">
          <el-radio-button label="ASSIGNED">待确认</el-radio-button>
          <el-radio-button label="COMPLETED">已完成</el-radio-button>
          <el-radio-button label="">全部</el-radio-button>
        </el-radio-group>

        <el-form :inline="true" :model="queryForm" class="query-form query-form--single-line">
          <el-form-item label="关键字" class="query-form__keyword query-form__keyword--wide">
            <el-input
              v-model="queryForm.keyword"
              placeholder="任务编号 / 文物编号 / 文物名称"
              clearable
              @keyup.enter="handleSearch"
            />
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
          <div class="list-section__title">我的转存任务</div>
          <div class="list-section__desc">
            当前展示 {{ currentPageCount }} 条任务，可查看文物详情，并对待确认任务执行“确认转存”。
          </div>
        </div>
      </div>

      <el-table :data="pageData.records" v-loading="loading">
        <template #empty>
          <el-empty class="empty-block" description="当前没有匹配的转存任务，请调整筛选条件后重试。" />
        </template>
        <el-table-column prop="taskNo" label="任务编号" min-width="160" />
        <el-table-column prop="relicNo" label="文物编号" min-width="140" />
        <el-table-column prop="relicName" label="文物名称" min-width="180" />
        <el-table-column label="转存路径" min-width="220">
          <template #default="{ row }">
            <div class="path-cell">
              <span>{{ resolveDictLabel(locationOptions, row.fromLocationCode) || row.fromLocationCode || '--' }}</span>
              <span class="path-cell__arrow">→</span>
              <span>{{ resolveDictLabel(locationOptions, row.targetLocationCode) || row.targetLocationCode || '--' }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="assignUserName" label="派发人" min-width="120" />
        <el-table-column label="任务状态" width="120">
          <template #default="{ row }">
            <StatusTag :status="row.taskStatus" :label="taskStatusLabelMap[row.taskStatus] || row.taskStatus" />
          </template>
        </el-table-column>
        <el-table-column label="派发时间" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.assignTime) }}</template>
        </el-table-column>
        <el-table-column label="完成时间" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.completeTime) }}</template>
        </el-table-column>
        <el-table-column label="操作" class-name="table-action-column" width="220" fixed="right">
          <template #default="{ row }">
            <el-button text type="primary" @click="router.push(`/relic/detail/${row.relicId}`)">详情</el-button>
            <el-button
              text
              type="primary"
              :disabled="row.taskStatus !== 'ASSIGNED'"
              @click="openConfirmDialog(row)"
            >
              确认转存
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

    <el-dialog v-model="dialogVisible" title="确认转存" width="720px">
      <div class="detail-stack">
        <div class="overview-panel overview-panel--compact transfer-dialog-overview">
          <div class="overview-panel__top">
            <div>
              <div class="overview-panel__eyebrow">Transfer Confirmation</div>
              <h3 class="overview-panel__title transfer-dialog-overview__title">
                {{ currentTask?.taskNo || '确认转存' }}
              </h3>
              <p class="overview-panel__desc">
                请在完成实际转存后再次确认。确认成功后，系统会正式更新文物库位，并同步写入业务时间线。
              </p>
            </div>
            <div class="overview-panel__meta">
              <span class="overview-chip">{{ currentTask?.relicNo || '--' }}</span>
              <span class="overview-chip overview-chip--accent">{{ currentTask?.relicName || '未选择任务' }}</span>
            </div>
          </div>
        </div>

        <div class="soft-note soft-note--accent">
          <div class="soft-note__title">执行提示</div>
          <div class="soft-note__desc">
            请确认实物已转移至目标库位后再提交。若库位已被他人修改，系统会阻止提交并提示重新发起任务。
          </div>
        </div>

        <div v-if="currentTask" class="task-summary-grid">
          <section class="info-section">
            <div class="info-section__header">
              <div>
                <h3 class="info-section__title">任务信息</h3>
                <p class="info-section__desc">核对当前任务对应的文物、库位和派发信息。</p>
              </div>
            </div>
            <el-descriptions :column="1" border>
              <el-descriptions-item label="文物">{{ currentTask.relicNo }} / {{ currentTask.relicName }}</el-descriptions-item>
              <el-descriptions-item label="当前库位">
                {{ resolveDictLabel(locationOptions, currentTask.fromLocationCode) || currentTask.fromLocationCode || '--' }}
              </el-descriptions-item>
              <el-descriptions-item label="目标库位">
                {{ resolveDictLabel(locationOptions, currentTask.targetLocationCode) || currentTask.targetLocationCode || '--' }}
              </el-descriptions-item>
              <el-descriptions-item label="派发人">{{ currentTask.assignUserName || '--' }}</el-descriptions-item>
              <el-descriptions-item label="转存说明">{{ currentTask.transferReason || '--' }}</el-descriptions-item>
            </el-descriptions>
          </section>

          <section class="info-section">
            <div class="info-section__header">
              <div>
                <h3 class="info-section__title">确认说明</h3>
                <p class="info-section__desc">可选填写现场执行情况、复核备注或需要提醒的事项。</p>
              </div>
            </div>

            <el-form label-width="88px">
              <el-form-item label="补充说明">
                <el-input
                  v-model="formData.confirmRemark"
                  type="textarea"
                  :rows="6"
                  placeholder="可填写实际转存情况、库位复核说明或后续提醒事项"
                />
              </el-form-item>
            </el-form>
          </section>
        </div>
      </div>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleConfirmTransfer">确认转存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { computed, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { confirmTransferTaskApi, getMyTransferTaskPageApi } from '@/api/inventory'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { useDictStore } from '@/stores/dict'
import { formatDateTime, resolveDictLabel } from '@/utils/format'

const router = useRouter()
const dictStore = useDictStore()

const loading = ref(false)
const saving = ref(false)
const dialogVisible = ref(false)
const currentTask = ref(null)
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
  taskStatus: 'ASSIGNED'
})

const formData = reactive({
  confirmRemark: ''
})

const taskStatusLabelMap = {
  ASSIGNED: '待确认',
  COMPLETED: '已完成'
}

const locationOptions = computed(() => dictStore.itemsMap.storage_location || [])
const currentPageCount = computed(() => pageData.value.records.length)
const assignedCount = computed(() => pageData.value.records.filter((item) => item.taskStatus === 'ASSIGNED').length)
const completedCount = computed(() => pageData.value.records.filter((item) => item.taskStatus === 'COMPLETED').length)
const locationCount = computed(() =>
  new Set(pageData.value.records.map((item) => item.targetLocationCode).filter(Boolean)).size
)

function resetForm() {
  formData.confirmRemark = ''
}

async function loadPage() {
  loading.value = true
  try {
    pageData.value = await getMyTransferTaskPageApi(queryForm)
  } finally {
    loading.value = false
  }
}

function openConfirmDialog(row) {
  currentTask.value = row
  resetForm()
  dialogVisible.value = true
}

async function handleConfirmTransfer() {
  if (!currentTask.value?.id) {
    return
  }
  try {
    await ElMessageBox.confirm(
      '确认已经完成文物转存吗？确认后系统会正式更新文物库位。',
      '确认转存',
      {
        confirmButtonText: '确认完成',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    saving.value = true
    await confirmTransferTaskApi(currentTask.value.id, {
      confirmRemark: formData.confirmRemark
    })
    ElMessage.success('转存任务已确认完成')
    dialogVisible.value = false
    await loadPage()
  } catch (error) {
    if (error === 'cancel' || error === 'close') {
      return
    }
    throw error
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
    taskStatus: 'ASSIGNED'
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

dictStore.ensureItems('storage_location')
loadPage()
</script>

<style scoped>
.transfer-metrics {
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

.table-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}

.path-cell {
  display: inline-flex;
  align-items: center;
  gap: 10px;
}

.path-cell__arrow {
  color: var(--text-second);
}

.transfer-dialog-overview__title {
  font-size: 22px;
}

.task-summary-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 18px;
}

@media (max-width: 960px) {
  .transfer-metrics,
  .task-summary-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 720px) {
  .transfer-metrics,
  .task-summary-grid {
    grid-template-columns: 1fr;
  }
}
</style>
