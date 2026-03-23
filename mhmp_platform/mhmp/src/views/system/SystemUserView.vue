<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <PageHeader title="用户管理" description="支持用户分页、状态维护、角色分配与基本资料编辑。">
        <template #extra>
          <el-button v-if="authStore.hasPermission('sys:user:add')" type="primary" @click="openCreate">
            新增用户
          </el-button>
        </template>
      </PageHeader>
    </section>

    <section class="page-card page-card--section">
      <el-form :inline="true" :model="queryForm">
        <el-form-item label="关键词">
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
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </section>

    <section class="page-card page-card--section">
      <el-table :data="pageData.records" v-loading="loading">
        <el-table-column prop="username" label="用户名" min-width="120" />
        <el-table-column prop="realName" label="姓名" min-width="120" />
        <el-table-column prop="nickName" label="昵称" min-width="120" />
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
        <el-table-column label="操作" fixed="right" width="230">
          <template #default="{ row }">
            <el-button text type="primary" @click="openEdit(row.id)">编辑</el-button>
            <el-button text @click="handleToggleStatus(row)">
              {{ row.status === 'ENABLED' ? '停用' : '启用' }}
            </el-button>
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

    <el-dialog v-model="dialogVisible" :title="editingId ? '编辑用户' : '新增用户'" width="680px">
      <el-form ref="formRef" :model="formData" :rules="rules" label-width="92px">
        <el-row :gutter="14">
          <el-col :span="12">
            <el-form-item label="用户名" prop="username">
              <el-input v-model="formData.username" :disabled="Boolean(editingId)" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item :label="editingId ? '重置密码' : '初始密码'">
              <el-input v-model="formData.password" type="password" show-password :placeholder="editingId ? '不填则不修改' : '默认 123456'" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="姓名" prop="realName">
              <el-input v-model="formData.realName" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="昵称" prop="nickName">
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
            <el-form-item label="角色">
              <el-select v-model="formData.roleIds" multiple clearable placeholder="请选择角色">
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
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleSave">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { nextTick, reactive, ref } from 'vue'
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
  roleIds: []
})

const rules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  nickName: [{ required: true, message: '请输入昵称', trigger: 'blur' }],
  realName: [{ required: true, message: '请输入姓名', trigger: 'blur' }]
}

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
    roleIds: []
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
    roleIds: detail.roleIds || []
  })
  dialogVisible.value = true
  nextTick(() => formRef.value?.clearValidate())
}

async function handleSave() {
  await formRef.value.validate()
  saving.value = true
  try {
    if (editingId.value) {
      await updateUserApi(editingId.value, formData)
      ElMessage.success('用户已更新')
    } else {
      await createUserApi(formData)
      ElMessage.success('用户已创建')
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
  await ElMessageBox.confirm(`确认删除用户“${row.username}”吗？`, '删除确认', {
    type: 'warning'
  })
  await deleteUserApi(row.id)
  ElMessage.success('用户已删除')
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
.table-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}
</style>
