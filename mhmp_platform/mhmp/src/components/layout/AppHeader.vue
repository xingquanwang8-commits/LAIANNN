<template>
  <header class="header-shell page-card">
    <div>
      <div class="header-title">{{ route.meta.title || '工作台' }}</div>
      <div class="header-breadcrumb text-secondary">
        {{ breadcrumbText || '博物馆文物综合管理平台' }}
      </div>
    </div>

    <div class="header-actions">
      <div class="header-user">
        <div class="header-user__avatar">{{ userInitial }}</div>
        <div>
          <div class="header-user__name">{{ authStore.displayName }}</div>
          <div class="header-user__role text-secondary">{{ roleText }}</div>
        </div>
      </div>

      <el-button text @click="$emit('profile')">个人中心</el-button>
      <el-button text @click="$emit('logout')">退出登录</el-button>
    </div>
  </header>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

defineEmits(['logout', 'profile'])

const authStore = useAuthStore()
const route = useRoute()

const roleText = computed(() => authStore.user?.roles?.join(' / ') || '未分配角色')
const userInitial = computed(() => authStore.displayName?.slice(0, 1) || '馆')
const breadcrumbText = computed(() => route.matched
  .filter((record) => record.meta?.title)
  .map((record) => record.meta.title)
  .join(' / '))
</script>

<style scoped>
.header-shell {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  padding: 14px 18px;
}

.header-title {
  font-size: 20px;
  font-weight: 700;
}

.header-breadcrumb {
  margin-top: 4px;
  font-size: 12px;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.header-user {
  display: flex;
  align-items: center;
  gap: 10px;
}

.header-user__avatar {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  border-radius: 12px;
  background: rgba(123, 44, 42, 0.12);
  color: var(--primary);
  font-weight: 700;
}

.header-user__name {
  font-size: 14px;
  font-weight: 600;
}

.header-user__role {
  font-size: 12px;
}

@media (max-width: 960px) {
  .header-shell {
    flex-direction: column;
    align-items: flex-start;
  }

  .header-actions {
    width: 100%;
    justify-content: space-between;
    flex-wrap: wrap;
  }
}
</style>
