<template>
  <section class="interests">
    <section-title
      :title="title">
    </section-title>
    <div class="section-content">
      <ul>
        <template v-for="keyword, i of keywords">
          <li :style="{ 'border-color': colors[i] }">
            <a href="javascript:;" :style="{ 'color': colors[i] }">
              {{ keyword }}
            </a>
          </li>
          <li v-if="i === 3" class="line"></li>
        </template>
      </ul>
    </div>
  </section>
</template>

<style scoped>
.interests ul {
    white-space: nowrap;
    overflow-x: auto;
    padding: 15px 15px 43px 15px;
    font-size: 0;
    margin-left: -5px;
    -webkit-overflow-scrolling: touch;
}
.interests li {
    margin: 0 0 8px 8px;
    font-size: .94rem;
    display: inline-block;
    border-radius: .25rem;
    border: solid 1px;
    vertical-align: middle;
}
.interests a {
    height: 50px;
    line-height: 50px;
    padding: 0 1.55rem;
    letter-spacing: .1em;
    overflow: auto;
    display: block;
    text-align: center;
}
.interests li.line {
    width: 100%;
    display: block;
    height: 1px;
    border: 0;
    margin: 0;
}
</style>

<script>
import SectionTitle from '@/components/section-title'

export default {
  components: {
    SectionTitle
  },
  data () {
    return {
      colors: [
        '#FFC46C',
        '#FFAC2D',
        '#CC3344',
        '#FF4055',
        '#42BD56',
        '#2384E8',
        '#3BA94D',
        '#4F9DED'
      ].sort((a, b) => {
        return Math.random() > 0.5 ? -1 : 1
      })
    }
  },
  props: {
    title: String,
    keywords: Array
  }
}
</script>
