/* @flow */
export const handleCenter = (cmd: string, data: Object) => {
  if (cmd) {
    const funcStackArr = cmd.split('.')
    let func
    funcStackArr.forEach((name, index) => {
      if (index === 0) {
        if (uiKit[name]) {
          func = uiKit[name]
        }
      } else {
        if (func && func[name]) {
          func = func[name]
        }
      }
    })
    if (typeof func === 'function') {
      func(data)
    }
  }
}
