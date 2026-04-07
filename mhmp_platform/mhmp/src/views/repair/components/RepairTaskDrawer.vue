<template>
  <el-drawer v-model="drawerVisible" title="修复任务详情" size="58%">
    <el-descriptions :column="2" border>
      <el-descriptions-item label="任务编号">{{ detail?.taskNo || '--' }}</el-descriptions-item>
      <el-descriptions-item label="任务状态">
        <StatusTag :status="detail?.taskStatus" :label="taskStatusLabelMap[detail?.taskStatus] || detail?.taskStatus || '--'" />
      </el-descriptions-item>
      <el-descriptions-item label="验收状态">
        <StatusTag
          :status="detail?.acceptanceStatus"
          :label="acceptanceStatusLabelMap[detail?.acceptanceStatus] || detail?.acceptanceStatus || '--'"
        />
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

    <section v-if="detail?.historyTasks?.length" class="detail-section">
      <div class="detail-section__title">该文物历次修复任务</div>
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

    <section class="detail-section">
      <div class="detail-section__title">详细修复过程</div>
      <el-timeline v-if="detail?.logs?.length">
        <el-timeline-item
          v-for="log in detail.logs"
          :key="log.id"
          :timestamp="formatDateTime(log.logTime)"
        >
          <div class="timeline-title">
            {{ log.stepName || '修复过程更新' }} / {{ progressLabelMap[log.progressStatus] || log.progressStatus || '--' }}
          </div>
          <div class="timeline-text">{{ log.operationContent || '--' }}</div>
          <div class="timeline-meta">操作人：{{ log.operatorName || '--' }}</div>
          <div class="timeline-meta">使用材料：{{ log.materialsUsed || '--' }}</div>
          <div class="timeline-meta">备注：{{ log.remark || '--' }}</div>
        </el-timeline-item>
      </el-timeline>
      <el-empty v-else description="暂无修复过程记录" />
    </section>

    <section v-if="detail?.attachments?.length" class="detail-section">
      <div class="detail-section__title">修复资料</div>
      <el-table :data="detail.attachments">
        <el-table-column label="资料类型" min-width="120">
          <template #default="{ row }">{{ attachmentTypeLabelMap[row.attachmentType] || row.attachmentType || '--' }}</template>
        </el-table-column>
        <el-table-column prop="fileName" label="文件名称" min-width="240" />
        <el-table-column label="文件大小" min-width="120">
          <template #default="{ row }">{{ formatFileSize(row.fileSize) }}</template>
        </el-table-column>
        <el-table-column prop="remark" label="备注" min-width="220" show-overflow-tooltip />
        <el-table-column label="操作" width="100">
          <template #default="{ row }">
            <a :href="row.fileUrl" target="_blank" rel="noreferrer">查看</a>
          </template>
        </el-table-column>
      </el-table>
    </section>

    <section v-if="detail?.acceptance" class="detail-section">
      <div class="detail-section__title">验收记录</div>
      <el-descriptions :column="1" border>
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
    </section>
  </el-drawer>
</template>

<script setup>
import { computed } from 'vue'
import StatusTag from '@/components/common/StatusTag.vue'
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
</script>

<style scoped>
.detail-section {
  margin-top: 20px;
}

.detail-section__title {
  margin-bottom: 12px;
  font-size: 15px;
  font-weight: 700;
}

.timeline-title {
  font-weight: 600;
}

.timeline-text {
  margin-top: 6px;
}

.timeline-meta {
  margin-top: 4px;
  color: var(--text-second);
  font-size: 13px;
}
</style>
