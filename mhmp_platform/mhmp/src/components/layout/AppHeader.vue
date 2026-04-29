<template>
  <header class="header-shell page-card">
    <AppTabs class="header-tabs" />

    <div class="header-actions">
      <button class="header-user" type="button" @click="$emit('profile')">
        <div class="header-user__avatar">
          <img v-if="authStore.user?.avatarUrl" :src="authStore.user.avatarUrl" alt="用户头像" class="header-user__avatar-image">
          <span v-else>{{ userInitial }}</span>
        </div>
        <div class="header-user__content">
          <div class="header-user__name">{{ authStore.displayName }}</div>
          <div class="header-user__role text-secondary">{{ roleText }}</div>
        </div>
      </button>

      <el-button text class="header-logout" @click="$emit('logout')">退出登录</el-button>
    </div>
  </header>
</template>

<script setup>
import { computed } from 'vue'
import AppTabs from '@/components/layout/AppTabs.vue'
import { useAuthStore } from '@/stores/auth'

defineEmits(['logout', 'profile'])

const authStore = useAuthStore()

const roleText = computed(() => authStore.user?.roles?.join(' / ') || '未分配角色')
const userInitial = computed(() => authStore.displayName?.slice(0, 1) || '馆')
</script>

<style scoped>
.header-shell {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  padding: 14px 18px;
  border-radius: 16px;
  background:
    radial-gradient(circle at top left, rgba(123, 44, 42, 0.12), transparent 30%),
    radial-gradient(circle at left center, rgba(184, 138, 68, 0.1), transparent 24%),
    radial-gradient(circle at top right, rgba(184, 138, 68, 0.18), transparent 28%),
    radial-gradient(circle at bottom right, rgba(123, 44, 42, 0.06), transparent 22%),
    linear-gradient(135deg, rgba(255, 255, 255, 0.98), rgba(249, 242, 235, 0.97) 42%, rgba(244, 236, 228, 0.95));
}

.header-tabs {
  flex: 1;
  min-width: 0;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-shrink: 0;
}

.header-user {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 0;
  border: none;
  background: transparent;
  cursor: pointer;
  transition: transform 0.2s ease;
}

.header-user:hover {
  transform: translateY(-1px);
}

.header-user__avatar {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 42px;
  height: 42px;
  border-radius: 12px;
  background: rgba(123, 44, 42, 0.12);
  color: var(--primary);
  font-weight: 700;
  overflow: hidden;
  transition: background 0.2s ease, box-shadow 0.2s ease;
}

.header-user:hover .header-user__avatar {
  background: rgba(123, 44, 42, 0.16);
  box-shadow: 0 8px 18px rgba(79, 49, 31, 0.08);
}

.header-user__avatar-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.header-user__content {
  text-align: left;
}

.header-user__name {
  font-size: 14px;
  font-weight: 600;
}

.header-user__role {
  font-size: 12px;
}

.header-logout {
  color: var(--primary-deep);
  font-weight: 600;
}

@media (max-width: 960px) {
  .header-shell {
    flex-direction: column;
    align-items: flex-start;
    border-radius: 18px;
  }

  .header-tabs {
    width: 100%;
  }

  .header-actions {
    width: 100%;
    justify-content: space-between;
    flex-wrap: wrap;
  }
}
</style>
