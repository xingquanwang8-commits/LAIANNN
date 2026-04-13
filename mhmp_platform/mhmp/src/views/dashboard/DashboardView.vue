<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="overview-panel dashboard-hero">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">{{ APP_SHORT_NAME }} Operations Hub</div>
            <h1 class="overview-panel__title">{{ APP_TITLE }}</h1>
            <p class="overview-panel__desc">
              面向馆藏建档、库位流转、盘点核验、修复闭环与系统授权的统一业务工作台，支持日常办理、状态总览和关键事项优先处置。
            </p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">馆藏文物 {{ summary.totalRelicCount || 0 }} 件</span>
            <span class="overview-chip overview-chip--accent">待处理事项 {{ activeTodoCount }} 项</span>
          </div>
        </div>

        <div class="dashboard-focus-grid">
          <article
            v-for="item in heroFocusCards"
            :key="item.title"
            class="dashboard-focus-card"
          >
            <div class="dashboard-focus-card__title">{{ item.title }}</div>
            <div class="dashboard-focus-card__desc">{{ item.description }}</div>
          </article>
        </div>

      </div>
    </section>

    <section class="page-grid dashboard-main">
      <article class="page-card page-card--section dashboard-chart-card">
        <PageHeader
          title="馆藏状态分析"
          description="按当前文物状态实时汇总馆藏分布，用于日常监管、业务研判和异常趋势跟踪。"
        >
          <template #extra>
            <el-button @click="loadSummary">刷新数据</el-button>
          </template>
        </PageHeader>

        <div class="chart-layout">
          <div class="status-pie" :style="pieStyle">
            <div class="status-pie__inner">
              <strong>{{ summary.totalRelicCount || 0 }}</strong>
              <span>馆藏总量</span>
            </div>
          </div>

          <div v-if="statusStats.length" class="status-legend">
            <div v-for="item in statusStats" :key="item.status" class="status-legend__item">
              <span class="status-legend__dot" :style="{ background: item.color }" />
              <div class="status-legend__content">
                <div class="status-legend__row">
                  <span class="status-legend__label">{{ item.label }}</span>
                  <span class="status-legend__count">{{ item.count }} 件文物</span>
                  <strong class="status-legend__percent">{{ item.percentText }}</strong>
                </div>
              </div>
            </div>
          </div>

          <el-empty v-else description="当前暂无馆藏状态数据，请稍后刷新后重试。" />
        </div>
      </article>

      <article class="page-card page-card--section dashboard-panel">
        <PageHeader
          title="待处理事项"
          description="聚合当前账号可办理的关键业务，优先推进审批、归还登记、验收和盘点闭环。"
        >
          <template #extra>
            <el-button type="primary" @click="router.push(primaryTodoRoute)">优先处理</el-button>
          </template>
        </PageHeader>

        <div v-if="todoCards.length" :class="todoGridClass">
          <button
            v-for="item in todoCards"
            :key="item.title"
            class="todo-card"
            @click="router.push(item.route)"
          >
            <div class="todo-card__header">
              <div class="todo-card__main">
                <span class="todo-card__title">{{ item.title }}</span>
                <span class="todo-card__desc">{{ item.description }}</span>
              </div>
              <div class="todo-card__meta">
                <span class="todo-card__count">{{ item.count }}</span>
                <span class="todo-card__action">进入</span>
              </div>
            </div>
          </button>
        </div>
        <el-empty v-else description="当前账号暂无待处理事项。" />
      </article>
    </section>

    <section class="page-card page-card--section">
      <PageHeader
        title="常用业务入口"
        description="保留当前账号高频访问入口，便于在文物台账、流转、修复和系统管理场景之间快速切换。"
      >
        <template #extra>
          <div class="shortcut-note">已聚合 {{ shortcutCards.length }} 个常用入口</div>
        </template>
      </PageHeader>

      <div class="shortcut-grid">
        <button
          v-for="menu in shortcutCards"
          :key="menu.id"
          class="shortcut-card"
          @click="router.push(menu.path)"
        >
          <div class="shortcut-card__title">{{ menu.menuName }}</div>
          <div class="shortcut-card__desc">{{ menu.description }}</div>
          <div class="shortcut-card__path">{{ menu.path }}</div>
        </button>
      </div>
    </section>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { getDashboardSummaryApi } from '@/api/dashboard'
