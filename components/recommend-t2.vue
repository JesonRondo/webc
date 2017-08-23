<template>
  <div>
    <tit>{{ title }}</tit>
    <div v-for="good, i of goods"
      class="goods"
      :class="{ 'goods-odd': i % 2 !== 0 }"
      :style="{ 'background-image': `url(${good.img})` }">
      <p class="m-t">{{ good.t }}</p>
      <p class="m-d">{{ good.desc }}</p>
      <div class="m-p">
        <p class="price">{{ good.price }}</p>
        <p class="old-price">{{ good.oldPrice }}</p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.goods {
  background-size: cover;
  min-height: 4.208333333333333rem;
  overflow: hidden;
}
.goods-odd {
  min-height: 3.9305555555555554rem;
}
.m-t {
  width: 45%;
  color: rgb(255, 255, 255);
  font-size: 0.2916666666666667rem;
  text-align: center;
  margin-top: 0.5694444444444444rem;
  margin-left: 51.66666666666667%;
  clear: both;
  min-height: 0.3472222222222222rem;
}
.m-d {
  width: 46%;
  color: rgb(255, 255, 255);
  font-size: 0.2916666666666667rem;
  font-weight: 300;
  text-align: center;
  margin-top: 0.09722222222222221rem;
  margin-left: 51%;
  clear: both;
  min-height: 0.3472222222222222rem;
}
.m-p {
  margin-top: 0.23611111111111116rem;
  margin-left: 48%;
  text-align: center;
}
.price {
  font-size: 15px;
  padding-left: 2px;
  padding-right: 2px;
  color: #fff;
}
.old-price {
  font-size: 12px;
  padding-left: 2px;
  padding-right: 2px;
  color: #fff;
  text-decoration: line-through;
}
.goods-odd .m-t {
  margin-left: 3%;
  margin-top: 0.4rem;
}
.goods-odd .m-d {
  margin-left: 2.3%;
}
.goods-odd .m-p {
  margin-left: 0;
  margin-right: 48%;
}
</style>

<script>
import Tit from '~/components/tit'

export default {
  components: {
    Tit
  },
  props: {
    title: {
      type: String,
      required: true
    },
    goods: {
      validator: function (val) {
        return typeof val === 'object' && val.length === 3
      }
    }
  }
}
</script>
