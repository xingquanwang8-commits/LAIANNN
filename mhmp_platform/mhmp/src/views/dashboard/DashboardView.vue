<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <PageHeader
        title="工作台"
        description="保留简洁信息密度，帮助演示登录后角色、菜单与核心业务入口。"
      />
    </section>

    <section class="page-grid dashboard-grid">
      <article class="page-card page-card--section dashboard-hero">
        <div>
          <div class="dashboard-hero__eyebrow">当前登录账号</div>
          <h2 class="dashboard-hero__title">{{ authStore.displayName }}</h2>
          <p class="dashboard-hero__desc">
            欢迎进入馆藏管理后台。当前账号共拥有
            <strong>{{ authStore.permissions.length }}</strong>
            个权限点，可访问
            <strong>{{ shortcutList.length }}</strong>
            个首批联调页面。
          </p>
        </div>
        <el-button type="primary" @click="router.push('/relic/list')">进入文物管理</el-button>
      </article>

      <article class="page-card page-card--section">
        <div class="dashboard-stat__label">角色信息</div>
        <div class="dashboard-stat__value">{{ roleText }}</div>
        <div class="dashboard-stat__note text-secondary">角色信息来自后端当前用户接口</div>
      </article>

      <article class="page-card page-card--section">
        <div class="dashboard-stat__label">当前菜单</div>
        <div class="dashboard-stat__value">{{ authStore.menus.length }}</div>
        <div class="dashboard-stat__note text-secondary">仅展示当前已支持并可真实联调的模块</div>
      </article>
    </section>

    <section class="page-card page-card--section">
      <PageHeader
        title="快捷入口"
        description="保留首批联调页面，避免出现后端暂未完成的空菜单。"
      />

      <div class="dashboard-shortcuts">
        <button
          v-for="item in shortcutList"
          :key="item.path"
          class="dashboard-shortcut"
          @click="router.push(item.path)"
        >
          <div class="dashboard-shortcut__title">{{ item.title }}</div>
          <div class="dashboard-shortcut__path">{{ item.path }}</div>
        </button>
      </div>
    </section>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import PageHeader from '@/components/common/PageHeader.vue'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const authStore = useAuthStore()

const roleText = computed(() => authStore.user?.roles?.join(' / ') || '未分配角色')

const shortcutList = computed(() => {
  const result = []
  authStore.menus.forEach((menu) => {
    if (menu.children?.length) {
      menu.children.forEach((child) => {
        if (child.path) {
          result.push({
            title: child.menuName,
            path: child.path
          })
        }
      })
      return
    }
    if (menu.path) {
      result.push({
        title: menu.menuName,
        path: menu.path
      })
    }
  })
  return result
})
</script>

<style scoped>
.dashboard-grid {
  grid-template-columns: 2fr 1fr 1fr;
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
  max-width: 600px;
  margin: 12px 0 0;
  line-height: 1.8;
  color: var(--text-second);
}

.dashboard-stat__label {
  color: var(--text-second);
  font-size: 13px;
}

.dashboard-stat__value {
  margin-top: 10px;
  font-size: 30px;
  font-weight: 700;
}

.dashboard-stat__note {
  margin-top: 12px;
  line-height: 1.7;
  font-size: 13px;
}

.dashboard-shortcuts {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 14px;
  margin-top: 18px;
}

.dashboard-shortcut {
  padding: 18px;
  border: 1px solid var(--border-line);
  border-radius: 12px;
  background: linear-gradient(180deg, #fff, #faf8f8);
  box-shadow: var(--shadow-card);
  text-align: left;
  cursor: pointer;
  transition: transform 0.2s ease, border-color 0.2s ease;
}

.dashboard-shortcut:hover {
  transform: translateY(-2px);
  border-color: rgba(123, 44, 42, 0.35);
}

.dashboard-shortcut__title {
  font-size: 16px;
  font-weight: 700;
}

.dashboard-shortcut__path {
  margin-top: 8px;
  color: var(--text-second);
  font-size: 13px;
}

@media (max-width: 1080px) {
  .dashboard-grid {
    grid-template-columns: 1fr;
  }

  .dashboard-hero {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>
