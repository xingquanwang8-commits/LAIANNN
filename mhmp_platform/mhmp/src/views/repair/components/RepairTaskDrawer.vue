<template>
  <el-drawer v-model="drawerVisible" title="修复任务详情" size="62%">
    <div class="detail-stack">
      <div class="overview-panel overview-panel--compact">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">MHMP Repair Task</div>
            <h3 class="overview-panel__title drawer-overview__title">{{ detail?.taskNo || '修复任务详情' }}</h3>
            <p class="overview-panel__desc">
              查看修复任务的申请、审批、执行、验收与归档信息，便于在修复全流程中进行核查和追踪。
            </p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">任务状态 {{ currentTaskStatusLabel }}</span>
            <span class="overview-chip overview-chip--accent">验收状态 {{ currentAcceptanceStatusLabel }}</span>
          </div>
        </div>

        <div class="metric-grid drawer-metrics">
          <article class="metric-card">
            <span class="metric-card__label">修复过程记录</span>
            <strong class="metric-card__value">{{ logCount }}</strong>
            <div class="metric-card__meta">已登记的过程日志条数</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">历史修复任务</span>
            <strong class="metric-card__value">{{ historyTaskCount }}</strong>
            <div class="metric-card__meta">该文物关联的历史修复任务数</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">修复资料附件</span>
            <strong class="metric-card__value">{{ attachmentCount }}</strong>
            <div class="metric-card__meta">过程图片和过程附件合计数量</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">关联文物</span>
            <strong class="metric-card__value drawer-metric-text">{{ detail?.relicName || '--' }}</strong>
            <div class="metric-card__meta">文物编号 {{ detail?.relicNo || '--' }}</div>
          </article>
        </div>
      </div>

      <section class="info-section">
        <div class="info-section__header">
          <div>
            <h3 class="info-section__title">任务信息</h3>
            <p class="info-section__desc">
              汇总修复任务编号、文物信息、申请与审批信息、开始与完成时间，作为修复业务的主记录。
            </p>
          </div>
        </div>

        <el-descriptions :column="2" border>
          <el-descriptions-item label="任务编号">{{ detail?.taskNo || '--' }}</el-descriptions-item>
          <el-descriptions-item label="任务状态">
            <StatusTag :status="detail?.taskStatus" :label="currentTaskStatusLabel" />
          </el-descriptions-item>
          <el-descriptions-item label="验收状态">
            <StatusTag :status="detail?.acceptanceStatus" :label="currentAcceptanceStatusLabel" />
          </el-descriptions-item>
          <el-descriptions-item label="文物编号">{{ detail?.relicNo || '--' }}</el-descriptions-item>
          <el-descriptions-item label="文物名称">{{ detail?.relicName || '--' }}</el-descriptions-item>
          <el-descriptions-item label="申请人">{{ detail?.applyUserName || '--' }}</el-descriptions-item>
          <el-descriptions-item label="申请时间">{{ formatDateTime(detail?.applyTime) }}</el-descriptions-item>
          <el-descriptions-item label="审批人">{{ detail?.approveUserName || '--' }}</el-descriptions-item>
          <el-descriptions-item label="审批时间">{{ formatDateTime(detail?.approveTime) }}</el-descriptions-item>
          <el-descriptions-item label="开始时间">{{ formatDateTime(detail?.startTime) }}</el-descriptions-item>
          <el-descriptions-item label="完成时间">{{ formatDateTime(detail?.endTime) }}</el-descriptions-item>
          <el-descriptions-item label="申请原因" :span="2">{{ detail?.applyReason || '--' }}</el-descriptions-item>
          <el-descriptions-item label="审批意见" :span="2">{{ detail?.approveRemark || '--' }}</el-descriptions-item>
          <el-descriptions-item label="备注" :span="2">{{ detail?.remark || '--' }}</el-descriptions-item>
        </el-descriptions>
      </section>

      <section v-if="detail?.historyTasks?.length" class="info-section">
        <PageHeader
          title="历史修复任务"
          description="查看该文物以往的修复任务、申请原因和完成情况，便于横向比对修复履历。"
        />
        <el-table :data="detail.historyTasks">
          <el-table-column prop="taskNo" label="任务编号" min-width="150" />
          <el-table-column label="任务状态" width="120">
            <template #default="{ row }">
              <StatusTag :status="row.taskStatus" :label="taskStatusLabelMap[row.taskStatus] || row.taskStatus || '--'" />
            </template>
          </el-table-column>
          <el-table-column label="验收状态" width="120">
            <template #default="{ row }">
              <StatusTag
                :status="row.acceptanceStatus"
                :label="acceptanceStatusLabelMap[row.acceptanceStatus] || row.acceptanceStatus || '--'"
              />
            </template>
          </el-table-column>
          <el-table-column label="申请时间" min-width="160">
            <template #default="{ row }">{{ formatDateTime(row.applyTime) }}</template>
          </el-table-column>
          <el-table-column label="完成时间" min-width="160">
            <template #default="{ row }">{{ formatDateTime(row.endTime) }}</template>
          </el-table-column>
          <el-table-column prop="applyReason" label="申请原因" min-width="220" show-overflow-tooltip />
        </el-table>
      </section>

      <section class="info-section">
        <PageHeader
          title="修复过程记录"
          description="按时间线查看本次修复中的关键步骤、处理内容、操作人和材料信息。"
        />
        <el-timeline v-if="detail?.logs?.length">
          <el-timeline-item
            v-for="log in detail.logs"
            :key="log.id"
            :timestamp="formatDateTime(log.logTime)"
            placement="top"
          >
            <div class="timeline-card">
              <div class="timeline-card__header">
                <div class="timeline-card__title">
                  {{ log.stepName || '修复过程更新' }}
                </div>
                <StatusTag
                  :status="log.progressStatus"
                  :label="progressLabelMap[log.progressStatus] || log.progressStatus || '--'"
                />
              </div>
              <div class="timeline-card__desc">{{ log.operationContent || '--' }}</div>
              <div class="timeline-card__meta">操作人：{{ log.operatorName || '--' }}</div>
              <div class="timeline-card__meta">使用材料：{{ log.materialsUsed || '--' }}</div>
              <div class="timeline-card__meta">备注：{{ log.remark || '--' }}</div>
            </div>
          </el-timeline-item>
        </el-timeline>
        <el-empty v-else class="empty-block" description="当前暂无修复过程记录。" />
      </section>

      <section class="info-section">
        <PageHeader
          title="修复资料"
          description="集中查看修复过程图片和附件，便于后续验收、归档和答辩展示。"
        />
        <el-table v-if="detail?.attachments?.length" :data="detail.attachments">
          <el-table-column label="资料类型" min-width="120">
            <template #default="{ row }">{{ attachmentTypeLabelMap[row.attachmentType] || row.attachmentType || '--' }}</template>
          </el-table-column>
          <el-table-column label="文件名称" min-width="260">
            <template #default="{ row }">
              <div class="document-file-name">{{ row.fileName || '--' }}</div>
            </template>
          </el-table-column>
          <el-table-column label="文件大小" min-width="120">
            <template #default="{ row }">{{ formatFileSize(row.fileSize) }}</template>
          </el-table-column>
          <el-table-column prop="remark" label="备注" min-width="220" show-overflow-tooltip />
          <el-table-column label="操作" class-name="table-action-column" width="180">
            <template #default="{ row }">
              <div class="file-action-group">
                <el-button text type="primary" :icon="TopRight" @click="openOriginalFile(row)">预览</el-button>
              </div>
            </template>
          </el-table-column>
        </el-table>
        <el-empty v-else class="empty-block" description="当前暂无修复资料。" />
      </section>

      <section class="info-section">
        <div class="info-section__header">
          <div>
            <h3 class="info-section__title">验收记录</h3>
            <p class="info-section__desc">
              查看验收结果、验收意见和后续建议，明确修复任务是否已形成最终业务结论。
            </p>
          </div>
        </div>

        <el-descriptions v-if="detail?.acceptance" :column="1" border>
          <el-descriptions-item label="验收结果">
            {{ detail.acceptance.acceptanceResult === 'PASS' ? '通过' : '未通过' }}
          </el-descriptions-item>
          <el-descriptions-item label="验收时间">
            {{ formatDateTime(detail.acceptance.acceptanceTime) }}
          </el-descriptions-item>
          <el-descriptions-item :label="detail.acceptance.acceptanceResult === 'PASS' ? '验收意见' : '驳回原因'">
            {{ detail.acceptance.acceptanceRemark || '--' }}
          </el-descriptions-item>
          <el-descriptions-item label="后续建议">
            {{ detail.acceptance.followUpSuggestion || '--' }}
          </el-descriptions-item>
        </el-descriptions>
        <div v-else class="soft-note">
          <div class="soft-note__title">当前尚未形成验收记录</div>
          <div class="soft-note__desc">
            任务在提交验收前会持续保留在修复过程页；提交后进入待验收队列，验收完成后将在这里显示最终结果。
          </div>
        </div>
      </section>
    </div>
  </el-drawer>
