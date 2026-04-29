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
