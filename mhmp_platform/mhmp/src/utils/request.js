import axios from 'axios'
import { ElMessage } from 'element-plus'
import { markErrorHandled, resolveErrorMessage, showErrorMessage } from '@/utils/error'

const TOKEN_KEY = 'mhmp_token'
let redirecting = false

function getToken() {
  return sessionStorage.getItem(TOKEN_KEY) || ''
}

function setToken(token) {
  sessionStorage.setItem(TOKEN_KEY, token)
  localStorage.removeItem(TOKEN_KEY)
}

function clearToken() {
  sessionStorage.removeItem(TOKEN_KEY)
  localStorage.removeItem(TOKEN_KEY)
}

function handleUnauthorized(message) {
  clearToken()
  if (!redirecting) {
    redirecting = true
    ElMessage.error(resolveErrorMessage(message, '登录已失效，请重新登录'))
    const currentHash = window.location.hash || '#/'
    const redirect = encodeURIComponent(currentHash.replace(/^#/, ''))
    window.location.hash = `/login?redirect=${redirect}`
    window.setTimeout(() => {
      redirecting = false
    }, 300)
  }
}

function rejectHandledMessage(message) {
  const error = new Error(message)
  error.userMessage = message
  return Promise.reject(markErrorHandled(error))
}

const request = axios.create({
  baseURL: '/api',
  timeout: 15000
})

request.interceptors.request.use((config) => {
  const token = getToken()
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
      showErrorMessage(result.msg, '没有访问权限')
    } else {
      showErrorMessage(result.msg, '请求失败，请稍后重试')
    }
    return rejectHandledMessage(resolveErrorMessage(result.msg, '请求失败，请稍后重试'))
  },
  (error) => {
    const status = error.response?.status
    if (status === 401) {
      handleUnauthorized(error.response?.data?.msg)
    } else if (status === 403) {
      showErrorMessage(error, '没有访问权限')
    } else {
      showErrorMessage(error, '网络请求失败，请稍后重试')
    }
    return Promise.reject(markErrorHandled(error))
  }
)

export { TOKEN_KEY, clearToken, getToken, setToken }
export default request
