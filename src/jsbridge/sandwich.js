/* @flow */
import { isCoreEnv } from 'util/index'
import { genFunc, callFunc } from 'util/func-pool'

export default {
  // 调用native
  exec (cmd: string, data?: Object, callback?: Function) {
    if (isCoreEnv) {
      __webc_bridge_call(cmd, data, genFunc(callback))
    } else if (window.webkit &&
      window.webkit.messageHandlers &&
      window.webkit.messageHandlers.__webc_bridge_call) {
      window.webkit.messageHandlers.__webc_bridge_call.postMessage({
        cmd: cmd,
        data: data,
        callback: genFunc(callback)
      })
    }
  },
  // 监听native的调用
  handle (context: Object) {
    if (!context.__webc_bridge_handle) {
      context.__webc_bridge_handle = function (
        result: Object,
        error?: string,
        callbackId: number) {
        callFunc(callbackId, error, result)
      }
    }
  }
}
