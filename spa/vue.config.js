module.exports = {
  devServer: {
    host: 'localhost',
    https: true,
    port: 8888,
    proxy: {
      '^/api/': {
        target: 'http://localhost:3000',
        changeOrigin: true,
        //ws: true,
        logLevel: 'debug',
        //pathRewrite: p => {
        //  console.log({p: p})
        //  return p
        //  //return p.replace(/.*api/, '/api/')
        //},
      }
    },
    disableHostCheck: true
  }
}
