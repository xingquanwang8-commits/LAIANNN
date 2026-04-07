<template>
  <div class="page-shell">
    <section class="page-grid dashboard-summary">
      <article
        v-for="item in summaryCards"
        :key="item.label"
        class="page-card page-card--section summary-card"
      >
        <div class="summary-card__label">{{ item.label }}</div>
        <div class="summary-card__value">{{ item.value }}</div>
        <div class="summary-card__note">{{ item.note }}</div>
      </article>
    </section>

    <section class="page-grid dashboard-main">
      <article class="page-card page-card--section dashboard-chart-card">
        <div class="section-head">
          <div>
            <div class="section-head__title">馆藏状态占比</div>
            <div class="section-head__desc">按数据库中当前文物状态实时汇总，页面刷新后自动更新百分比。</div>
          </div>
          <el-button @click="loadSummary">刷新数据</el-button>
        </div>

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

          <el-empty v-else description="暂无馆藏状态数据" />
        </div>
      </article>

      <article class="page-card page-card--section dashboard-panel">
        <div class="section-head">
          <div>
            <div class="section-head__title">业务待办</div>
          </div>
          <el-button type="primary" @click="router.push(primaryTodoRoute)">优先处理待办</el-button>
        </div>

        <div v-if="todoCards.length" class="todo-grid">
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
        <el-empty v-else description="当前账号暂无可处理待办" />
      </article>
    </section>

    <section class="page-card page-card--section">
      <div class="section-head">
        <div>
          <div class="section-head__title">快捷入口</div>
          <div class="section-head__desc">保留当前高频业务入口，进入页面即可继续演示完整流程。</div>
        </div>
        <div class="shortcut-note">已聚合 {{ shortcuts.length }} 个常用入口</div>
      </div>

      <div class="shortcut-grid">
        <button
          v-for="menu in shortcuts"
          :key="menu.id"
          class="shortcut-card"
          @click="router.push(menu.path)"
        >
          <div class="shortcut-card__title">{{ menu.menuName }}</div>
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
import { useAuthStore } from '@/stores/auth'
import { useDictStore } from '@/stores/dict'
import { resolveDictLabel } from '@/utils/format'
import { collectShortcutMenus } from '@/utils/menu'

const STATUS_COLORS = ['#7B2C2A', '#C68A39', '#3C8E5B', '#4C7CBE', '#8A5BB2', '#2E8C8C']

const router = useRouter()
const authStore = useAuthStore()
const dictStore = useDictStore()

const summary = ref({
  totalRelicCount: 0,
  inStockRelicCount: 0,
  outboundPendingCount: 0,
  outboundReturnPendingCount: 0,
  repairPendingCount: 0,
  repairAcceptancePendingCount: 0,
  repairingCount: 0,
  inventoryRunningCount: 0,
  statusDistribution: []
})

const statusOptions = computed(() => dictStore.itemsMap.relic_status || [])

const summaryCards = computed(() => [
  {
    label: '文物总量',
    value: summary.value.totalRelicCount || 0,
    note: '系统已登记的全部馆藏文物'
  },
  {
    label: '在库文物',
    value: summary.value.inStockRelicCount || 0,
    note: '当前可正常在馆藏库位中查询的文物'
  },
  {
    label: '待出库审批',
    value: summary.value.outboundPendingCount || 0,
    note: '等待管理员处理的文物出库业务'
  },
  {
    label: '待修复验收',
    value: summary.value.repairAcceptancePendingCount || 0,
    note: '已完成修复、等待最终验收回库'
  },
  {
    label: '修复进行中',
    value: summary.value.repairingCount || 0,
    note: '研究员正在推进的修复任务'
  },
  {
    label: '盘点进行中',
    value: summary.value.inventoryRunningCount || 0,
    note: '尚未完成提交结果的盘点任务'
  }
])

