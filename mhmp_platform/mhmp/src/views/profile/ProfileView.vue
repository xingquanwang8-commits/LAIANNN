<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <PageHeader
        title="个人中心"
        description="维护当前登录账号的基本信息，并支持独立修改密码。"
      >
        <template #extra>
          <el-button type="primary" @click="passwordDialogVisible = true">修改密码</el-button>
        </template>
      </PageHeader>
    </section>

    <section class="page-grid profile-grid">
      <article class="page-card page-card--section">
        <div class="profile-card__title">账号概览</div>
        <div class="profile-meta">
          <div class="profile-meta__item">
            <span class="profile-meta__label">用户名</span>
            <span>{{ profile.username || '--' }}</span>
          </div>
          <div class="profile-meta__item">
            <span class="profile-meta__label">角色</span>
            <span>{{ profile.roles?.join(' / ') || '--' }}</span>
          </div>
          <div class="profile-meta__item">
            <span class="profile-meta__label">邮箱</span>
            <span>{{ profile.email || '--' }}</span>
          </div>
          <div class="profile-meta__item">
            <span class="profile-meta__label">电话</span>
            <span>{{ profile.phone || '--' }}</span>
          </div>
        </div>
      </article>

      <article class="page-card page-card--section">
        <div class="profile-card__title">资料编辑</div>
        <el-form ref="profileFormRef" :model="profileForm" :rules="profileRules" label-width="88px">
          <el-form-item label="昵称" prop="nickName">
            <el-input v-model="profileForm.nickName" />
          </el-form-item>
          <el-form-item label="姓名" prop="realName">
            <el-input v-model="profileForm.realName" />
          </el-form-item>
          <el-form-item label="电话">
            <el-input v-model="profileForm.phone" />
          </el-form-item>
          <el-form-item label="邮箱">
            <el-input v-model="profileForm.email" />
          </el-form-item>
          <el-form-item label="性别">
            <el-select v-model="profileForm.gender" clearable placeholder="请选择">
              <el-option label="男" value="MALE" />
              <el-option label="女" value="FEMALE" />
              <el-option label="未知" value="UNKNOWN" />
            </el-select>
          </el-form-item>
          <el-form-item label="头像地址">
            <el-input v-model="profileForm.avatarUrl" placeholder="可填写现有图片 URL" />
          </el-form-item>
          <el-form-item label="备注">
            <el-input v-model="profileForm.remark" type="textarea" :rows="4" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" :loading="saving" @click="handleSaveProfile">保存资料</el-button>
          </el-form-item>
        </el-form>
      </article>
    </section>

    <el-dialog v-model="passwordDialogVisible" title="修改密码" width="420px">
      <el-form ref="passwordFormRef" :model="passwordForm" :rules="passwordRules" label-width="88px">
        <el-form-item label="旧密码" prop="oldPassword">
          <el-input v-model="passwordForm.oldPassword" type="password" show-password />
        </el-form-item>
        <el-form-item label="新密码" prop="newPassword">
          <el-input v-model="passwordForm.newPassword" type="password" show-password />
        </el-form-item>
        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input v-model="passwordForm.confirmPassword" type="password" show-password />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="passwordDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="savingPassword" @click="handleSavePassword">确认修改</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { getProfileApi, updatePasswordApi, updateProfileApi } from '@/api/profile'
import PageHeader from '@/components/common/PageHeader.vue'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()

const profile = ref({})
const saving = ref(false)
const savingPassword = ref(false)
const passwordDialogVisible = ref(false)
const profileFormRef = ref()
const passwordFormRef = ref()

const profileForm = reactive({
  nickName: '',
  realName: '',
  phone: '',
  email: '',
  gender: '',
  avatarUrl: '',
  remark: ''
})

const passwordForm = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
})

const profileRules = {
  nickName: [{ required: true, message: '请输入昵称', trigger: 'blur' }],
  realName: [{ required: true, message: '请输入姓名', trigger: 'blur' }]
}

const passwordRules = {
  oldPassword: [{ required: true, message: '请输入旧密码', trigger: 'blur' }],
  newPassword: [{ required: true, message: '请输入新密码', trigger: 'blur' }],
  confirmPassword: [
    { required: true, message: '请再次输入新密码', trigger: 'blur' },
    {
      validator: (_rule, value, callback) => {
        if (value !== passwordForm.newPassword) {
          callback(new Error('两次输入的新密码不一致'))
          return
        }
        callback()
      },
      trigger: 'blur'
    }
  ]
}

async function loadProfile() {
  const data = await getProfileApi()
  profile.value = data
  Object.assign(profileForm, {
    nickName: data.nickName || '',
    realName: data.realName || '',
    phone: data.phone || '',
    email: data.email || '',
    gender: data.gender || '',
    avatarUrl: data.avatarUrl || '',
    remark: data.remark || ''
  })
}

async function handleSaveProfile() {
  await profileFormRef.value.validate()
  saving.value = true
  try {
    await updateProfileApi(profileForm)
    ElMessage.success('资料已更新')
    await loadProfile()
    await authStore.initializeSession(true)
  } finally {
    saving.value = false
  }
}

async function handleSavePassword() {
  await passwordFormRef.value.validate()
  savingPassword.value = true
  try {
    await updatePasswordApi({
      oldPassword: passwordForm.oldPassword,
      newPassword: passwordForm.newPassword
    })
    ElMessage.success('密码已修改，请重新登录')
    passwordDialogVisible.value = false
    await authStore.logout(false)
    window.location.hash = '/login'
  } finally {
    savingPassword.value = false
  }
}

loadProfile()
</script>

<style scoped>
.profile-grid {
  grid-template-columns: 1fr 1.4fr;
}

.profile-card__title {
  margin-bottom: 16px;
  font-size: 16px;
  font-weight: 700;
}

.profile-meta {
  display: grid;
  gap: 14px;
}

.profile-meta__item {
  display: flex;
  justify-content: space-between;
  gap: 12px;
  padding-bottom: 12px;
  border-bottom: 1px dashed var(--border-line);
}

.profile-meta__label {
  color: var(--text-second);
}

@media (max-width: 960px) {
  .profile-grid {
    grid-template-columns: 1fr;
  }
}
</style>
