module.exports = {
  devServer: {
    // host: 'localhost',
    port: 8888,
    proxy: {
      '^/api/': {
        target: 'http://localhost:3000',
        changeOrigin: true,
        logLevel: 'debug',
      }
    },
    disableHostCheck: true
  }
}
