/* @flow */
import sandwich from '../sandwich'

export const pushWindow = (pageInst: AppPageInstance, callback: Function) => {
  sandwich.exec('navigation.pushWindow', {
    id: pageInst.id
  }, callback)
}
