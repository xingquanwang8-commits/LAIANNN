const tagTypeMap = {
  IN_STOCK: 'success',
  OUTBOUND_PENDING: 'warning',
  OUT_STOCK: 'info',
  IN_REPAIR: 'danger',
  PENDING: 'warning',
  APPROVED: 'success',
  REJECTED: 'danger',
  RETURNED: 'info'
}

export function formatDateTime(value) {
  if (!value) {
    return '--'
  }
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) {
    return value
  }
  const year = date.getFullYear()
  const month = `${date.getMonth() + 1}`.padStart(2, '0')
  const day = `${date.getDate()}`.padStart(2, '0')
  const hour = `${date.getHours()}`.padStart(2, '0')
  const minute = `${date.getMinutes()}`.padStart(2, '0')
  return `${year}-${month}-${day} ${hour}:${minute}`
}

export function resolveDictLabel(options = [], value) {
  const target = options.find((item) => item.itemValue === value)
  return target ? target.itemLabel : value || '--'
}

export function resolveStatusTagType(status) {
  return tagTypeMap[status] || 'info'
}
