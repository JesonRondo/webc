<template>
  <section class="types">
    <section-title
      :title="title">
    </section-title>
    <div class="section-content">
      <a name="cate"></a>
      <ul class="type-list">
        <li v-for="cate of cates">
          <a href="javascript:;">{{ cate }}<span></span></a>
        </li>
        <li v-if="cates.length % 2 !== 0"></li>
      </ul>
    </div>
  </section>
</template>

<style scoped>
.types .section-content {
  margin-bottom: 0;
}
.types .section-content {
  margin-left: .94rem;
}
.type-list {
  width: 100%;
  padding: 1.12rem 0 1.88rem;
  color: #eee;
  font-size: .9rem;
  overflow: hidden;
}
.type-list li {
  width: 49%;
  border-top: solid 1px #eee;
  border-right: solid 1px #eee;
  float: left;
  padding-right: 1.12rem;
  height: 2.64rem;
  box-sizing: border-box;
}
.type-list a {
  float: left;
  display: inline-block;
  width: 100%;
  line-height: 2.64rem;
}
.type-list span {
  color: #ccc;
  float: right;
  font-weight: bold;
  display: inline-block;
  border-right: solid 1px #ccc;
  border-bottom: solid 1px #ccc;
  width: .5rem;
  height: .5rem;
  transform: rotate(-45deg);
  margin-top: 1rem;
}
.type-list li:nth-child(even) {
  border-right: none;
  padding-left: 1.12rem;
}
.type-list li:last-child,
.type-list li:nth-last-child(2) {
  border-bottom: solid 1px #eee;
}
</style>

<script>
import SectionTitle from '@/components/section-title'
export default {
  components: {
    SectionTitle
  },
  props: {
    title: String,
    cates: Array
  }
}
</script>
