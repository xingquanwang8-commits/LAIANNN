<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="overview-panel overview-panel--compact">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">MHMP Account Administration</div>
            <h2 class="overview-panel__title">用户管理</h2>
            <p class="overview-panel__desc">
              统一维护平台账号、角色绑定和启停状态，确保业务办理、审批留痕、操作日志和个人档案展示都基于有效账号身份。
            </p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">平台账号 {{ pageData.total }} 个</span>
            <span class="overview-chip overview-chip--accent">当前页 {{ currentPageCount }} 个</span>
          </div>
        </div>

        <div class="metric-grid system-metrics">
          <article class="metric-card">
            <span class="metric-card__label">当前页启用账号</span>
            <strong class="metric-card__value">{{ enabledCount }}</strong>
            <div class="metric-card__meta">可正常登录并参与业务办理的账号</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页停用账号</span>
            <strong class="metric-card__value">{{ disabledCount }}</strong>
            <div class="metric-card__meta">已停止使用或临时冻结的账号</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页角色类型</span>
            <strong class="metric-card__value">{{ roleTypeCount }}</strong>
            <div class="metric-card__meta">按当前页平台账号绑定的角色类型去重统计</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">最近活跃账号</span>
            <strong class="metric-card__value metric-card__value--text">{{ latestLoginUser }}</strong>
            <div class="metric-card__meta">便于快速识别近期登录并参与业务的账号</div>
          </article>
        </div>
      </div>
    </section>

    <section class="page-card page-card--section">
      <PageHeader
        title="账号检索"
        description="按用户名、姓名、电话、状态和角色筛选平台账号，支持直接新增、编辑、启停和删除。"
      >
        <template #extra>
          <div v-if="authStore.hasPermission('sys:user:add')" class="query-toolbar__actions">
            <el-button type="primary" @click="openCreate">新增账号</el-button>
          </div>
        </template>
      </PageHeader>

      <div class="query-toolbar">
        <el-form :inline="true" :model="queryForm" class="query-form query-form--single-line">
          <el-form-item label="关键字" class="query-form__keyword">
            <el-input v-model="queryForm.keyword" placeholder="用户名 / 姓名 / 电话" clearable @keyup.enter="handleSearch" />
          </el-form-item>
          <el-form-item label="状态">
            <el-select v-model="queryForm.status" clearable placeholder="全部状态">
              <el-option label="启用" value="ENABLED" />
              <el-option label="停用" value="DISABLED" />
            </el-select>
          </el-form-item>
          <el-form-item label="角色">
            <el-select v-model="queryForm.roleId" clearable placeholder="全部角色">
              <el-option v-for="role in roleOptions" :key="role.id" :label="role.roleName" :value="role.id" />
            </el-select>
          </el-form-item>
          <el-form-item class="query-form__actions">
            <el-button type="primary" @click="handleSearch">查询</el-button>
            <el-button @click="handleReset">重置</el-button>
          </el-form-item>
        </el-form>
      </div>
    </section>

    <section class="page-card page-card--section">
      <div class="list-section__header">
        <div>
          <div class="list-section__title">平台账号列表</div>
          <div class="list-section__desc">
            当前展示 {{ currentPageCount }} 个平台账号，可直接维护角色绑定、启停状态和基础资料。
          </div>
        </div>
      </div>

      <el-table :data="pageData.records" v-loading="loading">
        <template #empty>
          <el-empty class="empty-block" description="未检索到符合条件的平台账号，请调整筛选条件后重试。" />
        </template>
        <el-table-column prop="username" label="用户名" min-width="120" />
        <el-table-column prop="realName" label="姓名" min-width="120" />
        <el-table-column prop="nickName" label="显示名" min-width="120" />
        <el-table-column prop="phone" label="电话" min-width="130" />
        <el-table-column label="角色" min-width="180">
          <template #default="{ row }">
            {{ row.roleNames?.join(' / ') || '--' }}
          </template>
        </el-table-column>
        <el-table-column label="状态" width="120">
          <template #default="{ row }">
            <StatusTag :status="row.status" :label="row.status === 'ENABLED' ? '启用' : '停用'" />
          </template>
        </el-table-column>
        <el-table-column label="最近登录" min-width="160">
          <template #default="{ row }">{{ formatDateTime(row.lastLoginTime) }}</template>
        </el-table-column>
        <el-table-column label="操作" class-name="table-action-column" fixed="right" width="260">
          <template #default="{ row }">
            <template v-if="authStore.hasPermission('sys:user:edit')">
              <el-button text type="primary" @click="openEdit(row.id)">编辑</el-button>
              <el-button text @click="handleToggleStatus(row)">
                {{ row.status === 'ENABLED' ? '停用' : '启用' }}
              </el-button>
            </template>
            <el-button
              v-if="authStore.hasPermission('sys:user:delete')"
              text
              type="danger"
              @click="handleDelete(row)"
            >
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="table-footer">
        <el-pagination
          :current-page="queryForm.pageNum"
          :page-size="queryForm.pageSize"
          :page-sizes="[10, 20, 30]"
          :total="pageData.total"
          layout="total, sizes, prev, pager, next"
          @current-change="handleCurrentChange"
          @size-change="handleSizeChange"
        />
      </div>
    </section>

    <el-dialog v-model="dialogVisible" :title="editingId ? '编辑账号' : '新增账号'" width="720px">
      <div class="detail-stack">
        <div class="soft-note">
          <div class="soft-note__title">平台账号维护说明</div>
          <div class="soft-note__desc">
            新增账号默认用于平台登录、业务办理和审批留痕；编辑时若密码留空，则不修改原密码。
          </div>
        </div>

        <el-form ref="formRef" :model="formData" :rules="rules" label-width="92px" autocomplete="off">
          <div class="autofill-guard" aria-hidden="true">
            <input type="text" tabindex="-1" autocomplete="username" />
            <input type="password" tabindex="-1" autocomplete="current-password" />
          </div>
          <el-row :gutter="14">
            <el-col :span="12">
              <el-form-item label="用户名" prop="username">
                <el-input
                  v-model="formData.username"
                  :disabled="Boolean(editingId)"
                  name="system-user-username"
                  autocomplete="off"
                  spellcheck="false"
                />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item :label="editingId ? '重置密码' : '初始密码'">
                <el-input
                  v-model="formData.password"
                  type="password"
                  show-password
                  name="system-user-password"
                  autocomplete="new-password"
                  :placeholder="editingId ? '不填则不修改' : '默认 123456'"
                />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="姓名" prop="realName">
                <el-input v-model="formData.realName" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="显示名" prop="nickName">
                <el-input v-model="formData.nickName" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="电话">
                <el-input v-model="formData.phone" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="邮箱">
                <el-input v-model="formData.email" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="性别">
                <el-select v-model="formData.gender" clearable placeholder="请选择">
                  <el-option label="男" value="MALE" />
                  <el-option label="女" value="FEMALE" />
                  <el-option label="未知" value="UNKNOWN" />
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="状态">
                <el-select v-model="formData.status">
                  <el-option label="启用" value="ENABLED" />
                  <el-option label="停用" value="DISABLED" />
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="24">
              <el-form-item label="主角色" prop="roleId">
                <el-select v-model="formData.roleId" clearable placeholder="请选择主角色">
                  <el-option v-for="role in roleOptions" :key="role.id" :label="role.roleName" :value="role.id" />
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="24">
              <el-form-item label="头像地址">
                <el-input v-model="formData.avatarUrl" />
              </el-form-item>
            </el-col>
            <el-col :span="24">
              <el-form-item label="备注">
                <el-input v-model="formData.remark" type="textarea" :rows="3" />
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
      </div>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleSave">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { computed, nextTick, reactive, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  createUserApi,
  deleteUserApi,
  getRoleListApi,
  getUserDetailApi,
  getUserPageApi,
  updateUserApi,
  updateUserStatusApi
} from '@/api/system'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { useAuthStore } from '@/stores/auth'
import { validateElForm } from '@/utils/form'
import { formatDateTime } from '@/utils/format'

