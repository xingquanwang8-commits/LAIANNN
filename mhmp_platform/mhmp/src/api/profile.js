import request from '@/utils/request'

export function getProfileApi() {
  return request({
    url: '/profile',
    method: 'get'
  })
}

export function updateProfileApi(data) {
  return request({
    url: '/profile',
    method: 'put',
    data
  })
}

export function updatePasswordApi(data) {
  return request({
    url: '/profile/password',
    method: 'put',
    data
  })
}
