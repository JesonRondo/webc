/* view.js */
import { mixin } from 'util/index'
import * as api from './api/index'
import * as handle from './handle/index'

const uiKit = {}
mixin(uiKit, api)
mixin(uiKit, handle)

// 开启bridge监听
__bridge.init(window)

export default uiKit
