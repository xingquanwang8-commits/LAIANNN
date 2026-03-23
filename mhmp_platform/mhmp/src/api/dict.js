import request from '@/utils/request'

export function getDictTypesApi() {
  return request({
    url: '/dict/types',
    method: 'get'
  })
}

export function getDictItemsApi(dictTypeCode) {
  return request({
    url: `/dict/${dictTypeCode}/items`,
    method: 'get'
  })
}
