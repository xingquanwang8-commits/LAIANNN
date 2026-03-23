<template>
  <div class="login-page">
    <div class="login-panel login-panel--brand">
      <div class="login-brand__eyebrow">Museum Heritage Platform</div>
      <h1 class="login-brand__title">博物馆文物综合管理平台</h1>
      <p class="login-brand__desc">
        面向馆藏信息、文物出入库与修复流程的数字化后台。界面保持庄重克制，流程清晰高效，适合毕业设计演示与真实联调。
      </p>

      <div class="login-feature-list">
        <div class="login-feature-item">
          <span class="status-dot" style="color: var(--primary)">真实接口联调</span>
          <p>已接认证、字典、文物管理与出库审批接口。</p>
        </div>
        <div class="login-feature-item">
          <span class="status-dot" style="color: var(--success)">简洁后台体验</span>
          <p>以清晰表单、稳重色彩和少噪音布局提升日常使用效率。</p>
        </div>
        <div class="login-feature-item">
          <span class="status-dot" style="color: var(--warning)">毕业设计导向</span>
          <p>优先保证可运行、可演示、可答辩，不做无必要的复杂设计。</p>
        </div>
      </div>
    </div>

    <div class="login-panel login-panel--form page-card">
      <div class="login-form__head">
        <div class="login-form__title">账号登录</div>
        <div class="login-form__hint">请使用已导入数据库中的账号密码进行登录</div>
      </div>

      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-position="top"
        size="large"
        @keyup.enter="handleLogin"
      >
        <el-form-item label="用户名" prop="username">
          <el-input v-model="form.username" placeholder="请输入用户名" clearable />
        </el-form-item>

        <el-form-item label="密码" prop="password">
          <el-input
            v-model="form.password"
            type="password"
            placeholder="请输入密码"
            show-password
            clearable
          />
        </el-form-item>

        <el-button
          class="login-submit"
          type="primary"
          size="large"
          :loading="submitting"
          @click="handleLogin"
        >
          登录系统
        </el-button>
      </el-form>

      <el-alert
        class="login-alert"
        title="如果登录后菜单较少，说明当前账号权限较低，这是正常的角色权限控制效果。"
        type="info"
        :closable="false"
      />
    </div>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useAuthStore } from '@/stores/auth'
import { getFirstAccessiblePath } from '@/utils/menu'

const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()

const formRef = ref(null)
const submitting = ref(false)
const form = reactive({
  username: '',
  password: ''
})

const rules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
}

async function handleLogin() {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) {
    return
  }
  submitting.value = true
  try {
    await authStore.login(form)
    ElMessage.success('登录成功')
    const targetPath = route.query.redirect || getFirstAccessiblePath(authStore.menus)
    router.replace(targetPath)
  } finally {
    submitting.value = false
  }
}
</script>

<style scoped>
.login-page {
  display: grid;
  grid-template-columns: minmax(360px, 1.2fr) minmax(360px, 420px);
  gap: 28px;
  align-items: stretch;
  min-height: 100vh;
  padding: 28px;
}

.login-panel {
  min-height: calc(100vh - 56px);
  border-radius: 20px;
}

.login-panel--brand {
  position: relative;
  overflow: hidden;
  padding: 42px;
  background:
    linear-gradient(160deg, rgba(123, 44, 42, 0.92), rgba(91, 28, 27, 0.96)),
    var(--primary);
  color: #fff7f4;
}

.login-panel--brand::before,
.login-panel--brand::after {
  content: '';
  position: absolute;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.08);
}

.login-panel--brand::before {
  top: -120px;
  right: -60px;
  width: 280px;
  height: 280px;
}

.login-panel--brand::after {
  bottom: -100px;
  left: -80px;
  width: 240px;
  height: 240px;
}

.login-brand__eyebrow {
  display: inline-flex;
  padding: 6px 12px;
  margin-bottom: 20px;
  border: 1px solid rgba(255, 255, 255, 0.18);
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.08);
  font-size: 12px;
  letter-spacing: 0.08em;
}

.login-brand__title {
  max-width: 520px;
  margin: 0;
  font-size: 42px;
  line-height: 1.15;
}

.login-brand__desc {
  max-width: 520px;
  margin: 18px 0 0;
  line-height: 1.85;
  color: rgba(255, 247, 244, 0.86);
}

.login-feature-list {
  display: grid;
  gap: 16px;
  margin-top: 42px;
}

.login-feature-item {
  padding: 18px 20px;
  border: 1px solid rgba(255, 255, 255, 0.12);
  border-radius: 14px;
  background: rgba(255, 255, 255, 0.06);
  backdrop-filter: blur(6px);
}

.login-feature-item p {
  margin: 10px 0 0;
  color: rgba(255, 247, 244, 0.82);
  line-height: 1.8;
}

.login-panel--form {
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 36px 32px;
}

.login-form__head {
  margin-bottom: 28px;
}

.login-form__title {
  font-size: 30px;
  font-weight: 700;
}

.login-form__hint {
  margin-top: 8px;
  color: var(--text-second);
  line-height: 1.7;
}

.login-submit {
  width: 100%;
  margin-top: 10px;
}

.login-alert {
  margin-top: 20px;
}

@media (max-width: 1080px) {
  .login-page {
    grid-template-columns: 1fr;
  }

  .login-panel {
    min-height: auto;
  }
}
</style>
