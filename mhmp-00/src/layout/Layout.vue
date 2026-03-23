<template>
  <div class="layout-container">
    <el-container class="layout-shell">
      <el-aside width="200px" class="layout-aside">
        <div class="logo">MHMP</div>
        <el-menu
          active-text-color="#ffd04b"
          background-color="#304156"
          text-color="#fff"
          router
        >
          <el-menu-item index="/dashboard">
            <el-icon><Menu /></el-icon>
            <span>仪表盘</span>
          </el-menu-item>
        </el-menu>
      </el-aside>

      <el-container>
        <el-header class="layout-header">
          <el-dropdown>
            <span class="user-entry">
              管理员
              <el-icon class="user-entry-icon"><ArrowDown /></el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item @click="handleLogout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </el-header>

        <el-main>
          <router-view />
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>

<script>
export default {
  name: 'AppLayout',
}
</script>

<script setup>
import { ArrowDown, Menu } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { useRouter } from 'vue-router'

const router = useRouter()

const handleLogout = () => {
  ElMessage.success('退出成功')
  router.push('/login')
}
</script>

<style scoped>
.layout-container {
  height: 100vh;
}

.layout-shell {
  height: 100vh;
}

.layout-aside {
  background-color: #304156;
}

.layout-header {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  border-bottom: 1px solid #ddd;
}

.logo {
  height: 60px;
  line-height: 60px;
  text-align: center;
  color: #fff;
  font-size: 20px;
  font-weight: bold;
  background-color: #2b3649;
}

.user-entry {
  display: inline-flex;
  align-items: center;
  cursor: pointer;
}

.user-entry-icon {
  margin-left: 6px;
}
</style>
