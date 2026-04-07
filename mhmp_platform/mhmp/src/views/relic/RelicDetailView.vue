<template>
  <div class="page-shell" v-loading="loading">
    <template v-if="detail">
      <section class="page-card page-card--section cockpit-shell">
        <div class="cockpit-grid">
          <div class="cockpit-main">
            <div class="cockpit-media">
              <img v-if="detail.imageUrl" :src="detail.imageUrl" alt="文物主图" class="cockpit-media__image">
              <div v-else class="cockpit-media__placeholder">暂无文物主图</div>
            </div>

            <div class="cockpit-content">
              <div class="cockpit-eyebrow">文物业务驾驶舱</div>
              <div class="cockpit-title-row">
                <div>
                  <h1 class="cockpit-title">{{ detail.name || '文物详情' }}</h1>
                  <div class="cockpit-meta">
                    编号：{{ detail.relicNo || '--' }}
                    <span class="cockpit-meta__divider">|</span>
                    最近更新：{{ formatDateTime(detail.updateTime) }}
                  </div>
                </div>
                <StatusTag
                  :status="detail.currentStatus"
                  :label="resolveDictLabel(statusOptions, detail.currentStatus)"
                />
              </div>

              <div class="cockpit-tags">
                <span class="cockpit-tag">类别：{{ resolveDictLabel(categoryOptions, detail.categoryCode) || '--' }}</span>
                <span class="cockpit-tag">材质：{{ resolveDictLabel(materialOptions, detail.materialCode) || '--' }}</span>
                <span class="cockpit-tag">库位：{{ resolveDictLabel(locationOptions, detail.storageLocationCode) || '--' }}</span>
                <span class="cockpit-tag">保护级别：{{ detail.protectionLevel || '--' }}</span>
              </div>

              <p class="cockpit-desc">{{ detail.description || '暂无文物描述，建议补充该文物的业务背景与档案说明。' }}</p>

              <div v-if="launchActions.length" class="launch-panel">
                <div class="launch-panel__title">一键发起业务</div>
                <div class="launch-grid">
                  <button
                    v-for="item in launchActions"
                    :key="item.key"
                    class="launch-card"
                    :class="{ 'launch-card--disabled': !item.enabled }"
                    type="button"
                    @click="handleLaunchBusiness(item)"
                  >
                    <div class="launch-card__title">{{ item.title }}</div>
                    <div class="launch-card__check" :class="item.enabled ? 'launch-card__check--pass' : 'launch-card__check--warn'">
                      {{ item.checkText }}
                    </div>
                    <div class="launch-card__desc">{{ item.description }}</div>
                    <div class="launch-card__action">{{ item.enabled ? '立即发起' : item.disabledText }}</div>
                  </button>
                </div>
              </div>

              <div class="cockpit-actions">
                <el-button @click="router.push('/relic/list')">返回列表</el-button>
                <el-button @click="handleExportLedger">导出台账</el-button>
                <el-button @click="handlePrintLedger">打印台账</el-button>
                <el-button
                  v-if="authStore.hasPermission('relic:edit')"
                  type="primary"
                  @click="router.push(`/relic/edit/${detail.id}`)"
                >
                  编辑文物
                </el-button>
              </div>
            </div>
          </div>

          <div class="cockpit-side">
            <div class="cockpit-metrics">
              <article v-for="item in cockpitMetrics" :key="item.label" class="cockpit-metric">
                <div class="cockpit-metric__label">{{ item.label }}</div>
                <div class="cockpit-metric__value">{{ item.value }}</div>
              </article>
            </div>

            <div class="pending-panel">
              <div class="section-header">
                <div>
                  <div class="section-header__title">当前待办</div>
                  <div class="section-header__desc">可直接在详情页完成审批、归还和验收等关键动作。</div>
                </div>
              </div>

              <div v-if="detail.pendingBusinesses?.length" class="pending-grid">
                <article
                  v-for="item in detail.pendingBusinesses"
                  :key="`${item.businessType}-${item.relatedId}`"
                  class="pending-card"
                >
                  <div class="pending-card__header">
                    <div class="pending-card__title">{{ item.title }}</div>
                    <StatusTag :status="item.status" :label="resolveBusinessStatusLabel(item.status)" />
                  </div>
                  <div class="pending-card__time">业务时间：{{ formatDateTime(item.eventTime) }}</div>
                  <div class="pending-card__desc">{{ item.description || '--' }}</div>

                  <div class="pending-card__actions">
                    <el-button
                      v-if="item.businessType === 'OUTBOUND_APPROVAL' && authStore.hasPermission('inventory:outbound:approve')"
                      type="primary"
                      @click="handleApproveOutbound(item.relatedId)"
                    >
                      审批通过
                    </el-button>
                    <el-button
                      v-if="item.businessType === 'OUTBOUND_APPROVAL' && authStore.hasPermission('inventory:outbound:reject')"
                      type="danger"
                      plain
                      @click="handleRejectOutbound(item.relatedId)"
                    >
                      驳回申请
                    </el-button>
                    <el-button
                      v-if="item.businessType === 'OUTBOUND_RETURN' && authStore.hasPermission('inventory:outbound:approve')"
                      type="primary"
                      @click="handleReturnOutbound(item.relatedId)"
                    >
                      登记归还
                    </el-button>
                    <el-button
                      v-if="item.businessType === 'REPAIR_ACCEPTANCE' && authStore.hasPermission('repair:acceptance:add')"
                      type="primary"
                      @click="openAcceptanceDialog(item.relatedId, 'PASS')"
                    >
                      确认验收
                    </el-button>
                    <el-button @click="handleBusinessPageJump(item)">查看业务页</el-button>
                  </div>
                </article>
              </div>
              <el-empty v-else class="empty-block" description="当前没有待办业务" />
            </div>
          </div>
        </div>
      </section>

      <section class="page-grid detail-body-grid">
        <article class="page-card page-card--section">
          <div class="section-header">
            <div>
              <div class="section-header__title">档案信息</div>
              <div class="section-header__desc">集中查看文物基础档案、保存信息和鉴定资料。</div>
            </div>
          </div>

          <el-descriptions :column="2" border>
            <el-descriptions-item label="文物编号">{{ detail.relicNo }}</el-descriptions-item>
            <el-descriptions-item label="文物名称">{{ detail.name }}</el-descriptions-item>
            <el-descriptions-item label="文物类别">
              {{ resolveDictLabel(categoryOptions, detail.categoryCode) }}
            </el-descriptions-item>
            <el-descriptions-item label="文物材质">
              {{ resolveDictLabel(materialOptions, detail.materialCode) }}
            </el-descriptions-item>
            <el-descriptions-item label="馆藏位置">
              {{ resolveDictLabel(locationOptions, detail.storageLocationCode) }}
            </el-descriptions-item>
            <el-descriptions-item label="年代">{{ detail.era || '--' }}</el-descriptions-item>
            <el-descriptions-item label="来源">{{ detail.source || '--' }}</el-descriptions-item>
            <el-descriptions-item label="保护级别">{{ detail.protectionLevel || '--' }}</el-descriptions-item>
            <el-descriptions-item label="当前状态">
              {{ resolveDictLabel(statusOptions, detail.currentStatus) || '--' }}
            </el-descriptions-item>
            <el-descriptions-item label="保存状态">
              {{ resolveDictLabel(preservationOptions, detail.preservationStatusCode) || '--' }}
            </el-descriptions-item>
            <el-descriptions-item label="创建时间">{{ formatDateTime(detail.createTime) }}</el-descriptions-item>
            <el-descriptions-item label="更新时间">{{ formatDateTime(detail.updateTime) }}</el-descriptions-item>
            <el-descriptions-item label="保存条件" :span="2">{{ detail.storageCondition || '--' }}</el-descriptions-item>
            <el-descriptions-item label="注意事项" :span="2">{{ detail.attentionNote || '--' }}</el-descriptions-item>
            <el-descriptions-item label="备注" :span="2">{{ filteredNote || '--' }}</el-descriptions-item>
            <el-descriptions-item label="鉴定报告" :span="2">
              <a v-if="detail.appraisalReportUrl" :href="detail.appraisalReportUrl" target="_blank" rel="noreferrer">
                查看鉴定报告
              </a>
              <span v-else>--</span>
            </el-descriptions-item>
          </el-descriptions>
        </article>

        <article class="page-card page-card--section">
          <div class="section-header">
            <div>
              <div class="section-header__title">附件资料</div>
              <div class="section-header__desc">展示该文物归档的图片、报告和业务附件。</div>
            </div>
          </div>

          <el-table v-if="detail.attachments?.length" :data="detail.attachments">
            <el-table-column label="附件类型" min-width="140">
              <template #default="{ row }">{{ resolveAttachmentTypeLabel(row.attachmentType) }}</template>
            </el-table-column>
            <el-table-column prop="fileName" label="文件名称" min-width="220" />
            <el-table-column label="文件大小" min-width="120">
              <template #default="{ row }">{{ formatFileSize(row.fileSize) }}</template>
            </el-table-column>
            <el-table-column prop="remark" label="备注" min-width="180" show-overflow-tooltip />
            <el-table-column label="操作" width="120">
              <template #default="{ row }">
                <a :href="row.fileUrl" target="_blank" rel="noreferrer">打开文件</a>
              </template>
            </el-table-column>
          </el-table>
          <el-empty v-else class="empty-block" description="暂无附件资料" />
        </article>
      </section>

      <section class="page-card page-card--section">
        <div class="section-header">
          <div>
            <div class="section-header__title">业务时间线</div>
            <div class="section-header__desc">汇总文物入库、出库、馆内转存、盘点、修复与验收全过程。</div>
          </div>
        </div>

        <el-timeline v-if="detail.businessTimeline?.length">
          <el-timeline-item
            v-for="item in detail.businessTimeline"
            :key="`${item.eventType}-${item.relatedId}-${item.eventTime}`"
            :timestamp="formatDateTime(item.eventTime)"
            placement="top"
          >
            <div class="timeline-card">
              <div class="timeline-card__header">
                <div class="timeline-card__title">{{ item.title }}</div>
                <StatusTag :status="item.status" :label="resolveBusinessStatusLabel(item.status)" />
              </div>
              <div class="timeline-card__desc">{{ item.description || '--' }}</div>
            </div>
          </el-timeline-item>
        </el-timeline>
        <el-empty v-else class="empty-block" description="暂无业务记录" />
      </section>
    </template>

    <RepairAcceptanceDialog
      v-model="acceptanceVisible"
      :task-id="acceptanceTaskId"
      :default-location-code="detail?.storageLocationCode || ''"
      :default-preservation-status-code="detail?.preservationStatusCode || 'BASIC_COMPLETE'"
      @success="loadDetail"
    />
  </div>
