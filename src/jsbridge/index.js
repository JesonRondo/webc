import { isCoreEnv } from 'util/index'
import * as navigation from './plugins/navigation'
import * as notification from './plugins/notification'
import sandwich from './sandwich'

const __bridge = {
  init: (context) => {
    // 启动监听native的回调
    sandwich.handle(context)
  }
}

// common

// for core
if (isCoreEnv) {
  __bridge.notification = notification
  __bridge.navigation = navigation
}

// for view

export default __bridge