</template>

<script setup>
import { computed } from 'vue'
import { ElMessage } from 'element-plus'
import { TopRight } from '@element-plus/icons-vue'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { openOriginalFile as openOriginalFileUrl } from '@/utils/filePreview'
import { formatDateTime } from '@/utils/format'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  detail: {
    type: Object,
    default: () => ({})
  }
})

const emit = defineEmits(['update:modelValue'])

const drawerVisible = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value)
})

const taskStatusLabelMap = {
  APPLIED: '待审批',
  APPROVED: '已审批',
  IN_PROGRESS: '修复中',
  COMPLETED: '已完成',
  ACCEPTED: '已验收',
  REJECTED: '已驳回'
}

const acceptanceStatusLabelMap = {
  UNACCEPTED: '尚未验收',
  WAITING: '等待验收',
  SUCCESS: '验收成功',
  REJECTED: '验收被驳回'
}

const progressLabelMap = {
  IN_PROGRESS: '进行中',
  COMPLETED: '已完成'
}

const attachmentTypeLabelMap = {
  REPAIR_IMAGE: '过程图片',
  REPAIR_FILE: '过程附件'
}

const currentTaskStatusLabel = computed(() =>
  taskStatusLabelMap[props.detail?.taskStatus] || props.detail?.taskStatus || '--'
)
const currentAcceptanceStatusLabel = computed(() =>
  acceptanceStatusLabelMap[props.detail?.acceptanceStatus] || props.detail?.acceptanceStatus || '--'
)
const logCount = computed(() => props.detail?.logs?.length || 0)
const historyTaskCount = computed(() => props.detail?.historyTasks?.length || 0)
const attachmentCount = computed(() => props.detail?.attachments?.length || 0)