import PageHeader from '@/components/common/PageHeader.vue'
import { APP_SHORT_NAME, APP_TITLE } from '@/constants/menu'
import { useAuthStore } from '@/stores/auth'
import { useDictStore } from '@/stores/dict'
import { resolveDictLabel } from '@/utils/format'
import { collectShortcutMenus } from '@/utils/menu'

const STATUS_COLORS = ['#7B2C2A', '#C68A39', '#3C8E5B', '#4C7CBE', '#8A5BB2', '#2E8C8C']

const heroFocusCards = [
  {
    title: '馆藏建档',
    description: '统一维护文物基本档案、图像资料、保存状态和库位信息。'
  },
  {
    title: '业务闭环',
    description: '覆盖入库、出库、盘点、修复、验收等馆内核心流程。'
  },
  {
    title: '权限留痕',
    description: '菜单授权、审批记录和操作日志统一沉淀，便于审计追溯。'
  }
]

const shortcutDescriptionMap = {
  '/system/user': '维护平台账号资料、角色绑定和启停状态。',
  '/system/role': '维护角色分层、权限范围和菜单授权关系。',
  '/system/menu': '维护菜单结构、按钮权限和授权标识。',
  '/system/dict': '维护类别、材质、状态、库位等基础业务字典。',
  '/system/log': '查看系统操作日志、请求参数和执行结果。',
  '/relic/list': '统一检索馆藏档案、库位状态与数字化资料。',
  '/relic/transfer': '在馆内库位之间发起单件或批量转存。',
  '/inventory/inbound': '登记来源、批次和入库文物，形成入库台账。',
  '/inventory/inbound/approve': '集中处理入库审批并将文物正式转为在库状态。',
  '/inventory/outbound/apply': '提交文物出库申请并跟踪流转状态。',
  '/inventory/outbound/approve': '处理出库审批、归还登记与流转闭环。',
  '/inventory/query': '按状态、类别、材质和库位筛查库存文物。',
  '/inventory/task': '创建盘点任务并提交盘点结果。',
  '/repair/apply': '筛选待修复文物并发起修复申请。',
  '/repair/approve': '审核修复申请并确认是否进入修复流程。',
  '/repair/process': '跟进个人修复任务、过程记录和附件资料。',
  '/repair/acceptance': '完成修复成果验收、返库和闭环登记。',
  '/repair/history': '查看已修复任务和历史修复档案。'
}

const router = useRouter()
const authStore = useAuthStore()
const dictStore = useDictStore()

const summary = ref({
  totalRelicCount: 0,
  inStockRelicCount: 0,
  inboundPendingCount: 0,
  outboundPendingCount: 0,
  outboundReturnPendingCount: 0,
  repairPendingCount: 0,
  repairAcceptancePendingCount: 0,
  repairingCount: 0,
  inventoryRunningCount: 0,
  statusDistribution: []
})

const statusOptions = computed(() => dictStore.itemsMap.relic_status || [])

const shortcutCards = computed(() =>
  collectShortcutMenus(authStore.menus, 10).map((menu) => ({
    ...menu,
    description: shortcutDescriptionMap[menu.path] || `${menu.menuName}业务入口，支持按当前角色权限直接办理。`
  }))
)

const activeTodoCount = computed(() =>
  todoCards.value.reduce((sum, item) => sum + Number(item.count || 0), 0)
)

const todoGridClass = computed(() => [
  'todo-grid',
  { 'todo-grid--compact': todoCards.value.length > 6 }
])

const statusStats = computed(() => {
  const total = summary.value.totalRelicCount || 0
  let start = 0
  return (summary.value.statusDistribution || []).map((item, index) => {
    const count = Number(item.count || 0)
    const percent = total ? (count / total) * 100 : 0
    const end = start + percent
    const color = STATUS_COLORS[index % STATUS_COLORS.length]
    const stat = {
      status: item.status,
      count,
      color,
      start,
      end,
      label: resolveDictLabel(statusOptions.value, item.status) || item.status || '--',
      percentText: `${percent.toFixed(percent >= 10 || percent === 0 ? 0 : 1)}%`
    }
    start = end
    return stat
  })
})

const pieStyle = computed(() => {
  if (!statusStats.value.length) {
    return {
      background: 'conic-gradient(#E6E8EC 0% 100%)'
    }
  }
  const gradients = statusStats.value.map((item) => `${item.color} ${item.start}% ${item.end}%`)
  return {
    background: `conic-gradient(${gradients.join(', ')})`
  }
})

