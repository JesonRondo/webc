/* @flow */

// 混合
export const mixin = (obj: Object, source: Object) => {
  Object.keys(source).forEach(key => {
    obj[key] = source[key]
  })
}

// '/' to '_'
export const pathToKey = (url: string): string => {
  return url.replace(/\//img, '_')
}
