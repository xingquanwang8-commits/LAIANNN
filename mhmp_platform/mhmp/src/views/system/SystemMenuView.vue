<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <PageHeader title="菜单管理" description="维护平台菜单树、路由路径、权限标识和显示状态。">
        <template #extra>
          <el-button v-if="authStore.hasPermission('sys:menu:add')" type="primary" @click="openCreate()">
            新增菜单
          </el-button>
        </template>
      </PageHeader>
    </section>

    <section class="page-card page-card--section">
      <el-table
        :data="menuTree"
        row-key="id"
        v-loading="loading"
        default-expand-all
        :tree-props="{ children: 'children' }"
      >
        <el-table-column prop="menuName" label="菜单名称" min-width="180" />
        <el-table-column prop="menuCode" label="菜单编码" min-width="150" />
        <el-table-column prop="menuType" label="类型" width="110" />
        <el-table-column prop="path" label="路由路径" min-width="180" show-overflow-tooltip />
        <el-table-column prop="permissionCode" label="权限标识" min-width="160" show-overflow-tooltip />
        <el-table-column label="显示" width="90">
          <template #default="{ row }">{{ row.visible === 1 ? '是' : '否' }}</template>
        </el-table-column>
        <el-table-column label="状态" width="120">
          <template #default="{ row }">
            <StatusTag :status="row.status" :label="row.status === 'ENABLED' ? '启用' : '停用'" />
          </template>
        </el-table-column>
        <el-table-column label="操作" fixed="right" width="220">
          <template #default="{ row }">
            <el-button text type="primary" @click="openCreate(row)">新增子菜单</el-button>
            <el-button text @click="openEdit(row.id)">编辑</el-button>
            <el-button text type="danger" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </section>

    <el-dialog v-model="dialogVisible" :title="editingId ? '编辑菜单' : '新增菜单'" width="680px">
      <el-form ref="formRef" :model="formData" :rules="rules" label-width="96px">
        <el-row :gutter="14">
          <el-col :span="12">
            <el-form-item label="上级菜单">
              <el-cascader
                v-model="parentPath"
                :options="menuOptions"
                :props="{ checkStrictly: true, value: 'value', label: 'label', children: 'children' }"
                clearable
                placeholder="顶级菜单"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="菜单类型" prop="menuType">
              <el-select v-model="formData.menuType">
                <el-option label="目录" value="DIR" />
                <el-option label="菜单" value="MENU" />
                <el-option label="按钮" value="BUTTON" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="菜单名称" prop="menuName">
              <el-input v-model="formData.menuName" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="菜单编码" prop="menuCode">
              <el-input v-model="formData.menuCode" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="路由路径">
              <el-input v-model="formData.path" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="组件路径">
              <el-input v-model="formData.component" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="权限标识">
              <el-input v-model="formData.permissionCode" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="排序" prop="sortNo">
              <el-input-number v-model="formData.sortNo" :min="0" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="图标">
              <el-select v-model="formData.icon" clearable filterable>
                <el-option v-for="icon in ICON_OPTIONS" :key="icon" :label="icon" :value="icon" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="显示">
              <el-select v-model="formData.visible">
                <el-option label="显示" :value="1" />
                <el-option label="隐藏" :value="0" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="缓存">
              <el-select v-model="formData.keepAlive">
                <el-option label="缓存" :value="1" />
                <el-option label="不缓存" :value="0" />
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
import { computed, nextTick, reactive, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { ICON_OPTIONS } from '@/constants/icons'
import { createMenuApi, deleteMenuApi, getMenuDetailApi, getMenuTreeApi, updateMenuApi } from '@/api/system'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { useAuthStore } from '@/stores/auth'
import { buildTreeSelectOptions } from '@/utils/format'

const authStore = useAuthStore()
const loading = ref(false)
const saving = ref(false)
const dialogVisible = ref(false)
const editingId = ref(null)
const formRef = ref()
const menuTree = ref([])
const parentPath = ref([])

const formData = reactive({
  parentId: 0,
  menuName: '',
  menuCode: '',
  menuType: 'MENU',
  path: '',
  component: '',
  permissionCode: '',
  sortNo: 0,
  visible: 1,
  status: 'ENABLED',
  icon: '',
  keepAlive: 1,
  remark: ''
})

const rules = {
  menuName: [{ required: true, message: '请输入菜单名称', trigger: 'blur' }],
  menuCode: [{ required: true, message: '请输入菜单编码', trigger: 'blur' }],
  menuType: [{ required: true, message: '请选择菜单类型', trigger: 'change' }],
  sortNo: [{ required: true, message: '请输入排序', trigger: 'blur' }]
}

const menuOptions = computed(() => buildTreeSelectOptions(menuTree.value))

function resetForm() {
  Object.assign(formData, {
    parentId: 0,
    menuName: '',
    menuCode: '',
    menuType: 'MENU',
    path: '',
    component: '',
    permissionCode: '',
    sortNo: 0,
    visible: 1,
    status: 'ENABLED',
    icon: '',
    keepAlive: 1,
    remark: ''
  })
  parentPath.value = []
}

async function loadMenus() {
  loading.value = true
  try {
    menuTree.value = await getMenuTreeApi()
  } finally {
    loading.value = false
  }
}

function openCreate(parentRow = null) {
  editingId.value = null
  resetForm()
  if (parentRow) {
    formData.parentId = parentRow.id
    parentPath.value = [parentRow.id]
  }
  dialogVisible.value = true
  nextTick(() => formRef.value?.clearValidate())
}

async function openEdit(id) {
  editingId.value = id
  resetForm()
  const detail = await getMenuDetailApi(id)
  Object.assign(formData, {
    parentId: detail.parentId ?? 0,
    menuName: detail.menuName || '',
    menuCode: detail.menuCode || '',
    menuType: detail.menuType || 'MENU',
    path: detail.path || '',
    component: detail.component || '',
    permissionCode: detail.permissionCode || '',
    sortNo: detail.sortNo ?? 0,
    visible: detail.visible ?? 1,
    status: detail.status || 'ENABLED',
    icon: detail.icon || '',
    keepAlive: detail.keepAlive ?? 1,
    remark: detail.remark || ''
  })
  parentPath.value = detail.parentId ? [detail.parentId] : []
  dialogVisible.value = true
  nextTick(() => formRef.value?.clearValidate())
}

async function handleSave() {
  await formRef.value.validate()
  saving.value = true
  try {
    const payload = {
      ...formData,
      parentId: parentPath.value?.length ? parentPath.value[parentPath.value.length - 1] : 0
    }
    if (editingId.value) {
      await updateMenuApi(editingId.value, payload)
      ElMessage.success('菜单已更新')
    } else {
      await createMenuApi(payload)
      ElMessage.success('菜单已创建')
    }
    dialogVisible.value = false
    await loadMenus()
  } finally {
    saving.value = false
  }
}

async function handleDelete(row) {
  await ElMessageBox.confirm(`确认删除菜单“${row.menuName}”吗？`, '删除确认', {
    type: 'warning'
  })
  await deleteMenuApi(row.id)
  ElMessage.success('菜单已删除')
  await loadMenus()
}

loadMenus()
</script>
