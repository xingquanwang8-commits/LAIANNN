import request from '@/utils/request'

export function getInventorySummaryApi() {
  return request({
    url: '/inventory/query/summary',
    method: 'get'
  })
}

export function getInventoryQueryPageApi(params) {
  return request({
    url: '/inventory/query/page',
    method: 'get',
    params
  })
}

export function getInventoryTaskPageApi(params) {
  return request({
    url: '/inventory/tasks/page',
    method: 'get',
    params
  })
}

export function getInventoryTaskDetailApi(id) {
  return request({
    url: `/inventory/tasks/${id}`,
    method: 'get'
  })
}

export function getInventoryTaskPrincipalOptionsApi() {
  return request({
    url: '/inventory/tasks/principals',
    method: 'get'
  })
}

export function createInventoryTaskApi(data) {
  return request({
    url: '/inventory/tasks',
    method: 'post',
    data
  })
}

export function updateInventoryTaskDetailApi(taskId, detailId, data) {
  return request({
    url: `/inventory/tasks/${taskId}/details/${detailId}`,
    method: 'put',
    data
  })
}

export function submitInventoryTaskApi(taskId) {
  return request({
    url: `/inventory/tasks/${taskId}/submit`,
    method: 'post'
  })
}

export function getTransferTaskPrincipalOptionsApi() {
  return request({
    url: '/inventory/transfer-tasks/principals',
    method: 'get'
  })
}

export function createTransferTaskApi(data) {
  return request({
    url: '/inventory/transfer-tasks',
    method: 'post',
    data
  })
}

export function createTransferBatchTasksApi(data) {
  return request({
    url: '/inventory/transfer-tasks/batch',
    method: 'post',
    data
  })
}

export function getMyTransferTaskPageApi(params) {
  return request({
    url: '/inventory/transfer-tasks/my/page',
    method: 'get',
    params
  })
}

export function getTransferTaskDetailApi(id) {
  return request({
    url: `/inventory/transfer-tasks/${id}`,
    method: 'get'
  })
}

export function confirmTransferTaskApi(id, data) {
  return request({
    url: `/inventory/transfer-tasks/${id}/confirm`,
    method: 'post',
    data
  })
}
