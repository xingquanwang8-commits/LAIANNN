<template>
  <div class="page-shell" v-loading="loading">
    <template v-if="detail">
      <section class="page-card page-card--section cockpit-shell">
        <div class="cockpit-grid">
          <div class="cockpit-main">
            <div class="cockpit-media">
              <el-popover
                v-if="detail.imageUrl"
                placement="right-start"
                trigger="hover"
                :width="340"
                popper-class="artifact-preview-popover"
              >
                <template #reference>
                  <div class="artifact-preview-frame artifact-preview-frame--hero artifact-preview-frame--interactive">
                    <img
                      :src="detail.imageUrl"
                      alt="文物主图"
                      class="artifact-preview-frame__image artifact-preview-frame__image--contain"
                    >
                    <div class="artifact-preview-frame__badge artifact-preview-frame__badge--hero">查看大图</div>
                  </div>
                </template>

                <div class="artifact-preview-panel">
                  <img
                    :src="detail.imageUrl"
                    :alt="detail.name || '文物主图预览'"
                    class="artifact-preview-panel__image artifact-preview-panel__image--hero"
                  >
                  <div class="artifact-preview-panel__name">{{ detail.name || '文物主图' }}</div>
                  <div class="artifact-preview-panel__meta">编号：{{ detail.relicNo || '--' }}</div>
                  <div class="artifact-preview-panel__meta">最近更新：{{ formatDateTime(detail.updateTime) }}</div>
                </div>
              </el-popover>

              <div v-else class="artifact-preview-frame artifact-preview-frame--hero">
                <div class="artifact-preview-frame__empty">暂无文物主图</div>
              </div>
            </div>

            <div class="cockpit-content">
              <div class="cockpit-eyebrow">MHMP 文物业务档案</div>
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

              <p class="cockpit-desc">{{ detail.description || '暂无文物说明，建议补充该文物的馆藏背景、保存特征和业务管理要求。' }}</p>

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
                  <div class="section-header__desc">可直接在详情页完成审批、归还登记和修复验收等关键动作。</div>
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
                      v-if="item.businessType === 'INBOUND_APPROVAL' && authStore.hasPermission('inventory:inbound:approve')"
                      type="primary"
                      @click="handleApproveInbound(item.relatedId)"
                    >
                      审批通过
                    </el-button>
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
                      v-if="item.businessType === 'OUTBOUND_RETURN' && authStore.hasPermission(['inventory:outbound:approve', 'inventory:outbound:submit'])"
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
              <el-empty v-else class="empty-block" description="当前暂无待办业务。" />
            </div>
          </div>
        </div>
      </section>

      <section class="page-grid detail-body-grid">
        <article class="page-card page-card--section">
          <div class="section-header">
            <div>
              <div class="section-header__title">档案信息</div>
              <div class="section-header__desc">集中查看文物基础档案、保存信息、鉴定资料与管理要点。</div>
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
              <div class="section-header__desc">按影像资料与文档资料分层展示该文物归档附件，便于答辩演示、日常查阅与交接复核。</div>
            </div>
          </div>

          <div v-if="galleryMediaItems.length || documentAttachmentItems.length || detail.appraisalReportUrl" class="detail-stack">
            <section class="media-gallery">
              <div class="media-gallery__header">
                <div>
                  <div class="media-gallery__title">影像图库</div>
                  <div class="media-gallery__desc">集中展示主图、文物影像和修复过程图片，点击缩略图可查看大图预览。</div>
                </div>
                <span class="overview-chip">共 {{ galleryMediaItems.length }} 张</span>
              </div>

              <div v-if="galleryMediaItems.length" class="media-gallery__grid">
                <article v-for="(item, index) in galleryMediaItems" :key="`${item.fileUrl}-${index}`" class="media-gallery__card">
                  <el-image
                    :src="item.fileUrl"
                    :preview-src-list="galleryPreviewList"
                    :initial-index="index"
                    fit="cover"
                    class="media-gallery__image"
                    preview-teleported
                  />
                  <div class="media-gallery__content">
                    <div class="media-gallery__name">{{ item.fileName }}</div>
                    <div class="media-gallery__meta">
                      <span>{{ item.typeLabel }}</span>
                      <span v-if="item.fileSizeText !== '--'">{{ item.fileSizeText }}</span>
                    </div>
                    <div class="media-gallery__remark">{{ item.remark || '可点击查看原图。' }}</div>
                  </div>
                </article>
              </div>
              <el-empty v-else class="empty-block" description="当前暂无影像资料。" />
            </section>

            <section class="info-section">
              <div class="info-section__header">
                <div>
                  <h3 class="info-section__title">文档资料</h3>
                  <p class="info-section__desc">保留鉴定报告与业务附件索引，便于下载、打印和交接复核。</p>
                </div>
              </div>

              <el-table v-if="documentAttachmentItems.length" :data="documentAttachmentItems">
                <el-table-column label="附件类型" min-width="140">
                  <template #default="{ row }">{{ row.typeLabel }}</template>
                </el-table-column>
                <el-table-column prop="fileName" label="文件名称" min-width="220" />
                <el-table-column label="文件大小" min-width="120">
                  <template #default="{ row }">{{ row.fileSizeText }}</template>
                </el-table-column>
                <el-table-column prop="remark" label="备注" min-width="180" show-overflow-tooltip />
                <el-table-column label="操作" class-name="table-action-column" width="120">
                  <template #default="{ row }">
                    <a :href="row.fileUrl" target="_blank" rel="noreferrer">打开文件</a>
                  </template>
                </el-table-column>
              </el-table>
              <el-empty v-else class="empty-block" description="当前暂无文档资料。" />
            </section>
          </div>
          <el-empty v-else class="empty-block" description="当前暂无附件资料。" />
        </article>
      </section>

      <section class="page-card page-card--section">
        <div class="section-header">
          <div>
            <div class="section-header__title">业务时间线</div>
            <div class="section-header__desc">汇总文物入库、出库、馆内转存、盘点、修复与验收全过程，便于追踪生命周期记录。</div>
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
        <el-empty v-else class="empty-block" description="当前暂无业务记录。" />
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
import { approveInboundApi } from '@/api/inbound'
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
  ASSIGNED: '待确认',
  IN_PROGRESS: '进行中',
  COMPLETED: '已完成',
  ACCEPTED: '已验收',
  UNACCEPTED: '尚未验收',
  WAITING: '等待验收',
  SUCCESS: '验收成功',
  PASS: '通过',
  TO_BE_INBOUND: '待入库',
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
  RELIC_IMAGE: '文物影像',
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

