<template>
  <div class="login-page">
    <div class="login-panel login-panel--brand">
      <div class="login-brand__masthead">
        <div class="login-brand__logo">
          <img :src="APP_LOGO_PUBLIC_PATH" alt="MHMP Logo" class="login-brand__logo-image">
        </div>
        <div class="login-brand__masthead-content">
          <div class="login-brand__eyebrow">{{ APP_BRAND_LINE }}</div>
          <h1 class="login-brand__title">博物馆文物综合管理平台</h1>
        </div>
      </div>
      <p class="login-brand__desc">
        围绕馆藏建档、出入库流转、盘点核查、修复验收与系统权限配置构建，
        适用于博物馆日常业务登记、流程审批与档案追溯。
      </p>

      <div class="login-feature-list">
        <div class="login-feature-item">
          <span class="status-dot" style="color: #fff7f4">统一档案台账</span>
          <p>围绕文物主档、附件资料与业务时间线形成统一数据视图，便于查询、复核和追溯。</p>
        </div>
        <div class="login-feature-item">
          <span class="status-dot" style="color: #fff7f4">流程闭环管理</span>
          <p>支持入库、出库、馆内转存、盘点、修复与验收等关键环节的连续流转与状态追踪。</p>
        </div>
        <div class="login-feature-item">
          <span class="status-dot" style="color: #fff7f4">角色权限联动</span>
          <p>登录后按当前账号自动加载菜单与操作权限，兼顾管理员、审批人员和业务办理人员。</p>
        </div>
      </div>
    </div>

    <div class="login-panel login-panel--form page-card">
      <div class="login-form__head">
        <div class="login-form__title">账号登录</div>
        <div class="login-form__hint">请输入已分配系统账号，登录后将自动加载当前角色可访问的菜单与业务入口。</div>
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

        <el-button class="login-submit" type="primary" size="large" :loading="submitting" @click="handleLogin">
          登录系统
        </el-button>
      </el-form>

      <el-alert
        class="login-alert"
        title="如果登录后可见菜单较少，说明当前账号权限范围较小，属于系统正常的角色授权结果。"
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
import { APP_BRAND_LINE, APP_LOGO_PUBLIC_PATH } from '@/constants/menu'
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
    radial-gradient(circle at top right, rgba(227, 188, 120, 0.16), transparent 28%),
    radial-gradient(circle at bottom left, rgba(255, 255, 255, 0.08), transparent 24%),
    linear-gradient(160deg, rgba(123, 44, 42, 0.94), rgba(91, 28, 27, 0.98)),
    var(--primary);
  color: #fff7f4;
  box-shadow: 0 24px 48px rgba(73, 24, 23, 0.24);
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
  border: 1px solid rgba(255, 239, 219, 0.24);
  border-radius: 999px;
  background: rgba(255, 247, 244, 0.12);
  color: rgba(255, 247, 244, 0.92);
  font-size: 12px;
  letter-spacing: 0.08em;
}

.login-brand__masthead {
  display: flex;
  align-items: center;
  gap: 20px;
}

.login-brand__logo {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 96px;
  height: 96px;
  padding: 10px;
  border-radius: 28px;
  border: 1px solid rgba(255, 239, 219, 0.18);
  background: linear-gradient(180deg, rgba(255, 247, 244, 0.18), rgba(255, 247, 244, 0.08));
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.18);
}

.login-brand__logo-image {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.login-brand__masthead-content {
  min-width: 0;
}

.login-brand__title {
  max-width: 520px;
  margin: 12px 0 0;
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
  border: 1px solid rgba(255, 255, 255, 0.14);
  border-radius: 14px;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.09), rgba(255, 255, 255, 0.05));
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.08);
  backdrop-filter: blur(10px);
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
  background:
    linear-gradient(180deg, rgba(255, 255, 255, 0.98), rgba(250, 244, 238, 0.96)),
    #fff;
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

  .login-brand__masthead {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>
