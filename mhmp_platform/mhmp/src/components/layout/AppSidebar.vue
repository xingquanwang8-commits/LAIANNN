<template>
  <aside class="sidebar-shell page-card">
    <div class="sidebar-brand">
      <div class="sidebar-brand__logo">
        <img
          v-if="logoAvailable"
          :src="APP_LOGO_PUBLIC_PATH"
          alt="MHMP Logo"
          class="sidebar-brand__logo-image"
          @error="handleLogoError"
        >
      </div>
      <div class="sidebar-brand__content">
        <div class="sidebar-brand__title-primary">{{ APP_TITLE_PRIMARY }}</div>
        <div class="sidebar-brand__title-secondary">
          <span>{{ APP_TITLE_SECONDARY }}</span>
          <span class="sidebar-brand__title-dot">&middot;</span>
          <span class="sidebar-brand__title-short">{{ APP_SHORT_NAME }}</span>
        </div>
        <div class="sidebar-brand__desc">{{ APP_SIDEBAR_ENGLISH_LINE }}</div>
      </div>
    </div>

    <el-scrollbar class="sidebar-scroll">
      <el-menu
        :default-active="activeMenuPath || activePath"
        :default-openeds="defaultOpeneds"
        :unique-opened="true"
        class="sidebar-menu"
        router
      >
        <template v-for="menu in orderedMenus" :key="menu.id">
          <el-sub-menu
            v-if="menu.children?.length"
            :index="resolveMenuIndex(menu)"
            :class="{ 'sidebar-group--current': isMenuGroupActive(menu) }"
          >
            <template #title>
              <el-icon><component :is="resolveMenuIcon(menu.icon)" /></el-icon>
              <span>{{ menu.menuName }}</span>
            </template>
            <el-menu-item
              v-for="child in menu.children"
              :key="child.id"
              :index="child.path"
              :class="{ 'sidebar-child--current': isMenuActive(child.path) }"
            >
              <el-icon><component :is="resolveMenuIcon(child.icon)" /></el-icon>
              <span>{{ child.menuName }}</span>
            </el-menu-item>
          </el-sub-menu>

          <el-menu-item
            v-else
            :index="menu.path"
            :class="{ 'sidebar-leaf--current': isMenuActive(menu.path) }"
          >
            <el-icon><component :is="resolveMenuIcon(menu.icon)" /></el-icon>
            <span>{{ menu.menuName }}</span>
          </el-menu-item>
        </template>
      </el-menu>
    </el-scrollbar>
  </aside>
</template>

<script setup>
import { computed, ref } from 'vue'
import { useRoute } from 'vue-router'
import { resolveMenuIcon } from '@/constants/icons'
import {
  APP_LOGO_PUBLIC_PATH,
  APP_SHORT_NAME,
  APP_SIDEBAR_ENGLISH_LINE,
  APP_TITLE_PRIMARY,
  APP_TITLE_SECONDARY
} from '@/constants/menu'

const props = defineProps({
  menus: {
    type: Array,
    default: () => []
  }
})

const route = useRoute()
const logoAvailable = ref(true)
const activePath = computed(() => route.path)
const activeMenuPath = computed(() => findBestMatchingMenuPath(props.menus, activePath.value))
const orderedMenus = computed(() => {
  const menus = [...(props.menus || [])]
  return menus.sort((left, right) => {
    const leftIsProfile = normalizePath(left.path) === '/profile'
    const rightIsProfile = normalizePath(right.path) === '/profile'
    if (leftIsProfile === rightIsProfile) {
      return 0
    }
    return leftIsProfile ? 1 : -1
  })
})
const defaultOpeneds = computed(() =>
  orderedMenus.value
    .filter((menu) =>
      (menu.children || []).some((child) => normalizePath(child.path) === activeMenuPath.value)
    )
    .map((menu) => resolveMenuIndex(menu))
)

function handleLogoError() {
  logoAvailable.value = false
}

function resolveMenuIndex(menu) {
  return menu.path || String(menu.id)
}

function isMenuActive(path) {
  return normalizePath(path) === activeMenuPath.value
}

function isMenuGroupActive(menu) {
  return (menu.children || []).some((child) => normalizePath(child.path) === activeMenuPath.value)
}

function normalizePath(path) {
  if (!path) {
    return ''
  }
  return path.startsWith('/') ? path : `/${path}`
}

function isPathMatch(menuPath, currentPath) {
  const normalizedPath = normalizePath(menuPath)
  if (!normalizedPath || !currentPath) {
    return false
  }
  return currentPath === normalizedPath || currentPath.startsWith(`${normalizedPath}/`)
}

function flattenLeafPaths(menus = []) {
  return menus.flatMap((menu) => {
    if (menu.children?.length) {
      return flattenLeafPaths(menu.children)
    }
    return menu.path ? [normalizePath(menu.path)] : []
  })
}

function findBestMatchingMenuPath(menus, currentPath) {
  let bestMatch = ''
  for (const path of flattenLeafPaths(menus)) {
    if (isPathMatch(path, currentPath) && path.length > bestMatch.length) {
      bestMatch = path
    }
  }
  return bestMatch
}
</script>

<style scoped>
.sidebar-shell {
  display: flex;
  flex-direction: column;
  width: 252px;
  min-height: calc(100vh - 32px);
  padding: 14px 0 16px;
  background:
    radial-gradient(circle at top right, rgba(184, 138, 68, 0.12), transparent 28%),
    linear-gradient(180deg, rgba(255, 255, 255, 0.98), rgba(248, 242, 235, 0.94));
}

.sidebar-brand {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 0 18px 16px;
  margin: 0 0 8px;
  border-bottom: 1px solid rgba(123, 44, 42, 0.1);
}

