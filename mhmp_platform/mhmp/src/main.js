import { createApp } from 'vue'
import App from './App.vue'
import pinia from './stores'
import router from './router'
import { setupElement } from './plugins/element'
import { registerGlobalErrorHandlers } from './utils/error'
import './styles/theme.css'

const app = createApp(App)

app.use(pinia)
app.use(router)
setupElement(app)

registerGlobalErrorHandlers(app)

app.mount('#app')
