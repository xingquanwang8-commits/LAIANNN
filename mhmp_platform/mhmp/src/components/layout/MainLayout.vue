<template>
  <div class="layout-shell app-page">
    <AppSidebar :menus="authStore.menus" />

    <div class="layout-content">
      <AppHeader @logout="handleLogout" @profile="handleProfile" />

      <main class="layout-main">
        <router-view />
      </main>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import AppHeader from '@/components/layout/AppHeader.vue'
import AppSidebar from '@/components/layout/AppSidebar.vue'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const authStore = useAuthStore()

async function handleLogout() {
  await authStore.logout()
  router.replace('/login')
}

function handleProfile() {
  router.push('/profile')
}
</script>

<style scoped>
.layout-shell {
  display: flex;
  gap: 16px;
  padding: 16px;
}

.layout-content {
  display: flex;
  flex: 1;
  flex-direction: column;
  gap: 16px;
  min-width: 0;
}

.layout-main {
  min-height: calc(100vh - 112px);
}

@media (max-width: 960px) {
  .layout-shell {
    flex-direction: column;
  }
}
</style>
