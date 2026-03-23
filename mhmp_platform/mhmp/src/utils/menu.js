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

export function collectShortcutMenus(menus = [], limit = 8) {
  return flattenMenus(menus)
    .filter((menu) => menu.path && (!menu.children || menu.children.length === 0))
    .slice(0, limit)
}
