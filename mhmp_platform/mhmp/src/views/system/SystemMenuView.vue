<template>
  <div class="page-shell">
    <section class="page-card page-card--section">
      <div class="overview-panel overview-panel--compact">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">MHMP Navigation & Permission</div>
            <h2 class="overview-panel__title">菜单管理</h2>
            <p class="overview-panel__desc">
              统一维护目录、页面菜单和按钮权限项三类结构节点，控制前端导航层级、业务入口和动作级权限标识。
            </p>
          </div>
          <div class="overview-panel__meta">
            <span class="overview-chip">结构节点 {{ totalMenuCount }} 个</span>
            <span class="overview-chip overview-chip--accent">导航结构实时同步</span>
          </div>
        </div>

        <div class="metric-grid menu-metrics">
          <article class="metric-card">
            <span class="metric-card__label">目录节点</span>
            <strong class="metric-card__value">{{ dirCount }}</strong>
            <div class="metric-card__meta">用于组织系统模块和导航层级</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">页面菜单</span>
            <strong class="metric-card__value">{{ menuCount }}</strong>
            <div class="metric-card__meta">对应可访问的具体业务页面</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">按钮权限项</span>
            <strong class="metric-card__value">{{ buttonCount }}</strong>
            <div class="metric-card__meta">对应页面上的动作级权限控制</div>
          </article>
          <article class="metric-card">
            <span class="metric-card__label">启用节点</span>
            <strong class="metric-card__value">{{ enabledCount }}</strong>
            <div class="metric-card__meta">当前状态为启用的菜单结构节点</div>
          </article>
        </div>
      </div>
    </section>

    <section class="page-card page-card--section">
      <PageHeader
        title="导航与权限结构"
        description="通过树形结构维护导航目录、业务页面和按钮权限项，可新增父子节点并编辑权限标识。"
      >
        <template #extra>
          <div v-if="authStore.hasPermission('sys:menu:add')" class="query-toolbar__actions">
            <el-button type="primary" @click="openCreate()">新增节点</el-button>
          </div>
        </template>
      </PageHeader>

      <el-table
        :data="menuTree"
        row-key="id"
        v-loading="loading"
        default-expand-all
        :tree-props="{ children: 'children' }"
      >
        <template #empty>
          <el-empty class="empty-block" description="当前暂无导航结构，请先新增节点。" />
        </template>
        <el-table-column prop="menuName" label="节点名称" min-width="180" />
        <el-table-column prop="menuCode" label="节点编码" min-width="150" />
        <el-table-column label="节点类型" width="110">
          <template #default="{ row }">{{ resolveMenuTypeLabel(row.menuType) }}</template>
        </el-table-column>
        <el-table-column prop="path" label="访问路径" min-width="180" show-overflow-tooltip />
        <el-table-column prop="permissionCode" label="权限标识" min-width="160" show-overflow-tooltip />
        <el-table-column label="导航显示" width="90">
          <template #default="{ row }">{{ row.visible === 1 ? '是' : '否' }}</template>
        </el-table-column>
        <el-table-column label="状态" width="120">
          <template #default="{ row }">
            <StatusTag :status="row.status" :label="row.status === 'ENABLED' ? '启用' : '停用'" />
          </template>
        </el-table-column>
        <el-table-column label="操作" class-name="table-action-column" fixed="right" width="220">
          <template #default="{ row }">
            <template v-if="authStore.hasPermission('sys:menu:add')">
              <el-button text type="primary" @click="openCreate(row)">新增子节点</el-button>
            </template>
            <template v-if="authStore.hasPermission('sys:menu:edit')">
              <el-button text @click="openEdit(row.id)">编辑</el-button>
            </template>
            <template v-if="authStore.hasPermission('sys:menu:delete')">
              <el-button text type="danger" @click="handleDelete(row)">删除</el-button>
            </template>
          </template>
        </el-table-column>
      </el-table>
    </section>

    <el-dialog v-model="dialogVisible" :title="editingId ? '编辑节点' : '新增节点'" width="720px">
      <div class="detail-stack">
        <div class="soft-note soft-note--accent">
          <div class="soft-note__title">结构类型说明</div>
          <div class="soft-note__desc">
            目录用于组织导航层级，菜单用于承载业务页面，按钮用于声明页面内的动作级权限项。
          </div>
        </div>

        <el-form ref="formRef" :model="formData" :rules="rules" label-width="96px">
          <el-row :gutter="14">
            <el-col :span="12">
              <el-form-item label="上级节点">
                <el-cascader
                  v-model="parentPath"
                  :options="menuOptions"
                  :props="{ checkStrictly: true, value: 'value', label: 'label', children: 'children' }"
                  clearable
                  placeholder="顶级节点"
                />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="节点类型" prop="menuType">
                <el-select v-model="formData.menuType">
                  <el-option label="目录" value="DIR" />
                  <el-option label="菜单" value="MENU" />
                  <el-option label="按钮" value="BUTTON" />
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="节点名称" prop="menuName">
                <el-input v-model="formData.menuName" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="节点编码" prop="menuCode">
                <el-input v-model="formData.menuCode" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="访问路径">
                <el-input v-model="formData.path" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="前端组件">
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
              <el-form-item label="导航显示">
                <el-select v-model="formData.visible">
                  <el-option label="显示" :value="1" />
                  <el-option label="隐藏" :value="0" />
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="页面缓存">
                <el-select v-model="formData.keepAlive">
                  <el-option label="启用缓存" :value="1" />
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
import { ICON_OPTIONS } from '@/constants/icons'
import { createMenuApi, deleteMenuApi, getMenuDetailApi, getMenuTreeApi, updateMenuApi } from '@/api/system'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { useAuthStore } from '@/stores/auth'
import { validateElForm } from '@/utils/form'
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
  menuName: [{ required: true, message: '请输入节点名称', trigger: 'blur' }],
  menuCode: [{ required: true, message: '请输入节点编码', trigger: 'blur' }],
  menuType: [{ required: true, message: '请选择节点类型', trigger: 'change' }],
  sortNo: [{ required: true, message: '请输入排序', trigger: 'blur' }]
}