function formatFileSize(fileSize) {
  if (!fileSize) {
    return '--'
  }
  if (fileSize < 1024) {
    return `${fileSize} B`
  }
  if (fileSize < 1024 * 1024) {
    return `${(fileSize / 1024).toFixed(1)} KB`
  }
  return `${(fileSize / (1024 * 1024)).toFixed(1)} MB`
}

function openOriginalFile(file) {
  if (!openOriginalFileUrl(file)) {
    ElMessage.warning('浏览器阻止了新页面打开，请允许弹出窗口后重试')
  }
}
</script>

<style scoped>
.drawer-overview__title {
  font-size: 22px;
}

.drawer-metrics {
  grid-template-columns: repeat(4, minmax(0, 1fr));
}

.drawer-metric-text {
  font-size: 20px;
  line-height: 1.35;
}

.timeline-card {
  padding: 14px 16px;
  border: 1px solid var(--border-line);
  border-radius: 16px;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.98), rgba(248, 243, 236, 0.94));
}

.timeline-card__header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 12px;
}

.timeline-card__title {
  font-weight: 700;
}

.timeline-card__desc {
  margin-top: 10px;
  line-height: 1.7;
}

.timeline-card__meta {
  margin-top: 6px;
  color: var(--text-second);
  font-size: 13px;
  line-height: 1.7;
}

.file-action-group {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  flex-wrap: wrap;
}

.document-file-name {
  line-height: 1.6;
  white-space: normal;
  word-break: break-all;
}

@media (max-width: 960px) {
  .drawer-metrics {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 640px) {
  .drawer-metrics {
    grid-template-columns: 1fr;
  }

  .timeline-card__header {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>
