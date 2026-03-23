import request from '@/utils/request'

export function loginApi(data) {
  return request({
    url: '/auth/login',
    method: 'post',
    data
  })
}

export function logoutApi() {
  return request({
    url: '/auth/logout',
    method: 'post'
  })
}

export function getCurrentUserApi() {
  return request({
    url: '/auth/current-user',
    method: 'get'
  })
}

export function getMenusApi() {
  return request({
    url: '/auth/menus',
    method: 'get'
  })
}
