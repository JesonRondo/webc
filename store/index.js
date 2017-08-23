import axios from 'axios'
import { isBrowser } from '~/utils/env'

export const state = () => {
  return {
    banner: null,
    recommend: null
  }
}

export const mutations = {
  setBanner (state, banner) {
    state.banner = banner
  },
  setRecommend (state, recommend) {
    state.recommend = recommend
  }
}

export const actions = {
  fetchData ({ commit }) {
    return new Promise((resolve, reject) => {
      axios
        .get(`${!isBrowser ? 'http://localhost:3000' : ''}/data/data.json`)
        .then(response => response.data)
        .then(data => {
          commit('setBanner', data.banner)
          commit('setRecommend', data.recommend)
          resolve()
        })
        .catch(err => console.log(err))
    })
  }
}
