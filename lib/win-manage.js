// winMap = {
//    [id]: {
//      win: win Instance,
//      ready: boolen,
//      queue: [{
//        cmd: xxx,
//        payload: payload
//      }]
//    }
// }

const winMap = {}

const winManage = {
  openChildWin: function (id) {
    const win = window.open('/static/view.html', id)
    setTimeout(function () {
      winMap[id].ready = true
      winManage.exec(id)
    }, 1000)

    winMap[id] = {
      win: win,
      ready: false,
      queue: []
    }
  },

  sendMessage: function (id, cmd, payload) {
    winMap[id] && winMap[id].queue.push({
      cmd: cmd,
      payload: payload
    })
    this.exec(id)
  },

  exec: function (id) {
    if (winMap[id] && winMap[id].ready) {
      const win = winMap[id].win
      const queue = winMap[id].queue

      while (queue.length > 0) {
        const msg = winMap[id].queue.shift()
        win.postMessage(msg, 'http://localhost:8080')
      }
    }
  }
}

module.exports = window.winManage = winManage