.sidebar-brand__logo {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 60px;
  height: 60px;
  flex-shrink: 0;
  padding: 6px;
  border-radius: 18px;
  border: 1px solid rgba(123, 44, 42, 0.08);
  background:
    radial-gradient(circle at top right, rgba(184, 138, 68, 0.14), transparent 28%),
    linear-gradient(145deg, rgba(255, 255, 255, 0.96), rgba(246, 239, 231, 0.92));
  box-shadow: 0 10px 20px rgba(79, 49, 31, 0.08), inset 0 1px 0 rgba(255, 255, 255, 0.55);
  overflow: hidden;
}

.sidebar-brand__logo-image {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.sidebar-brand__content {
  min-width: 0;
  flex: 1;
}

.sidebar-brand__title-primary {
  color: var(--primary);
  font-size: 21px;
  font-weight: 800;
  line-height: 1.1;
}

.sidebar-brand__title-secondary {
  display: flex;
  align-items: baseline;
  gap: 6px;
  margin-top: 4px;
  color: #4f4a46;
  font-size: 11px;
  font-weight: 700;
  line-height: 1.2;
}

.sidebar-brand__title-short {
  color: rgba(94, 33, 31, 0.86);
  font-size: 10px;
  font-weight: 600;
}

.sidebar-brand__title-dot {
  color: rgba(94, 33, 31, 0.7);
}

.sidebar-brand__desc {
  margin-top: 6px;
  color: rgba(88, 72, 64, 0.78);
  font-size: 9px;
  line-height: 1.35;
  letter-spacing: 0.02em;
}

.sidebar-scroll {
  flex: 1;
}

.sidebar-menu {
  background: transparent;
}

.sidebar-menu :deep(.el-menu-item),
.sidebar-menu :deep(.el-sub-menu__title) {
  position: relative;
  min-height: 48px;
  padding-inline: 14px;
  font-weight: 600;
  color: rgba(55, 49, 45, 0.88);
  transition: background 0.2s ease, color 0.2s ease, transform 0.2s ease, box-shadow 0.2s ease;
}

.sidebar-menu :deep(.el-menu-item .el-icon),
.sidebar-menu :deep(.el-sub-menu__title .el-icon) {
  color: rgba(123, 44, 42, 0.72);
  transition: color 0.2s ease, transform 0.2s ease;
}

.sidebar-menu :deep(.el-menu-item:hover),
.sidebar-menu :deep(.el-sub-menu__title:hover) {
  transform: translateX(2px);
}

.sidebar-menu :deep(.el-menu-item:hover .el-icon),
.sidebar-menu :deep(.el-sub-menu__title:hover .el-icon) {
  color: var(--primary);
}

.sidebar-menu :deep(.el-sub-menu__title) {
  margin-bottom: 6px;
  border: 1px solid transparent;
}

.sidebar-menu :deep(.el-sub-menu .el-menu) {
  margin: 4px 12px 12px 24px;
  padding: 4px 0 2px 16px;
  background: transparent;
  border-left: 1px solid rgba(123, 44, 42, 0.12);
}

.sidebar-menu :deep(.el-sub-menu .el-menu-item) {
  justify-content: flex-start;
  min-height: 44px;
  margin: 0 0 10px;
  padding-left: 16px;
  border: 1px solid transparent;
  border-radius: 14px;
}

.sidebar-menu :deep(.el-sub-menu .el-menu-item::before) {
  content: '';
  position: absolute;
  left: -17px;
  top: 50%;
  width: 9px;
  height: 1px;
  background: rgba(123, 44, 42, 0.18);
  transform: translateY(-50%);
}

.sidebar-menu :deep(.sidebar-group--current > .el-sub-menu__title),
.sidebar-menu :deep(.el-sub-menu.is-opened > .el-sub-menu__title) {
  border-color: rgba(123, 44, 42, 0.08);
  box-shadow: inset 3px 0 0 rgba(123, 44, 42, 0.18);
  color: var(--primary-deep);
}

.sidebar-menu :deep(.sidebar-group--current > .el-sub-menu__title .el-icon),
.sidebar-menu :deep(.el-sub-menu.is-opened > .el-sub-menu__title .el-icon) {
  color: var(--primary);
}

.sidebar-menu :deep(.el-sub-menu__icon-arrow) {
  color: rgba(123, 44, 42, 0.54);
}

.sidebar-menu :deep(.sidebar-child--current),
.sidebar-menu :deep(.sidebar-leaf--current) {
  border-color: rgba(123, 44, 42, 0.1);
  background: linear-gradient(135deg, rgba(123, 44, 42, 0.12), rgba(184, 138, 68, 0.08));
  box-shadow: 0 10px 20px rgba(79, 49, 31, 0.08);
  color: var(--primary-deep);
}

.sidebar-menu :deep(.sidebar-child--current .el-icon),
.sidebar-menu :deep(.sidebar-leaf--current .el-icon) {
  color: var(--primary);
  transform: scale(1.05);
}

.sidebar-menu :deep(.sidebar-child--current::after),
.sidebar-menu :deep(.sidebar-leaf--current::after) {
  content: '';
  position: absolute;
  left: 12px;
  top: 50%;
  width: 6px;
  height: 6px;
  border-radius: 999px;
  background: var(--primary);
  transform: translateY(-50%);
}

.sidebar-menu :deep(.sidebar-child--current span),
.sidebar-menu :deep(.sidebar-leaf--current span) {
  font-weight: 700;
}

.sidebar-menu :deep(.sidebar-leaf--current) {
  margin-inline: 12px;
}

@media (max-width: 960px) {
  .sidebar-shell {
    width: 100%;
    min-height: auto;
  }
}
</style>
