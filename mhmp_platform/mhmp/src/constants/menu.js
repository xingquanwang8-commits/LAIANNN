export const APP_TITLE = '博物馆文物综合管理平台'

export const APP_ROUTE_DEFINITIONS = [
  {
    path: 'dashboard',
    name: 'dashboard',
    component: () => import('@/views/dashboard/DashboardView.vue'),
    meta: {
      title: '工作台',
      requiresAuth: true,
      permission: 'dashboard:view'
    }
  },
  {
    path: 'system/user',
    name: 'system-user',
    component: () => import('@/views/system/SystemUserView.vue'),
    meta: {
      title: '用户管理',
      requiresAuth: true,
      permission: 'sys:user:view'
    }
  },
  {
    path: 'system/role',
    name: 'system-role',
    component: () => import('@/views/system/SystemRoleView.vue'),
    meta: {
      title: '角色管理',
      requiresAuth: true,
      permission: 'sys:role:view'
    }
  },
  {
    path: 'system/menu',
    name: 'system-menu',
    component: () => import('@/views/system/SystemMenuView.vue'),
    meta: {
      title: '菜单管理',
      requiresAuth: true,
      permission: 'sys:menu:view'
    }
  },
  {
    path: 'system/dict',
    name: 'system-dict',
    component: () => import('@/views/system/SystemDictView.vue'),
    meta: {
      title: '字典管理',
      requiresAuth: true,
      permission: 'sys:dict:view'
    }
  },
  {
    path: 'system/log',
    name: 'system-log',
    component: () => import('@/views/system/SystemLogView.vue'),
    meta: {
      title: '操作日志',
      requiresAuth: true,
      permission: 'sys:log:view'
    }
  },
  {
    path: 'relic/list',
    name: 'relic-list',
    component: () => import('@/views/relic/RelicListView.vue'),
    meta: {
      title: '文物列表',
      requiresAuth: true,
      permission: 'relic:list:view'
    }
  },
  {
    path: 'relic/detail/:id',
    name: 'relic-detail',
    component: () => import('@/views/relic/RelicDetailView.vue'),
    meta: {
      title: '文物详情',
      requiresAuth: true,
      permission: ['relic:detail:view', 'relic:view', 'relic:list:view']
    }
  },
  {
    path: 'relic/create',
    name: 'relic-create',
    component: () => import('@/views/relic/RelicFormView.vue'),
    meta: {
      title: '新增文物',
      requiresAuth: true,
      permission: 'relic:add'
    }
  },
  {
    path: 'relic/edit/:id',
    name: 'relic-edit',
    component: () => import('@/views/relic/RelicFormView.vue'),
    meta: {
      title: '编辑文物',
      requiresAuth: true,
      permission: 'relic:edit'
    }
  },
  {
    path: 'inventory/inbound',
    name: 'inventory-inbound',
    component: () => import('@/views/inventory/InboundView.vue'),
    meta: {
      title: '入库登记',
      requiresAuth: true,
      permission: 'inventory:inbound:view'
    }
  },
  {
    path: 'inventory/outbound/apply',
    name: 'inventory-outbound-apply',
    component: () => import('@/views/outbound/OutboundApplyView.vue'),
    meta: {
      title: '出库申请',
      requiresAuth: true,
      permission: 'inventory:outbound:apply:view'
    }
  },
  {
    path: 'inventory/outbound/approve',
    name: 'inventory-outbound-approve',
    component: () => import('@/views/outbound/OutboundApproveView.vue'),
    meta: {
      title: '出库审批',
      requiresAuth: true,
      permission: 'inventory:outbound:approve:view'
    }
  },
  {
    path: 'inventory/query',
    name: 'inventory-query',
    component: () => import('@/views/inventory/InventoryQueryView.vue'),
    meta: {
      title: '库存查询',
      requiresAuth: true,
      permission: 'inventory:query:view'
    }
  },
  {
    path: 'inventory/task',
    name: 'inventory-task',
    component: () => import('@/views/inventory/InventoryTaskView.vue'),
    meta: {
      title: '盘点任务',
      requiresAuth: true,
      permission: 'inventory:task:view'
    }
  },
  {
    path: 'repair/apply',
    name: 'repair-apply',
    component: () => import('@/views/repair/RepairApplyView.vue'),
    meta: {
      title: '修复申请',
      requiresAuth: true,
      permission: 'repair:apply:view'
    }
  },
  {
    path: 'repair/approve',
    name: 'repair-approve',
    component: () => import('@/views/repair/RepairApproveView.vue'),
    meta: {
      title: '修复审批',
      requiresAuth: true,
      permission: 'repair:approve:view'
    }
  },
  {
    path: 'repair/process',
    name: 'repair-process',
    component: () => import('@/views/repair/RepairProcessView.vue'),
    meta: {
      title: '修复过程',
      requiresAuth: true,
      permission: 'repair:process:view'
    }
  },
  {
    path: 'repair/acceptance',
    name: 'repair-acceptance',
    component: () => import('@/views/repair/RepairAcceptanceView.vue'),
    meta: {
      title: '修复验收',
      requiresAuth: true,
      permission: 'repair:acceptance:view'
    }
  },
  {
    path: 'repair/history',
    name: 'repair-history',
    component: () => import('@/views/repair/RepairHistoryView.vue'),
    meta: {
      title: '修复历史',
      requiresAuth: true,
      permission: 'repair:history:view'
    }
  },
  {
    path: 'profile',
    name: 'profile',
    component: () => import('@/views/profile/ProfileView.vue'),
    meta: {
      title: '个人中心',
      requiresAuth: true,
      permission: 'profile:view'
    }
  }
]
