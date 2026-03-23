import request from '@/utils/request'

export function getOutboundPageApi(params) {
  return request({
    url: '/outbound/page',
    method: 'get',
    params
  })
}

export function getOutboundDetailApi(id) {
  return request({
    url: `/outbound/${id}`,
    method: 'get'
  })
}

export function createOutboundApi(data) {
  return request({
    url: '/outbound',
    method: 'post',
    data
  })
}

export function approveOutboundApi(id, data) {
  return request({
    url: `/outbound/approve/${id}`,
    method: 'post',
    data
  })
}

export function rejectOutboundApi(id, data) {
  return request({
    url: `/outbound/reject/${id}`,
    method: 'post',
    data
  })
}
