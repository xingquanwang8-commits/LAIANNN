import { defineStore } from 'pinia'
import { ElMessage } from 'element-plus'
import { getCurrentUserApi, getMenusApi, loginApi, logoutApi } from '@/api/auth'
import { TOKEN_KEY, clearToken } from '@/utils/request'

let initializePromise = null

export const useAuthStore = defineStore('auth', {
  state: () => ({
    token: localStorage.getItem(TOKEN_KEY) || '',
    user: null,
    menus: [],
    initialized: false
  }),
  getters: {
    isAuthenticated: (state) => Boolean(state.token),
    permissions: (state) => state.user?.permissions || [],
    displayName: (state) => state.user?.realName || state.user?.nickName || state.user?.username || '未登录'
  },
  actions: {
    setToken(token) {
      this.token = token
      localStorage.setItem(TOKEN_KEY, token)
    },
    clearSession() {
      this.token = ''
      this.user = null
      this.menus = []
      this.initialized = false
      clearToken()
    },
    hasPermission(permission) {
      if (!permission) {
        return true
      }
      if (Array.isArray(permission)) {
        return permission.some((item) => this.permissions.includes(item))
      }
      return this.permissions.includes(permission)
    },
    async login(formData) {
      const data = await loginApi(formData)
      this.setToken(data.token)
      await this.initializeSession(true)
      return data
    },
    async initializeSession(force = false) {
      if (!this.token) {
        this.clearSession()
        return false
      }
      if (this.initialized && !force) {
        return true
      }
      if (initializePromise) {
        return initializePromise
      }
      initializePromise = Promise.all([getCurrentUserApi(), getMenusApi()])
        .then(([user, menus]) => {
          this.user = user
          this.menus = menus || []
          this.initialized = true
          return true
        })
        .catch((error) => {
          this.clearSession()
          throw error
        })
        .finally(() => {
          initializePromise = null
        })
      return initializePromise
    },
    async logout(showMessage = true) {
      try {
        if (this.token) {
          await logoutApi()
        }
      } catch (error) {
        // Allow local logout even when the backend session is already invalid.
      } finally {
        this.clearSession()
      }
      if (showMessage) {
        ElMessage.success('已安全退出登录')
      }
    }
  }
})
