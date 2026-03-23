const tagTypeMap = {
  ENABLED: 'success',
  DISABLED: 'info',
  SUCCESS: 'success',
  FAIL: 'danger',
  IN_STOCK: 'success',
  OUTBOUND_PENDING: 'warning',
  OUT_STOCK: 'info',
  IN_REPAIR: 'danger',
  DRAFT: 'info',
  PENDING: 'warning',
  APPROVED: 'success',
  REJECTED: 'danger',
  RETURNED: 'info',
  CREATED: 'info',
  IN_PROGRESS: 'warning',
  COMPLETED: 'success',
  NORMAL: 'success',
  CHECKED: 'info',
  DIFF_FOUND: 'warning',
  APPLIED: 'warning',
  ACCEPTED: 'success',
  PASS: 'success'
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

export function formatDate(value) {
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
  return `${year}-${month}-${day}`
}

export function resolveDictLabel(options = [], value) {
  const target = options.find((item) => item.itemValue === value)
  return target ? target.itemLabel : value || '--'
}

export function resolveStatusTagType(status) {
  return tagTypeMap[status] || 'info'
}

export function flattenTree(nodes = []) {
  return nodes.flatMap((node) => [node, ...flattenTree(node.children || [])])
}

export function buildTreeSelectOptions(nodes = [], labelKey = 'menuName') {
  return nodes.map((node) => ({
    value: node.id,
    label: node[labelKey],
    children: buildTreeSelectOptions(node.children || [], labelKey)
  }))
}
