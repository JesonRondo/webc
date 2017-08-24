/**
 * 处理生成的静态文件并压缩
 */
const fs = require('fs')
const path = require('path')
const walk = require('walk').walk
const exec = require('child_process').execSync

const distPath = 'dist'
const pkgPath = 'static/data/pkg.amr'

// 清除离线包
exec(`rm -f dist/data/pkg.amr`)

// 处理文件中的路径，变为相对路径
walk(distPath, {
  listeners: {
    file: (root, fileStats, next) => {
      if (fileStats.name.endsWith('.html')) {
        const filePath = path.resolve(root, fileStats.name)
        fs.readFile(filePath, 'utf-8', (err, data) => {
          if (!err) {
            const lv = root.split('/').length - 1
            const ups = (new Array(lv)).fill('..')
            fs.writeFile(
              filePath.replace(/\.html/, '_file.html'),
              data
                .replace(/src="(\/\S*)"/img, `src="${ups.join('/')}$1"`)
                .replace(/href="(\/\S*)"/img, `href="${ups.join('/')}$1"`)
                .replace(/url\((\/\S*)\)/img, `url(${ups.join('/')}$1)`),
              'utf-8',
              () => {
                console.log(`write file: ${root} - ${fileStats.name}`)
                next()
              })
          } else {
            next()
          }
        })
      } else {
        next()
      }
    },
    end: () => {
      // 压缩
      console.log(`zip pack`)
      exec(`zip -r ${pkgPath} ${distPath}`)
    }
  }
})

