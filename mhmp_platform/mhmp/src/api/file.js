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

export function getFilePreviewApi(fileUrl) {
  return request({
    url: '/files/preview',
    method: 'get',
    params: { fileUrl }
  })
}