const imageAttachmentTypes = new Set(['IMAGE', 'RELIC_IMAGE', 'REPAIR_IMAGE'])

const galleryMediaItems = computed(() => {
  if (!detail.value) {
    return []
  }

  const items = []
  const usedUrls = new Set()

  if (detail.value.imageUrl) {
    items.push({
      fileUrl: detail.value.imageUrl,
      fileName: detail.value.name ? `${detail.value.name} 主图` : '文物主图',
      fileSizeText: '--',
      remark: '当前文物主图，用于列表封面与详情展示。',
      typeLabel: '主图'
    })
    usedUrls.add(detail.value.imageUrl)
  }

  (detail.value.attachments || []).forEach((item) => {
    if (!item?.fileUrl || !imageAttachmentTypes.has(item.attachmentType) || usedUrls.has(item.fileUrl)) {
      return
    }
    usedUrls.add(item.fileUrl)
    items.push({
      fileUrl: item.fileUrl,
      fileName: item.fileName || resolveAttachmentTypeLabel(item.attachmentType),
      fileSizeText: formatFileSize(item.fileSize),
      remark: item.remark || '文物影像资料',
      typeLabel: resolveAttachmentTypeLabel(item.attachmentType)
    })
  })

  return items
})

const galleryPreviewList = computed(() => galleryMediaItems.value.map((item) => item.fileUrl))

