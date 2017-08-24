// rem
const $html = document.getElementsByTagName('html')[0]
$html.style.fontSize = screen.width / 10 + 'px'

// jsbrige
window.jsbrige = {
  blankOver: function () {
    window.setupWebViewJavascriptBridge && window.setupWebViewJavascriptBridge(function (bridge) {
      bridge.callHandler('blankOver')
    })
  }
}
