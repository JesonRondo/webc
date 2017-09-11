/* @flow */

const pageMap: { [string]: AppPageInstance } = {}

// 页面
const pages: AppPages = []
// 组件
const components: AppComponents = {}

// 增加页面信息
export const addPage = (page: string) => {
  pages.push(page)
}

// 获取页面信息
export const getPages = (): AppPages => {
  return pages
}

// 设置组件
export const setComponent = (key: string, com: Object) => {
  components[key] = com
}

// 获取组件
export const getComponent = (key: string): Object => {
  return components[key]
}

// 新建页面
export const newPage = (app: Object, page: Object): AppPageInstance => {
  const instance = new Vue({
    render: createElement => {
      return createElement('app', undefined, [
        createElement('page')
      ])
    },
    components: { app, page }
  })

  const id: string = instance._uid
  const inst: AppPageInstance = { id, instance }

  pageMap[id] = inst

  return inst
}
