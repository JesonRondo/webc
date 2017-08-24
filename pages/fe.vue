<template>
  <div>
    <banner v-if="banner"
      :image="banner.image"
      :title="banner.title"
      :sub-title="banner.subTitle">
    </banner>
    <template v-for="rec of recommend">
      <recommend-t1 v-if="rec.type === 'm1'"
        :title="rec.tit"
        :goods="rec.goods">
      </recommend-t1>
      <recommend-t2 v-if="rec.type === 'm2'"
        :title="rec.tit"
        :goods="rec.goods">
      </recommend-t2>
    </template>
  </div>
</template>

<script>
import Banner from '~/components/banner'
import RecommendT1 from '~/components/recommend-t1'
import RecommendT2 from '~/components/recommend-t2'

import { mapState, mapActions } from 'vuex'

export default {
  components: {
    Banner, RecommendT1, RecommendT2
  },
  head () {
    return {
      title: 'SMARTER TECH'
    }
  },
  computed: {
    ...mapState([
      'banner', 'recommend'
    ])
  },
  methods: {
    ...mapActions([
      'fetchData'
    ])
  },
  mounted () {
    this.fetchData()
  }
}
</script>
