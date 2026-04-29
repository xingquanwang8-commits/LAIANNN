import request from '@/utils/request'

export function getDashboardSummaryApi() {
  return request({
    url: '/dashboard/summary',
    method: 'get'
  })
}
