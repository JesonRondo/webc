var args = require('args')

args.option('app', 'The path to app source root')

module.exports = function (key) {
  return args.parse(process.argv)[key]
}
