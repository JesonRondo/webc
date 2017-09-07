/* @flow */
let timerCount = 0

function getCount (): number {
  return timerCount++
}

export const setTimeout = (callback: Function, delay: number): number => {
  return getCount()
}

export const clearTimeout = (callback: Function, delay: number) => {

}

export const setInterval = (callback: Function, delay: number): number => {
  return getCount()
}

export const clearInterval = (callback: Function, delay: number) => {

}
