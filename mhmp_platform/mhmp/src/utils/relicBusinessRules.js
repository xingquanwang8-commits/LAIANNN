export const DAMAGE_PRESERVATION_CODES = [
  'INCOMPLETE',
  'SEVERE_INCOMPLETE',
  'FRAGMENTED',
  'PHYSICAL_DAMAGE',
  'CHEMICAL_DEGRADATION',
  'BIOLOGICAL_DISEASE'
]

function pass(message) {
  return {
    passed: true,
    message
  }
}

function fail(message) {
  return {
    passed: false,
    message
  }
}

export function pickRelicBusinessFields(relic = {}) {
  return {
    id: relic.id,
    relicNo: relic.relicNo || '',
    name: relic.name || '',
    currentStatus: relic.currentStatus || '',
    preservationStatusCode: relic.preservationStatusCode || '',
    storageLocationCode: relic.storageLocationCode || ''
  }
}

export function formatRelicIdentity(relic = {}) {
  const identity = [relic.relicNo, relic.name].filter(Boolean).join(' / ')
  if (identity) {
    return identity
  }
  if (relic.id !== undefined && relic.id !== null && relic.id !== '') {
    return `ID ${relic.id}`
  }
  return '\u672a\u77e5\u6587\u7269'
}

export function checkInboundRelicEligibility(relic = {}) {
  if (!relic?.id) {
    return fail('\u672a\u83b7\u53d6\u5230\u6587\u7269\u4fe1\u606f\uff0c\u8bf7\u5237\u65b0\u540e\u91cd\u8bd5')
  }

  switch (relic.currentStatus) {
    case 'TO_BE_INBOUND':
      return pass('\u5f53\u524d\u6587\u7269\u5904\u4e8e\u5f85\u5165\u5e93\u72b6\u6001\uff0c\u53ef\u76f4\u63a5\u63d0\u4ea4\u5165\u5e93\u5355')
    case 'INBOUND_PENDING':
      return fail('\u8be5\u6587\u7269\u5df2\u6709\u5165\u5e93\u5f85\u5ba1\u6279\u4e1a\u52a1\uff0c\u8bf7\u5148\u5b8c\u6210\u5f53\u524d\u6d41\u7a0b')
    case 'IN_STOCK':
      return fail('\u8be5\u6587\u7269\u5f53\u524d\u5df2\u5728\u5e93\uff0c\u65e0\u9700\u518d\u6b21\u53d1\u8d77\u5165\u5e93')
    case 'OUT_STOCK':
      return fail('\u8be5\u6587\u7269\u5df2\u51fa\u5e93\uff0c\u8bf7\u5148\u5c06\u72b6\u6001\u8c03\u6574\u4e3a\u5f85\u5165\u5e93\u540e\u518d\u53d1\u8d77')
    case 'OUTBOUND_PENDING':
      return fail('\u8be5\u6587\u7269\u5b58\u5728\u51fa\u5e93\u5f85\u5ba1\u6279\u4e1a\u52a1\uff0c\u8bf7\u5148\u5904\u7406\u5b8c\u6210\u540e\u518d\u53d1\u8d77\u5165\u5e93')
    case 'IN_REPAIR':
      return fail('\u8be5\u6587\u7269\u6b63\u5728\u4fee\u590d\u4e2d\uff0c\u8bf7\u5f85\u4fee\u590d\u5b8c\u6210\u540e\u518d\u53d1\u8d77\u5165\u5e93')
    default:
      return fail('\u5f53\u524d\u72b6\u6001\u6682\u4e0d\u652f\u6301\u53d1\u8d77\u5165\u5e93')
  }
}

