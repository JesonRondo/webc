<template>
  <div>
    <tit>{{ title }}</tit>
    <div class="m1"
      :style="{ 'background-image': `url(${tGood.img})` }">
      <div class="m1-t-block">
        <p class="m1-t">{{ tGood.no }}</p>
        <p class="m1-t">{{ tGood.t }}</p>
      </div>
      <div class="m1-p-block">
        <span class="price">{{ tGood.price }}</span>
        <span class="old-price">{{ tGood.oldPrice }}</span>
      </div>
      <span class="btn">Shop Now</span>
    </div>
    <div>
      <div class="m2-top-bg">
        <div class="m2-t-block" v-for="bGood of bGoods">
          <p class="m2-t">{{ bGood.no }}</p>
          <p class="m2-t">{{ bGood.t }}</p>
        </div>
      </div>
      <div class="m2-bottom-bg">
        <div class="m2-d-block" v-for="bGood of bGoods">
          <img class="m2-d-img" :src="bGood.img" alt="">
          <p class="m2-desc">{{ bGood.desc }}</p>
          <p class="price">{{ bGood.price }}</p>
          <p class="old-price">{{ bGood.oldPrice }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.m1 {
  height: 5.527777777777778rem;
  background-size: cover;
  overflow: hidden;
}
.m1-t-block {
  margin-top: 0.6805555555555556rem;
  margin-left: 4.305555555555555%;
  width: 54.30555555555556%;
}
.m1-t {
  font-size: 0.3333333333333333rem;
  font-weight: 700;
}
.price {
  font-size: 15px;
  padding-left: 2px;
  padding-right: 2px;
  color: #333;
  font-weight: 700;
  line-height: 1.2;
  white-space: nowrap;
}
.old-price {
  font-size: 12px;
  padding-left: 2px;
  padding-right: 2px;
  color: #666;
  line-height: 1.2;
  white-space: nowrap;
  text-decoration: line-through;
}
.m1-p-block {
  margin-top: 0.6666666666666667rem;
  margin-left: 3.75%;
}
.btn {
  display: inline-block;
  margin-top: 0.26388888888888884rem;
  margin-left: 4.444444444444445%;
  min-width: 80px;
  text-align: center;
  border-radius: 3px;
  background-color: #F44336;
  color: #FFF;
  text-decoration: none;
  font-size: 12px;
  padding: 6px 10px;
  text-transform: uppercase;
  box-shadow: 0 1px 2px rgba(0,0,0,.25);
}
.m2-top-bg {
  min-height: 2.0277777777777777rem;
  max-width: 10rem;
  background-image: url(/img/m1-b2.jpg);
  background-size: cover;
}
.m2-bottom-bg {
  background-image: url(/img/m1-b3.jpg);
  background-size: cover;
  min-height: 6.166666666666667rem;
  max-width: 10rem;
  overflow: hidden;
}
.m2-t-block {
  float: left;
  width: 33.05555555555556%;
  margin-top: 0.2777777777777778rem;
  margin-left: 11%;
  min-height: 0.3611111111111111rem;
}
.m2-t {
  text-align: center;
  font-size: 0.3333333333333333rem;
}
.m2-d-block {
  position: relative;
  overflow: hidden;
  width: 42.08333333333333%;
  margin-top: 0rem;
  margin-left: 4.722222222222223%;
  float: left;
  text-align: center;
}
.m2-desc {
  font-size: 0.3333333333333333rem;
  text-align: center;
  margin-left: 4.861111111111116%;
  min-height: 1rem;
}
.m2-d-img {
  width: 100%;
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
  },
  computed: {
    tGood () {
      return this.goods[0]
    },
    bGoods () {
      return this.goods.slice(1, 3)
    }
  }
}
</script>
