import axios from 'axios'
import { ElMessage } from 'element-plus'

const TOKEN_KEY = 'mhmp_token'
let redirecting = false

function clearToken() {
  localStorage.removeItem(TOKEN_KEY)
}

function handleUnauthorized(message) {
  clearToken()
  if (!redirecting) {
    redirecting = true
    ElMessage.error(message || '登录已过期，请重新登录')
    const currentHash = window.location.hash || '#/'
    const redirect = encodeURIComponent(currentHash.replace(/^#/, ''))
    window.location.hash = `/login?redirect=${redirect}`
    window.setTimeout(() => {
      redirecting = false
    }, 300)
  }
}

const request = axios.create({
  baseURL: '/api',
  timeout: 15000
})

request.interceptors.request.use((config) => {
  const token = localStorage.getItem(TOKEN_KEY)
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

request.interceptors.response.use(
  (response) => {
    const result = response.data
    if (result.code === 200) {
      return result.data
    }
    if (result.code === 401) {
      handleUnauthorized(result.msg)
    } else if (result.code === 403) {
      ElMessage.error(result.msg || '没有访问权限')
    } else {
      ElMessage.error(result.msg || '请求失败')
    }
    return Promise.reject(new Error(result.msg || 'Request Error'))
  },
  (error) => {
    const status = error.response?.status
    if (status === 401) {
      handleUnauthorized(error.response?.data?.msg)
    } else if (status === 403) {
      ElMessage.error('没有访问权限')
    } else {
      ElMessage.error(error.response?.data?.msg || error.message || '网络请求失败')
    }
    return Promise.reject(error)
  }
)

export { TOKEN_KEY, clearToken }
export default request
