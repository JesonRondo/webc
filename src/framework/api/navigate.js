/* @flow */
import { pathToKey } from 'util/index'
import {
  getPages,
  getComponent,
  newPage
} from '../manage/index'

// 保留当前页面，跳转到应用内的某个页面
export const navigateTo = (opts: {
  url: string,
  success?: Function,
  fail?: Function,
  complete?: Function,
}) => {
  const {
    url
    // success,
    // fail,
    // complete
  } = opts

  if (url && getPages().indexOf(url) >= 0) {
    const appCom: Object = getComponent('app')
    const pageCom: Object = getComponent(pathToKey(url))

    const pageInst: AppPageInstance = newPage(appCom, pageCom)

    console.log('jump to ', url)
    console.log('page inst ', pageInst)

    __bridge.navigation.pushWindow(pageInst)
  }
}
