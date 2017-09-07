import app from '@/app'
import pages_home from '@/pages/home'
import pages_article from '@/pages/article'

// 注册App信息
webc.app.install({"pages":["pages/home","pages/article"]})

// 引入组件
webc.app.setComponent('app', app)
webc.app.setComponent('pages_home', pages_home)
webc.app.setComponent('pages_article', pages_article)


// 启动App
webc.app.start()