const authStore = useAuthStore()

const loading = ref(false)
const saving = ref(false)
const dialogVisible = ref(false)
const editingId = ref(null)
const formRef = ref()
const roleOptions = ref([])
const pageData = ref({
  total: 0,
  pageNum: 1,
  pageSize: 10,
  records: []
})

const queryForm = reactive({
  pageNum: 1,
  pageSize: 10,
  keyword: '',
  status: '',
  roleId: ''
})

const formData = reactive({
  username: '',
  password: '',
  nickName: '',
  realName: '',
  phone: '',
  email: '',
  gender: '',
  avatarUrl: '',
  status: 'ENABLED',
  remark: '',
  roleId: ''
})

const rules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  nickName: [{ required: true, message: '请输入显示名', trigger: 'blur' }],
  realName: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
  roleId: [{ required: true, message: '请选择主角色', trigger: 'change' }]
}

const currentPageCount = computed(() => pageData.value.records.length)
const enabledCount = computed(() => pageData.value.records.filter((item) => item.status === 'ENABLED').length)
const disabledCount = computed(() => pageData.value.records.filter((item) => item.status === 'DISABLED').length)
const roleTypeCount = computed(() => new Set(pageData.value.records.flatMap((item) => item.roleNames || [])).size)
const latestLoginUser = computed(() => {
  const records = [...pageData.value.records].filter((item) => item.lastLoginTime)
  if (!records.length) {
    return '--'
  }
  records.sort((a, b) => new Date(b.lastLoginTime).getTime() - new Date(a.lastLoginTime).getTime())
  return records[0].username || '--'
})

