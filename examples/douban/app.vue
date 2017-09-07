<template>
  <div id="app">
    <slot></slot>
  </div>
</template>

<script>
export default {
  name: 'app'
}
</script>

<style>
#app {
  padding-top: 47px;
}
body {
  margin: 0;
  color: #111;
  font-size: 12px;
  font-family: 'Helvetica Neue',Helvetica,Roboto,Arial,sans-serif;
  position: relative;
}
a {
  color: #42bd56;
  text-decoration: none;
}
h1 {
  margin: 30px 0 5px;
  font-size: 24px;
  line-height: 32px;
  word-break: break-all;
}
h2 {
  color: #aaa;
  margin: 0 0 15px;
  font-size: 15px;
}
h1, h2, h3 {
  font-weight: normal;
}
ul {
  list-style: none;
  margin: 0;
  padding: 0;
}
* {
  -webkit-tap-highlight-color: rgba(255,0,0,0);
}
</style>
