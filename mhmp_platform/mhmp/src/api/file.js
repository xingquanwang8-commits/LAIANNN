import request from '@/utils/request'

export function uploadFileApi(file, bizType = 'common') {
  const formData = new FormData()
  formData.append('file', file)
  formData.append('bizType', bizType)
  return request({
    url: '/files/upload',
    method: 'post',
    data: formData
  })
}
