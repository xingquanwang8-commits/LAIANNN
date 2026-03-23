import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue')
  },
  {
    path: '/layout',
    name: 'Layout',
    component: () => import('../layout/Layout.vue'),
    redirect: '/dashboard', // 暂定跳转到仪表盘
    children: [
      {
        path: '/dashboard',
        name: 'Dashboard',
        component: () => import('../views/Dashboard.vue')
      }
    ]
  },
  {
    path: '/',
    redirect: '/login'
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
