import { ElMessage } from 'element-plus'

const HANDLED_FLAG = '__mhmpHandled'
const TECHNICAL_MESSAGE_PATTERNS = [
  /cannot read properties/i,
  /is not a function/i,
  /undefined/i,
  /unexpected token/i,
  /network error/i,
  /request failed/i,
  /timeout/i,
  /json parse error/i,
  /status code \d+/i
]

function extractFieldMessage(error) {
  const fields = error?.errors || error?.fields
  if (!fields || typeof fields !== 'object') {
    return ''
  }
  const firstFieldErrors = Object.values(fields)[0]
  if (typeof firstFieldErrors === 'string') {
    return firstFieldErrors
  }
  if (Array.isArray(firstFieldErrors) && firstFieldErrors.length) {
    return firstFieldErrors[0]?.message || firstFieldErrors[0] || ''
  }
  if (firstFieldErrors && typeof firstFieldErrors === 'object') {
    return firstFieldErrors.message || ''
  }
  return ''
}

function extractResponseMessage(error) {
  const responseData = error?.response?.data
  if (responseData && typeof responseData === 'object') {
    return responseData.message || responseData.msg || ''
  }
  if (error && typeof error === 'object') {
    return error.message || error.msg || ''
  }
  return ''
}

function normalizeMessage(message, fallback) {
  const resolved = typeof message === 'string' ? message.trim() : ''
  if (!resolved) {
    return fallback
  }
  if (TECHNICAL_MESSAGE_PATTERNS.some((pattern) => pattern.test(resolved))) {
    return fallback
  }
  return resolved
}

export function markErrorHandled(error) {
  if (error && typeof error === 'object') {
    error[HANDLED_FLAG] = true
  }
  return error
}

export function isErrorHandled(error) {
  return Boolean(error && typeof error === 'object' && error[HANDLED_FLAG])
}

export function resolveErrorMessage(error, fallback = '操作失败，请稍后重试') {
  if (typeof error === 'string') {
    return normalizeMessage(error, fallback)
  }

  const fieldMessage = extractFieldMessage(error) || extractFieldMessage(error?.response?.data)
  if (fieldMessage) {
    return normalizeMessage(fieldMessage, fallback)
  }

  if (Array.isArray(error?.errors) && error.errors.length) {
    const message = error.errors[0]?.message || error.errors[0]
    return normalizeMessage(message, fallback)
  }

  const responseMessage = extractResponseMessage(error)
  if (responseMessage) {
    return normalizeMessage(responseMessage, fallback)
  }

  return normalizeMessage(error?.userMessage || error?.message, fallback)
}

export function showErrorMessage(error, fallback = '操作失败，请稍后重试') {
  const message = resolveErrorMessage(error, fallback)
  if (!isErrorHandled(error)) {
    ElMessage.error(message)
    markErrorHandled(error)
  }
  return message
}

let registered = false

export function registerGlobalErrorHandlers(app) {
  if (registered) {
    return
  }
  registered = true

  app.config.errorHandler = (error) => {
    showErrorMessage(error, '页面处理失败，请刷新后重试')
  }

  window.addEventListener('error', (event) => {
    showErrorMessage(event.error || event.message, '页面处理失败，请刷新后重试')
  })

  window.addEventListener('unhandledrejection', (event) => {
    if (isErrorHandled(event.reason)) {
      event.preventDefault()
      return
    }
    showErrorMessage(event.reason, '操作失败，请稍后重试')
    event.preventDefault()
  })
}
