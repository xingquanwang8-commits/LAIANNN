import axios from 'axios'
import { ElMessage } from 'element-plus'
import { markErrorHandled, resolveErrorMessage, showErrorMessage } from '@/utils/error'

const TOKEN_KEY = 'mhmp_token'
let redirecting = false

function getToken() {
  return sessionStorage.getItem(TOKEN_KEY) || ''
}

function setToken(token) {
  // Keep the login state bound to the current browser session.
  sessionStorage.setItem(TOKEN_KEY, token)
  localStorage.removeItem(TOKEN_KEY)
}

function clearToken() {
  sessionStorage.removeItem(TOKEN_KEY)
  localStorage.removeItem(TOKEN_KEY)
}

function resolveResultMessage(result, fallback) {
  return resolveErrorMessage(result?.message || result?.msg || result, fallback)
}

function handleUnauthorized(message) {
  // Clear stale credentials first so the router does not keep reusing an invalid token.
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
    // Backend business APIs return a unified envelope with code/message/data.
    if (!result || typeof result !== 'object' || typeof result.code === 'undefined') {
      return result
    }
    if (result.code === 200) {
      return result.data
    }
    const message = resolveResultMessage(result, '请求失败，请稍后重试')
    if (result.code === 401) {
      handleUnauthorized(message)
    } else if (result.code === 403) {
      showErrorMessage(result, '没有访问权限')
    } else {
      showErrorMessage(result, '请求失败，请稍后重试')
    }
    return rejectHandledMessage(message)
  },
  (error) => {
    const status = error.response?.status
    const responseData = error.response?.data
    if (status === 401) {
      handleUnauthorized(responseData)
    } else if (status === 403) {
      showErrorMessage(responseData || error, '没有访问权限')
    } else {
      showErrorMessage(responseData || error, '网络请求失败，请稍后重试')
    }
    return Promise.reject(markErrorHandled(error))
  }
)

export { TOKEN_KEY, clearToken, getToken, setToken }
export default request
