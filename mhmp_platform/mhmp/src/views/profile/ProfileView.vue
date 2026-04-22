<template>
  <div class="page-shell">
    <section class="page-card page-card--section profile-hero">
      <div class="profile-hero__main">
        <div class="profile-avatar">
          <img v-if="profile.avatarUrl" :src="profile.avatarUrl" alt="头像" class="profile-avatar__image">
          <span v-else>{{ userInitial }}</span>
        </div>

        <div class="profile-hero__info">
          <div class="profile-hero__eyebrow">MHMP Personal Profile</div>
          <h2 class="profile-hero__title">{{ profile.realName || profile.nickName || profile.username || '--' }}</h2>
          <p class="profile-hero__desc">
            当前平台身份：{{ profile.roles?.join(' / ') || '未分配角色' }}。可在此维护个人档案与头像，平台会同步用于业务经办、
            审批留痕、操作日志和页面展示。
          </p>
        </div>
      </div>

      <div class="profile-hero__actions">
        <el-upload :show-file-list="false" accept="image/*" :http-request="handleAvatarUpload">
          <el-button :loading="uploadingAvatar">上传头像</el-button>
        </el-upload>
        <el-button class="profile-hero__action--password" @click="openPasswordDialog">修改密码</el-button>
        <el-button type="primary" @click="openEditDialog">编辑档案</el-button>
      </div>
    </section>

    <section class="page-grid profile-grid">
      <article class="page-card page-card--section profile-panel">
        <div class="profile-panel__title">账号身份信息</div>
        <div class="profile-meta">
          <div class="profile-meta__item">
            <span class="profile-meta__label">平台账号</span>
            <span>{{ profile.username || '--' }}</span>
          </div>
          <div class="profile-meta__item">
            <span class="profile-meta__label">角色身份</span>
            <span>{{ profile.roles?.join(' / ') || '--' }}</span>
          </div>
          <div class="profile-meta__item">
            <span class="profile-meta__label">显示名</span>
            <span>{{ profile.nickName || '--' }}</span>
          </div>
          <div class="profile-meta__item">
            <span class="profile-meta__label">姓名</span>
            <span>{{ profile.realName || '--' }}</span>
          </div>
        </div>
      </article>

      <article class="page-card page-card--section profile-panel">
        <div class="profile-panel__title">联系方式与补充说明</div>
        <div class="profile-meta">
          <div class="profile-meta__item">
            <span class="profile-meta__label">电话</span>
            <span>{{ profile.phone || '--' }}</span>
          </div>
          <div class="profile-meta__item">
            <span class="profile-meta__label">邮箱</span>
            <span>{{ profile.email || '--' }}</span>
          </div>
          <div class="profile-meta__item">
            <span class="profile-meta__label">性别</span>
            <span>{{ genderLabelMap[profile.gender] || '--' }}</span>
          </div>
          <div class="profile-meta__item profile-meta__item--column">
            <span class="profile-meta__label">补充说明</span>
            <span>{{ profile.remark || '暂无补充说明' }}</span>
          </div>
        </div>
      </article>
    </section>

    <el-dialog v-model="dialogVisible" title="编辑个人档案" width="520px">
      <el-form ref="profileFormRef" :model="profileForm" :rules="profileRules" label-width="88px">
        <el-form-item label="账号头像">
          <div class="dialog-avatar">
            <div class="dialog-avatar__preview">
              <img v-if="profileForm.avatarUrl" :src="profileForm.avatarUrl" alt="头像预览" class="dialog-avatar__image">
              <span v-else>{{ userInitial }}</span>
            </div>
            <el-upload :show-file-list="false" accept="image/*" :http-request="handleAvatarUpload">
              <el-button :loading="uploadingAvatar">重新上传</el-button>
            </el-upload>
          </div>
        </el-form-item>
        <el-form-item label="显示名" prop="nickName">
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
        <el-form-item label="备注">
          <el-input v-model="profileForm.remark" type="textarea" :rows="4" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleSaveProfile">保存档案</el-button>
      </template>
    </el-dialog>

    <el-dialog
      v-model="passwordDialogVisible"
      title="修改登录密码"
      width="460px"
      @closed="resetPasswordForm"
    >
      <el-form ref="passwordFormRef" :model="passwordForm" :rules="passwordRules" label-width="96px" status-icon>
        <el-form-item label="旧密码" prop="oldPassword">
          <el-input
            v-model="passwordForm.oldPassword"
            type="password"
            show-password
            autocomplete="current-password"
            placeholder="请输入当前登录密码"
          />
        </el-form-item>
        <el-form-item label="新密码" prop="newPassword">
          <el-input
            v-model="passwordForm.newPassword"
            type="password"
            show-password
            autocomplete="new-password"
            placeholder="请输入新的登录密码"
          />
        </el-form-item>
        <el-form-item label="确认新密码" prop="confirmPassword">
          <el-input
            v-model="passwordForm.confirmPassword"
            type="password"
            show-password
            autocomplete="new-password"
            placeholder="请再次输入新密码"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="passwordDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="passwordSaving" @click="handleSavePassword">确认修改</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { computed, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { useRouter } from 'vue-router'
import { uploadFileApi } from '@/api/file'
import { getProfileApi, updatePasswordApi, updateProfileApi } from '@/api/profile'
import { useAuthStore } from '@/stores/auth'
import { validateElForm } from '@/utils/form'

const authStore = useAuthStore()
const router = useRouter()

const profile = ref({})
const saving = ref(false)
const passwordSaving = ref(false)
const dialogVisible = ref(false)
const passwordDialogVisible = ref(false)
const uploadingAvatar = ref(false)
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

