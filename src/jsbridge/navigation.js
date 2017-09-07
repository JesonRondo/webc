/* @flow */
export const pushWindow = (pageInst: AppPageInstance) => {
  __webc_bridge_call('navigation.pushWindow', {
    id: pageInst.id
  })
}
