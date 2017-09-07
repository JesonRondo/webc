<template>
  <div>
    <movie-light v-for="light, index of lights"
      :key="index"
      :title="light.title"
      :movies="lightMovies[index]">
    </movie-light>
    <movie-pop
      :title="popKeys.title"
      :keywords="popKeys.keywords"></movie-pop>
    <movie-cate
      :title="cates.title"
      :cates="cates.cates">
    </movie-cate>
  </div>
</template>

<script>
// import Vue from 'vue'
import MovieLight from '@/components/movie-light'
import MoviePop from '@/components/movie-pop'
import MovieCate from '@/components/movie-cate'
export default {
  components: {
    MovieLight, MoviePop, MovieCate
  },
  data () {
    return {
      lights: [{
        title: '影院热映',
        source: 'https://m.douban.com/rexxar/api/v2/subject_collection/movie_showing/items'
      }, {
        title: '免费在线观影',
        source: 'https://m.douban.com/rexxar/api/v2/subject_collection/movie_free_stream/items'
      }, {
        title: '新片速递',
        source: 'https://m.douban.com/rexxar/api/v2/subject_collection/movie_latest/items'
      }],
      lightMovies: [],
      popKeys: {
        title: '发现好电影',
        keywords: [
          '同时入选IMDB250和豆瓣电影250的电影',
          '带你进入不正常的世界',
          '用电【影】来祭奠逝去的岁月',
          '女孩们的故事【电影】',
          '科幻是未来的钥匙——科幻启示录【科幻题材】',
          '美国生活面面观',
          '2015终极期待',
          '经典韩国电影——收集100部'
        ]
      },
      cates: {
        title: '分类浏览',
        cates: [
          '经典', '冷门佳片', '豆瓣高分', '动作',
          '喜剧', '爱情', '悬疑', '恐怖', '科幻', '治愈',
          '文艺', '成长', '动画', '华语', '欧美', '韩国', '日本'
        ]
      }
    }
  },
  mounted () {
    this.fetchData()
  },
  methods: {
    fetchData () {
      this.lights.forEach((light, index) => {
        ((light, i) => {
          webc.request({
            url: light.source,
            data: {
              start: 0,
              count: 8,
              loc_id: 108288
            },
            success: data => {
              if (data.statusCode === 200) {
                const lightMovies = this.lightMovies
                lightMovies[i] = data.data.subject_collection_items
                // Vue.set(this.lightMovies, lightMovies)
              }
            }
          })
        })(light, index)
      })
    }
  }
}
</script>
