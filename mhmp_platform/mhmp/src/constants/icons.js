import {
  Box,
  Checked,
  Collection,
  Document,
  House,
  Menu,
  Search,
  Setting,
  Tickets,
  Upload
} from '@element-plus/icons-vue'

const iconMap = {
  Box,
  Checked,
  Collection,
  Document,
  House,
  Menu,
  Search,
  Setting,
  Tickets,
  Upload
}

export function resolveMenuIcon(iconName) {
  return iconMap[iconName] || Menu
}
