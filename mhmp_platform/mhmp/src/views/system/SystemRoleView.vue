<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="overview-panel overview-panel--compact">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">MHMP Role Administration</div>
            <h2 class="overview-panel__title">角色管理</h2>
            <p class="overview-panel__desc">
              统一维护系统角色、账号规模和菜单授权范围，确保权限分层清晰，适配馆内业务办理、审批和管理入口。
            </p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">角色总数 {{ pageData.total }} 个</span>
            <span class="overview-chip overview-chip--accent">当前页 {{ currentPageCount }} 个</span>
          </div>
        </div>

        <div class="metric-grid role-metrics">
          <article class="metric-card">
            <span class="metric-card__label">当前页启用角色</span>
            <strong class="metric-card__value">{{ enabledCount }}</strong>
            <div class="metric-card__meta">当前可被账号绑定并参与授权的角色</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">当前页停用角色</span>
            <strong class="metric-card__value">{{ disabledCount }}</strong>
            <div class="metric-card__meta">已停用或暂不使用的角色配置</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">绑定用户总数</span>
            <strong class="metric-card__value">{{ totalUserCount }}</strong>
            <div class="metric-card__meta">按当前页角色汇总统计的用户数量</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">授权菜单总数</span>
            <strong class="metric-card__value">{{ totalMenuCount }}</strong>
            <div class="metric-card__meta">按当前页角色汇总统计的授权菜单数量</div>
          </article>
        </div>
      </div>
    </section>

    <section class="page-card page-card--section">
      <PageHeader
        title="角色检索"
        description="按角色名称、编码和状态筛选角色，支持直接维护角色资料、启停状态和菜单授权。"
      >
        <template #extra>
          <div v-if="authStore.hasPermission('sys:role:add')" class="query-toolbar__actions">
            <el-button type="primary" @click="openCreate">新增角色</el-button>
          </div>
        </template>
      </PageHeader>

      <div class="query-toolbar">
        <el-form :inline="true" :model="queryForm" class="query-form query-form--single-line">
          <el-form-item label="关键字" class="query-form__keyword">
            <el-input v-model="queryForm.keyword" placeholder="角色名称 / 编码" clearable @keyup.enter="handleSearch" />
          </el-form-item>
          <el-form-item label="状态">
            <el-select v-model="queryForm.status" clearable placeholder="全部状态">
              <el-option label="启用" value="ENABLED" />
              <el-option label="停用" value="DISABLED" />
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
          <div class="list-section__title">角色列表</div>
          <div class="list-section__desc">
            当前展示 {{ currentPageCount }} 个系统角色，可直接维护角色资料、启停状态和菜单授权。
          </div>
        </div>
      </div>

      <el-table :data="pageData.records" v-loading="loading">
        <template #empty>
          <el-empty class="empty-block" description="未检索到符合条件的系统角色，请调整筛选条件后重试。" />
        </template>
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
        <el-table-column label="操作" class-name="table-action-column" fixed="right" width="320">
          <template #default="{ row }">
            <el-button
              v-if="authStore.hasPermission('sys:role:edit')"
              text
              type="primary"
              @click="openEdit(row.id)"
            >
              编辑
            </el-button>
            <el-button
              v-if="authStore.hasPermission('sys:role:status')"
              text
              @click="handleToggleStatus(row)"
            >
              {{ row.status === 'ENABLED' ? '停用' : '启用' }}
            </el-button>
            <el-button
              v-if="authStore.hasPermission('sys:role:assign')"
              text
              @click="openGrant(row)"
            >
              授权菜单
            </el-button>
            <el-button
              v-if="authStore.hasPermission('sys:role:delete')"
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

    <el-dialog v-model="dialogVisible" :title="editingId ? '编辑角色' : '新增角色'" width="560px">
      <div class="detail-stack">
        <div class="soft-note">
          <div class="soft-note__title">角色维护说明</div>
          <div class="soft-note__desc">
            角色编码建议保持稳定，便于后端授权标识和菜单配置长期一致；菜单授权可在保存角色后单独维护。
          </div>
        </div>

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
      </div>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleSave">保存</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="grantDialogVisible" title="菜单授权" width="560px">
      <div class="detail-stack">
        <div class="soft-note soft-note--accent">
          <div class="soft-note__title">授权说明</div>
          <div class="soft-note__desc">
            勾选后的菜单和按钮将同步成为当前角色可访问的系统入口与操作权限。
          </div>
        </div>

        <el-tree
          ref="treeRef"
          :data="menuTree"
          node-key="id"
          show-checkbox
          default-expand-all
          :props="{ label: 'menuName', children: 'children' }"
        />
      </div>
      <template #footer>
        <el-button @click="grantDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="savingGrant" @click="handleSaveGrant">保存授权</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { computed, nextTick, reactive, ref } from 'vue'
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

const currentPageCount = computed(() => pageData.value.records.length)
const enabledCount = computed(() => pageData.value.records.filter((item) => item.status === 'ENABLED').length)
const disabledCount = computed(() => pageData.value.records.filter((item) => item.status === 'DISABLED').length)
const totalUserCount = computed(() => pageData.value.records.reduce((sum, item) => sum + Number(item.userCount || 0), 0))
const totalMenuCount = computed(() => pageData.value.records.reduce((sum, item) => sum + Number(item.menuCount || 0), 0))

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
  if (!authStore.hasPermission('sys:role:add')) {
    ElMessage.warning('当前账号没有新增角色的权限')
    return
  }
  editingId.value = null
  resetForm()
  dialogVisible.value = true
  nextTick(() => formRef.value?.clearValidate())
}

async function openEdit(id) {
  if (!authStore.hasPermission('sys:role:edit')) {
    ElMessage.warning('当前账号没有编辑角色的权限')
    return
  }
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
  if (editingId.value && !authStore.hasPermission('sys:role:edit')) {
    ElMessage.warning('当前账号没有编辑角色的权限')
    return
  }
  if (!editingId.value && !authStore.hasPermission('sys:role:add')) {
    ElMessage.warning('当前账号没有新增角色的权限')
    return
  }
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
  if (!authStore.hasPermission('sys:role:status')) {
    ElMessage.warning('当前账号没有修改角色状态的权限')
    return
  }
  const nextStatus = row.status === 'ENABLED' ? 'DISABLED' : 'ENABLED'
  await updateRoleStatusApi(row.id, { status: nextStatus })
  ElMessage.success('状态已更新')
  await loadRoles()
}

async function openGrant(row) {
  if (!authStore.hasPermission('sys:role:assign')) {
    ElMessage.warning('当前账号没有角色授权的权限')
    return
  }
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
  if (!authStore.hasPermission('sys:role:delete')) {
    ElMessage.warning('当前账号没有删除角色的权限')
    return
  }
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
.role-metrics {
  grid-template-columns: repeat(4, minmax(0, 1fr));
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

.table-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}

@media (max-width: 960px) {
  .role-metrics {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 640px) {
  .role-metrics {
    grid-template-columns: 1fr;
  }
}
</style>