const shortcuts = computed(() => collectShortcutMenus(authStore.menus, 10))

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
      title: '待出库审批',
      description: '处理文物出库申请并完成审批流转',
      count: summary.value.outboundPendingCount || 0,
      route: { path: '/inventory/outbound/approve', query: { approveStatus: 'PENDING' } },
      visible: authStore.hasPermission('inventory:outbound:approve:view')
    },
    {
      title: '待归还登记',
      description: '登记已审批出库文物的归还结果',
      count: summary.value.outboundReturnPendingCount || 0,
      route: { path: '/inventory/outbound/approve', query: { approveStatus: 'APPROVED' } },
      visible: authStore.hasPermission('inventory:outbound:approve:view')
    },
    {
      title: '待修复审批',
      description: '审核研究员提交的修复申请任务',
      count: summary.value.repairPendingCount || 0,
      route: { path: '/repair/approve' },
      visible: authStore.hasPermission('repair:approve:view')
    },
    {
      title: '待修复验收',
      description: '确认已完成修复任务的最终验收结果',
      count: summary.value.repairAcceptancePendingCount || 0,
      route: { path: '/repair/acceptance', query: { acceptanceStatus: 'WAITING' } },
      visible: authStore.hasPermission('repair:acceptance:view')
    },
    {
      title: '修复进行中',
      description: '跟进研究员当前推进中的修复任务',
      count: summary.value.repairingCount || 0,
      route: { path: '/repair/process', query: { taskStatus: 'IN_PROGRESS' } },
      visible: authStore.hasPermission('repair:process:view')
    },
    {
      title: '盘点进行中',
      description: '继续处理尚未完成提交的盘点任务',
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
.dashboard-summary {
  grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
}

.summary-card {
  background:
    linear-gradient(180deg, rgba(255, 255, 255, 0.98), rgba(248, 244, 239, 0.92)),
    var(--bg-card);
}

.summary-card__label {
  color: var(--text-second);
  font-size: 13px;
}

.summary-card__value {
  margin-top: 10px;
  font-size: 30px;
  font-weight: 700;
}

.summary-card__note {
  margin-top: 12px;
  color: var(--text-second);
  line-height: 1.7;
  font-size: 13px;
}

.dashboard-main {
  grid-template-columns: 1.15fr 1fr;
}

.section-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  flex-wrap: wrap;
}

.section-head__title {
  font-size: 18px;
  font-weight: 700;
}

.section-head__desc {
  margin-top: 8px;
  color: var(--text-second);
  font-size: 13px;
  line-height: 1.8;
}

.chart-layout {
  display: grid;
  grid-template-columns: minmax(0, 3fr) minmax(0, 2fr);
  gap: 24px;
  align-items: start;
  margin-top: 26px;
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
    linear-gradient(145deg, rgba(123, 44, 42, 0.06), rgba(123, 44, 42, 0.01)),
    var(--bg-card);
}

.todo-grid {
  display: grid;
  gap: 12px;
  margin-top: 18px;
}

.todo-card {
  padding: 16px;
  border: 1px solid var(--border-line);
  border-radius: 14px;
  background: linear-gradient(180deg, #fff, #faf8f6);
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
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 14px;
  margin-top: 18px;
}

.shortcut-card {
  padding: 18px;
  border: 1px solid var(--border-line);
  border-radius: 14px;
  background: linear-gradient(180deg, #fff, #faf8f8);
  text-align: left;
  cursor: pointer;
  transition: transform 0.2s ease, border-color 0.2s ease;
}

.shortcut-card__title {
  font-size: 16px;
  font-weight: 700;
}

.shortcut-card__path {
  margin-top: 8px;
  color: var(--text-second);
  font-size: 13px;
}

@media (max-width: 1180px) {
  .dashboard-main {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 960px) {
  .chart-layout {
    grid-template-columns: 1fr;
    justify-items: center;
  }

  .status-legend {
    width: 100%;
  }
}

@media (max-width: 720px) {
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
