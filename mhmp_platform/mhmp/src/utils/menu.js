const SHORTCUT_EXCLUDED_PATHS = new Set(['/dashboard', '/profile'])
const PREFERRED_SHORTCUT_PATHS = [
  '/relic/list',
  '/inventory/inbound',
  '/inventory/inbound/approve',
  '/inventory/outbound/apply',
  '/inventory/outbound/approve',
  '/inventory/outbound/return',
  '/inventory/transfer',
  '/inventory/transfer/my',
  '/inventory/task',
  '/inventory/task/my',
  '/repair/apply',
  '/repair/process',
  '/repair/acceptance'
]

export function getFirstAccessiblePath(menus = []) {
  for (const menu of menus) {
    if (menu.path && (!menu.children || menu.children.length === 0)) {
      return menu.path
    }
    const childPath = getFirstAccessiblePath(menu.children || [])
    if (childPath) {
      return childPath
    }
  }
  return '/dashboard'
}

export function flattenMenus(menus = []) {
  return menus.flatMap((menu) => [menu, ...flattenMenus(menu.children || [])])
}

export function findMenuByPath(menus = [], path = '') {
  const normalizedPath = normalizePath(path)
  return flattenMenus(menus).find((menu) => normalizePath(menu.path) === normalizedPath)
}

export function collectShortcutMenus(menus = [], limit = 8) {
  const allMenus = flattenMenus(menus)
    .filter((menu) => menu.path && !SHORTCUT_EXCLUDED_PATHS.has(menu.path) && (!menu.children || menu.children.length === 0))
  const menuMap = new Map(allMenus.map((menu) => [menu.path, menu]))
  const preferredMenus = PREFERRED_SHORTCUT_PATHS
    .map((path) => menuMap.get(path))
    .filter(Boolean)
  const fallbackMenus = allMenus.filter((menu) => !PREFERRED_SHORTCUT_PATHS.includes(menu.path))
  return [...preferredMenus, ...fallbackMenus].slice(0, limit)
}

function normalizePath(path) {
  if (!path) {
    return ''
  }
  return path.startsWith('/') ? path : `/${path}`
}