const todoCards = computed(() => {
  const items = [
    {
      title: '待入库审批',
      description: '处理已提交的入库单并确认文物正式入库。',
      count: summary.value.inboundPendingCount || 0,
      route: { path: '/inventory/inbound/approve', query: { status: 'PENDING' } },
      visible: authStore.hasPermission('inventory:inbound:approve')
    },
    {
      title: '待出库审批',
      description: '处理文物出库申请并完成审批流转。',
      count: summary.value.outboundPendingCount || 0,
      route: { path: '/inventory/outbound/approve', query: { approveStatus: 'PENDING' } },
      visible: authStore.hasPermission('inventory:outbound:approve:view')
    },
    {
      title: '待归还登记',
      description: '登记已审批出库文物的归还结果。',
      count: summary.value.outboundReturnPendingCount || 0,
      route: { path: '/inventory/outbound/approve', query: { approveStatus: 'APPROVED' } },
      visible: authStore.hasPermission('inventory:outbound:approve:view')
    },
    {
      title: '待修复审批',
      description: '审核研究员提交的修复申请任务。',
      count: summary.value.repairPendingCount || 0,
      route: { path: '/repair/approve' },
      visible: authStore.hasPermission('repair:approve:view')
    },
    {
      title: '待修复验收',
      description: '确认已完成修复任务的最终验收结果。',
      count: summary.value.repairAcceptancePendingCount || 0,
      route: { path: '/repair/acceptance', query: { acceptanceStatus: 'WAITING' } },
      visible: authStore.hasPermission('repair:acceptance:view')
    },
    {
      title: '修复进行中',
      description: '跟进研究员当前推进中的修复任务。',
      count: summary.value.repairingCount || 0,
      route: { path: '/repair/process', query: { taskStatus: 'IN_PROGRESS' } },
      visible: authStore.hasPermission('repair:process:view')
    },
    {
      title: '盘点进行中',
      description: '继续处理尚未完成提交的盘点任务。',
      count: summary.value.inventoryRunningCount || 0,
      route: { path: '/inventory/task', query: { taskStatus: 'IN_PROGRESS' } },
      visible: authStore.hasPermission('inventory:task:view')
    }
  ]

  return items.filter((item) => item.visible)
})

const primaryTodoRoute = computed(() => {
  const firstUrgent = todoCards.value.find((item) => item.count > 0)
  return firstUrgent ? firstUrgent.route : '/relic/list'
})

async function loadSummary() {
  summary.value = await getDashboardSummaryApi()
}

dictStore.ensureMultipleItems(['relic_status'])

onMounted(() => {
  loadSummary()
})
</script>

<style scoped>
.dashboard-hero {
  background:
    radial-gradient(circle at top right, rgba(184, 138, 68, 0.14), transparent 26%),
    radial-gradient(circle at bottom left, rgba(123, 44, 42, 0.08), transparent 22%),
    linear-gradient(180deg, rgba(255, 251, 246, 0.98), rgba(245, 237, 228, 0.95));
}

.dashboard-focus-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 14px;
  margin-top: 18px;
}

.dashboard-focus-card {
  padding: 16px 18px;
  border: 1px solid rgba(123, 44, 42, 0.08);
  border-radius: 18px;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.92), rgba(248, 241, 233, 0.94));
}

.dashboard-focus-card__title {
  font-size: 15px;
  font-weight: 700;
}

.dashboard-focus-card__desc {
  margin-top: 8px;
  color: var(--text-second);
  font-size: 13px;
  line-height: 1.75;
}

.dashboard-main {
  grid-template-columns: 1.15fr 1fr;
}

.chart-layout {
  display: grid;
  grid-template-columns: minmax(0, 3fr) minmax(0, 2fr);
  gap: 24px;
  align-items: start;
  margin-top: 24px;
}

.status-pie {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  justify-self: center;
  width: min(100%, 320px);
  aspect-ratio: 1;
  border-radius: 50%;
  box-shadow: inset 0 0 0 1px rgba(123, 44, 42, 0.08);
}

.status-pie::after {
  content: '';
  position: absolute;
  inset: 28px;
  border-radius: 50%;
  background: var(--bg-card);
  box-shadow: inset 0 0 0 1px rgba(123, 44, 42, 0.06);
}

