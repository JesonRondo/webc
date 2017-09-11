// http://eslint.org/docs/user-guide/configuring

module.exports = {
  root: true,
  parser: 'babel-eslint',
  parserOptions: {
    sourceType: 'module'
  },
  env: {
    browser: true,
  },
  globals: {
    'Vue': false,
    'webc': false,
    'uiKit': false,
    '__bridge': false,
    '__webc_bridge_call': false,
    '__webc_bridge_handle': false
  },
  // https://github.com/feross/standard/blob/master/RULES.md#javascript-standard-style
  extends: [
    'standard',
    'plugin:flowtype/recommended'
  ],
  // required to lint *.vue files
  plugins: [
    'html',
    'flowtype'
  ],
  // add your custom rules here
  'rules': {
    // allow paren-less arrow functions
    'arrow-parens': 0,
    // allow async-await
    'generator-star-spacing': 0,
    // allow debugger during development
    'no-debugger': process.env.NODE_ENV === 'production' ? 2 : 0
  }
}
