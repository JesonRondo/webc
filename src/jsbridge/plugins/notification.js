/* @flow */
import sandwich from '../sandwich'

// 向view发送消息
export const toView = (cmd: string, targetId: number, data: Object) => {
  sandwich.exec('notification.toView', {
    cmd: 'patchEmit',
    id: targetId,
    data: data
  }, (err) => {
    if (err) {
      console.log('call error: ' + err)
    }
  })
}
