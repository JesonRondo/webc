// bridge for web debug
import bridgeMock from 'webc-framework'
// parser for web debug
import htmlparser from 'html-dom-parser'
// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'

import { hyphenate } from '../../lib/util'

import App from './app'
import Home from '@/pages/home'

const isWebDebug = navigator.userAgent.indexOf('WebC') < 0

Vue.config.productionTip = false

if (isWebDebug) {
  window.webc = bridgeMock
}

webc.navigation.push('home')

const instance = new Vue({
  el: document.createElement('div'),
  template: '<App><Home></Home></App>',
  components: { App, Home }
}).$mount()

const cleanMap = [
  'next', 'parent', 'prev',
  '__vue__', '_prevClass', 'nodeType'
]

function isEmptyObj (obj) {
  for (let o in obj) {
    return false
  }
  return true
}

function formatEl (el) {
  cleanMap.forEach(prop => {
    delete el[prop]
  })

  // prod style is in mock style [CSSStyleDeclaration]
  if (el.style) {
    const _style = el.style._style
    if (!isEmptyObj(_style)) {
      const styles = []
      for (let k in _style) {
        styles.push(`${hyphenate(k)}:${_style[k]}`)
      }

      el.attribs = el.attribs || {}
      el.attribs.style = styles.join(';')
    }
    delete el.style
  }

  if (el.children) {
    el.children.forEach(child => {
      formatEl(child)
    })
  }
}

let liteEl = isWebDebug
  ? htmlparser(instance.$el.outerHTML)[0]
  : instance.$el

formatEl(liteEl)
console.log(liteEl)

webc.nodeOpt.mount('home', JSON.stringify(liteEl))