export function checkOutboundRelicEligibility(relic = {}) {
  if (!relic?.id) {
    return fail('\u672a\u83b7\u53d6\u5230\u6587\u7269\u4fe1\u606f\uff0c\u8bf7\u5237\u65b0\u540e\u91cd\u8bd5')
  }

  if (relic.currentStatus !== 'IN_STOCK') {
    switch (relic.currentStatus) {
      case 'TO_BE_INBOUND':
        return fail('\u8be5\u6587\u7269\u5c1a\u672a\u5b8c\u6210\u5165\u5e93\uff0c\u8bf7\u5148\u63d0\u4ea4\u5165\u5e93\u5e76\u901a\u8fc7\u5ba1\u6279')
      case 'INBOUND_PENDING':
        return fail('\u8be5\u6587\u7269\u4ecd\u5728\u5165\u5e93\u5ba1\u6279\u6d41\u7a0b\u4e2d\uff0c\u8bf7\u5ba1\u6279\u5b8c\u6210\u540e\u518d\u53d1\u8d77\u51fa\u5e93')
      case 'OUTBOUND_PENDING':
        return fail('\u8be5\u6587\u7269\u5df2\u6709\u51fa\u5e93\u5f85\u5ba1\u6279\u4e1a\u52a1\uff0c\u65e0\u9700\u91cd\u590d\u53d1\u8d77')
      case 'OUT_STOCK':
        return fail('\u8be5\u6587\u7269\u5df2\u51fa\u5e93\uff0c\u8bf7\u5148\u5b8c\u6210\u5165\u5e93\u540e\u518d\u53d1\u8d77\u65b0\u7684\u51fa\u5e93')
      case 'IN_REPAIR':
        return fail('\u8be5\u6587\u7269\u6b63\u5728\u4fee\u590d\u4e2d\uff0c\u8bf7\u5f85\u4fee\u590d\u5b8c\u6210\u540e\u518d\u53d1\u8d77\u51fa\u5e93')
      default:
        return fail('\u53ea\u6709\u5728\u5e93\u6587\u7269\u624d\u53ef\u53d1\u8d77\u51fa\u5e93')
    }
  }

  if (!relic.storageLocationCode) {
    return fail('\u8be5\u6587\u7269\u7f3a\u5c11\u9986\u5185\u5e93\u4f4d\u4fe1\u606f\uff0c\u8bf7\u5148\u5b8c\u5584\u6863\u6848\u540e\u518d\u53d1\u8d77\u51fa\u5e93')
  }

  return pass('\u5728\u5e93\u4e14\u5e93\u4f4d\u4fe1\u606f\u5b8c\u6574\uff0c\u53ef\u76f4\u63a5\u53d1\u8d77\u51fa\u5e93\u7533\u8bf7')
}

export function checkTransferRelicEligibility(relic = {}, targetLocationCode = '') {
  if (!relic?.id) {
    return fail('\u672a\u83b7\u53d6\u5230\u6587\u7269\u4fe1\u606f\uff0c\u8bf7\u5237\u65b0\u540e\u91cd\u8bd5')
  }

  if (relic.currentStatus !== 'IN_STOCK') {
    switch (relic.currentStatus) {
      case 'TO_BE_INBOUND':
        return fail('\u8be5\u6587\u7269\u5c1a\u672a\u5b8c\u6210\u5165\u5e93\uff0c\u6682\u4e0d\u53ef\u53d1\u8d77\u9986\u5185\u8f6c\u5b58')
      case 'INBOUND_PENDING':
        return fail('\u8be5\u6587\u7269\u4ecd\u5728\u5165\u5e93\u5ba1\u6279\u6d41\u7a0b\u4e2d\uff0c\u6682\u4e0d\u53ef\u53d1\u8d77\u9986\u5185\u8f6c\u5b58')
      case 'OUTBOUND_PENDING':
        return fail('\u8be5\u6587\u7269\u5b58\u5728\u51fa\u5e93\u5f85\u5ba1\u6279\u4e1a\u52a1\uff0c\u8bf7\u5148\u5b8c\u6210\u5f53\u524d\u6d41\u7a0b')
      case 'OUT_STOCK':
        return fail('\u8be5\u6587\u7269\u5df2\u51fa\u5e93\uff0c\u4e0d\u80fd\u53d1\u8d77\u9986\u5185\u8f6c\u5b58')
      case 'IN_REPAIR':
        return fail('\u8be5\u6587\u7269\u6b63\u5728\u4fee\u590d\u4e2d\uff0c\u8bf7\u5f85\u4fee\u590d\u5b8c\u6210\u540e\u518d\u8f6c\u5b58')
      default:
        return fail('\u5f53\u524d\u72b6\u6001\u6682\u4e0d\u652f\u6301\u53d1\u8d77\u9986\u5185\u8f6c\u5b58')
    }
  }

  if (!relic.storageLocationCode) {
    return fail('\u8be5\u6587\u7269\u7f3a\u5c11\u5f53\u524d\u9986\u5185\u5e93\u4f4d\uff0c\u8bf7\u5148\u5b8c\u5584\u6863\u6848\u540e\u518d\u8f6c\u5b58')
  }

  if (targetLocationCode && targetLocationCode === relic.storageLocationCode) {
    return fail('\u76ee\u6807\u5e93\u4f4d\u4e0d\u80fd\u4e0e\u5f53\u524d\u5e93\u4f4d\u76f8\u540c')
  }

  return pass(
    targetLocationCode
      ? '\u5f53\u524d\u5728\u5e93\u4e14\u8f6c\u5b58\u76ee\u6807\u5e93\u4f4d\u6709\u6548\uff0c\u53ef\u76f4\u63a5\u63d0\u4ea4\u9986\u5185\u8f6c\u5b58'
      : '\u5f53\u524d\u5728\u5e93\u4e14\u5e93\u4f4d\u660e\u786e\uff0c\u53ef\u7ee7\u7eed\u9009\u62e9\u76ee\u6807\u5e93\u4f4d\u53d1\u8d77\u8f6c\u5b58'
  )
}

