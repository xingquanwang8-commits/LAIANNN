<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <PageHeader title="角色管理" description="维护角色信息，并为角色分配可访问的菜单与按钮权限。">
        <template #extra>
          <el-button type="primary" @click="openCreate">新增角色</el-button>
        </template>
      </PageHeader>
    </section>

    <section class="page-card page-card--section">
      <el-form :inline="true" :model="queryForm">
        <el-form-item label="关键词">
          <el-input v-model="queryForm.keyword" placeholder="角色名称 / 编码" clearable @keyup.enter="handleSearch" />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="queryForm.status" clearable placeholder="全部状态">
            <el-option label="启用" value="ENABLED" />
            <el-option label="停用" value="DISABLED" />
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
        <el-table-column prop="roleName" label="角色名称" min-width="150" />
        <el-table-column prop="roleCode" label="角色编码" min-width="150" />
        <el-table-column label="状态" width="120">
          <template #default="{ row }">
            <StatusTag :status="row.status" :label="row.status === 'ENABLED' ? '启用' : '停用'" />
          </template>
        </el-table-column>
        <el-table-column prop="userCount" label="绑定用户数" width="120" />
        <el-table-column prop="menuCount" label="授权菜单数" width="120" />
        <el-table-column prop="remark" label="备注" min-width="180" show-overflow-tooltip />
        <el-table-column label="操作" fixed="right" width="250">
          <template #default="{ row }">
            <el-button text type="primary" @click="openEdit(row.id)">编辑</el-button>
            <el-button text @click="handleToggleStatus(row)">
              {{ row.status === 'ENABLED' ? '停用' : '启用' }}
            </el-button>
            <el-button
              v-if="authStore.hasPermission('sys:role:assign')"
              text
              @click="openGrant(row)"
            >
              授权菜单
            </el-button>
            <el-button text type="danger" @click="handleDelete(row)">删除</el-button>
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

    <el-dialog v-model="dialogVisible" :title="editingId ? '编辑角色' : '新增角色'" width="520px">
      <el-form ref="formRef" :model="formData" :rules="rules" label-width="88px">
        <el-form-item label="角色名称" prop="roleName">
          <el-input v-model="formData.roleName" />
        </el-form-item>
        <el-form-item label="角色编码" prop="roleCode">
          <el-input v-model="formData.roleCode" />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="formData.status">
            <el-option label="启用" value="ENABLED" />
            <el-option label="停用" value="DISABLED" />
          </el-select>
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="formData.remark" type="textarea" :rows="3" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleSave">保存</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="grantDialogVisible" title="菜单授权" width="520px">
      <el-tree
        ref="treeRef"
        :data="menuTree"
        node-key="id"
        show-checkbox
        default-expand-all
        :props="{ label: 'menuName', children: 'children' }"
      />
      <template #footer>
        <el-button @click="grantDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="savingGrant" @click="handleSaveGrant">保存授权</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { nextTick, reactive, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  createRoleApi,
  deleteRoleApi,
  getMenuTreeApi,
  getRoleDetailApi,
  getRolePageApi,
  grantRoleMenusApi,
  updateRoleApi,
  updateRoleStatusApi
} from '@/api/system'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()

const loading = ref(false)
const saving = ref(false)
const savingGrant = ref(false)
const dialogVisible = ref(false)
const grantDialogVisible = ref(false)
const editingId = ref(null)
const grantingId = ref(null)
const formRef = ref()
const treeRef = ref()
const menuTree = ref([])
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
  status: ''
})

const formData = reactive({
  roleName: '',
  roleCode: '',
  status: 'ENABLED',
  remark: ''
})

const rules = {
  roleName: [{ required: true, message: '请输入角色名称', trigger: 'blur' }],
  roleCode: [{ required: true, message: '请输入角色编码', trigger: 'blur' }]
}

function resetForm() {
  Object.assign(formData, {
    roleName: '',
    roleCode: '',
    status: 'ENABLED',
    remark: ''
  })
}

async function loadMenuTree() {
  menuTree.value = await getMenuTreeApi()
}

async function loadRoles() {
  loading.value = true
  try {
    pageData.value = await getRolePageApi(queryForm)
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
  const detail = await getRoleDetailApi(id)
  Object.assign(formData, {
    roleName: detail.roleName || '',
    roleCode: detail.roleCode || '',
    status: detail.status || 'ENABLED',
    remark: detail.remark || ''
  })
  dialogVisible.value = true
  nextTick(() => formRef.value?.clearValidate())
}

async function handleSave() {
  await formRef.value.validate()
  saving.value = true
  try {
    if (editingId.value) {
      await updateRoleApi(editingId.value, formData)
      ElMessage.success('角色已更新')
    } else {
      await createRoleApi(formData)
      ElMessage.success('角色已创建')
    }
    dialogVisible.value = false
    await loadRoles()
  } finally {
    saving.value = false
  }
}

async function handleToggleStatus(row) {
  const nextStatus = row.status === 'ENABLED' ? 'DISABLED' : 'ENABLED'
  await updateRoleStatusApi(row.id, { status: nextStatus })
  ElMessage.success('状态已更新')
  await loadRoles()
}

async function openGrant(row) {
  grantingId.value = row.id
  if (!menuTree.value.length) {
    await loadMenuTree()
  }
  const detail = await getRoleDetailApi(row.id)
  grantDialogVisible.value = true
  await nextTick()
  treeRef.value?.setCheckedKeys(detail.menuIds || [])
}

async function handleSaveGrant() {
  savingGrant.value = true
  try {
    const menuIds = treeRef.value?.getCheckedKeys(false) || []
    await grantRoleMenusApi(grantingId.value, { menuIds })
    ElMessage.success('菜单授权已保存')
    grantDialogVisible.value = false
    await loadRoles()
  } finally {
    savingGrant.value = false
  }
}

async function handleDelete(row) {
  await ElMessageBox.confirm(`确认删除角色“${row.roleName}”吗？`, '删除确认', {
    type: 'warning'
  })
  await deleteRoleApi(row.id)
  ElMessage.success('角色已删除')
  await loadRoles()
}

function handleSearch() {
  queryForm.pageNum = 1
  loadRoles()
}

function handleReset() {
  Object.assign(queryForm, {
    pageNum: 1,
    pageSize: 10,
    keyword: '',
    status: ''
  })
  loadRoles()
}

function handleCurrentChange(pageNum) {
  queryForm.pageNum = pageNum
  loadRoles()
}

function handleSizeChange(pageSize) {
  queryForm.pageSize = pageSize
  queryForm.pageNum = 1
  loadRoles()
}

loadRoles()
loadMenuTree()
</script>

<style scoped>
.table-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}
</style>
