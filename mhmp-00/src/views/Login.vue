<template>
  <div class="login-page">
    <el-card class="login-card" shadow="never">
      <div class="login-header">
        <h1>博物馆文物综合管理平台</h1>
      </div>

      <el-form
        ref="loginFormRef"
        :model="loginForm"
        :rules="loginRules"
        label-position="top"
        size="large"
      >
        <el-form-item prop="username">
          <el-input
            v-model="loginForm.username"
            :prefix-icon="User"
            placeholder="请输入用户名"
          />
        </el-form-item>

        <el-form-item prop="password">
          <el-input
            v-model="loginForm.password"
            :prefix-icon="Lock"
            type="password"
            show-password
            placeholder="请输入密码"
          />
        </el-form-item>

        <el-form-item class="submit-item">
          <el-button
            type="primary"
            class="login-button"
            :loading="loading"
            @click="handleLogin"
          >
            登录
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'LoginView',
}
</script>

<script setup>
import { Lock, User } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const loginFormRef = ref(null)
const loading = ref(false)

const loginForm = reactive({
  username: '',
  password: '',
})

const loginRules = reactive({
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度不能少于 6 位', trigger: 'blur' },
  ],
})

const handleLogin = async () => {
  if (!loginFormRef.value || loading.value) {
    return
  }

  const isValid = await loginFormRef.value.validate().catch(() => false)

  if (!isValid) {
    return
  }

  loading.value = true

  setTimeout(() => {
    loading.value = false
    ElMessage.success('登录成功')
    router.push('/layout')
  }, 1000)
}
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
  background:
    radial-gradient(circle at top, rgba(255, 255, 255, 0.32), transparent 35%),
    linear-gradient(135deg, #e7edf8 0%, #cfdcf3 45%, #b9cdeb 100%);
}

.login-card {
  width: min(420px, 100%);
  border: 0;
  border-radius: 18px;
  box-shadow: 0 20px 50px rgba(58, 92, 141, 0.18);
}

.login-card :deep(.el-card__body) {
  padding: 32px 28px 28px;
}

.login-header {
  margin-bottom: 28px;
  text-align: center;
}

.login-header h1 {
  margin: 0;
  color: #1f2a44;
  font-size: 28px;
  font-weight: 700;
  line-height: 1.35;
}

.submit-item {
  margin-bottom: 0;
}

.login-button {
  width: 100%;
  height: 44px;
  font-size: 16px;
  letter-spacing: 1px;
}
</style>
