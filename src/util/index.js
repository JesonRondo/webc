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

// 判断是否JSCore运行环境
export const isCoreEnv: boolean = !(typeof window !== 'undefined' &&
                                    window.navigator &&
                                    navigator.userAgent.indexOf('WebC') < 0)

export const isUndef = (v: any) => {
  return v === undefined || v === null
}

export const isDef = (v: any) => {
  return v !== undefined && v !== null
}

export const isTrue = (v: any) => {
  return v === true
}

export const isFalse = (v: any) => {
  return v === false
}

export const isPrimitive = (value: any) => {
  return (
    typeof value === 'string' ||
    typeof value === 'number' ||
    typeof value === 'boolean'
  )
}
