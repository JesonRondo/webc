// bridge for web debug
import bridgeMock from 'webc-framework'
// parser for web debug
import htmlparser from 'html-dom-parser'
// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'

import { hyphenate } from '../../lib/util'

import App from './app'
import Page from '@/pages/home'

const isWebDebug = navigator.userAgent.indexOf('WebC') < 0
let isMounted = false

Vue.config.productionTip = false

function changeSign (el) {
  if (!isMounted) return
  if (el.getAttribute('_changed')) return

  el.setAttribute('_changed', true)
  if (el.parentNode && !el.parentNode.getAttribute('_changed')) {
    changeSign(el.parentNode)
  }
  window.__update()
}

if (isWebDebug) {
  window.webc = bridgeMock

  document.$createElement = document.createElement
  document.createElement = function () {
    const el = document.$createElement.apply(this, arguments)
    changeSign(el)

    if (el.setAttribute) {
      el.$setAttribute = el.setAttribute
      el.setAttribute = function () {
        this.$setAttribute.apply(this, arguments)
        changeSign(this)
      }
    }
    if (el.insertBefore) {
      el.$insertBefore = el.insertBefore
      el.insertBefore = function () {
        this.$insertBefore.apply(this, arguments)
        changeSign(this)
      }
    }
    if (el.removeChild) {
      el.$removeChild = el.removeChild
      el.removeChild = function () {
        this.$removeChild.apply(this, arguments)
        changeSign(this)
      }
    }
    if (el.appendChild) {
      el.$appendChild = el.appendChild
      el.appendChild = function () {
        this.$appendChild.apply(this, arguments)
        changeSign(this)
      }
    }
    return el
  }
}

webc.navigate.push('home')

const instance = new Vue({
  el: document.createElement('div'),
  template: '<App><Page></Page></App>',
  components: { App, Page }
}).$mount()

isMounted = true

let __updateTimer = 0
window.__update = function () {
  clearTimeout(__updateTimer)
  __updateTimer = setTimeout(() => {
    let liteEl = isWebDebug
      ? htmlparser(instance.$el.outerHTML)[0]
      : instance.$el

    formatEl(liteEl)
    console.log(liteEl)
    webc.nodeOpt.patch('home', JSON.stringify(liteEl))
  }, 16)
}

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

  if (el.attribs && el.attribs._changed) {
    el.changed = true
    delete el.attribs._changed
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

webc.nodeOpt.patch('home', JSON.stringify(liteEl))
