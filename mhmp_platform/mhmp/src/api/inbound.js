import request from '@/utils/request'

export function getInboundPageApi(params) {
  return request({
    url: '/inbound/page',
    method: 'get',
    params
  })
}

export function getInboundDetailApi(id) {
  return request({
    url: `/inbound/${id}`,
    method: 'get'
  })
}

export function createInboundApi(data) {
  return request({
    url: '/inbound',
    method: 'post',
    data
  })
}
