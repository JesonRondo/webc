/* @flow */
/**
 * 回调函数池子
 * 与native交互时webview的函数不能作为JSValue传入，所以替换成函数ID相互传递
 * 池子存放的函数为匿名函数，调用一次后将会取消引用保存
 */
const pool: Map<number, Function> = new Map()

let idCount: number = 0
function getUnionID (): number {
  return idCount++
}

// 生成函数
export const genFunc = (func?: Function): number => {
  const id: number = getUnionID()
  if (func) {
    pool.set(id, func)
  }
  return id
}

// 调用函数
export const callFunc = function (id: number, error?: string, result: Object) {
  const func = pool.get(id)
  if (func) {
    const args = Array.prototype.slice.call(arguments, 1)
    func.apply(this, args)
    pool.delete(id)
  }
}
