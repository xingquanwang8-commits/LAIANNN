import { createRouter, createWebHashHistory } from 'vue-router'
import { ElMessage } from 'element-plus'
import pinia from '@/stores'
import { useAuthStore } from '@/stores/auth'
import { getFirstAccessiblePath } from '@/utils/menu'
import MainLayout from '@/components/layout/MainLayout.vue'
import LoginView from '@/views/auth/LoginView.vue'
import DashboardView from '@/views/dashboard/DashboardView.vue'
import RelicListView from '@/views/relic/RelicListView.vue'
import RelicDetailView from '@/views/relic/RelicDetailView.vue'
import RelicFormView from '@/views/relic/RelicFormView.vue'
import OutboundApplyView from '@/views/outbound/OutboundApplyView.vue'
import OutboundApproveView from '@/views/outbound/OutboundApproveView.vue'

const routes = [
  {
    path: '/login',
    name: 'login',
    component: LoginView,
    meta: {
      title: '登录'
    }
  },
  {
    path: '/',
    component: MainLayout,
    redirect: '/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'dashboard',
        component: DashboardView,
        meta: {
          title: '工作台',
          requiresAuth: true,
          permission: 'dashboard:view'
        }
      },
      {
        path: 'relic/list',
        name: 'relic-list',
        component: RelicListView,
        meta: {
          title: '文物列表',
          requiresAuth: true,
          permission: 'relic:list:view'
        }
      },
      {
        path: 'relic/detail/:id',
        name: 'relic-detail',
        component: RelicDetailView,
        meta: {
          title: '文物详情',
          requiresAuth: true,
          permission: ['relic:detail:view', 'relic:view', 'relic:list:view']
        }
      },
      {
        path: 'relic/create',
        name: 'relic-create',
        component: RelicFormView,
        meta: {
          title: '新增文物',
          requiresAuth: true,
          permission: 'relic:add'
        }
      },
      {
        path: 'relic/edit/:id',
        name: 'relic-edit',
        component: RelicFormView,
        meta: {
          title: '编辑文物',
          requiresAuth: true,
          permission: 'relic:edit'
        }
      },
      {
        path: 'inventory/outbound/apply',
        name: 'outbound-apply',
        component: OutboundApplyView,
        meta: {
          title: '出库申请',
          requiresAuth: true,
          permission: 'inventory:outbound:apply:view'
        }
      },
      {
        path: 'inventory/outbound/approve',
        name: 'outbound-approve',
        component: OutboundApproveView,
        meta: {
          title: '出库审批',
          requiresAuth: true,
          permission: 'inventory:outbound:approve:view'
        }
      }
    ]
  },
  {
    path: '/:pathMatch(.*)*',
    redirect: '/dashboard'
  }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

router.beforeEach(async (to) => {
  const authStore = useAuthStore(pinia)

  if (to.meta.title) {
    document.title = `${to.meta.title} | 博物馆文物综合管理平台`
  }

  if (to.path === '/login') {
    if (authStore.token) {
      try {
        await authStore.initializeSession()
        return getFirstAccessiblePath(authStore.menus)
      } catch (error) {
        return true
      }
    }
    return true
  }

  if (!to.meta.requiresAuth) {
    return true
  }

  if (!authStore.token) {
    return {
      path: '/login',
      query: {
        redirect: to.fullPath
      }
    }
  }

  try {
    await authStore.initializeSession()
  } catch (error) {
    return {
      path: '/login',
      query: {
        redirect: to.fullPath
      }
    }
  }

  if (to.meta.permission && !authStore.hasPermission(to.meta.permission)) {
    ElMessage.warning('当前账号没有访问该页面的权限')
    return getFirstAccessiblePath(authStore.menus)
  }

  return true
})

export default router
