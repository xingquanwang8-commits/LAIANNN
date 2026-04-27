export const IMAGE_PREVIEW_SUFFIXES = new Set(['png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp', 'svg'])

export function resolveFileSuffix(file) {
  if (!file) {
    return ''
  }
  const suffix = (file.fileSuffix || '').trim().toLowerCase()
  if (suffix) {
    return suffix
  }
  const fileUrl = file.fileUrl || ''
  const cleanUrl = fileUrl.split('?')[0]
  const index = cleanUrl.lastIndexOf('.')
  return index >= 0 ? cleanUrl.slice(index + 1).toLowerCase() : ''
}

export function buildPreviewFile(file) {
  return {
    fileName: file?.fileName || '文件预览',
    fileUrl: resolveFileAccessUrl(file?.fileUrl || ''),
    fileSuffix: resolveFileSuffix(file)
  }
}

export function resolveFileAccessUrl(fileUrl) {
  if (!fileUrl) {
    return ''
  }
  if (fileUrl.startsWith('/uploads/')) {
    return fileUrl
  }
  try {
    const parsedUrl = new URL(fileUrl, window.location.origin)
    if (parsedUrl.pathname.startsWith('/uploads/')) {
      return `${parsedUrl.pathname}${parsedUrl.search}${parsedUrl.hash}`
    }
  } catch (error) {
    return fileUrl
  }
  return fileUrl
}

export function openOriginalFile(file) {
  if (!file?.fileUrl) {
    return false
  }
  const openedWindow = window.open(resolveFileAccessUrl(file.fileUrl), '_blank')
  if (openedWindow) {
    openedWindow.opener = null
  }
  return Boolean(openedWindow)
}
