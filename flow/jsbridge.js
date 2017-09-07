declare type JSBridge = {
  navigation: {
    pushWindow: Function
  }
}

declare var __bridge: JSBridge

declare type JSBridgeCall = Function

declare var __webc_bridge_call: JSBridgeCall
