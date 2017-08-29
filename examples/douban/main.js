// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
// import WinManage from '../../lib/win-manage'

import App from './app'
import Home from '@/pages/home'

Vue.config.productionTip = false

/* eslint-disable no-new */
// new Vue({
//   el: '#app',
//   router,
//   template: '<App/>',
//   components: { App }
// })

webc.navigation.openView('home')

const instance = new Vue({
  el: document.createElement('div'),
  template: '<App><Home></Home></App>',
  components: { App, Home }
}).$mount()

const attrMap = {
  tag: true,
  text: true,
  style: true,
  attrs: true,
  nodeType: true
  // children
}
function walkEl (el) {
  const copyEl = {}

  for (let k in attrMap) {
    if (el[k] !== undefined) {
      copyEl[k] = el[k]
    }
  }

  if (el.children) {
    copyEl.children = []
    el.children.forEach(child => {
      copyEl.children.push(walkEl(child))
    })
  }

  return copyEl
}

const liteEl = walkEl(instance.$el)
console.log(liteEl)

webc.nodeOpt.mount('home', JSON.stringify(liteEl))

// // set scope id attribute for scoped CSS.
// // this is implemented as a special case to avoid the overhead
// // of going through the normal attribute patching process.
// function setScope (liteNode, vnode) {
//   function isDef (v) {
//     return v !== undefined && v !== null
//   }

//   function setAttr (lNode, k, v) {
//     if (!lNode.data) {
//       lNode.data = {}
//     }

//     if (!lNode.data.attrs) {
//       lNode.data.attrs = {}
//     }

//     lNode.data.attrs[k] = v
//   }

//   var i
//   var ancestor = vnode
//   while (ancestor) {
//     if (isDef(i = ancestor.context) && isDef(i = i.$options._scopeId)) {
//       setAttr(liteNode, i, '')
//     }
//     ancestor = ancestor.parent
//   }
//   // for slot content they should also get the scopeId from the host instance.
//   // if (isDef(i = activeInstance) &&
//   //   i !== vnode.context &&
//   //   isDef(i = i.$options._scopeId)
//   // ) {
//   //   setAttr(liteNode, i, '')
//   // }
// }

// function walkLineVNode (oLineVNode) {
//   const liteNode = {
//     tag: oLineVNode.tag,
//     children: [],
//     text: oLineVNode.text,
//     data: oLineVNode.data,
//     isComponent: !!oLineVNode.componentInstance
//   }
//   setScope(liteNode, oLineVNode)

//   if (oLineVNode.children) {
//     oLineVNode.children.forEach(child => {
//       liteNode.children.push(walkLineVNode(child))
//     })
//   }

//   return liteNode
// }

// function walkVNode (oNode) {
//   const node = {}

//   node._vnode = walkLineVNode(oNode._vnode)
//   node.tag = oNode.$vnode ? oNode.$vnode.tag : undefined

//   if (oNode._vnode.children) {
//     node._vnode.children = []
//     oNode._vnode.children.forEach((v, i) => {
//       node._vnode.children[i] = walkLineVNode(v)
//     })
//   }

//   node.$children = []
//   oNode.$children.forEach(($child, i) => {
//     node.$children[i] = walkVNode($child, node.$children[i])
//   })

//   return node
// }

// const liteNode = walkVNode(instance)

// console.log(liteNode)

// function generatorComponent ($children, tag) {
//   let dom = {}
//   $children.forEach($child => {
//     if ($child.tag === tag) {
//       dom = generatorTree($child)
//       return
//     }
//   })
//   return dom
// }

// function generatorNode (node, $children) {
//   return {
//     tag: node.tag,
//     text: node.text,
//     data: node.data,
//     children: generatorChildrenNodes(node.children, $children)
//   }
// }

// function generatorChildrenNodes (children, $children) {
//   const nodes = []

//   if (children) {
//     children.forEach(child => {
//       if (child.isComponent) {
//         nodes.push(generatorComponent($children, child.tag))
//       } else {
//         nodes.push(generatorNode(child, $children))
//       }
//     })
//   }
//   return nodes
// }

// function generatorTree (node) {
//   let dom
//   if (!node._vnode.isComponent) {
//     dom = generatorNode(node._vnode, node.$children)
//   } else {
//     dom = generatorComponent(node.$children, node._vnode.tag)
//   }
//   return dom
// }

// const domTree = generatorTree(liteNode)

// console.log(domTree)

// WinManage.sendMessage('home', 'mount', {
//   tree: domTree
// })
