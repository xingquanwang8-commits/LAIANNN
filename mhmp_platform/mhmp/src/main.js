import { createApp } from 'vue'
import ElementPlus from 'element-plus'
import zhCn from 'element-plus/es/locale/lang/zh-cn'
import 'element-plus/dist/index.css'
import App from './App.vue'
import pinia from './stores'
import router from './router'
import { registerGlobalErrorHandlers } from './utils/error'
import './styles/theme.css'

const app = createApp(App)

app.use(pinia)
app.use(router)
app.use(ElementPlus, {
  locale: zhCn
})

registerGlobalErrorHandlers(app)

app.mount('#app')