const menuOptions = computed(() => buildTreeSelectOptions(menuTree.value))
const flatMenus = computed(() => flattenMenus(menuTree.value))
const totalMenuCount = computed(() => flatMenus.value.length)
const dirCount = computed(() => flatMenus.value.filter((item) => item.menuType === 'DIR').length)
const menuCount = computed(() => flatMenus.value.filter((item) => item.menuType === 'MENU').length)
const buttonCount = computed(() => flatMenus.value.filter((item) => item.menuType === 'BUTTON').length)
const enabledCount = computed(() => flatMenus.value.filter((item) => item.status === 'ENABLED').length)

function resolveMenuTypeLabel(menuType) {
  if (menuType === 'DIR') {
    return '目录'
  }
  if (menuType === 'MENU') {
    return '菜单'
  }
  if (menuType === 'BUTTON') {
    return '按钮'
  }
  return menuType || '--'
}

function flattenMenus(nodes = []) {
  return nodes.flatMap((item) => [item, ...flattenMenus(item.children || [])])
}

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
  if (!authStore.hasPermission('sys:menu:add')) {
    ElMessage.warning('当前账号没有新增结构节点的权限')
    return
  }
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
  if (!authStore.hasPermission('sys:menu:edit')) {
    ElMessage.warning('当前账号没有编辑结构节点的权限')
    return
  }
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
  if (editingId.value && !authStore.hasPermission('sys:menu:edit')) {
    ElMessage.warning('当前账号没有编辑结构节点的权限')
    return
  }
  if (!editingId.value && !authStore.hasPermission('sys:menu:add')) {
    ElMessage.warning('当前账号没有新增结构节点的权限')
    return
  }
  const valid = await validateElForm(formRef, '璇峰厛瀹屽杽鑿滃崟淇℃伅鍚庡啀淇濆瓨')
  if (!valid) {
    return
  }
  saving.value = true
  try {
    const payload = {
      ...formData,
      parentId: parentPath.value?.length ? parentPath.value[parentPath.value.length - 1] : 0
    }
    if (editingId.value) {
      await updateMenuApi(editingId.value, payload)
      ElMessage.success('结构节点已更新')
    } else {
      await createMenuApi(payload)
      ElMessage.success('结构节点已创建')
    }
    dialogVisible.value = false
    await loadMenus()
  } finally {
    saving.value = false
  }
}

async function handleDelete(row) {
  if (!authStore.hasPermission('sys:menu:delete')) {
    ElMessage.warning('当前账号没有删除结构节点的权限')
    return
  }
  await ElMessageBox.confirm(`确认删除结构节点“${row.menuName}”吗？`, '删除确认', {
    type: 'warning'
  })
  await deleteMenuApi(row.id)
  ElMessage.success('结构节点已删除')
  await loadMenus()
}

loadMenus()
</script>

<style scoped>
.menu-metrics {
  grid-template-columns: repeat(4, minmax(0, 1fr));
}

@media (max-width: 960px) {
  .menu-metrics {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 640px) {
  .menu-metrics {
    grid-template-columns: 1fr;
  }
}
</style>
