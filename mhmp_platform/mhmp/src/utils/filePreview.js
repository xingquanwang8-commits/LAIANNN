export const IMAGE_PREVIEW_SUFFIXES = new Set(['png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp', 'svg'])
export const PDF_PREVIEW_SUFFIXES = new Set(['pdf'])
export const TEXT_PREVIEW_SUFFIXES = new Set(['doc', 'docx', 'xls', 'xlsx', 'txt', 'log', 'md', 'json', 'xml', 'csv'])

export function resolveFileSuffix(file) {
  if (!file) {
    return ''
  }
  const suffix = (file.fileSuffix || '').trim().replace(/^\./, '').toLowerCase()
  if (suffix) {
    return suffix
  }
  return resolveSuffixFromText(file.fileName) || resolveSuffixFromText(file.fileUrl)
}

function resolveSuffixFromText(value) {
  const cleanName = (value || '').split('?')[0].split('#')[0]
  const index = cleanName.lastIndexOf('.')
  return index >= 0 ? cleanName.slice(index + 1).toLowerCase() : ''
}

export function ensureFileNameSuffix(fileName, suffix) {
  const safeName = (fileName || '文件预览').trim() || '文件预览'
  const safeSuffix = (suffix || '').trim().replace(/^\./, '').toLowerCase()
  if (!safeSuffix || safeName.toLowerCase().endsWith(`.${safeSuffix}`)) {
    return safeName
  }
  return `${safeName}.${safeSuffix}`
}

export function resolvePreviewFileName(file) {
  return ensureFileNameSuffix(file?.fileName || '文件预览', resolveFileSuffix(file))
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

export function buildFilePreviewUrl(file) {
  if (!file?.fileUrl) {
    return ''
  }
  const params = new URLSearchParams()
  params.set('fileUrl', resolveFileAccessUrl(file.fileUrl))
  params.set('fileName', resolvePreviewFileName(file))
  params.set('fileSuffix', resolveFileSuffix(file))
  return `${window.location.origin}${window.location.pathname}${window.location.search}#/file-preview?${params.toString()}`
}

export function openPreviewFile(file) {
  const previewUrl = buildFilePreviewUrl(file)
  if (!previewUrl) {
    return false
  }
  const openedWindow = window.open(previewUrl, '_blank')
  if (openedWindow) {
    openedWindow.opener = null
  }
  return Boolean(openedWindow)
}

export function openOriginalFile(file) {
  return openPreviewFile(file)
}
