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