export function checkRepairRelicEligibility(relic = {}) {
  if (!relic?.id) {
    return fail('\u672a\u83b7\u53d6\u5230\u6587\u7269\u4fe1\u606f\uff0c\u8bf7\u5237\u65b0\u540e\u91cd\u8bd5')
  }

  if (relic.currentStatus === 'IN_REPAIR') {
    return fail('\u8be5\u6587\u7269\u5df2\u5728\u4fee\u590d\u4e2d\uff0c\u8bf7\u76f4\u63a5\u5230\u6211\u7684\u4fee\u590d\u8ddf\u8fdb\u8fdb\u5ea6')
  }

  if (relic.currentStatus !== 'IN_STOCK') {
    switch (relic.currentStatus) {
      case 'TO_BE_INBOUND':
        return fail('\u8be5\u6587\u7269\u5c1a\u672a\u5b8c\u6210\u5165\u5e93\uff0c\u6682\u4e0d\u53ef\u53d1\u8d77\u4fee\u590d')
      case 'INBOUND_PENDING':
        return fail('\u8be5\u6587\u7269\u4ecd\u5728\u5165\u5e93\u5ba1\u6279\u6d41\u7a0b\u4e2d\uff0c\u5ba1\u6279\u901a\u8fc7\u540e\u624d\u53ef\u53d1\u8d77\u4fee\u590d')
      case 'OUTBOUND_PENDING':
        return fail('\u8be5\u6587\u7269\u5b58\u5728\u51fa\u5e93\u5f85\u5ba1\u6279\u4e1a\u52a1\uff0c\u8bf7\u5148\u5904\u7406\u5b8c\u6210\u540e\u518d\u53d1\u8d77\u4fee\u590d')
      case 'OUT_STOCK':
        return fail('\u8be5\u6587\u7269\u5df2\u51fa\u5e93\uff0c\u8bf7\u5148\u5b8c\u6210\u5165\u5e93\u540e\u518d\u53d1\u8d77\u4fee\u590d')
      default:
        return fail('\u53ea\u6709\u5728\u5e93\u6587\u7269\u624d\u53ef\u53d1\u8d77\u4fee\u590d\u7533\u8bf7')
    }
  }

  if (!relic.preservationStatusCode) {
    return fail('\u8be5\u6587\u7269\u7f3a\u5c11\u4fdd\u5b58\u72b6\u6001\u4fe1\u606f\uff0c\u8bf7\u5148\u5b8c\u5584\u6863\u6848\u540e\u518d\u53d1\u8d77\u4fee\u590d')
  }

  if (!DAMAGE_PRESERVATION_CODES.includes(relic.preservationStatusCode)) {
    return fail('\u8be5\u6587\u7269\u5f53\u524d\u4fdd\u5b58\u72b6\u6001\u4e0d\u5c5e\u4e8e\u5f85\u4fee\u590d\u8303\u56f4\uff0c\u8bf7\u5148\u786e\u8ba4\u4fdd\u5b58\u72b6\u6001')
  }

  return pass('\u5728\u5e93\u4e14\u5c5e\u4e8e\u75c5\u5bb3\u7c7b\u4fdd\u5b58\u72b6\u6001\uff0c\u53ef\u76f4\u63a5\u53d1\u8d77\u4fee\u590d\u7533\u8bf7')
}

