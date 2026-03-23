import request from '@/utils/request'

export function getRelicPageApi(params) {
  return request({
    url: '/relic/page',
    method: 'get',
    params
  })
}

export function getRelicDetailApi(id) {
  return request({
    url: `/relic/${id}`,
    method: 'get'
  })
}

export function getRelicAttachmentsApi(id) {
  return request({
    url: `/relic/${id}/attachments`,
    method: 'get'
  })
}

export function createRelicApi(data) {
  return request({
    url: '/relic',
    method: 'post',
    data
  })
}

export function updateRelicApi(id, data) {
  return request({
    url: `/relic/${id}`,
    method: 'put',
    data
  })
}

export function deleteRelicApi(id) {
  return request({
    url: `/relic/${id}`,
    method: 'delete'
  })
}
