import {
  Avatar,
  Box,
  Checked,
  CircleCheck,
  Clock,
  Collection,
  Document,
  DocumentCopy,
  Download,
  EditPen,
  Files,
  House,
  List,
  Menu,
  Operation,
  Search,
  Select,
  Setting,
  Tickets,
  Upload,
  User,
  UserFilled
} from '@element-plus/icons-vue'

const iconMap = {
  Avatar,
  Box,
  Checked,
  CircleCheck,
  Clock,
  Collection,
  Document,
  DocumentCopy,
  Download,
  EditPen,
  Files,
  House,
  List,
  Menu,
  Operation,
  Search,
  Select,
  Setting,
  Tickets,
  Upload,
  User,
  UserFilled
}

export const ICON_OPTIONS = Object.keys(iconMap)

export function resolveMenuIcon(iconName) {
  return iconMap[iconName] || Menu
}