export function checkInventoryRelicEligibility(relic = {}) {
  if (!relic?.id) {
    return fail('\u672a\u83b7\u53d6\u5230\u6587\u7269\u4fe1\u606f\uff0c\u8bf7\u5237\u65b0\u540e\u91cd\u8bd5')
  }

  if (relic.currentStatus !== 'IN_STOCK') {
    switch (relic.currentStatus) {
      case 'TO_BE_INBOUND':
        return fail('\u8be5\u6587\u7269\u5c1a\u672a\u5b8c\u6210\u5165\u5e93\uff0c\u6682\u4e0d\u5efa\u8bae\u53d1\u8d77\u76d8\u70b9')
      case 'INBOUND_PENDING':
        return fail('\u8be5\u6587\u7269\u4ecd\u5728\u5165\u5e93\u5ba1\u6279\u6d41\u7a0b\u4e2d\uff0c\u6682\u4e0d\u5efa\u8bae\u53d1\u8d77\u76d8\u70b9')
      case 'OUTBOUND_PENDING':
        return fail('\u8be5\u6587\u7269\u5df2\u8fdb\u5165\u51fa\u5e93\u5ba1\u6279\u6d41\u7a0b\uff0c\u6682\u4e0d\u5efa\u8bae\u53d1\u8d77\u76d8\u70b9')
      case 'OUT_STOCK':
        return fail('\u8be5\u6587\u7269\u5df2\u51fa\u5e93\uff0c\u4e0d\u80fd\u4ece\u9986\u5185\u5e93\u4f4d\u53d1\u8d77\u76d8\u70b9')
      case 'IN_REPAIR':
        return fail('\u8be5\u6587\u7269\u6b63\u5728\u4fee\u590d\u4e2d\uff0c\u8bf7\u5f85\u56de\u5e93\u540e\u518d\u53d1\u8d77\u76d8\u70b9')
      default:
        return fail('\u5f53\u524d\u72b6\u6001\u6682\u4e0d\u652f\u6301\u53d1\u8d77\u76d8\u70b9')
    }
  }

  if (!relic.storageLocationCode) {
    return fail('\u8be5\u6587\u7269\u7f3a\u5c11\u9986\u5185\u5e93\u4f4d\uff0c\u65e0\u6cd5\u4ece\u8be5\u6587\u7269\u76f4\u63a5\u53d1\u8d77\u76d8\u70b9')
  }

  return pass('\u5f53\u524d\u5728\u5e93\u4e14\u6240\u5728\u5e93\u4f4d\u660e\u786e\uff0c\u53ef\u4ece\u6240\u5728\u5e93\u4f4d\u53d1\u8d77\u76d8\u70b9\u4efb\u52a1')
}

export function analyzeRelicSelection(relics = [], checker) {
  const items = (relics || [])
    .filter(Boolean)
    .map((relic) => {
      const result = checker(relic)
      return {
        ...result,
        relic,
        identity: formatRelicIdentity(relic)
      }
    })

  const invalidItems = items.filter((item) => !item.passed)
  const validItems = items.filter((item) => item.passed)

  return {
    items,
    invalidItems,
    validItems,
    totalCount: items.length,
    validCount: validItems.length,
    allPassed: items.length > 0 && invalidItems.length === 0
  }
}
