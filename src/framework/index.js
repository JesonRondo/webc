import { mixin } from 'util/index'
import * as doc from './doc/index'
import * as apis from './api/index'
import * as envs from './win/index'

const webc = {}
mixin(webc, apis)

const win = window

win.webc = webc
mixin(win, doc)
mixin(win, envs)

// 开启bridge监听
__bridge.init(win)

export default win
