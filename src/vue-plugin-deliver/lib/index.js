/**
 * 替换Vue._update方法，把VNode传递給视图层
 */
const deliver = {
  install: function (Vue, options) {
    // Vue.prototype._packLiteVnode = function (vnode) {
    //   function onCyclicClone (oNode) {
    //     const node = {}

    //     for (let key in oNode) {
    //       if (typeof oNode[key] === 'function' ||
    //         key === 'context') {
    //         continue
    //       }

    //       if (typeof oNode[key] === 'object') {
    //         node[key] = onCyclicClone(oNode[key])
    //       } else {
    //         node[key] = oNode[key]
    //       }
    //     }
    //     return node
    //   }
    //   return onCyclicClone(vnode)
    // }

    const __patch__ = Vue.prototype.__patch__
    Vue.prototype.__patch__ = function () {
      const elm = __patch__.apply(this, arguments)
      console.log(elm)
      return elm

      // console.log(oldVnode)
      // console.log(vnode)
      // const liteVnode = this._packLiteVnode(vnode)
      // console.log(liteVnode)

      // const targetId = vnode.context._uid
      // __bridge.notification.toView('patchEmit', targetId, liteVnode)
    }
  }
}

export default deliver
