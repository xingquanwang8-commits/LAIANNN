import { ElMessage } from 'element-plus'

const HANDLED_FLAG = '__mhmpHandled'
const TECHNICAL_MESSAGE_PATTERNS = [
  /cannot read properties/i,
  /is not a function/i,
  /undefined/i,
  /unexpected token/i,
  /network error/i,
  /request failed/i,
  /timeout/i
]

function extractFieldMessage(error) {
  if (!error?.fields || typeof error.fields !== 'object') {
    return ''
  }
  const firstFieldErrors = Object.values(error.fields)[0]
  if (Array.isArray(firstFieldErrors) && firstFieldErrors.length) {
    return firstFieldErrors[0]?.message || ''
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

  const fieldMessage = extractFieldMessage(error)
  if (fieldMessage) {
    return normalizeMessage(fieldMessage, fallback)
  }

  if (Array.isArray(error?.errors) && error.errors.length) {
    const message = error.errors[0]?.message || error.errors[0]
    return normalizeMessage(message, fallback)
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
