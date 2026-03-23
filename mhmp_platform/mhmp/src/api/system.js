import request from '@/utils/request'

export function getUserPageApi(params) {
  return request({
    url: '/system/users/page',
    method: 'get',
    params
  })
}

export function getUserDetailApi(id) {
  return request({
    url: `/system/users/${id}`,
    method: 'get'
  })
}

export function createUserApi(data) {
  return request({
    url: '/system/users',
    method: 'post',
    data
  })
}

export function updateUserApi(id, data) {
  return request({
    url: `/system/users/${id}`,
    method: 'put',
    data
  })
}

export function updateUserStatusApi(id, data) {
  return request({
    url: `/system/users/${id}/status`,
    method: 'put',
    data
  })
}

export function deleteUserApi(id) {
  return request({
    url: `/system/users/${id}`,
    method: 'delete'
  })
}

export function getRolePageApi(params) {
  return request({
    url: '/system/roles/page',
    method: 'get',
    params
  })
}

export function getRoleListApi() {
  return request({
    url: '/system/roles/list',
    method: 'get'
  })
}

export function getRoleDetailApi(id) {
  return request({
    url: `/system/roles/${id}`,
    method: 'get'
  })
}

export function createRoleApi(data) {
  return request({
    url: '/system/roles',
    method: 'post',
    data
  })
}

export function updateRoleApi(id, data) {
  return request({
    url: `/system/roles/${id}`,
    method: 'put',
    data
  })
}

export function updateRoleStatusApi(id, data) {
  return request({
    url: `/system/roles/${id}/status`,
    method: 'put',
    data
  })
}

export function grantRoleMenusApi(id, data) {
  return request({
    url: `/system/roles/${id}/menus`,
    method: 'put',
    data
  })
}

export function deleteRoleApi(id) {
  return request({
    url: `/system/roles/${id}`,
    method: 'delete'
  })
}

export function getMenuTreeApi() {
  return request({
    url: '/system/menus/tree',
    method: 'get'
  })
}

export function getMenuDetailApi(id) {
  return request({
    url: `/system/menus/${id}`,
    method: 'get'
  })
}

export function createMenuApi(data) {
  return request({
    url: '/system/menus',
    method: 'post',
    data
  })
}

export function updateMenuApi(id, data) {
  return request({
    url: `/system/menus/${id}`,
    method: 'put',
    data
  })
}

export function deleteMenuApi(id) {
  return request({
    url: `/system/menus/${id}`,
    method: 'delete'
  })
}

export function getDictTypePageApi(params) {
  return request({
    url: '/system/dicts/types/page',
    method: 'get',
    params
  })
}

export function createDictTypeApi(data) {
  return request({
    url: '/system/dicts/types',
    method: 'post',
    data
  })
}

export function updateDictTypeApi(id, data) {
  return request({
    url: `/system/dicts/types/${id}`,
    method: 'put',
    data
  })
}

export function deleteDictTypeApi(id) {
  return request({
    url: `/system/dicts/types/${id}`,
    method: 'delete'
  })
}

export function getSystemDictItemsApi(dictTypeCode) {
  return request({
    url: `/system/dicts/${dictTypeCode}/items`,
    method: 'get'
  })
}

export function createDictItemApi(data) {
  return request({
    url: '/system/dicts/items',
    method: 'post',
    data
  })
}

export function updateDictItemApi(id, data) {
  return request({
    url: `/system/dicts/items/${id}`,
    method: 'put',
    data
  })
}

export function deleteDictItemApi(id) {
  return request({
    url: `/system/dicts/items/${id}`,
    method: 'delete'
  })
}

export function importDictItemsApi(data) {
  return request({
    url: '/system/dicts/import',
    method: 'post',
    data
  })
}

export function getLogPageApi(params) {
  return request({
    url: '/system/logs/page',
    method: 'get',
    params
  })
}

export function getLogDetailApi(id) {
  return request({
    url: `/system/logs/${id}`,
    method: 'get'
  })
}
