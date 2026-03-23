<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <PageHeader
        title="工作台"
        description="展示文物保管、审批、修复与盘点的核心摘要，作为答辩演示的统一入口。"
      />
    </section>

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
      <article class="page-card page-card--section dashboard-hero">
        <div>
          <div class="dashboard-hero__eyebrow">当前账号</div>
          <h2 class="dashboard-hero__title">{{ authStore.displayName }}</h2>
          <p class="dashboard-hero__desc">
            当前角色：{{ authStore.user?.roles?.join(' / ') || '未分配角色' }}，
            已加载 {{ authStore.menus.length }} 个菜单入口，可直接用于联调和答辩演示。
          </p>
        </div>
        <el-button type="primary" @click="router.push('/relic/list')">进入文物列表</el-button>
      </article>

      <article class="page-card page-card--section dashboard-panel">
        <div class="dashboard-panel__title">待办提醒</div>
        <ul class="dashboard-todo">
          <li>待出库审批：{{ summary.outboundPendingCount || 0 }} 单</li>
          <li>待修复审批：{{ summary.repairPendingCount || 0 }} 单</li>
          <li>修复进行中：{{ summary.repairingCount || 0 }} 单</li>
          <li>盘点进行中：{{ summary.inventoryRunningCount || 0 }} 单</li>
        </ul>
      </article>
    </section>

    <section class="page-card page-card--section">
      <PageHeader
        title="快捷入口"
        description="常用菜单直接跳转，优先聚焦当前已实现的业务流程。"
      />

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
import PageHeader from '@/components/common/PageHeader.vue'
import { useAuthStore } from '@/stores/auth'
import { collectShortcutMenus } from '@/utils/menu'

const router = useRouter()
const authStore = useAuthStore()

const summary = ref({
  totalRelicCount: 0,
  inStockRelicCount: 0,
  outboundPendingCount: 0,
  repairPendingCount: 0,
  repairingCount: 0,
  inventoryRunningCount: 0
})

const summaryCards = computed(() => [
  {
    label: '文物总量',
    value: summary.value.totalRelicCount || 0,
    note: '系统已登记馆藏文物数量'
  },
  {
    label: '在库文物',
    value: summary.value.inStockRelicCount || 0,
    note: '当前可正常在库查询的文物数量'
  },
  {
    label: '待审批出库',
    value: summary.value.outboundPendingCount || 0,
    note: '等待管理员审批的出库申请'
  },
  {
    label: '待修复审批',
    value: summary.value.repairPendingCount || 0,
    note: '刚提交、待修复方案审批的任务'
  }
])

const shortcuts = computed(() => collectShortcutMenus(authStore.menus, 10))

async function loadSummary() {
  summary.value = await getDashboardSummaryApi()
}

onMounted(() => {
  loadSummary()
})
</script>

<style scoped>
.dashboard-summary {
  grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
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
  grid-template-columns: 2fr 1fr;
}

.dashboard-hero {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  background:
    linear-gradient(145deg, rgba(123, 44, 42, 0.08), rgba(123, 44, 42, 0.02)),
    var(--bg-card);
}

.dashboard-hero__eyebrow {
  display: inline-flex;
  padding: 5px 10px;
  margin-bottom: 12px;
  border-radius: 999px;
  background: rgba(123, 44, 42, 0.08);
  color: var(--primary);
  font-size: 12px;
  font-weight: 700;
}

.dashboard-hero__title {
  margin: 0;
  font-size: 28px;
}

.dashboard-hero__desc {
  max-width: 620px;
  margin: 12px 0 0;
  line-height: 1.8;
  color: var(--text-second);
}

.dashboard-panel__title {
  font-size: 16px;
  font-weight: 700;
}

.dashboard-todo {
  padding-left: 18px;
  margin: 16px 0 0;
  color: var(--text-second);
  line-height: 2;
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
  border-radius: 12px;
  background: linear-gradient(180deg, #fff, #faf8f8);
  box-shadow: var(--shadow-card);
  text-align: left;
  cursor: pointer;
  transition: transform 0.2s ease, border-color 0.2s ease;
}

.shortcut-card:hover {
  transform: translateY(-2px);
  border-color: rgba(123, 44, 42, 0.35);
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

@media (max-width: 1080px) {
  .dashboard-main {
    grid-template-columns: 1fr;
  }

  .dashboard-hero {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>
