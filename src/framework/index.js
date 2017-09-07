import { mixin } from 'util/index'
import * as apis from './api/index'
import * as envs from './win/index'

const webc = {}
mixin(webc, apis)

const win = window

win.webc = webc
mixin(win, envs)

export default win
