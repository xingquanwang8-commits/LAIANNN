<template>
  <nav class="tabs-shell page-card" aria-label="页面标签导航">
    <el-scrollbar class="tabs-scrollbar">
      <div class="tabs-track">
        <button
          v-for="tab in tabs"
          :key="tab.fullPath"
          type="button"
          class="tab-item"
          :class="{ 'tab-item--active': tab.fullPath === route.fullPath }"
          @click="activateTab(tab)"
        >
          <span class="tab-item__dot" />
          <span class="tab-item__label" :title="tab.title">{{ tab.title }}</span>
          <el-icon
            v-if="tab.closable"
            class="tab-item__close"
            @click.stop="closeTab(tab)"
          >
            <Close />
          </el-icon>
        </button>
      </div>
    </el-scrollbar>
  </nav>
</template>

<script setup>
import { computed, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { Close } from '@element-plus/icons-vue'
import { useAuthStore } from '@/stores/auth'
import { findMenuByPath } from '@/utils/menu'

const HOME_TAB = {
  title: '首页',
  path: '/dashboard',
  fullPath: '/dashboard',
  closable: false
}

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()
const tabs = ref([HOME_TAB])

const menuTitleMap = computed(() => {
  const map = new Map()
  collectMenuTitles(authStore.menus, map)
  return map
})

watch(
  () => route.fullPath,
  () => addCurrentRouteTab(),
  { immediate: true }
)

watch(
  menuTitleMap,
  () => syncTabTitles(),
  { deep: true }
)

function addCurrentRouteTab() {
  if (!route.meta.requiresAuth || route.path === '/dashboard') {
    ensureHomeTab()
    return
  }
  const existingTab = tabs.value.find((tab) => tab.fullPath === route.fullPath)
  if (existingTab) {
    existingTab.title = resolveRouteTitle(route)
    return
  }
  tabs.value.push({
    title: resolveRouteTitle(route),
    path: route.path,
    fullPath: route.fullPath,
    closable: true
  })
}

function ensureHomeTab() {
  if (!tabs.value.some((tab) => tab.fullPath === HOME_TAB.fullPath)) {
    tabs.value.unshift(HOME_TAB)
  }
}

function activateTab(tab) {
  if (tab.fullPath !== route.fullPath) {
    router.push(tab.fullPath)
  }
}

function closeTab(tab) {
  if (!tab.closable) {
    return
  }
  const currentIndex = tabs.value.findIndex((item) => item.fullPath === tab.fullPath)
  if (currentIndex < 0) {
    return
  }
  tabs.value.splice(currentIndex, 1)
  if (tab.fullPath !== route.fullPath) {
    return
  }
  const nextTab = tabs.value[currentIndex] || tabs.value[currentIndex - 1] || HOME_TAB
  router.push(nextTab.fullPath)
}

function resolveRouteTitle(currentRoute) {
  if (currentRoute.path === '/dashboard') {
    return HOME_TAB.title
  }
  const menu = findMenuByPath(authStore.menus, currentRoute.path)
  return menu?.menuName || currentRoute.meta?.title || '未命名页面'
}

function syncTabTitles() {
  tabs.value.forEach((tab) => {
    if (tab.fullPath === HOME_TAB.fullPath) {
      tab.title = HOME_TAB.title
      return
    }
    const menuName = menuTitleMap.value.get(tab.path)
    if (menuName) {
      tab.title = menuName
    }
  })
}

function collectMenuTitles(menus = [], map) {
  menus.forEach((menu) => {
    if (menu.path) {
      map.set(normalizePath(menu.path), menu.menuName)
    }
    collectMenuTitles(menu.children || [], map)
  })
}

function normalizePath(path) {
  if (!path) {
    return ''
  }
  return path.startsWith('/') ? path : `/${path}`
}
</script>

<style scoped>
.tabs-shell {
  min-height: 54px;
  padding: 8px 10px;
  border-radius: 16px;
  background:
    radial-gradient(circle at 0 50%, rgba(123, 44, 42, 0.08), transparent 24%),
    linear-gradient(135deg, rgba(255, 255, 255, 0.98), rgba(249, 242, 235, 0.95));
}

.tabs-scrollbar {
  width: 100%;
}

.tabs-track {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  min-width: 100%;
}

.tab-item {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  max-width: 180px;
  height: 38px;
  padding: 0 12px;
  border: 1px solid rgba(123, 44, 42, 0.08);
  border-radius: 13px;
  background: rgba(255, 255, 255, 0.72);
  color: rgba(55, 49, 45, 0.86);
  cursor: pointer;
  transition: transform 0.2s ease, border-color 0.2s ease, background 0.2s ease, box-shadow 0.2s ease;
}

.tab-item:hover {
  transform: translateY(-1px);
  border-color: rgba(123, 44, 42, 0.22);
  background: rgba(255, 255, 255, 0.94);
}

.tab-item--active {
  border-color: rgba(123, 44, 42, 0.2);
  background: linear-gradient(135deg, rgba(123, 44, 42, 0.13), rgba(184, 138, 68, 0.1));
  box-shadow: 0 10px 18px rgba(79, 49, 31, 0.08);
  color: var(--primary-deep);
  font-weight: 700;
}

.tab-item__dot {
  width: 7px;
  height: 7px;
  border-radius: 999px;
  background: rgba(123, 44, 42, 0.24);
}

.tab-item--active .tab-item__dot {
  background: var(--primary);
}

.tab-item__label {
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.tab-item__close {
  width: 18px;
  height: 18px;
  flex-shrink: 0;
  border-radius: 999px;
  color: rgba(123, 44, 42, 0.68);
  transition: background 0.2s ease, color 0.2s ease;
}

.tab-item__close:hover {
  background: rgba(123, 44, 42, 0.12);
  color: var(--primary);
}

@media (max-width: 720px) {
  .tabs-shell {
    padding: 8px;
  }

  .tab-item {
    max-width: 142px;
  }
}
</style>
