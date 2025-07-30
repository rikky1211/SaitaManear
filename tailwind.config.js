module.exports = {
  content: [
    './app/views/**/*.html.erb',  // これでビューのHTMLファイルを監視します
    './app/helpers/**/*.rb',      // ヘルパーファイルも監視対象に
    './app/javascript/**/*.js'   // JavaScriptファイルも監視対象に

  ],

  plugins: [require("daisyui")],
  daisyui: {
  },
}