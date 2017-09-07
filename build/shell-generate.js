var fs = require('fs')
var path = require('path')
var checkParams = require('./check-params')
var exec = require('child_process').execSync

module.exports = function () {
  var appRoot = checkParams('app')

  var appConfig = fs.readFileSync(path.resolve(appRoot, 'app.json'), 'utf8')
  appConfig = JSON.parse(appConfig)

  var pages = appConfig.pages

  // 生成启动文件
  var shellRoot = path.resolve(appRoot, '.webc')
  exec(`mkdir -p ${shellRoot}`)

  // 注意提示
  fs.writeFileSync(`${shellRoot}/NOTICE`, '这个目录的文件由程序自动生成，不要修改', 'utf8')

  // 入口
  var componentsInfo = [{
    name: 'app',
    path: '@/app'
  }]

  pages.forEach(page => {
    componentsInfo.push({
      name: page.replace(/\//img, '_'),
      path: `@/${page}`
    })
  })

  var importInfo = ''
  var componentInfo = ''

  componentsInfo.forEach(info => {
    importInfo += `import ${info.name} from '${info.path}'\n`
    componentInfo += `webc.app.setComponent('${info.name}', ${info.name})\n`
  })

  fs.writeFileSync(`${shellRoot}/index.js`,
`${importInfo}
// 注册App信息
webc.app.install(${JSON.stringify(appConfig)})

// 引入组件
${componentInfo}

// 启动App
webc.app.start()
`, 'utf8')
}
