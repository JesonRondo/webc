<template>
  <div class="banner">
    <img class="bg" :src="image" onload="jsbrige.blankOver()" />
    <span class="tit">{{ title }}</span>
    <span class="desc">{{ subTitle }}</span>
  </div>
</template>

<script>
export default {
  props: {
    image: {
      type: String,
      required: true
    },
    title: {
      type: String,
      required: true
    },
    subTitle: {
      type: String,
      required: true
    }
  }
}
</script>

<style scoped>
.banner {
  position: relative;
  height: 7.47rem;
}
.bg {
  width: 100%;
}
.tit {
  position: absolute;
  left: 1rem;
  top: 4.78rem;
  width: 8rem;
  height: 0.375rem;
  font-size: 0.36rem;
  font-weight: 700;
  text-align: center;
}
.desc {
  position: absolute;
  left: 1.597rem;
  top: 5.43rem;
  width: 6.81rem;
  height: 0.375rem;
  font-size: 0.333rem;
  font-weight: 400;
  text-align: center;
}
</style>
