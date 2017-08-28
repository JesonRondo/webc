<template>
  <header>
    <h2>{{ title }}</h2>
    <a v-if="more" href="javascript:;">更多</a>
  </header>
</template>

<style scoped>
section header {
    padding: 0 1.12rem;
}
section h2 {
    display: inline-block;
    min-width: 4em;
    margin-bottom: 0;
    font-size: 18px;
    color: #111;
    padding-left: 0;
    padding-bottom: 0;
    font-size: 1.06rem;
}
section header a {
    float: right;
    font-size: .9rem;
    line-height: 1.5rem;
}
</style>

<script>
export default {
  props: {
    title: String,
    more: {
      type: Boolean,
      default: false
    }
  }
}
</script>
