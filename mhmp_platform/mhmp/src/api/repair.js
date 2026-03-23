import request from '@/utils/request'

export function getRepairApplyPageApi(params) {
  return request({
    url: '/repair/apply/page',
    method: 'get',
    params
  })
}

export function getRepairApprovePageApi(params) {
  return request({
    url: '/repair/approve/page',
    method: 'get',
    params
  })
}

export function getRepairProcessPageApi(params) {
  return request({
    url: '/repair/process/page',
    method: 'get',
    params
  })
}

export function getRepairAcceptancePageApi(params) {
  return request({
    url: '/repair/acceptance/page',
    method: 'get',
    params
  })
}

export function getRepairHistoryPageApi(params) {
  return request({
    url: '/repair/history/page',
    method: 'get',
    params
  })
}

export function getRepairDetailApi(id) {
  return request({
    url: `/repair/${id}`,
    method: 'get'
  })
}

export function createRepairApplyApi(data) {
  return request({
    url: '/repair/apply',
    method: 'post',
    data
  })
}

export function approveRepairApi(id, data) {
  return request({
    url: `/repair/approve/${id}`,
    method: 'post',
    data
  })
}

export function addRepairLogApi(id, data) {
  return request({
    url: `/repair/process/${id}/log`,
    method: 'post',
    data
  })
}

export function acceptRepairApi(id, data) {
  return request({
    url: `/repair/acceptance/${id}`,
    method: 'post',
    data
  })
}
