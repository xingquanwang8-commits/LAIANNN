<template>
  <aside class="sidebar-shell page-card">
    <div class="sidebar-brand">
      <div class="sidebar-brand__badge">MH</div>
      <div>
        <div class="sidebar-brand__title">博物馆管理平台</div>
        <div class="sidebar-brand__desc">Museum Heritage Management</div>
      </div>
    </div>

    <el-scrollbar class="sidebar-scroll">
      <el-menu
        :default-active="activePath"
        class="sidebar-menu"
        router
      >
        <template v-for="menu in menus" :key="menu.id">
          <el-sub-menu v-if="menu.children?.length" :index="menu.path || String(menu.id)">
            <template #title>
              <el-icon><component :is="resolveMenuIcon(menu.icon)" /></el-icon>
              <span>{{ menu.menuName }}</span>
            </template>
            <el-menu-item
              v-for="child in menu.children"
              :key="child.id"
              :index="child.path"
            >
              <el-icon><component :is="resolveMenuIcon(child.icon)" /></el-icon>
              <span>{{ child.menuName }}</span>
            </el-menu-item>
          </el-sub-menu>

          <el-menu-item v-else :index="menu.path">
            <el-icon><component :is="resolveMenuIcon(menu.icon)" /></el-icon>
            <span>{{ menu.menuName }}</span>
          </el-menu-item>
        </template>
      </el-menu>
    </el-scrollbar>
  </aside>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { resolveMenuIcon } from '@/constants/icons'

defineProps({
  menus: {
    type: Array,
    default: () => []
  }
})

const route = useRoute()
const activePath = computed(() => route.path)
</script>

<style scoped>
.sidebar-shell {
  display: flex;
  flex-direction: column;
  width: 244px;
  min-height: calc(100vh - 32px);
  padding: 16px 0;
}

.sidebar-brand {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 0 18px 18px;
  margin: 0 0 10px;
  border-bottom: 1px solid var(--border-line);
}

.sidebar-brand__badge {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 42px;
  height: 42px;
  border-radius: 12px;
  background: rgba(123, 44, 42, 0.12);
  color: var(--primary);
  font-weight: 800;
}

.sidebar-brand__title {
  font-size: 16px;
  font-weight: 700;
}

.sidebar-brand__desc {
  margin-top: 3px;
  font-size: 12px;
  color: var(--text-second);
}

.sidebar-scroll {
  flex: 1;
}

.sidebar-menu {
  background: transparent;
}

@media (max-width: 960px) {
  .sidebar-shell {
    width: 100%;
    min-height: auto;
  }
}
</style>
