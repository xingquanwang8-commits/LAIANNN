import { createRouter, createWebHashHistory } from 'vue-router'
import { ElMessage } from 'element-plus'
import pinia from '@/stores'
import { useAuthStore } from '@/stores/auth'
import { APP_ROUTE_DEFINITIONS, APP_TITLE } from '@/constants/menu'
import { getFirstAccessiblePath } from '@/utils/menu'
import MainLayout from '@/components/layout/MainLayout.vue'
import LoginView from '@/views/auth/LoginView.vue'

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
    children: APP_ROUTE_DEFINITIONS
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
    document.title = `${to.meta.title} | ${APP_TITLE}`
  }

  if (to.path === '/login') {
    if (authStore.token) {
      try {
        await authStore.initializeSession()
        return to.query.redirect || getFirstAccessiblePath(authStore.menus)
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