const genderLabelMap = {
  MALE: '男',
  FEMALE: '女',
  UNKNOWN: '未知'
}

const profileRules = {
  nickName: [{ required: true, message: '请输入显示名', trigger: 'blur' }],
  realName: [{ required: true, message: '请输入姓名', trigger: 'blur' }]
}

function validateNewPassword(rule, value, callback) {
  if (!value) {
    callback(new Error('请输入新密码'))
    return
  }
  if (value.length < 6) {
    callback(new Error('新密码不少于 6 位'))
    return
  }
  if (value === passwordForm.oldPassword) {
    callback(new Error('新密码不能与旧密码相同'))
    return
  }
  callback()
}

function validateConfirmPassword(rule, value, callback) {
  if (!value) {
    callback(new Error('请再次输入新密码'))
    return
  }
  if (value !== passwordForm.newPassword) {
    callback(new Error('两次输入的新密码不一致'))
    return
  }
  callback()
}

const passwordRules = {
  oldPassword: [{ required: true, message: '请输入旧密码', trigger: 'blur' }],
  newPassword: [{ validator: validateNewPassword, trigger: ['blur', 'change'] }],
  confirmPassword: [{ validator: validateConfirmPassword, trigger: ['blur', 'change'] }]
}

const userInitial = computed(() => (profile.value.realName || profile.value.nickName || profile.value.username || '馆').slice(0, 1))

function fillProfileForm(data) {
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

function resetPasswordForm() {
  Object.assign(passwordForm, {
    oldPassword: '',
    newPassword: '',
    confirmPassword: ''
  })
  passwordFormRef.value?.clearValidate?.()
}

async function loadProfile() {
  const data = await getProfileApi()
  profile.value = data
  fillProfileForm(data)
}

function openEditDialog() {
  fillProfileForm(profile.value)
  dialogVisible.value = true
}

function openPasswordDialog() {
  resetPasswordForm()
  passwordDialogVisible.value = true
}

async function handleAvatarUpload(option) {
  uploadingAvatar.value = true
  try {
    const result = await uploadFileApi(option.file, 'avatar')
    profileForm.avatarUrl = result.fileUrl
    await updateProfileApi({
      nickName: profileForm.nickName || profile.value.nickName || '',
      realName: profileForm.realName || profile.value.realName || '',
      phone: profileForm.phone || profile.value.phone || '',
      email: profileForm.email || profile.value.email || '',
      gender: profileForm.gender || profile.value.gender || '',
      avatarUrl: result.fileUrl,
      remark: profileForm.remark || profile.value.remark || ''
    })
    await loadProfile()
    await authStore.initializeSession(true)
    ElMessage.success('账号头像已更新')
  } finally {
    uploadingAvatar.value = false
  }
}

async function handleSaveProfile() {
  const valid = await validateElForm(profileFormRef, '请先完善必填信息后再保存')
  if (!valid) {
    return
  }
  saving.value = true
  try {
    await updateProfileApi(profileForm)
    ElMessage.success('个人档案已更新')
    dialogVisible.value = false
    await loadProfile()
    await authStore.initializeSession(true)
  } finally {
    saving.value = false
  }
}

async function handleSavePassword() {
  const valid = await validateElForm(passwordFormRef, '请先正确填写旧密码和新密码')
  if (!valid) {
    return
  }
  passwordSaving.value = true
  try {
    await updatePasswordApi({
      oldPassword: passwordForm.oldPassword,
      newPassword: passwordForm.newPassword
    })
    passwordDialogVisible.value = false
    await authStore.logout(false)
    ElMessage.success('密码已修改，请重新登录')
    router.replace('/login')
  } finally {
    passwordSaving.value = false
  }
}

loadProfile()
</script>

<style scoped>
.profile-hero {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  background:
    linear-gradient(135deg, rgba(123, 44, 42, 0.1), rgba(204, 136, 34, 0.08)),
    #fff;
}

.profile-hero__main {
  display: flex;
  align-items: center;
  gap: 18px;
}

.profile-avatar,
.dialog-avatar__preview {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 92px;
  height: 92px;
  border-radius: 28px;
  background: rgba(123, 44, 42, 0.12);
  color: var(--primary);
  font-size: 32px;
  font-weight: 800;
  overflow: hidden;
}

.profile-avatar__image,
.dialog-avatar__image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.profile-hero__eyebrow {
  display: inline-flex;
  padding: 4px 10px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.7);
  color: var(--primary);
  font-size: 12px;
  font-weight: 700;
}

.profile-hero__title {
  margin: 10px 0 0;
  font-size: 28px;
}

.profile-hero__desc {
  margin: 10px 0 0;
  max-width: 560px;
  color: var(--text-second);
  line-height: 1.8;
}

.profile-hero__actions {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
}

.profile-hero__action--password {
  color: var(--primary);
  border-color: rgba(123, 44, 42, 0.2);
  background: rgba(123, 44, 42, 0.08);
}

.profile-hero__action--password:hover,
.profile-hero__action--password:focus {
  color: #6a2422;
  border-color: rgba(123, 44, 42, 0.34);
  background: rgba(123, 44, 42, 0.14);
}

.profile-grid {
  grid-template-columns: 1fr 1fr;
}

.profile-panel__title {
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

.profile-meta__item--column {
  flex-direction: column;
}

.profile-meta__label {
  color: var(--text-second);
}

.dialog-avatar {
  display: flex;
  align-items: center;
  gap: 16px;
}

@media (max-width: 960px) {
  .profile-hero {
    flex-direction: column;
    align-items: flex-start;
  }

  .profile-grid {
    grid-template-columns: 1fr;
  }

  .profile-hero__main {
    flex-direction: column;
    align-items: flex-start;
  }

  .dialog-avatar {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>