const documentAttachmentItems = computed(() => {
  if (!detail.value) {
    return []
  }

  const items = []

  if (detail.value.appraisalReportUrl) {
    items.push({
      attachmentType: 'APPRAISAL_REPORT',
      fileName: '鉴定报告',
      fileUrl: detail.value.appraisalReportUrl,
      fileSizeText: '--',
      remark: '文物鉴定报告',
      typeLabel: '鉴定报告'
    })
  }

  (detail.value.attachments || []).forEach((item) => {
    if (!item?.fileUrl || imageAttachmentTypes.has(item.attachmentType)) {
      return
    }
    items.push({
      ...item,
      fileSizeText: formatFileSize(item.fileSize),
      typeLabel: resolveAttachmentTypeLabel(item.attachmentType)
    })
  })

  return items
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
      visible: authStore.hasPermission('inventory:transfer:add'),
      route: {
        path: '/inventory/transfer',
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
      visible: authStore.hasPermission('inventory:outbound:submit'),
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
      visible: authStore.hasPermission('inventory:task:add'),
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
    subtitle: '用于汇总文物档案信息、在办事项与完整业务时间线，便于馆内复核、交接审阅与业务追踪。',
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
  if (item.businessType === 'INBOUND_APPROVAL') {
    router.push('/inventory/inbound/approve')
    return
  }
  if (item.businessType === 'TRANSFER_CONFIRM') {
    router.push('/inventory/transfer/my')
    return
  }
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

async function handleApproveInbound(id) {
  try {
    await ElMessageBox.confirm('确认审批通过该入库单吗？通过后相关文物将正式转为在库状态。', '入库审批', {
      type: 'warning'
    })
    await approveInboundApi(id)
    ElMessage.success('入库审批已通过')
    await loadDetail()
  } catch (error) {
    if (error !== 'cancel' && error !== 'close') {
      throw error
    }
  }
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
  align-items: stretch;
  min-height: 250px;
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

.media-gallery {
  padding: 18px;
  border: 1px solid var(--border-line);
  border-radius: 18px;
  background:
    radial-gradient(circle at top right, rgba(184, 138, 68, 0.08), transparent 24%),
    linear-gradient(180deg, rgba(255, 255, 255, 0.98), rgba(248, 243, 236, 0.94));
}

.media-gallery__header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 16px;
}

.media-gallery__title {
  font-size: 17px;
  font-weight: 700;
}

.media-gallery__desc {
  margin-top: 8px;
  color: var(--text-second);
  font-size: 13px;
  line-height: 1.8;
}

.media-gallery__grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 14px;
}

.media-gallery__card {
  display: flex;
  gap: 14px;
  padding: 14px;
  border: 1px solid rgba(123, 44, 42, 0.08);
  border-radius: 16px;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.96), rgba(249, 244, 238, 0.94));
}

.media-gallery__image {
  width: 112px;
  height: 112px;
  flex-shrink: 0;
  border-radius: 14px;
  overflow: hidden;
  border: 1px solid rgba(123, 44, 42, 0.08);
  background: linear-gradient(180deg, #faf8f6, #f2f4f7);
}

.media-gallery__content {
  flex: 1;
  min-width: 0;
}

.media-gallery__name {
  font-size: 15px;
  font-weight: 700;
  word-break: break-all;
}

.media-gallery__meta {
  display: flex;
  gap: 8px 12px;
  flex-wrap: wrap;
  margin-top: 8px;
  color: var(--text-second);
  font-size: 12px;
}

.media-gallery__remark {
  margin-top: 10px;
  color: var(--text-main);
  font-size: 13px;
  line-height: 1.7;
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

  .media-gallery__grid {
    grid-template-columns: 1fr;
  }

  .launch-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 720px) {
  .cockpit-title-row,
  .pending-card__header,
  .media-gallery__header,
  .media-gallery__card,
  .timeline-card__header {
    flex-direction: column;
    align-items: flex-start;
  }

  .cockpit-metrics {
    grid-template-columns: 1fr;
  }
}
</style>