function resetForm() {
  Object.assign(formData, {
    username: '',
    password: '',
    nickName: '',
    realName: '',
    phone: '',
    email: '',
    gender: '',
    avatarUrl: '',
    status: 'ENABLED',
    remark: '',
    roleId: ''
  })
}

async function loadRoles() {
  roleOptions.value = await getRoleListApi()
}

async function loadUsers() {
  loading.value = true
  try {
    pageData.value = await getUserPageApi(queryForm)
  } finally {
    loading.value = false
  }
}

function openCreate() {
  editingId.value = null
  resetForm()
  dialogVisible.value = true
  nextTick(() => formRef.value?.clearValidate())
}

async function openEdit(id) {
  editingId.value = id
  resetForm()
  const detail = await getUserDetailApi(id)
  Object.assign(formData, {
    username: detail.username || '',
    password: '',
    nickName: detail.nickName || '',
    realName: detail.realName || '',
    phone: detail.phone || '',
    email: detail.email || '',
    gender: detail.gender || '',
    avatarUrl: detail.avatarUrl || '',
    status: detail.status || 'ENABLED',
    remark: detail.remark || '',
    roleId: detail.roleIds?.[0] || ''
  })
  dialogVisible.value = true
  nextTick(() => formRef.value?.clearValidate())
}

function buildSavePayload() {
  const { roleId, ...payload } = formData
  return {
    ...payload,
    roleIds: roleId ? [roleId] : []
  }
}

async function handleSave() {
  const valid = await validateElForm(formRef, '璇峰厛瀹屽杽鐢ㄦ埛淇℃伅鍚庡啀淇濆瓨')
  if (!valid) {
    return
  }
  const payload = buildSavePayload()
  saving.value = true
  try {
    if (editingId.value) {
      await updateUserApi(editingId.value, payload)
      ElMessage.success('账号已更新')
    } else {
      await createUserApi(payload)
      ElMessage.success('账号已创建')
    }
    dialogVisible.value = false
    await loadUsers()
  } finally {
    saving.value = false
  }
}

async function handleToggleStatus(row) {
  const nextStatus = row.status === 'ENABLED' ? 'DISABLED' : 'ENABLED'
  await updateUserStatusApi(row.id, { status: nextStatus })
  ElMessage.success('状态已更新')
  await loadUsers()
}

async function handleDelete(row) {
  await ElMessageBox.confirm(`确认删除账号“${row.username}”吗？`, '删除确认', {
    type: 'warning'
  })
  await deleteUserApi(row.id)
  ElMessage.success('账号已删除')
  await loadUsers()
}

function handleSearch() {
  queryForm.pageNum = 1
  loadUsers()
}

function handleReset() {
  Object.assign(queryForm, {
    pageNum: 1,
    pageSize: 10,
    keyword: '',
    status: '',
    roleId: ''
  })
  loadUsers()
}

function handleCurrentChange(pageNum) {
  queryForm.pageNum = pageNum
  loadUsers()
}

function handleSizeChange(pageSize) {
  queryForm.pageSize = pageSize
  queryForm.pageNum = 1
  loadUsers()
}

loadRoles()
loadUsers()
</script>

<style scoped>
.system-metrics {
  grid-template-columns: repeat(4, minmax(0, 1fr));
}

.metric-card__value--text {
  font-size: 20px;
  line-height: 1.35;
}

.list-section__header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 16px;
}

.list-section__title {
  font-size: 17px;
  font-weight: 700;
}

.list-section__desc {
  margin-top: 8px;
  color: var(--text-second);
  font-size: 13px;
  line-height: 1.8;
}

.autofill-guard {
  position: absolute;
  width: 0;
  height: 0;
  overflow: hidden;
  opacity: 0;
  pointer-events: none;
}

.autofill-guard input {
  width: 0;
  height: 0;
  padding: 0;
  border: 0;
}

.table-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}

@media (max-width: 960px) {
  .system-metrics {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 640px) {
  .system-metrics {
    grid-template-columns: 1fr;
  }
}
</style>
