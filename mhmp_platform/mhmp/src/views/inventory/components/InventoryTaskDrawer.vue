<template>
  <el-drawer v-model="drawerVisible" title="盘点任务详情" size="60%">
    <div class="detail-stack">
      <div class="overview-panel overview-panel--compact drawer-overview">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">Inventory Detail</div>
            <h3 class="overview-panel__title drawer-overview__title">{{ detail.taskNo || '盘点任务详情' }}</h3>
            <p class="overview-panel__desc">
              查看当前盘点任务的库位、负责人、任务状态和盘点明细，可在任务未完成前持续登记实盘数量与差异备注。
            </p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">{{ resolveDictLabel(locationOptions, detail.locationCode) || '--' }}</span>
            <span class="overview-chip overview-chip--accent">差异 {{ diffCount }} 项</span>
          </div>
        </div>
      </div>

      <section class="info-section">
        <div class="info-section__header">
          <div>
            <h3 class="info-section__title">任务信息</h3>
            <p class="info-section__desc">汇总任务编号、名称、库位、负责人和开始时间，作为盘点主记录。</p>
          </div>
        </div>

        <el-descriptions :column="2" border>
          <el-descriptions-item label="任务编号">{{ detail.taskNo || '--' }}</el-descriptions-item>
          <el-descriptions-item label="任务名称">{{ detail.taskName || '--' }}</el-descriptions-item>
          <el-descriptions-item label="库位">{{ resolveDictLabel(locationOptions, detail.locationCode) }}</el-descriptions-item>
          <el-descriptions-item label="负责人">{{ detail.principalName || '--' }}</el-descriptions-item>
          <el-descriptions-item label="状态">
            {{ taskStatusLabelMap[detail.taskStatus] || detail.taskStatus || '--' }}
          </el-descriptions-item>
          <el-descriptions-item label="开始时间">{{ formatDateTime(detail.startTime) }}</el-descriptions-item>
        </el-descriptions>
      </section>

      <section class="info-section">
        <PageHeader
          title="盘点明细"
          description="录入实际盘点数量并补充差异说明，系统将自动回填正常、已核对或存在差异等结果状态。"
        />

        <el-table :data="detailItems" class="drawer-table">
          <template #empty>
            <el-empty class="empty-block" description="当前盘点任务暂无明细数据。" />
          </template>
          <el-table-column prop="relicNo" label="文物编号" min-width="130" />
          <el-table-column prop="relicName" label="文物名称" min-width="150" />
          <el-table-column prop="systemQuantity" label="系统数量" width="100" />
          <el-table-column label="实盘数量" width="130">
            <template #default="{ row }">
              <el-input-number
                v-model="row.actualQuantity"
                :min="0"
                :disabled="detail.taskStatus === 'COMPLETED' || !canEdit"
              />
            </template>
          </el-table-column>
          <el-table-column label="差异备注" min-width="150">
            <template #default="{ row }">
              <el-input v-model="row.diffRemark" :disabled="detail.taskStatus === 'COMPLETED' || !canEdit" />
            </template>
          </el-table-column>
          <el-table-column label="结果" width="120">
            <template #default="{ row }">
              <StatusTag :status="row.resultStatus" :label="resultLabelMap[row.resultStatus] || row.resultStatus" />
            </template>
          </el-table-column>
          <el-table-column v-if="canEdit" label="保存" width="100">
            <template #default="{ row }">
              <el-button
                text
                type="primary"
                :disabled="detail.taskStatus === 'COMPLETED'"
                @click="$emit('save-detail', row)"
              >
                保存
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </section>

      <div class="drawer-footer">
        <el-button
          v-if="canSubmit"
          type="primary"
          :disabled="detail.taskStatus === 'COMPLETED'"
          @click="$emit('submit-task')"
        >
          提交盘点结果
        </el-button>
      </div>
    </div>
  </el-drawer>
</template>

<script setup>
import { computed } from 'vue'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { formatDateTime, resolveDictLabel } from '@/utils/format'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  detail: {
    type: Object,
    default: () => ({})
  },
  locationOptions: {
    type: Array,
    default: () => []
  },
  taskStatusLabelMap: {
    type: Object,
    default: () => ({})
  },
  resultLabelMap: {
    type: Object,
    default: () => ({})
  },
  canEdit: {
    type: Boolean,
    default: false
  },
  canSubmit: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['update:modelValue', 'save-detail', 'submit-task'])

const drawerVisible = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value)
})

const detailItems = computed(() => props.detail?.details || [])
const diffCount = computed(() => detailItems.value.filter((item) => item.resultStatus === 'DIFF_FOUND').length)
</script>

<style scoped>
.drawer-overview__title {
  font-size: 22px;
}

.drawer-table {
  margin-top: 18px;
}

.drawer-footer {
  display: flex;
  justify-content: flex-end;
}
</style>
