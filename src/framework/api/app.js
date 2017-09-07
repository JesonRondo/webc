/* @flow */
/* App操作 */
import { navigateTo } from './navigate'
import {
  addPage,
  getPages,
  setComponent
} from '../manage/index'

// 是否已安装
let installed: boolean = false

// 注册App信息，只能调用一次
export const appInstall = (info: AppInfo) => {
  if (installed) {
    return
  }
  installed = true

  const pagesMap: AppPages = info.pages
  if (pagesMap.length <= 0) {
    throw new Error('no page exist')
  }
  pagesMap.forEach(page => {
    addPage(page)
  })
}

// 设置组件
export const appSetComponent = (key: string, com: Object) => {
  setComponent(key, com)
}

// 开始运行
export const appStart = () => {
  navigateTo({
    url: getPages()[0]
  })
}