.status-pie__inner {
  position: relative;
  z-index: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.status-pie__inner strong {
  font-size: 42px;
  line-height: 1;
}

.status-pie__inner span {
  margin-top: 10px;
  color: var(--text-second);
  font-size: 13px;
}

.status-legend {
  display: grid;
  gap: 12px;
}

.status-legend__item {
  display: flex;
  gap: 12px;
  align-items: center;
  padding: 14px 16px;
  border: 1px solid var(--border-line);
  border-radius: 14px;
  background: linear-gradient(180deg, #fff, #faf8f6);
}

.status-legend__dot {
  width: 12px;
  height: 12px;
  border-radius: 999px;
  flex-shrink: 0;
}

.status-legend__content {
  min-width: 0;
  flex: 1;
}

.status-legend__row {
  display: grid;
  grid-template-columns: minmax(0, 1fr) auto auto;
  align-items: center;
  gap: 12px;
  font-weight: 600;
}

.status-legend__label {
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.status-legend__count {
  color: var(--text-second);
  font-size: 13px;
}

.status-legend__percent {
  min-width: 52px;
  text-align: right;
}

.dashboard-panel {
  background:
    radial-gradient(circle at top right, rgba(184, 138, 68, 0.12), transparent 34%),
    linear-gradient(145deg, rgba(123, 44, 42, 0.08), rgba(123, 44, 42, 0.01)),
    var(--bg-card);
}

.todo-grid {
  display: grid;
  gap: 12px;
  margin-top: 18px;
}

.todo-grid--compact {
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 10px;
}

.todo-grid--compact .todo-card {
  padding: 14px;
}

.todo-card {
  padding: 16px;
  border: 1px solid var(--border-line);
  border-radius: 14px;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.98), rgba(249, 242, 235, 0.94));
  text-align: left;
  cursor: pointer;
  transition: transform 0.2s ease, border-color 0.2s ease;
}

.todo-card:hover,
.shortcut-card:hover {
  transform: translateY(-2px);
  border-color: rgba(123, 44, 42, 0.32);
}

.todo-card__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.todo-card__main {
  display: flex;
  align-items: center;
  gap: 10px;
  min-width: 0;
  flex: 1;
}

.todo-card__meta {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-shrink: 0;
}

.todo-card__title {
  font-size: 15px;
  font-weight: 700;
  flex-shrink: 0;
}

.todo-card__desc {
  min-width: 0;
  color: var(--text-second);
  font-size: 13px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.todo-card__count {
  min-width: 44px;
  padding: 4px 10px;
  border-radius: 999px;
  background: rgba(123, 44, 42, 0.1);
  color: var(--primary);
  text-align: center;
  font-weight: 700;
}

.todo-card__action {
  color: var(--primary);
  font-size: 13px;
  font-weight: 700;
}

.shortcut-note {
  color: var(--text-second);
  font-size: 13px;
}

.shortcut-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 14px;
  margin-top: 18px;
}

.shortcut-card {
  display: flex;
  flex-direction: column;
  gap: 10px;
  padding: 18px;
  border: 1px solid var(--border-line);
  border-radius: 14px;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.98), rgba(245, 240, 235, 0.94));
  text-align: left;
  cursor: pointer;
  transition: transform 0.2s ease, border-color 0.2s ease;
}

.shortcut-card__title {
  font-size: 16px;
  font-weight: 700;
}

.shortcut-card__desc {
  color: var(--text-second);
  font-size: 13px;
  line-height: 1.75;
}

.shortcut-card__path {
  margin-top: auto;
  color: var(--primary);
  font-size: 12px;
  font-weight: 600;
}

@media (max-width: 1180px) {
  .dashboard-main {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 960px) {
  .dashboard-focus-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .chart-layout {
    grid-template-columns: 1fr;
    justify-items: center;
  }

  .status-legend {
    width: 100%;
  }
}

@media (max-width: 720px) {
  .dashboard-focus-grid {
    grid-template-columns: 1fr;
  }

  .todo-grid--compact {
    grid-template-columns: 1fr;
  }

  .todo-card__header,
  .todo-card__main {
    flex-wrap: wrap;
  }

  .status-pie {
    width: min(100%, 228px);
  }

  .status-pie::after {
    inset: 24px;
  }
}
</style>
