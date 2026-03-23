import { SUPPORTED_MENU_CODES, SUPPORTED_MENU_PATHS } from '@/constants/menu'

function isSupportedMenu(menu) {
  return SUPPORTED_MENU_CODES.has(menu.menuCode) || SUPPORTED_MENU_PATHS.has(menu.path)
}

export function filterSupportedMenus(menus = []) {
  return menus.reduce((result, menu) => {
    const nextChildren = filterSupportedMenus(menu.children || [])
    if (isSupportedMenu(menu) || nextChildren.length > 0) {
      result.push({
        ...menu,
        children: nextChildren
      })
    }
    return result
  }, [])
}

export function getFirstAccessiblePath(menus = []) {
  for (const menu of menus) {
    if (menu.path && menu.children?.length === 0) {
      return menu.path
    }
    const childPath = getFirstAccessiblePath(menu.children || [])
    if (childPath) {
      return childPath
    }
  }
  return '/dashboard'
}
