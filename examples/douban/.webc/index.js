import app from '@/app'
import pages_home from '@/pages/home'
import pages_article from '@/pages/article'

// 注册App信息
webc.appInstall({"pages":["pages/home","pages/article"]})

// 引入组件
webc.appSetComponent('app', app)
webc.appSetComponent('pages_home', pages_home)
webc.appSetComponent('pages_article', pages_article)

