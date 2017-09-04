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

Vue.config.productionTip = false

if (isWebDebug) {
  window.webc = bridgeMock

  const changeSign = function (el) {
    if (el.getAttribute('_changed')) return

    el.setAttribute('_changed', true)
    if (el.parentNode && !el.parentNode.getAttribute('_changed')) {
      changeSign(el.parentNode)
    }
    window.__update()
  }

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

let __updateTimer = 0
window.__update = function () {
  clearTimeout(__updateTimer)
  __updateTimer = setTimeout(() => {
    const el = isWebDebug
      ? htmlparser(instance.$el.outerHTML)[0]
      : instance.$el

    const liteEl = formatEl(el)
    webc.nodeOpt.patch('home', JSON.stringify(liteEl))
  }, 16)
}

webc.navigate.push('home')
const instance = new Vue({
  el: document.createElement('div'),
  template: '<App><Page></Page></App>',
  components: { App, Page }
}).$mount()
window.instance = instance

function isEmptyObj (obj) {
  for (let o in obj) {
    return false
  }
  return true
}

function formatEl (el) {
  const liteEl = {}

  // attr
  liteEl.attribs = el.attribs || {}

  // changed
  if (liteEl.attribs._changed) {
    liteEl.changed = true
    delete liteEl.attribs._changed
  }

  // style
  if (el.style) {
    const _style = el.style._style
    if (!isEmptyObj(_style)) {
      const styles = []
      for (let k in _style) {
        styles.push(`${hyphenate(k)}:${_style[k]}`)
      }
      liteEl.attribs.style = styles.join(';')
    }
  }

  // name
  if (el.name) {
    liteEl.name = el.name
  }

  // type
  if (el.type) {
    liteEl.type = el.type
  }

  // data
  if (el.data) {
    liteEl.data = el.data
  }

  // children
  if (el.children) {
    liteEl.children = []
    el.children.forEach(child => {
      liteEl.children.push(formatEl(child))
    })
  }

  return liteEl
}