</template>

<script setup>
import { computed, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { approveOutboundApi, rejectOutboundApi, returnOutboundApi } from '@/api/outbound'
import { getRelicDetailApi } from '@/api/relic'
import StatusTag from '@/components/common/StatusTag.vue'
import { useAuthStore } from '@/stores/auth'
import { useDictStore } from '@/stores/dict'
import { formatDateTime, resolveDictLabel } from '@/utils/format'
import { downloadRelicLedger, printRelicLedger } from '@/utils/relicLedger'
import {
  checkInboundRelicEligibility,
  checkInventoryRelicEligibility,
  checkOutboundRelicEligibility,
  checkRepairRelicEligibility,
  checkTransferRelicEligibility,
  pickRelicBusinessFields
} from '@/utils/relicBusinessRules'
import RepairAcceptanceDialog from '@/views/repair/components/RepairAcceptanceDialog.vue'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()
const dictStore = useDictStore()

const loading = ref(false)
const detail = ref(null)
const acceptanceVisible = ref(false)
const acceptanceTaskId = ref(null)

const categoryOptions = computed(() => dictStore.itemsMap.relic_category || [])
const materialOptions = computed(() => dictStore.itemsMap.relic_material || [])
const statusOptions = computed(() => dictStore.itemsMap.relic_status || [])
const locationOptions = computed(() => dictStore.itemsMap.storage_location || [])
const preservationOptions = computed(() => dictStore.itemsMap.preservation_status || [])
const outboundStatusOptions = computed(() => dictStore.itemsMap.outbound_status || [])

const businessStatusLabelMap = {
  CREATED: '已创建',
  PENDING: '待审批',
  APPROVED: '已审批',
  REJECTED: '已驳回',
  RETURNED: '已归还',
  APPLIED: '待审批',
  IN_PROGRESS: '进行中',
  COMPLETED: '已完成',
  ACCEPTED: '已验收',
  UNACCEPTED: '尚未验收',
  WAITING: '等待验收',
  SUCCESS: '验收成功',
  PASS: '通过',
  IN_STOCK: '在库',
  INBOUND_PENDING: '入库待审批',
  OUTBOUND_PENDING: '出库待审批',
  OUT_STOCK: '已出库',
  IN_REPAIR: '修复中',
  NORMAL: '正常',
  CHECKED: '已盘点',
  DIFF_FOUND: '盘点异常'
}

const attachmentTypeLabelMap = {
  IMAGE: '主图',
  APPRAISAL_REPORT: '鉴定报告',
  DOCUMENT: '业务附件',
  REPAIR_IMAGE: '修复过程图片',
  REPAIR_FILE: '修复过程附件'
}

const filteredNote = computed(() => {
  if (!detail.value?.note) {
    return ''
  }
  return detail.value.note
    .split(/\r?\n/)
    .filter((line) => line && !line.startsWith('[TRANSFER]'))
    .join('\n')
})

const cockpitMetrics = computed(() => {
  if (!detail.value) {
    return []
  }
  return [
    {
      label: '当前状态',
      value: resolveDictLabel(statusOptions.value, detail.value.currentStatus) || '--'
    },
    {
      label: '在办业务',
      value: `${detail.value.pendingBusinesses?.length || 0} 项`
    },
    {
      label: '业务记录',
      value: `${detail.value.businessTimeline?.length || 0} 条`
    },
    {
      label: '档案附件',
      value: `${detail.value.attachments?.length || 0} 份`
    }
  ]
})

function createLaunchAction(config) {
  return {
    ...config,
    description: config.check.message,
    enabled: config.check.passed,
    checkText: config.check.passed
      ? '\u72b6\u6001\u524d\u7f6e\u6821\u9a8c\u5df2\u901a\u8fc7'
      : '\u72b6\u6001\u524d\u7f6e\u6821\u9a8c\u672a\u901a\u8fc7',
    disabledText: '\u67e5\u770b\u9650\u5236'
  }
}

const launchActions = computed(() => {
  if (!detail.value) {
    return []
  }

  const relicId = String(detail.value.id)
  const relic = pickRelicBusinessFields(detail.value)
  const actions = [
    createLaunchAction({
      key: 'transfer',
      title: '发起馆内转存',
      check: checkTransferRelicEligibility(relic),
      successText: '馆内转存条件校验通过，正在进入转存表单',
      visible: authStore.hasPermission('relic:edit'),
      route: {
        path: '/relic/transfer',
        query: {
          quickCreate: '1',
          relicId
        }
      }
    }),
    createLaunchAction({
      key: 'outbound',
      title: '发起文物出库',
      check: checkOutboundRelicEligibility(relic),
      successText: '\u51fa\u5e93\u6761\u4ef6\u6821\u9a8c\u901a\u8fc7\uff0c\u6b63\u5728\u8fdb\u5165\u51fa\u5e93\u8868\u5355',
      visible: authStore.hasPermission('inventory:outbound:apply:view'),
      route: {
        path: '/inventory/outbound/apply',
        query: {
          quickCreate: '1',
          relicId
        }
      }
    }),
    createLaunchAction({
      key: 'inbound',
      title: '发起文物入库',
      check: checkInboundRelicEligibility(relic),
      successText: '\u5165\u5e93\u6761\u4ef6\u6821\u9a8c\u901a\u8fc7\uff0c\u6b63\u5728\u8fdb\u5165\u5165\u5e93\u8868\u5355',
      visible: authStore.hasPermission('inventory:inbound:add'),
      route: {
        path: '/inventory/inbound',
        query: {
          quickCreate: '1',
          relicId
        }
      }
    }),
    createLaunchAction({
      key: 'inventory',
      title: '发起文物盘点',
      check: checkInventoryRelicEligibility(relic),
      successText: '盘点发起条件校验通过，正在进入盘点任务表单',
      visible: authStore.hasPermission('inventory:task:view'),
      route: {
        path: '/inventory/task',
        query: {
          quickCreate: '1',
          relicId,
          locationCode: detail.value.storageLocationCode || ''
        }
      }
    }),
    createLaunchAction({
      key: 'repair',
      title: '发起修复申请',
      check: checkRepairRelicEligibility(relic),
      successText: '\u4fee\u590d\u6761\u4ef6\u6821\u9a8c\u901a\u8fc7\uff0c\u6b63\u5728\u8fdb\u5165\u4fee\u590d\u7533\u8bf7\u8868\u5355',
      visible: authStore.hasPermission('repair:apply:submit'),
      route: {
        path: '/repair/apply',
        query: {
          quickCreate: '1',
          relicId
        }
      }
    })
  ]

  return actions.filter((item) => item.visible)
})

const ledgerPayload = computed(() => {
  if (!detail.value) {
    return null
  }

  return {
    title: `${detail.value.name || '文物'}业务台账`,
    subtitle: '用于展示文物档案信息、待办业务和完整业务时间线，便于业务复盘与答辩演示。',
    relicNo: detail.value.relicNo,
    relicName: detail.value.name,
    generatedAt: formatDateTime(new Date()),
    basicInfo: [
      { label: '文物类别', value: resolveDictLabel(categoryOptions.value, detail.value.categoryCode) },
      { label: '文物材质', value: resolveDictLabel(materialOptions.value, detail.value.materialCode) },
      { label: '馆藏位置', value: resolveDictLabel(locationOptions.value, detail.value.storageLocationCode) },
      { label: '当前状态', value: resolveBusinessStatusLabel(detail.value.currentStatus) },
      { label: '保存状态', value: resolveDictLabel(preservationOptions.value, detail.value.preservationStatusCode) },
      { label: '年代', value: detail.value.era || '--' },
      { label: '来源', value: detail.value.source || '--' },
      { label: '保护级别', value: detail.value.protectionLevel || '--' },
      { label: '创建时间', value: formatDateTime(detail.value.createTime) },
      { label: '更新时间', value: formatDateTime(detail.value.updateTime) },
      { label: '保存条件', value: detail.value.storageCondition || '--' },
      { label: '注意事项', value: detail.value.attentionNote || '--' }
    ],
    pendingBusinesses: (detail.value.pendingBusinesses || []).map((item) => ({
      title: item.title || '--',
      status: resolveBusinessStatusLabel(item.status),
      eventTime: formatDateTime(item.eventTime),
      description: item.description || '--'
    })),
    attachments: (detail.value.attachments || []).map((item) => ({
      type: resolveAttachmentTypeLabel(item.attachmentType),
      fileName: item.fileName || '--',
      fileSize: formatFileSize(item.fileSize),
      remark: item.remark || '--'
    })),
    timeline: (detail.value.businessTimeline || []).map((item) => ({
      eventTime: formatDateTime(item.eventTime),
      title: item.title || '--',
      status: resolveBusinessStatusLabel(item.status),
      description: item.description || '--'
    }))
  }
})

async function loadDetail() {
  loading.value = true
  try {
    detail.value = await getRelicDetailApi(route.params.id)
  } finally {
    loading.value = false
  }
}

function currentDateTime() {
  const now = new Date()
  const year = now.getFullYear()
  const month = `${now.getMonth() + 1}`.padStart(2, '0')
  const day = `${now.getDate()}`.padStart(2, '0')
  const hour = `${now.getHours()}`.padStart(2, '0')
  const minute = `${now.getMinutes()}`.padStart(2, '0')
  const second = `${now.getSeconds()}`.padStart(2, '0')
  return `${year}-${month}-${day}T${hour}:${minute}:${second}`
}

function resolveBusinessStatusLabel(status) {
  if (!status) {
    return '--'
  }
  const outboundLabel = resolveDictLabel(outboundStatusOptions.value, status)
  if (outboundLabel && outboundLabel !== status) {
    return outboundLabel
  }
  const relicLabel = resolveDictLabel(statusOptions.value, status)
  if (relicLabel && relicLabel !== status) {
    return relicLabel
  }
  return businessStatusLabelMap[status] || status
}

function resolveAttachmentTypeLabel(type) {
  return attachmentTypeLabelMap[type] || type || '--'
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

function handleBusinessPageJump(item) {
  if (item.businessType === 'REPAIR_ACCEPTANCE') {
    router.push({
      path: '/repair/acceptance',
      query: {
        acceptanceStatus: 'WAITING'
      }
    })
    return
  }
  router.push('/inventory/outbound/approve')
}

function handleLaunchBusiness(item) {
  if (!item.enabled) {
    ElMessage.warning(item.description)
    return
  }
  ElMessage.success(item.successText)
  router.push(item.route)
}

function handleExportLedger() {
  if (!ledgerPayload.value || !detail.value) {
    return
  }
  downloadRelicLedger(
    ledgerPayload.value,
    `relic-ledger-${detail.value.relicNo || detail.value.id || 'detail'}.html`
  )
  ElMessage.success('文物业务台账已导出')
}

function handlePrintLedger() {
  if (!ledgerPayload.value) {
    return
  }
  try {
    printRelicLedger(ledgerPayload.value)
  } catch (error) {
    ElMessage.error('打印窗口可能被浏览器拦截，请允许弹窗后重试')
  }
}

async function handleApproveOutbound(id) {
  try {
    const { value } = await ElMessageBox.prompt('可填写审批意见，留空则直接通过。', '出库审批通过', {
      confirmButtonText: '确认通过',
      cancelButtonText: '取消',
      inputPlaceholder: '请输入审批意见'
    })
    await approveOutboundApi(id, { approveRemark: value })
    ElMessage.success('出库审批已通过')
    await loadDetail()
  } catch (error) {
    if (error !== 'cancel' && error !== 'close') {
      throw error
    }
  }
}

async function handleRejectOutbound(id) {
  try {
    const { value } = await ElMessageBox.prompt('请填写驳回原因。', '驳回出库申请', {
      confirmButtonText: '确认驳回',
      cancelButtonText: '取消',
      inputPlaceholder: '请输入驳回原因',
      inputPattern: /.+/,
      inputErrorMessage: '驳回原因不能为空'
    })
    await rejectOutboundApi(id, { approveRemark: value })
    ElMessage.success('出库申请已驳回')
    await loadDetail()
  } catch (error) {
    if (error !== 'cancel' && error !== 'close') {
      throw error
    }
  }
}

async function handleReturnOutbound(id) {
  try {
    await ElMessageBox.confirm('确认登记该出库单已归还吗？', '归还登记', {
      type: 'warning'
    })
    await returnOutboundApi(id, {
      returnTime: currentDateTime(),
      remark: '文物详情页登记归还'
    })
    ElMessage.success('已完成归还登记')
    await loadDetail()
  } catch (error) {
    if (error !== 'cancel' && error !== 'close') {
      throw error
    }
  }
}

function openAcceptanceDialog(taskId) {
  acceptanceTaskId.value = taskId
  acceptanceVisible.value = true
}

dictStore.ensureMultipleItems([
  'relic_category',
  'relic_material',
  'relic_status',
  'storage_location',
  'preservation_status',
  'outbound_status'
])
loadDetail()
</script>

<style scoped>
.cockpit-shell {
  background:
    radial-gradient(circle at top right, rgba(123, 44, 42, 0.08), transparent 24%),
    linear-gradient(180deg, rgba(255, 255, 255, 0.98), rgba(248, 244, 239, 0.96));
}

.cockpit-grid {
  display: grid;
  grid-template-columns: 1.2fr 0.95fr;
  gap: 18px;
}

.cockpit-main {
  display: grid;
  grid-template-columns: 250px minmax(0, 1fr);
  gap: 18px;
}

.cockpit-media {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 250px;
  border: 1px solid var(--border-line);
  border-radius: 18px;
  background: linear-gradient(180deg, #faf8f6, #f2f4f7);
}

.cockpit-media__image {
  width: 100%;
  max-height: 250px;
  object-fit: contain;
  border-radius: 18px;
}

.cockpit-media__placeholder {
  color: var(--text-second);
}

.cockpit-content {
  display: flex;
  flex-direction: column;
}

.cockpit-eyebrow {
  display: inline-flex;
  width: fit-content;
  padding: 6px 12px;
  border-radius: 999px;
  background: rgba(123, 44, 42, 0.08);
  color: var(--primary);
  font-size: 12px;
  font-weight: 700;
}

.cockpit-title-row {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  margin-top: 16px;
}

.cockpit-title {
  margin: 0;
  font-size: 30px;
}

.cockpit-meta {
  margin-top: 10px;
  color: var(--text-second);
  font-size: 13px;
}

.cockpit-meta__divider {
  margin: 0 8px;
}

.cockpit-tags {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
  margin-top: 18px;
}

.cockpit-tag {
  padding: 8px 12px;
  border: 1px solid rgba(123, 44, 42, 0.1);
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.88);
  font-size: 13px;
}

.cockpit-desc {
  margin: 16px 0 0;
  color: var(--text-second);
  line-height: 1.8;
}

.launch-panel {
  margin-top: 18px;
}

.launch-panel__title {
  font-size: 15px;
  font-weight: 700;
}

.launch-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 12px;
  margin-top: 12px;
}

.launch-card {
  width: 100%;
  padding: 14px 16px;
  border: 1px solid rgba(123, 44, 42, 0.14);
  border-radius: 16px;
  background: rgba(255, 255, 255, 0.92);
  color: inherit;
  font: inherit;
  text-align: left;
  cursor: pointer;
  transition: transform 0.2s ease, border-color 0.2s ease, box-shadow 0.2s ease;
}

.launch-card:hover {
  transform: translateY(-2px);
  border-color: rgba(123, 44, 42, 0.3);
  box-shadow: 0 8px 20px rgba(123, 44, 42, 0.08);
}

.launch-card--disabled {
  cursor: not-allowed;
  opacity: 0.68;
  transform: none;
  box-shadow: none;
}

.launch-card--disabled:hover {
  transform: none;
  border-color: rgba(123, 44, 42, 0.14);
  box-shadow: none;
}

.launch-card__title {
  font-size: 15px;
  font-weight: 700;
}

.launch-card__check {
  margin-top: 8px;
  font-size: 12px;
  font-weight: 700;
}

.launch-card__check--pass {
  color: var(--success);
}

.launch-card__check--warn {
  color: var(--warning);
}

.launch-card__desc {
  margin-top: 8px;
  color: var(--text-second);
  font-size: 13px;
  line-height: 1.7;
}

.launch-card__action {
  margin-top: 12px;
  color: var(--primary);
  font-size: 13px;
  font-weight: 700;
}

.cockpit-actions {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
  margin-top: auto;
  padding-top: 22px;
}

.cockpit-side {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.cockpit-metrics {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 12px;
}

.cockpit-metric {
  padding: 16px;
  border: 1px solid var(--border-line);
  border-radius: 16px;
  background: rgba(255, 255, 255, 0.92);
}

.cockpit-metric__label {
  color: var(--text-second);
  font-size: 13px;
}

.cockpit-metric__value {
  margin-top: 10px;
  font-size: 20px;
  font-weight: 700;
}

.pending-panel {
  padding: 18px;
  border: 1px solid var(--border-line);
  border-radius: 18px;
  background: rgba(255, 255, 255, 0.92);
}

.section-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 18px;
}

.section-header__title {
  font-size: 18px;
  font-weight: 700;
}

.section-header__desc {
  margin-top: 8px;
  color: var(--text-second);
  font-size: 13px;
  line-height: 1.8;
}

.pending-grid {
  display: grid;
  gap: 12px;
}

.pending-card {
  padding: 16px;
  border: 1px solid var(--border-line);
  border-radius: 16px;
  background: linear-gradient(180deg, #fff, #faf8f6);
}

.pending-card__header {
  display: flex;
  justify-content: space-between;
  gap: 12px;
}

.pending-card__title {
  font-size: 15px;
  font-weight: 700;
}

.pending-card__time {
  margin-top: 8px;
  color: var(--text-second);
  font-size: 13px;
}

.pending-card__desc {
  margin-top: 10px;
  line-height: 1.7;
}

.pending-card__actions {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
  margin-top: 14px;
}

.detail-body-grid {
  grid-template-columns: 1.2fr 0.9fr;
}

.timeline-card {
  padding: 14px 16px;
  border: 1px solid var(--border-line);
  border-radius: 14px;
  background: var(--bg-soft);
}

.timeline-card__header {
  display: flex;
  justify-content: space-between;
  gap: 12px;
}

.timeline-card__title {
  font-weight: 700;
}

.timeline-card__desc {
  margin-top: 10px;
  color: var(--text-main);
  line-height: 1.7;
}

@media (max-width: 1180px) {
  .cockpit-grid,
  .detail-body-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 900px) {
  .cockpit-main {
    grid-template-columns: 1fr;
  }

  .cockpit-metrics {
    grid-template-columns: 1fr 1fr;
  }

  .launch-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 720px) {
  .cockpit-title-row,
  .pending-card__header,
  .timeline-card__header {
    flex-direction: column;
    align-items: flex-start;
  }

  .cockpit-metrics {
    grid-template-columns: 1fr;
  }
}
</style>
